//Copyright 2019 khlorghaal most rights reserved

//Cubes make me happy.

//#define PANORAMIC
#define LOCK
#define INTERNAL_REFLECTION
//#define ANIMATE_IOR
//#define MOUSE_IOR
//#define ORBIT_CAM

//these are mutex
#define BRDF_EMISSIVE_0
//#define BRDF_EMISSIVE_1
//#define BRDF_PHONG
//#define BRDF_BOUNCE


layout(location=0) uniform  vec2  res;
layout(location=1) uniform ivec2 ires;
layout(location=2) uniform ivec2 iuv_offs;
layout(location=3) uniform int ss;
layout(location=4) uniform float time;
layout(location=5) uniform int MAX_I;//distance
layout(location=6) uniform int MAX_BOUNCE;//reflections


//const float time= 1.;

#define CAM_MOVE

const float TRANSMITTANCE= .82;//affects lumianance spatial freqenz of result; .84 is especially magical
const float EXPOSURE= 2.2;
const float GAMMA=  1.2;


const vec3 COLOR_A = vec3( .8,0.2,-0.10);
const vec3 COLOR_B = vec3( -0.1,.28,-0.05);
const vec3 COLOR_C = vec3( -0.1,-.20,1.);

const float IOR= .25;//high abs ior will cause rapid extinction

const float ROUGH= .1;

vec3 scatter(vec3 v, float s){
	return vnsesv(v);
}


bool stagger(vec3 p){
	int n= 1;
	return \
	((int(int(p.x)+int(p.x<0.))&n)==0)&&
	((int(int(p.y)+int(p.y<0.))&n)==0)&&
	((int(int(p.z)+int(p.z<0.))&n)==0);
}
vec3 img(vec2 uv){
    vec2 uvn= nmaps(uv);
    uvn.x*= asp;
    

    vec3 ra= vec3( uvn, -1.);
    vec3 rc= vec3( uvn, .0 );

    _FOV= 1.5;
	ray r= look_persp_orbit(uvn,vec2(
    	#ifdef CAM_MOVE
    		(3.+time*.2  )/8.,
    		(1.+time*.1   )/8.)*TAU,
		#else
    		(1.5)/8.,
    		(10.9)/8.)*TAU,
    	#endif
    	4.5);
    ra= r.a;
    rc= r.c*1.-40.;

    //rc+=.5;//translate
    rc.y+= 2.;

    
    //float ior= sin(time*2.)*-.4 + sin(time*3.5)*.5 + 1.25;
    //ior= sqrt(ior);
    //ior= ior*ior*ior;
    //float ior= IOR + sin(time*.04)*sin(time*.03)*1.98;
    float ior= 3.2;

    float iorrcp= 1./ior;
    
	vec3 p= rc;//position+near
	vec3 v= norm(ra);//march velocity
	vec3 a= BLACK;//accumulator
	vec3 n= vec3(ETA);//normal
    ass(real(p+v+a+ra+rc),RED);
    int b= 0;//bounce number
	float cmag= 1.;
	bool s= stagger(p);
    int i=0;
    int maxi= MAX_I;
    int maxb= MAX_BOUNCE;
    for(; i<maxi; i++){
		if(b>maxb)
			break;//worth the warp divergence

		//march
		vec3 sv= sign(v);
		vec3 ef= floor(p);
		//vec3 ec= ef+1.;
		vec3 e= ef+step(vec3(0.), sv);//next edges
		
		vec3 dp= e-p;//delta position to each next-edge
		vec3 edt= dp/nozero(v);//time to each edge
		float dt= minv(edt);//time to soonest edge
        ass(dt>=0.,ORANGE);//assert no negative time
        
        dp= v*(dt+ETA*4.);//if very precisely into an edge, may diagonal leap, dependent on eta
        p+= dp;
        n= ef-floor(p);
        ass(len(n)>0., GREEN);
        n= norm(n);
        ass(len(n)<=1., RED);
        ass(real(n),BLUE);
        //ass(sum(abs(n))<=1., RED);

		
		bool ps= s;//previous
        s= stagger(p);//true:entering , false:exiting medium
		if(s^^ps){ // transmission
			ass(len(v)>ETA && len(n)>ETA, WHITE);
			vec3 r;
			r= refract(v,n, s?ior:iorrcp);
			//r= norm(r); i dont know why this is undesirable
			if(eqf(maxv(r),0.)){
            	#ifdef INTERNAL_REFLECTION
                    r= reflect(v,n);
                    v= norm(r);
                    b++;
                    cmag*= TRANSMITTANCE;
                    continue;
                #else
               		break;
            	#endif
			}

            vec3 rho= rand3(sum(p)*.001);

			r+= 1.-exp2(-rho*rho*  ROUGH * nmapu(cos(time*.001)) );

			v= norm(r);
            if(s){//hit
                //brdf
                vec3 C= abs(n);
                vec3 c= 
                      C.x*COLOR_A
                    + C.y*COLOR_B
                    + C.z*COLOR_C;
                const float h= .2;
                float l= sat(maxv(1.-abs(dp))-h)/(1.-h);
                c*= l;

                a+= c*cmag;
                cmag*= TRANSMITTANCE;
                b++;
            }
		}
		ass(real(dt), CYAN);
		ass(real(v), YELLOW);
		ass(real(n), MAGENTA);
    }

    //if(uvn.x>0)
    //	a=lerp(a,(norm(a)-.2)*9.,.5);

    float cnorm= 1.;///(1.-pow(1.-TRANSMITTANCE,float(maxb)));
    //luminance normalization is empirical
    //meaning i have no fucking clue how it works
    
    return a*cnorm;
}






layout(binding=0, rgba16f) writeonly restrict uniform image2D img_o;

layout(
	local_size_x= 8,
	local_size_y= 8,
	local_size_z= 1
	) in;

void main(){
	ivec2 iuv= ivec2(gl_GlobalInvocationID.xy);
	iuv+= iuv_offs;
	 vec2  uv= (vec2(iuv))/res;

	vec4 col= vec4(0);

    if(ss>1){
        for(int x=0; x<ss; x++){
            for(int y=0; y<ss; y++){
            	vec4 c= vec4(img( uv + vec2(x,y)/((ss+1)*res)  ),1.);
            	if(real(c))
                	col+=c;
            }
        }
        col/= float(ss*ss);
    }else{
        col=vec4(img(uv),1.);
    }
    
    #ifdef DEBUG
        col= vec4(_err,1.);
    #endif
    

    //tonemap
    col*=EXPOSURE;
    //col*= 1.-1./(1.+lum(col.rgb));//rheinhard
 	col = vec4(1)- 1./(vec4(1) + pows(col,2.2));//parnell
 	//col = vec4(1)- 1./(exp(col)+1);

    col= pow(col,vec4(GAMMA));
    col.a= 1.;

    col= sat(col);
	imageStore(img_o, iuv, col);
}
