Shader "Unlit/GradientShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA" ,  Color) = (1,1,1,1)
        _ColorB ("ColorB" ,  Color) = (1,1,1,1)
        _ColorStart("ColorStart" , Range(0,1)) = 0
        _ColorEnd("ColorEnd" , Range(0,1)) = 1
        _Roatation("Rotation" , Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transperent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _Roatation;
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

            float inverseLerp(float a , float b , float v){
                return (v-a)/(b-a);
            }

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


                float t = saturate( inverseLerp(_ColorStart , _ColorEnd , i.uv));
                float4 col = lerp(_ColorA , _ColorB , t);
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
