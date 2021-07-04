Shader "Unlit/Pattern2"
{
    Properties
    {
        _ColorA ("ColorA" , Color) = (1,1,1,1)
        _ColorB ("ColorB" , Color) = (0,0,0,1)

        _FrequencyX ("FrequencyX" , Range(0 , 100)) = 1
        _FrequencyY ("FrequencyY" , Range(0 , 100)) = 1

        _PatternX ("PatternX" , Range(0 , 100)) = 1
        _PatternY ("PatternY" , Range(0 , 100)) = 1

        _AnimateTimeSpeed ("AnimateTimeSpeed" , Range(0,100)) = 5
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _FrequencyX;
            float _FrequencyY;
            float _PatternX;
            float _PatternY;
            float _AnimateTimeSpeed;
            float4 _ColorA;
            float4 _ColorB;


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
                
                 // apply fog
                float inner = sin((i.uv.x * _PatternX) + (i.uv.y * _PatternY));
                float outter = sin((i.uv.x * _FrequencyX) + (i.uv.y * _FrequencyY) + (_Time.y * _AnimateTimeSpeed) + inner);
                float4 c;
                float4 d;

                

                if(outter <= 0){
                    c = float4(_ColorA.r * (outter + 2) ,
                               _ColorA.g * (outter + 2) , 
                               _ColorA.b * (outter + 2) , 
                               _ColorA.a * (outter + 2) );
                }
                else{
                    c = float4(_ColorB.r * (outter + 2),
                               _ColorB.g * (outter + 2), 
                               _ColorB.b * (outter + 2), 
                               _ColorB.a * (outter + 2));
                }
                
                return c;

                /*UNITY_APPLY_FOG(i.fogCoord, col);
                float inner = sin(i.uv.y * 50);
                float x = sin(i.uv.y * _Frequency + _Time.y * 5  + inner) ;
                
                float4 col  = float4(x,x,x,1);
                return col;*/
            }
            ENDCG
        }
    }
}
