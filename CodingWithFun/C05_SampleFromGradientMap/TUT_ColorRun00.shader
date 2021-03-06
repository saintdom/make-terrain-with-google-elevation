// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//AnimationEffects2D-->sakuraplus-->https://sakuraplus.github.io/make-terrain-with-google-elevation/index.html
Shader "TUT/ColorRun00" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}

		_Color("Color", Color) = (0, 0, 0, 1)
		_ColorSpeed("color speed", Float) = 1.0

		_MaskTex ("Mask", 2D) = "white" {}		
	}
	SubShader {
		Tags {"Queue"="Transparent" }

		CGINCLUDE
		#include "UnityCG.cginc"

		sampler2D _MainTex;  
		sampler2D _MaskTex;  

		fixed4 _Color;
		float _ColorSpeed;

		uniform half4 _MainTex_ST;
		uniform half4 _MaskTex_ST;

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uvMain: TEXCOORD0;
			half2 uvMask: TEXCOORD1;
			half colorStrength: TEXCOORD2;
		};
		  
		v2f vert(appdata_img v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uvMain=(v.texcoord-_MainTex_ST.zw)*_MainTex_ST.xy ;
			o.uvMask=(v.texcoord-_MaskTex_ST.zw)*_MaskTex_ST.xy ;
			o.colorStrength=(sin(_Time.y * _ColorSpeed)+1 )/2;
			return o;
		}



		fixed4 frag(v2f i) : SV_Target {
			fixed4 sum = tex2D(_MainTex, i.uvMain).rgba ;
			fixed4 mask = tex2D(_MaskTex, i.uvMask).rgba;

			sum.rgb += (i.colorStrength*_Color.rgb*mask.a);			
			return sum;
		}
		    
		ENDCG


		Pass {
			Tags { "LightMode"="ForwardBase" }

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			  
			#pragma vertex vert  
			#pragma fragment frag
			  
			ENDCG  
		}


	} 
	FallBack "Diffuse"
}