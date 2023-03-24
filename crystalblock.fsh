//BSD license
//author khlorghaal

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

const int bounces= 6;
const float TRANSMITTANCE= .88;//~.82 consistently magical, idfk why


//layout(location=0) smooth in vec3 v_Nm;
//layout(location=1) smooth in vec3 v_Nv;
//layout(location=2) smooth in vec3 Pm;
//layout(location=3) smooth in vec3 Pv;
//layout(location=4) smooth in vec4 Pp;

vec3 env(vec3 V){
	V = V*V;
	V= lerp(V,V*V,.9);
	float l= sum(V);
	return vec3(l);
}

#define GAUSS(x) exp(-x*x*rough)

vec3 nseN(vec3 v){
	v= floor((v+.25)*4.);
	return GAUSS(rand33(v));
}
vec3 nseUV(vec2 uv){
	float a= dot(tex(tex0,uv).rgb,vec3(.3,.55,.15));//luminance
	a= sqrt(a);//contrast
	uv= floor((uv+1./16)*16.);
	vec3 b= rand23(uv);
	return norm(exp(-b*a*a));
}


#define DBREAK(c) fragColor= vec4(vec3(c),1); return;

void main(){
	vec4  C= vertexColor;
	vec2 UV= texCoord0;
	vec3  N= norm(normal);//viewspace
	vec3 N0= N;

	//DBREAK(env(N));

	vec3 alb= 
		unsrgb(tex(tex0, UV).rgb);
		//albedo;
	//DBREAK(alb)
	
	const vec3 V= BLUE;//view vector

	vec3 nse0=
		//nseN( Pm )*rough;
		nmaps(GAUSS(nseUV(UV)))*.5;
	//DBREAK(abs(nse0))

	N= N + nse0;
	N= norm(N);
	
	vec3 c= alb * ambient;
	
	//fresnel reflection, viewspace, non environmental
	vec3 rfl= reflect(V,N);
	float FR= sat(rfl.z);//fresnel
	//DBREAK(vec3(FR))
	
	vec3 Rp= Pm*.125;//ray pos
	vec3 Rd= Vm;//ray dir
	//reflaction operates in worldspace, except when dont
	float a= 1.;
	count(bounces){
		Rd= refract(abs(Rd),N,2.2);
		if( sum(Rd)==0. ){
			Rd= reflect(V,N);
			c+= ambient;
		}
		else
			c+= alb * env(Rd) * a;
		Rd= norm(Rd);

		//DBREAK(abs(Rd))
			
		//heuristic brdf
		//#define A 1
		#ifdef A
			Rp+= Rd*N;
			Rd+= N*a*.25;
			N+= nseN(Rd);
			N= norm(N);
		#else
	    	//Rp+= Rd*.05;
	    	//Rp+=  N*.125;
	    	//N+=nseN(Rd)*.2;
	    	//N= norm(N);

			N+= nseN(Rp)*.5;
			N= norm(N);
			Rp+= (Rd+N)*(a);//heuristic ramp;
	    #endif
	   	//DBREAK(abs(Rp))
	   	//DBREAK(abs(Rd))

		a*= TRANSMITTANCE;
	}
	//DBREAK(abs(norm(Rd)))

	float amag= 1;
	float asum= 0;//known't analytic integral
	count(bounces){
		asum+= amag;
		amag*= TRANSMITTANCE;
	}
	c/= asum;
	
	FR*=sqrt(FR)*FRm;//**1.5
	float FRw= FR*FR;
	c+= FR *reflective*FRm;//fresnel albedo
	c+= FRw*.8;//fresnel white

	c*= 3.;
	c*= 1.-(1./(1.+c));//rheinhard
	//c= norm(c)/max(1,maxv(c));//hue desat
	const float GAMMA= .9;
	c= pows(c,GAMMA);
	#define SRGB 1//srgb framebuffer is a fuck???

	#ifdef OPAQUE
		a= 1.;
	#else
		a= 1.-a;//high alpha is less transmission => less alpha
	#endif

	#ifdef SRGB
		c= srgb(c);
	#endif
	
	#ifdef DEBUG_NORMAL
		c= Nv*.5+.5;
	#endif


	fragColor = vec4(c,a);
}