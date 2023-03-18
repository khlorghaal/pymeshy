//BSD license
//author khlorghaal

//#define DEBUG_NORMAL


#define OPAQUE 1

#define TEXTURE_NOISE 1

smooth in vec4 vertexColor;
smooth in vec2 texCoord0;
smooth in vec3 normal;//viewspace
smooth in vec3 pos;//modelspace

out vec4 fragColor;



layout(location=2) uniform float time;
layout(location=3) uniform vec3 ambient;
layout(location=4) uniform vec3 reflective;
layout(location=5) uniform vec3 albedo;
layout(location=6) uniform float rough;
layout(location=7) uniform float IOR;

layout(location=8) uniform sampler2D tex0;

const int bounces= 4;


//layout(location=0) smooth in vec3 v_Nm;
//layout(location=1) smooth in vec3 v_Nv;
//layout(location=2) smooth in vec3 Pm;
//layout(location=3) smooth in vec3 Pv;
//layout(location=4) smooth in vec4 Pp;


vec3 env(vec3 V){
	V= abs(V);
	V = V*V*V;
	//V+= V*V;
	float l= sum(V)/3;
	return vec3(l);
}

vec3 nseN(vec3 v){
	v= floor((v+.25)*4.);
	return rand33(v)*2.-1.;
}
vec3 nseUV(vec2 uv){
	uv= floor((uv+.25)*4.);
	return sum(tex(tex0,uv).rgb)/3.
		*rand23(uv)*2.-1.;
}


/*
rgb behaves similarly to emission
	luminance as opacity

alpha channel
	 =1 functions normally
	!=1 is a flowmap
	where flow goes from [0,1)
	such that a gradient along [0,1)
	will make a looping pattern
	a longer gradient will have higher flow velocity

output emis not premultiplied
*/
/*
void fsurf(
	in vec2 uv,
	inout vec3 N,
	out vec3 emis,
	#ifndef OPAQUE
		out float opac
	#endif
	){

	vec4 tx= vec4(0);//tex(Sampler0,uv);



	//color
	emis= tx.rgb;

	//flow
	float t= tx.a;
	if(t!=1.){
		t= tri(t);//
		emis*= 1+t; 
	}

}
*/

#define distr(x) exp( -x*x * rough)

void main(){
	vec4  C= vertexColor;
	vec2 UV= texCoord0;
	vec3  N= norm(normal);//viewspace
	vec3  P= pos;//modelspace

	vec3 alb= tex(tex0, UV).rgb;
	//fragColor= vec4(alb,1); return;
	
	const vec3 V= BLUE;//view vector

	fragColor= vec4(0,fract(UV),1); return;
	fragColor= vec4(nseUV(UV),1); return;

	vec3 nse0= nseN( P );
	//fragColor= vec4(nse0,1); return;
	N= N + distr(nse0);
	
	N= norm(N);
	
	vec3 c= vec3(0);
	
	//reflection
	vec3 rfl= reflect(V,N);
	float FR0= abs(1-rfl.z);
	float FR1= FR0*FR0;
		
	vec3 R= P;
	float a= 1.;
	
	count(bounces){
		//refraction
		vec3 rfr= refract(V,N,IOR);
		if( sum(rfr)==0. )
			c+= alb * ambient * a;
		else
			c+= alb * env(rfr) * a;
			
		//heuristic
		N= N+ distr(nseN(N+time*.05));
		N= norm(N);
		R+= (rfr+N)*a*.5;
		
		a*= .9;
	}
	c/= float(bounces);
	
	c+= reflective*FR0 + (reflective/2+.5)*FR1;//fresnel with half-white factor

	c*= 2.;
	c*= 1.-(1./(1.+pow(maxv(c),.5)));

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