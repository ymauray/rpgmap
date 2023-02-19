precision highp float;

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 iLightPos;

out vec4 fragColor;

void main()
{
    // Normalized pixel position (from 0 to 1)
    float aspectRatio=iResolution.x/iResolution.y;
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    uv.y/=aspectRatio;
    
    // Normalized light source position (from 0 to 1)
    vec2 player=iLightPos/iResolution.xy;
    player.y/=aspectRatio;

    vec2 ray=normalize(uv-player);
    
    float d=distance(uv,player);
    if (d <= .25) {
        // de 1.0, 1.0, 0 => 1.0, 1.0, 1.0
        fragColor=vec4(1.,1.,d/.25,1.0);
    }
     
}
