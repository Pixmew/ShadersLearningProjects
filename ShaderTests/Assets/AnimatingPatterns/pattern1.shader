Shader "Unlit/pattern1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA" , Color) = (1,1,1,1)
        _ColorB ("ColorB" , Color) = (1,1,1,1)
        _Scale ("Scale" , Range(0,100)) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transperent"
            "Queue" = "Transperent" 
            }
        
        Pass
        {

            ZWrite Off
            Blend One One
            Cull Off


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _Scale;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : TEXTCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                //float4 color = lerp(_ColorA , _ColorB , i.uv.x));
                float factor = cos(i.uv.x*50);
                float t = cos((i.uv.y*_Scale)+factor +_Time.w*5);
                t *= 1 - i.uv.y;
                return t * abs(i.normal.y) < 0.999;
            }
            ENDCG
        }
    }
}
