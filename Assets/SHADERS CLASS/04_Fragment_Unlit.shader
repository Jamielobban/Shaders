Shader"ENTI/04_Fragment_Unlit"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1,1,1,1)
        _Color2 ("Color 2", Color) = (1,1,1,1)
        _Blend ("_Blend Value", Range(0,1)) = 1.0

        _MainTex ("Main Texture", 2D) = "white" {}
        _SecondTex ("Secondary Texture", 2D) = "white" {}

        _BlendTex("Blend Tex", 2D) = "WHITE" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

#include "UnityCG.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
};

sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _SecondTex;
float4 _SecondTex_ST;
fixed4 _Color1;
fixed4 _Color2;
float _Blend;

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    fixed4 col;

                //1. Blending
    col = _Color1 + _Color2 * _Blend;

                //2. Interpolation
    col = _Color1 * (1 - _Blend) + _Color2 * _Blend;
    col = lerp(_Color1, _Color2, _Blend);

                //3. Textures
                //calculate uv coordinates
    float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
    float2 second_uv = TRANSFORM_TEX(i.uv, _SecondTex);
                //read colors from texture
    //
    fixed4 main_color = tex2D(_MainTex, main_uv);
    fixed4 second_color = tex2D(_SecondTex, second_uv);
                //interpolate
    col = lerp(main_color, second_color, _Blend);

    return col;
}
            ENDCG
        }
    }
}



