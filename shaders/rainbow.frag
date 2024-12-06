//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//SHADERTOY PORT FIX
#define posterSteps 4.0
#define lumaMult 0.6
#define timeMult 0.3
#define BW 0

float rgbToGray(vec4 rgba) {
	const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgba.xyz, W);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 color = texture(iChannel0, uv);
    float luma = rgbToGray(color) * lumaMult;
    float lumaIndex = floor(luma * posterSteps);
   	float lumaFloor = lumaIndex / posterSteps;
    float lumaRemainder = (luma - lumaFloor) * posterSteps;
    if(mod(lumaIndex, 2.) == 0.) lumaRemainder = 1.0 - lumaRemainder; // flip luma remainder for smooth color transitions
    float timeInc = iTime * timeMult;
    float lumaCycle = mod(luma + timeInc, 1.);
    vec3 roygbiv = hsv2rgb(vec3(lumaCycle, 1., lumaRemainder));
    if(BW == 1) {
        float bw = rgbToGray(vec4(roygbiv, 1.));
        fragColor = vec4(vec3(bw), 1.0);
    } else {
        fragColor = vec4(roygbiv, 1.0);
    }
}