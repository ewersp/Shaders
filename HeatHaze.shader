// This shader works best when rendered on a sphere with inverted normals as a child of the camera
Shader "Game/HeatHaze" {
	Properties {
		_Distortion("Distortion", Float) = 0.5
		_Speed("Speed", Float) = 0.5
		_NormalMap("NormalMap", 2D) = "bump" {}
	}

	SubShader{
		// Render this effect after all other scene objects
		Tags { "Queue"="Transparent+1" "IgnoreProjector"="True"}

		Lighting Off
		Fog { Mode Off }

		GrabPass { "_GrabTexture" }

		Pass {
			Name "GrabOffset"
			Cull Back
			ZWrite Off
			Blend Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			float _Distortion;
			float _Speed;

			// camera.depthTextureMode = DepthTextureMode.Depth must be set for this to work
			sampler2D _CameraDepthTexture;

			struct appdata {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 grabUV : TEXCOORD1;
			};

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _NormalMap);
				o.grabUV = ComputeGrabScreenPos(o.pos);
				return o;
			}

			float4 frag(v2f i) : COLOR {

				// Apply animation
				i.texcoord.x += _Speed * _CosTime;
				i.texcoord.y += _Speed * _SinTime;

				// Compute the distorted texture coords
				float3 normal = normalize(UnpackNormal(tex2D(_NormalMap, i.texcoord)));
				float4 distUV = i.grabUV + (float4(normal, 0) * _Distortion);

				// Grab the pixel at the distorted coord
				float4 refraction = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(distUV));

				// If the distorted pixel is actually in front, ignore it
				float depth = UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(distUV)));
				if (LinearEyeDepth(depth) <= i.grabUV.z) {
					refraction = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabUV));;
				}

				return float4(refraction.rgb, 1);
			}

			ENDCG
		}
	}
}
