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
layout(location=3) uniform vec3 ambient;
layout(location=4) uniform vec3 reflective;
layout(location=5) uniform vec3 albedo;
layout(location=6) uniform float rough;
layout(location=7) uniform float IOR;
layout(location=8) uniform float FRm;//fresnel magnitude

uniform sampler2D tex0;


const vec3 col_x= vec3(.75,.125,0)*1.;
const vec3 col_y= vec3(0,.75,.125)*1.;
const vec3 col_z= vec3(.125,0,.75)*1.;

const int bounces= 2;
const float TRANSMITTANCE= .82;//~.82 consistently magical, idfk why


vec3 reinhard(vec3 c, float e){
	float l = maxv(c);
	float l1= l*(1+(l/(e*e)))/(1+l);
	return c*(l1/l);
}

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

	vec3 alb= unsrgb(tex(tex0, UV).rgb);
	//DBREAK(alb)

	const vec3 V= BLUE;//view vector

	vec3 nse0=
		//nseN( Pm )*rough;
		nseUV(UV)*rough;

	N= N + nse0;
	N= norm(N);
	
	vec3 c= BLACK;


	vec3 emi= vec3(lum(((tri( (alb)*14. + time*2. )))));
	emi= lerp(emi,alb, sat(len(prod(alb)-alb)));
	float lemi= lum(emi);//hea isa braight ladde
	lemi*= sat(abs(dot(V,N))*1.5+.5);//directional lobe
	emi*= alb*lemi;
	float a= sat(lemi*lemi*2.+.125);
	c+= emi*1.5;
	//DBREAK(emi);
	
	//fresnel reflection, viewspace, non environmental
	vec3 rfl= reflect(norm(Vm),N);

	vec3 FR;
	{
		vec3 R= rfl;
		float a= R.z;
		a*= a*a;//ramp
		float w= a*a*a;//white component, narrower angle
		a*= FRm;//magnitude
		w*= FRm;
		vec3 c;
		c+= a*alb;//albedo
		c+= w;//white
		FR= c;
	}

	//c= WHITE/16;
	vec3 re= env(rfl);
	c+= re*alb*.75;
	//DBREAK(re.x)
	//a*= 1-re.x;
	//a*= 1-(rfr.a*.5);//high alpha is less transmission => less alpha

	//c+= env(rfl)*.2;
	
	c+= FR*2.;
	//DBREAK(FR)

	c= reinhard(c*1.,1.25);

	//c= lerp(norm(c),vec3(lum(c)),.2);

	//const float GAMMA= .5;
	//c= pows(c,GAMMA);
	//#define SRGB 1//srgb framebuffer is a fuck???

	#ifdef SRGB
		c= srgb(c);
	#endif
	
	fragColor = vec4(c,a);
}
