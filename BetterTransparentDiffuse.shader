// An improvement to the default Unity "Transparent/Diffuse" shader to prevent see-through artifacts.
Shader "Game/Transparent/Diffuse (improved)" {
	Properties {
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" { }
	}

	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="False" "RenderType"="Transparent" }

		// First Pass: Only render alpha (A) channel
		Pass {
			ColorMask A
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;

			float4 vert(float4 vertex : POSITION) : SV_POSITION {
				return mul(UNITY_MATRIX_MVP, vertex);
			}

			fixed4 frag() : SV_Target {
				return _Color;
			}

			ENDCG
		}

		// Second Pass: Now render color (RGB) channel
		ColorMask RGB
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input {
			float4 color : COLOR;
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

	Fallback "Legacy Shaders/Transparent/Diffuse"
}
