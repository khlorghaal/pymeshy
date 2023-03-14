//BSD license
//author khlorghaal

//#define DEBUG_NORMAL


//vanil
uniform sampler2D Sampler0;
uniform vec4 ColorModulator;//idfk what this is
//where is the lightmap???

smooth in vec4 vertexColor;
smooth in vec2 texCoord0;
smooth in vec3 normal;//viewspace
smooth in vec3 pos;//modelspace

out vec4 fragColor;



uniform float time;
//uniform vec3 ambient=      vec3(1.0, 1.0, 5.)/255.;
//uniform vec3 reflective=   vec3(0.1, 0.6, 1.)*1.;
//uniform vec3 transmissive= vec3(0.8, 1.0, 1.)*.8;
//uniform float rough= .5;
//uniform float IOR= 1.1;

const int bounces= 3;


//layout(location=0) smooth in vec3 v_Nm;
//layout(location=1) smooth in vec3 v_Nv;
//layout(location=2) smooth in vec3 Pm;
//layout(location=3) smooth in vec3 Pv;
//layout(location=4) smooth in vec4 Pp;


vec3 env(vec3 V){
	V = V*V;
	V+= V*V;
	float l= sum(V.xz)/3.;
	return vec3(l);
}

vec3 nseN(vec3 v){
	return rand33(floor((v+.25)*4.))*2.-1.;
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
void fsurf(
	in vec2 uv,
	inout vec3 N,
	out vec3 emis,
	#ifndef OPAQUE
		out float opac
	#endif
	){

	vec4 tx= tex(Sampler0,uv);



	//color
	emis= tx.rgb;

	//flow
	float t= tx.a;
	if(t!=1.){
		t= tri(t);//
		emis*= 1+t; 
	}

}


void main(){
	/*
	vec3 nse0= nseN(  );

	N= lerp( N, nse0, rough);
	
	N= norm(N);
	
	vec3 c= vec3(0);
	
	//reflection
	vec3 rfl= reflect(V,N);
		
	vec3 R= Pm;
	float a= 1.;
	count(bounces){
		//refraction
		vec3 rfr= refract(V,N,IOR);
		if( sum(rfr)==0. )
			c+= ambient * a;
		else
			c+= 1.* env(R) * a;
			
		//heuristic
		N= lerp(N,nseN(R),.8);
		N= norm(N);    
		R+= (rfr+N)*.5;
		
		a*= transmissive;
	}
	c/= float(bounces);
	
	c+= env(rfl) * reflective;


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

	gl_FragColor = vec4(c,a) * ColorModulator;
	*/
	fragColor = vec4(abs(normal), 1);
}