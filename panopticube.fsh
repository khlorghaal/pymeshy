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


vec3 reinhard(vec3 c, float e){
	float l = maxv(c);
	float l1= l*(1+(l/(e*e)))/(1+l);
	return c*(l1/l);
}

float sdbox(vec2 p){
	return maxv(abs(p-.5));
}

//@fabrice fork
vec3 hilbert(vec2 U){
    vec2 P= vec2(.5);
    const vec2 X=vec2(1,0);
    const vec2 Y=vec2(0,1);
    vec2 l=-X;
    vec2 r=-X;


    #define swap(T,a,b){ T t= a; a=b; b=t; }
    
    const int N_H= 3;
    vec2 fU;
    bvec2 c;
    float d;
    vec3 acc= vec3(0);
    vec2 U0= U;
    vec2 D;
    count(N_H){
    	vec2 fC= step(.5,U);
        c= bvec2(fC);// select child

        vec2 dU= U;
        U= 2.*U- fC; // go to new local frame
        //dU= dU-U- fC;
        //acc+= vec3(0,dU);//color

        l=  c.x? c.y ? -Y :-X
               : c.y ?  l : Y;
        r= (c.x==c.y)?  X 
        	   : c.y ? -Y : Y;

       	//if(n==0){
   	    //	acc= vec3(0.,c);
   	    //}

       	if(n==2){
   	       	if(!c.y || !c.x)
   	       		if(c.x)
   	       			acc+= GREEN;
   	       		else
   	       			acc+= RED;
   	       	else
   	       		if(c.x)
   	       			acc+= CYAN;
   	       		else
   	       			acc+= BLUE;
   	    }
   	    //float bb= sat(sdbox(U)*32.-13.);
        //if(n==1){
        //	//acc= vec3(bb)*.2;
       	//    acc+= vec3(l.g, 0,0)*(1-bb)*.5;
       	//    acc+= vec3(  0,r.rg)*(1-bb)*.5;
       	//    return acc;
        //	acc*= 1-bb;
       	//}
        
        if (c.x){// sym
        	U.x = 1-U.x;  l.x=-l.x;  r.x=-r.x;  swap(vec2,r,l); }
        if (c.y){// rot+sym
        	U   = 1-U.yx; l  =-l.yx; r  =-r.yx; }

        dU= dU-U;

        //float S;
		//if(n==2){
       	//if(c.x)
       	//	if(!c.y){
       	//		S=  -dU.x +1.5
       	//		  + -dU.y;}
       	//	else{
       	//		S=  -dU.y +2.5
       	//		  + -dU.x;}
       	//else
       	//	if(!c.y){
       	//		S=  dU.y +1.
       	//		   -dU.x;}
       	//	else{
       	//		S= -dU.x 
       	//		  + dU.y;}}
	    //acc+= vec3(S/4)*exp2(-n); //lum
	    //acc+= vec3(0,D)*exp2(-n); //colored

        //acc *= 2.5;//max octave amp
        //acc*= .075;//min octave amp
    }
    //acc= vec3(sum(abs(U0-U)))*.5;

    //acc= norm(abs(acc));

    //return WHITE*acc= norm(acc);
    //return WHITE*len(acc)*.5;
    //return len(acc);

    vec2 dUP= U-P;
    #define rd(v) step(.0,v)
    #define plot(q) \
    ( rd(dot(dUP,q)) * .002/abs( dot( dUP, vec2(-q.y,q.x) )) )
    //( dot(dUP,l) < 0. ?  0: .0125/abs( dot( dUP, vec2(-l.y,l.x) )) )
    acc*= .5+vec3(plot(l)+plot(r))*.5;
	return acc;
}

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
		//unsrgb(tex(tex0, UV).rgb);
		srgb(albedo);
	//DBREAK(alb)

	DBREAK(hilbert(UV))
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
		nmaps(GAUSS(nseUV(UV)))*.25;
	//DBREAK(abs(nse0))

	N= N + nse0;
	N= norm(N);
	
	vec3 c= alb * ambient;
	
	//fresnel reflection, viewspace, non environmental
	vec3 rfl= reflect(V,N);
	vec3 FR= fresnel(rfl);//color
	//DBREAK(vec3(FR))
	

	float a= 1.;
	/*
	vec3 Rp= Pm*.125;//ray pos
	vec3 Rd= Vm;//ray dir
	//reflaction operates in worldspace, except when dont
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
	*/
	
	c+= alb;

	c+= FR;

	c= reinhard(c*1.,1.5);
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
	
	#ifdef DEBUG_NORMAL
		c= Nv*.5+.5;
	#endif


	fragColor = vec4(c,a);
}
