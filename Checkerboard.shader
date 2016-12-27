// Renders a two colored checkerboard pattern using the existing UV coordinates. 
Shader "Game/Unlit/Checkerboard" {
	Properties {
		_Color0("Color 0", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color1("Color 1", Color) = (0.0, 0.0, 0.0, 1.0)
		_Size("Density", Range(2, 50)) = 8
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float2 uv:TEXCOORD0;
				float4 vertex:SV_POSITION;
			};

			float4 _Color0;
			float4 _Color1;
			float _Size;

			v2f vert(float4 pos:POSITION, float2 uv:TEXCOORD0) {
				v2f o;
				o.vertex = UnityObjectToClipPos(pos);
				o.uv = _Size * uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float2 c = floor(i.uv) / 2;
				float checker = 2 * frac(c.x + c.y);
				return checker * _Color0 + (1 - checker) * _Color1;
			}

			ENDCG
		}

		// Enable shadow casting
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}
