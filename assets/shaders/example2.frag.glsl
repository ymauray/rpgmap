#version 320 es

precision highp float;
layout(location = 0)out vec4 fragColor;

layout(location = 0)uniform vec2 iResolution;
layout(location = 1)uniform float iTime;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0.,2.,4.));

    // Output to screen
    fragColor = vec4(col,1.0);
}
