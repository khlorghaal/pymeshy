//BSD license
//author khlorghaal

#define DEBUG
//#define DEBUG_NORMAL

//#define SRGB 1

//#define OPAQUE 1

smooth in vec4 vertexColor;
smooth in vec2 texCoord0;
smooth in vec3 normal;//viewspace
smooth in vec3 Pm;//position modelspace
smooth in vec3 Pv;//position viewspace
smooth in vec3 Vm;//viewvector modelspace

out vec4 fragColor;


layout(location=2) uniform float time;
layout(location=6) uniform float rough;//uh todo (never)

layout(location= 9) uniform sampler2D tex0;
layout(location=10) uniform sampler2D tex1;
layout(location=11) uniform sampler2D tex2;

layout(location=8) uniform float FRm;//fresnel magnitude




vec3 env(vec3 V){
	V= norm(V);
	V = V*V*V;
	V= abs(V);
	float l= sum(V)/3;
	l= sat(smoother(l));
	return vec3(l);
}

#define GAUSS(x) exp(-x*x)

vec3 nseN(vec3 v){
	v= floor(v*2);
	return GAUSS(rand33(v));
}
vec3 nseUV(vec2 uv){
	float a= dot(tex(tex0,uv).rgb,vec3(.3,.55,.15));//luminance
	//a= sqrt(a);//contrast
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

	//DBREAK(alb)

	const vec3 V= BLUE;//view vector

	vec3 nse0=
		//nseN( Pm )*rough;
		nseUV(UV)*rough;

	N= N + nse0;
	N= norm(N);
	

	vec4 talb= tex(tex0,UV);
	vec4 tflw= tex(tex1,UV);
	vec4 temi= tex(tex2,UV);
	vec3 alb= talb.rgb;
	vec1 flw= tflw.g;
	vec3 emi= temi.rgb*temi.a;//premul

	vec3 c= alb*.75;//darken albedo
	float a= .7*talb.a;//heuristic albedo-alpha

	float lal= lum(alb)+.25;
	a*= smoother(lal);

	
	{//emission
		const float flow_rate= 1.5;
		const float flow_freq= 5.;
		float l= tri( (flw.x)*flow_freq + time*flow_rate );
		l*= sat(abs(dot(V,N))*2.);//brdf lobe, decrease energy towards tangent
		//l= pow(l,.85);//gamma

		float la= l*temi.a;
		c-= c*la*la;//preserve emission hue
		c+= emi*1.*la;
		a+= la;
	}

	//viewspace reflection
	vec3 rfl= reflect(norm(Vm),N);

	vec3 FR;//esnel
	{
		vec3 R= rfl;
		float a= abs(R.z);
		a*= a*a;//ramp
		float w= a*a*a;//white component, narrower angle
		a*= FRm;//magnitude
		w*= FRm;
		vec3 c;
		c+= a*alb;//albedo
		c+= w;//white
		FR= c;
	}
	c+= FR;

	//environment reflection
	c+= env(rfl)*alb*.7;
	
	c= reinhard(c*1.,1.125);

	//const float GAMMA= .5;
	//c= pows(c,GAMMA);
	//#define SRGB 1//srgb framebuffer is a fuck???

	#ifdef SRGB
		c= srgb(c);
	#endif
	
	fragColor = vec4(c,a);
}
