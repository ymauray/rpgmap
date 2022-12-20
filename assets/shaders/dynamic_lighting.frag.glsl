precision highp float;

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 playerPos;
uniform float nwalls;

const int MAX_WALLS = 150 * 2;
uniform vec2 walls[MAX_WALLS];

out vec4 fragColor;

vec4 getLight(float distance,float maxViewDistance,float dim){
    float light=dim*distance/maxViewDistance;
    return vec4(vec3(0.),light);
}


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
    float maxViewDistance=.275;
    float dim=.75;
    
    float aspectRatio=iResolution.x/iResolution.y;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    uv.x*=aspectRatio;
    
    // Normalized player position (from 0 to 1)
    vec2 player=playerPos/iResolution.xy;
    player.x*=aspectRatio;
    
    vec2 ray=normalize(uv-player);
    
    float d=distance(uv,player);
    
    if(d<maxViewDistance){
        float nohit=1.;
        for (int i = 0; i < MAX_WALLS; i += 2) {
            if (i >= int(nwalls * 2)) break;
            vec2 wallStart = walls[i];
            vec2 wallEnd = walls[i + 1];
            nohit *= checkNoHit(wallStart, wallEnd, ray, player, uv, d, aspectRatio, nohit);
        }

        if(nohit==0.){
            fragColor=vec4(0.,0.,0.,dim);
        }else{
            fragColor=getLight(d,maxViewDistance,dim);
        }
    }else{
        fragColor=vec4(0.,0.,0.,dim);
    }
}
