//BSD license
//author khlorghaal

#define DEBUG
//#define DEBUG_NORMAL


#define OPAQUE 1

#define TEXTURE_NOISE 1

smooth in vec4 vertexColor;
smooth in vec2 texCoord0;
smooth in vec3 normal;//viewspace
smooth in vec3 Pm;//position modelspace
smooth in vec3 Pv;//position viewspace
smooth in vec3 Vm;//viewvector modelspace

out vec4 fragColor;



layout(location=2) uniform float time;
layout(location=3) uniform vec3 ambient;
layout(location=4) uniform vec3 reflective;
layout(location=5) uniform vec3 albedo;
layout(location=6) uniform float rough;
layout(location=7) uniform float IOR;
layout(location=8) uniform float FRm;//fresnel magnitude

uniform sampler2D tex0;

const int bounces= 7;
const float TRANSMITTANCE= .85;//~.82 consistently magical, idfk why


vec3 reinhard(vec3 c, float e){
	float l = maxv(c);
	float l1= l*(1+(l/(e*e)))/(1+l);
	return c*(l1/l);
}


vec3 env(vec3 V){
	V = V*V;
	V= lerp(V,V*V,.9);
	float l= sum(V);
	return vec3(l);
}

#define GAUSS(x) exp(-x*x)

vec3 nseN(vec3 v){
	v= floor((v+.125)*8.);
	return GAUSS(rand33(v));
}
vec3 nseUV(vec2 uv){
	float a= dot(tex(tex0,uv).rgb,vec3(.3,.55,.15));//luminance
	//a= sqrt(a);//contrast
	uv= floor((uv+1./16)*16.);
	vec3 b= rand23(uv);
	return norm(exp(-b*a*a));
}

vec3 fresnel(vec3 R){
	float a= R.z;
	a*= a*a*a;//ramp
	float w= a*a*a;//white component, narrower angle
	a*= FRm;//magnitude
	w*= FRm;
	vec3 c;
	c+= a*reflective;//albedo
	c+= w;//white
	return c;
}

vec4 reflact(vec3 R, vec3 N){
    vec3 ra= norm(R);
    vec3 rc= R*1.;
    ra= -abs(ra);
    rc= -abs(rc);
    //return abs(rc);
    
    //float ior= sin(time*2.)*-.4 + sin(time*3.5)*.5 + 1.25;
    float ior= 1.5;
    float iorrcp= 1./ior;
    
	vec3 p= rc;//position+near
	vec3 v= norm(ra);//march velocity
	vec3 a= BLACK;//accumulator
	//N= vec3(ETA);//normal
    ass(real(p+v+a+ra+rc),RED);
	float m= 1.;// magnitude | final alpha
    count(bounces){
		//march
		vec3 sv= sign(v);
		vec3 ef= floor(p);
		vec3 e= ef+step(vec3(0.), sv);//next edges
		
		vec3 dp= e-p;//delta position to each next-edge
		vec3 edt= dp/nozero(v);//time to each edge
		float dt= minv(edt);//time to soonest edge
        ass(dt>=0.,ORANGE);//assert no negative time


    	vec3 rfr= refract(v,N, iorrcp);
		vec3 rfl= reflect(v,-N);
		if(eqf(maxv(rfr),0.) || !real(rfr) )
            rfr= rfl;
        v= rfr+rfl*1.5;

        //vec3 rho= rand13(sum(p));
		//v+= 1.-GAUSS( rho*rough*.42 );

		v= norm(v);
  
        dp= v*(dt+ETA*8.);//if very precisely into an edge, may diagonal leap, dependent on eta
        p+= dp;
        N= ef-ceil(p);
        N= norm(N);

        //brdf
        vec3 C= abs(N);
        vec3 c= 
              C.x*RED
            + C.y*GREEN
            + C.z*BLUE;
        const float h= .420;
        float l= sat(maxv(abs(dp))-h);
        c*= l;
        //c= vec3(lum(c));

        a+= c*m;
        m*= TRANSMITTANCE;
      
	}

    float cnorm= 1.;///(1.-pow(1.-TRANSMITTANCE,float(maxb)));
    //empirical luminance normalization
    //meaning i have no fucking clue how it do
    
    //return vec4(abs(N),m);
    return vec4(a,m);
}


#define DBREAK(c) fragColor= vec4(vec3(c),1); return;

void main(){
	vec4  C= vertexColor;
	vec2 UV= texCoord0;
	vec3  N= norm(normal);//viewspace
	vec3 N0= N;

	//DBREAK(env(N));
	//DBREAK(abs(N));
	//DBREAK(abs(Vm));

	vec3 alb= 
		unsrgb(tex(tex0, UV).rgb);
		//srgb(albedo);
	//DBREAK(alb)

	//DBREAK(hilbert(UV))
		/*
	//alb*= hilbert2(UV);
	float hc;
	float h= float(hilbert2(32,nmapu(UV)*32.,hc));
	//DBREAK(vec3(hc,vec2(.25*log2(h*.05))));
	// DBREAK(fract(h/(fract(time/16)*4))); //fract of hilbert length causes peculiar alignments
	float T= fract((time*3.)/32.)*32;
	DBREAK(hc*fract(h/T));
	//DBREAK(1.-exp(-h*.001));
	//DBREAK(vec3(0,UV));*/
	
	const vec3 V= BLUE;//view vector

	vec3 nse0=
		nseN( Pm )*rough;
		//nseUV(UV)*rough;
	//DBREAK(abs(nse0))

	N= N + nse0;
	N= norm(N);
	
    //alb= vec3(tri( lum(nse0)*80.5 + time*.2 )*.9+.1);

	vec3 c= BLACK;

	vec3 emi= alb*vec3(lum(((tri( (alb)*32. + time*.65 )))));
	emi*= sat(abs(dot(V,N))*1.25+.25);//slight directional lobe
	//DBREAK(emi);
	float lemi= lum(emi);
	lemi*= lemi;//hea isa braight ladde
	emi*= lemi;
	c+= emi;
	//DBREAK(emi);
	
	//fresnel reflection, viewspace, non environmental
	vec3 rfl= reflect(V,N);
	vec3 FR= fresnel(rfl);//color
	//DBREAK(vec3(FR))

	//c= WHITE/16;
	float a= 1.;
	vec4 rfr= reflact(Vm, N);
	//DBREAK(rfr.rgb);
	a= rfr.a;
	c+= rfr.rgb;

	//c+= env(rfl)*.2;
	
	c+= FR;

	c= reinhard(c*1.2,.8);
	//const float GAMMA= 1.0;
	//c= pows(c,GAMMA);
	//#define SRGB 1//srgb framebuffer is a fuck???

	#ifdef OPAQUE
		a= 1.;
	#else
		a= 1.-a;//high alpha is less transmission => less alpha
	#endif

	#ifdef SRGB
		c= srgb(c);
	#endif
	


	fragColor = vec4(c,a);
}
