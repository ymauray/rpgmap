#version 320 es

precision highp float;
layout(location=0)out vec4 fragColor;

layout(location=0)uniform vec2 iResolution;
layout(location=1)uniform float iTime;
layout(location=2)uniform vec2 playerPos;
layout(location=3)uniform float nwalls;
layout(location=4)uniform vec2 wall001Start;
layout(location=5)uniform vec2 wall001End;
layout(location=6)uniform vec2 wall002Start;
layout(location=7)uniform vec2 wall002End;
layout(location=8)uniform vec2 wall003Start;
layout(location=9)uniform vec2 wall003End;
layout(location=10)uniform vec2 wall004Start;
layout(location=11)uniform vec2 wall004End;
layout(location=12)uniform vec2 wall005Start;
layout(location=13)uniform vec2 wall005End;
layout(location=14)uniform vec2 wall006Start;
layout(location=15)uniform vec2 wall006End;
layout(location=16)uniform vec2 wall007Start;
layout(location=17)uniform vec2 wall007End;
layout(location=18)uniform vec2 wall008Start;
layout(location=19)uniform vec2 wall008End;
layout(location=20)uniform vec2 wall009Start;
layout(location=21)uniform vec2 wall009End;
layout(location=22)uniform vec2 wall010Start;
layout(location=23)uniform vec2 wall010End;

vec4 getLight(float distance,float maxViewDistance,float dim){
    float light=dim*distance/maxViewDistance;
    return vec4(vec3(0.),light);
}

//float checkNoHit(vec2 wallStart,vec2 wallEnd,vec2 ray,vec2 uv,vec2 player,float d,float aspectRatio,float nohit){
    //    if (nohit == 0.){
        //        return 0.;
    //    }
    //    vec2 wallStartNormalized=wallStart/iResolution.xy;
    //    wallStartNormalized.x*=aspectRatio;
    
    //    vec2 wallEndNormalized=wallEnd/iResolution.xy;
    //    wallEndNormalized.x*=aspectRatio;
    
    //    float t=((uv.x-wallStartNormalized.x)*(wallEndNormalized.y-wallStartNormalized.y)-(uv.y-wallStartNormalized.y)*(wallEndNormalized.x-wallStartNormalized.x))/(ray.y*(wallEndNormalized.x-wallStartNormalized.x)-ray.x*(wallEndNormalized.y-wallStartNormalized.y));
    //    float u=((uv.x-wallStartNormalized.x)*ray.y-(uv.y-wallStartNormalized.y)*ray.x)/((wallEndNormalized.x-wallStartNormalized.x)*ray.y-(wallEndNormalized.y-wallStartNormalized.y)*ray.x);
    
    //    if(u>=0.&&u<=1.&&t>=0.){
        //        if(t<d){
            //            //fragColor=vec4(0.,0.,0.,dim);
            //            return 0.;
        //        }else{
            //            //fragColor=getLight(d,maxViewDistance,dim);
            //            return 1.;
        //        }
    //    }else{
        //        //fragColor=getLight(d,maxViewDistance,dim);
        //        return 1.;
    //    }
//}

float checkNoHit(vec2 wallStart,vec2 wallEnd,vec2 ray,vec2 uv,vec2 player,float d,float aspectRatio,float nohit)
{
    if(nohit==0.){
        return 0.;
    }
    
    vec2 wallStartNormalized=wallStart/iResolution.xy;
    wallStartNormalized.x*=aspectRatio;
    
    vec2 wallEndNormalized=wallEnd/iResolution.xy;
    wallEndNormalized.x*=aspectRatio;
    
    float t=((uv.x-wallStartNormalized.x)*(wallEndNormalized.y-wallStartNormalized.y)-(uv.y-wallStartNormalized.y)*(wallEndNormalized.x-wallStartNormalized.x))/(ray.y*(wallEndNormalized.x-wallStartNormalized.x)-ray.x*(wallEndNormalized.y-wallStartNormalized.y));
    float u=((uv.x-wallStartNormalized.x)*ray.y-(uv.y-wallStartNormalized.y)*ray.x)/((wallEndNormalized.x-wallStartNormalized.x)*ray.y-(wallEndNormalized.y-wallStartNormalized.y)*ray.x);
    
    float ret=0.;
    if(u>=0.&&u<=1.&&t>=0.){
        if(t<d){
            ret=0.;
        }else{
            ret=1.;
        }
    }else{
        ret=1.;
    }
    
    return ret;
}

void main()
{
    float maxViewDistance=.3;
    float dim=.75;
    
    float aspectRatio=iResolution.x/iResolution.y;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    uv.x*=aspectRatio;
    
    // Normalized player position (from 0 to 1)
    vec2 player=playerPos/iResolution.xy;
    player.x*=aspectRatio;
    
    vec2 ray=normalize(player-uv);
    
    float d=distance(uv,player);
    
    if(d<maxViewDistance){
        float nohit=1.;
        if(nwalls>0.)nohit*=checkNoHit(wall001Start,wall001End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>1.)nohit*=checkNoHit(wall002Start,wall002End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>2.)nohit*=checkNoHit(wall003Start,wall003End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>3.)nohit*=checkNoHit(wall004Start,wall004End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>4.)nohit*=checkNoHit(wall005Start,wall005End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>5.)nohit*=checkNoHit(wall006Start,wall006End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>6.)nohit*=checkNoHit(wall007Start,wall007End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>7.)nohit*=checkNoHit(wall008Start,wall008End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>8.)nohit*=checkNoHit(wall009Start,wall009End,ray,uv,player,d,aspectRatio,nohit);
        if(nwalls>9.)nohit*=checkNoHit(wall010Start,wall010End,ray,uv,player,d,aspectRatio,nohit);

        if(nohit==0.){
            fragColor=vec4(0.,0.,0.,dim);
        }else{
            fragColor=getLight(d,maxViewDistance,dim);
        }
    }else{
        fragColor=vec4(0.,0.,0.,dim);
    }
}
