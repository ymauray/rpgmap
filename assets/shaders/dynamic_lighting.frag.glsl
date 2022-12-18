#version 320 es

precision highp float;
layout(location=0)out vec4 fragColor;

layout(location=0)uniform vec2 iResolution;
layout(location=1)uniform float iTime;
layout(location=2)uniform vec2 playerPos;
layout(location=3)uniform vec2 wallS;
layout(location=4)uniform vec2 wallE;

vec4 getLight(float distance,float maxViewDistance,float dim){
    float light=dim*distance/maxViewDistance;
    return vec4(vec3(0.),light);
}

void main()
{
    float maxViewDistance=.2;
    float dim=.75;
    
    float aspectRatio=iResolution.x/iResolution.y;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    uv.x*=aspectRatio;
    
    // Normalized player position (from 0 to 1)
    vec2 player=playerPos/iResolution.xy;
    player.x*=aspectRatio;
    
    vec2 wallStart=wallS/iResolution.xy;
    wallStart.x*=aspectRatio;
    
    vec2 wallEnd=wallE/iResolution.xy;
    wallEnd.x*=aspectRatio;
    
    float d=distance(uv,player);
    
    if(d<maxViewDistance){
        
        vec2 ray=normalize(player-uv);
        float t=((uv.x-wallStart.x)*(wallEnd.y-wallStart.y)-(uv.y-wallStart.y)*(wallEnd.x-wallStart.x))/(ray.y*(wallEnd.x-wallStart.x)-ray.x*(wallEnd.y-wallStart.y));
        float u=((uv.x-wallStart.x)*ray.y-(uv.y-wallStart.y)*ray.x)/((wallEnd.x-wallStart.x)*ray.y-(wallEnd.y-wallStart.y)*ray.x);
        
        if(u>=0.&&u<=1.&&t>=0.){
            if(t<d){
                fragColor=vec4(0.,0.,0.,dim);
            }else{
                //fragColor=vec4(0.,0.,1.,.25);
                fragColor=getLight(d,maxViewDistance,dim);
            }
        }else{
            //fragColor=vec4(1.,1.,0.,.25);
            fragColor=getLight(d,maxViewDistance,dim);
        }
    }else{
        fragColor=vec4(0.,0.,0.,dim);
    }
}
