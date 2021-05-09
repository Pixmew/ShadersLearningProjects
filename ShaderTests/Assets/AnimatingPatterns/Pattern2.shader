Shader "Unlit/Pattern2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequency ("Frequency" , Range(0.001 , 100)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="transparent"
		"Queue" = "Transparent"       
    }


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _Frequency;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                float inner = sin(i.uv.y * 50);
                float x = sin(i.uv.y * _Frequency + _Time.y * 5  + inner) ;
                
                float4 col  = float4(x,x,x ,1);
                return col;
            }
            ENDCG
        }
    }
}
