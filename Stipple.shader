// Diffuse shader with stipple cutoff effect
Shader "Game/Diffuse Transparent Stipple" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" { }
		_Cutoff("Alpha Cutoff", Range(0, 1)) = 0.0
	}

	SubShader {
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest"  }

		CGPROGRAM
		#pragma surface surf Lambert addshadow alphatest:_Cutoff

		sampler2D _MainTex;

		static const float4x4 kThresholdMatrix = {
			 1.0 / 17.0,	 9.0 / 17.0,	 3.0 / 17.0,	11.0 / 17.0,
			13.0 / 17.0,	 5.0 / 17.0,	15.0 / 17.0,	 7.0 / 17.0,
			 4.0 / 17.0,	12.0 / 17.0,	 2.0 / 17.0,	10.0 / 17.0,
			16.0 / 17.0,	 8.0 / 17.0,	14.0 / 17.0,	 6.0 / 17.0
		};

		static const float4x4 kKernelMatrix = {
			1, 0, 0, 0, 
			0, 1, 0, 0, 
			0, 0, 1, 0, 
			0, 0, 0, 1 
		};

		// Cull distances in world units (from the camera)
		static const float kCullDistanceStart = 7;
		static const float kCullDistanceEnd = 8;

		struct Input {
			float2 uv_MainTex;
			float4 screenPos;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			// Unproject the screen pixel coordiante
			float2 pos = IN.screenPos.xy / IN.screenPos.w;
			pos *= _ScreenParams.xy;

			// Clip pixel within [start, end] distance from camera
			float worldDist = distance(_WorldSpaceCameraPos, IN.worldPos.xyz);
			float interpDist = 1.0 - smoothstep(kCullDistanceStart, kCullDistanceEnd, worldDist);
			clip(interpDist - kThresholdMatrix[fmod(pos.x, 4)] * kKernelMatrix[fmod(pos.y, 4)]);
		}

		ENDCG
	}

	Fallback "Transparent/Cutout/VertexLit"
}
