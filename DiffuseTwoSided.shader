// A basic shader to render both sides of a mesh
Shader "Game/Diffuse Two-Sided" {
	Properties {
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" { }
	}

	SubShader {
		Tags { "Queue"="Geometry" "IgnoreProjector"="False" "RenderType"="Opaque" }
		
		// First Pass: Render back faces only
		Cull Front

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input {
			float4 color:COLOR;
			float2 uv_MainTex;
		};
		
		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);

			// Flip normals when rendering back faces for correct lighting
			v.normal = -v.normal;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 1.0;
		}
		ENDCG
		
		// Second Pass: Render front faces as usual
		Cull Back

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input {
			float4 color:COLOR;
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 1.0;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
