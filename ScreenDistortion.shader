// Screen distortion image effect shader, loosely based off of Unity's standard assets image effects.
Shader "Game/Post Process/Screen Distortion" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "" { }
		_NormalMap("Base (RGB)", 2D) = "" { }
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	struct v2f {
		float4 pos:POSITION;
		float2 uv:TEXCOORD0;
	};

	sampler2D _MainTex;
	sampler2D _NormalMap;

	// Shader params from client
	uniform float2 intensity;
	uniform float widthOffsetPercent;
	uniform float aspectRatio;

	v2f vert(appdata_img v) {
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	half4 frag(v2f i) : COLOR {

		// Convert from (0, 1) to (-1, 1)
		half2 coords = (i.uv - 0.5) * 2.0;
		half2 normalCoords = i.uv;

		// Adjust x such that the distortion texture is always screen centered
		normalCoords.x -= widthOffsetPercent;
		normalCoords.x *= aspectRatio;

		// Compute offset from distortion texture
		coords = fixed4(UnpackNormal(tex2D(_NormalMap, normalCoords)), 0).xy;

		// Compute final coords based on distortion offsets
		half2 finalCoords;
		finalCoords.x = (1 - coords.y * coords.y) * intensity.y * coords.x;
		finalCoords.y = (1 - coords.x * coords.x) * intensity.x * coords.y;
		return tex2D(_MainTex, i.uv - finalCoords);
	}

	ENDCG

	Subshader {
		Pass {
			 ZTest Always Cull Off ZWrite Off
			 Fog { Mode off }

			 CGPROGRAM
			 #pragma fragmentoption ARB_precision_hint_fastest 
			 #pragma vertex vert
			 #pragma fragment frag
			 ENDCG
		}
	}

	Fallback off
}
