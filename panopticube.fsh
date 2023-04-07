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

const int bounces= 4;
const float TRANSMITTANCE= .75;//~.82 consistently magical, idfk why


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
	v= floor((v+.25)*4.);
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


#define DBREAK(c) fragColor= vec4(vec3(c),1); return;

void main(){
	vec4  C= vertexColor;
	vec2 UV= texCoord0;
	vec3  N= norm(normal);//viewspace
	vec3 N0= N;

	//DBREAK(env(N));
	//DBREAK(abs(N));

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
		//nseN( Pm )*rough;
		nseUV(UV)*rough*.01;
	//DBREAK(abs(nse0))

	N= N + nse0;
	N= norm(N);
	
    //alb= vec3(tri( lum(nse0)*80.5 + time*.2 )*.9+.1);

	vec3 c= alb;

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
	
	//DBREAK(vec3(abs(norm(Pv))));

	c= WHITE*.1;
	float a= 1.;
	//reflaction operates in worldspace
	vec3 Rd= norm(Pm);//ray dir
	vec3 Rp= Vm;//ray pos
	//DBREAK(abs(Rp));
	count(bounces){
		Rd= refract(Rd,N,1.5);
		if( sum(Rd)==0. ){
			Rd= reflect(V,N);
			c+= ambient;
		}
		else
			c+= env(Rd) * a;

		//heuristic brdf
		Rp+= Rd;
		N= sign(Rd)+Rp*.125;
		//Rp+= (Rd*N)*1.;

		N+= Rp*1.;
		N = norm(N);
		Rp+= (Rd*N)*1.;
		Rd= norm(Rd);
	   	//DBREAK(abs(Rp))
	   	//DBREAK(abs(Rd))


		a*= TRANSMITTANCE;
	}
	//DBREAK(fresnel(Rp));
	//DBREAK(abs(norm(Rd)));
	//DBREAK(abs(norm(Rp)))
	DBREAK(abs(N));

	float amag= 1;
	float asum= 0;//known't analytic integral
	count(bounces){
		asum+= amag;
		amag*= TRANSMITTANCE;
	}
	c/= asum;
	
	c+= FR;

	c= reinhard(c*1.,1.25);
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
