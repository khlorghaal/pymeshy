//Khlor's header
//https://github.com/khlorghaal/shaderheaders
//BSD license

//#define DEBUG 1

//Consts
#define PI  3.14159265359
#define TAU (PI*2.)
#define PHI 1.61803399
#define deg2rad 0.01745329251
#define SQRT2 (sqrt(2.))
#define SQRT3 (sqrt(3.))
#define BIG 1e8
#define SMALL 1e-8
#define ETA .5e-3
#define eqf(a,b) ( abs((a)-(b))<ETA )

//Aliases
#define aspect (res.x/res.y)
#define asp aspect
#define aspinv (1./aspect)
#define vec1 float
#define ivec1 int
#define uvec1 uint
#define len length
#define lerp mix
#define norm normalize
#define sat saturate
#define sats saturate_signed
#define smooth(x) smoothstep(0.,1.,x)
#define mouse ((iMouse.xy-res/2.)/(res*2.))
#define mouse_ang (mouse*TAU)
#define tex texture


vec3   srgb(vec3 c){ return pow(c,vec3(   2.2)); }
vec3 unsrgb(vec3 c){ return pow(c,vec3(1./2.2)); }
vec3 texsrgb(sampler2D s,   vec2 uv){ return unsrgb(texture(s,uv).rgb); }
vec3 texsrgb(samplerCube s, vec3  r){ return unsrgb(texture(s, r).rgb); }

//GLSL preproc lacks ## concat op

vec2 mods(vec2 x, vec1 y){ return mod(x,vec2(y));}
vec3 mods(vec3 x, vec1 y){ return mod(x,vec3(y));}
vec4 mods(vec4 x, vec1 y){ return mod(x,vec4(y));}

vec2 pows(vec2 x, vec1 y){ return pow(x,vec2(y));}
vec3 pows(vec3 x, vec1 y){ return pow(x,vec3(y));}
vec4 pows(vec4 x, vec1 y){ return pow(x,vec4(y));}

 vec2 clamps( vec2 x,  vec1 min,  vec1 max){ return clamp(x,  vec2(min), vec2(max));}
 vec3 clamps( vec3 x,  vec1 min,  vec1 max){ return clamp(x,  vec3(min), vec3(max));}
 vec4 clamps( vec4 x,  vec1 min,  vec1 max){ return clamp(x,  vec4(min), vec4(max));}
ivec2 clamps(ivec2 x, ivec1 min, ivec1 max){ return clamp(x, ivec2(min),ivec2(max));}
ivec3 clamps(ivec3 x, ivec1 min, ivec1 max){ return clamp(x, ivec3(min),ivec3(max));}
ivec4 clamps(ivec4 x, ivec1 min, ivec1 max){ return clamp(x, ivec4(min),ivec4(max));}

 vec2 mins( vec2 v,  vec1 s){ return min(v,  vec2(s));}
 vec3 mins( vec3 v,  vec1 s){ return min(v,  vec3(s));}
 vec4 mins( vec4 v,  vec1 s){ return min(v,  vec4(s));}
 vec2 maxs( vec2 v,  vec1 s){ return max(v,  vec2(s));}
 vec3 maxs( vec3 v,  vec1 s){ return max(v,  vec3(s));}
 vec4 maxs( vec4 v,  vec1 s){ return max(v,  vec4(s));}
 vec2 mins( vec1 s,  vec2 v){ return min(v,  vec2(s));}
 vec3 mins( vec1 s,  vec3 v){ return min(v,  vec3(s));}
 vec4 mins( vec1 s,  vec4 v){ return min(v,  vec4(s));}
 vec2 maxs( vec1 s,  vec2 v){ return max(v,  vec2(s));}
 vec3 maxs( vec1 s,  vec3 v){ return max(v,  vec3(s));}
 vec4 maxs( vec1 s,  vec4 v){ return max(v,  vec4(s));}
ivec2 mins(ivec2 v, ivec1 s){ return min(v, ivec2(s));}
ivec3 mins(ivec3 v, ivec1 s){ return min(v, ivec3(s));}
ivec4 mins(ivec4 v, ivec1 s){ return min(v, ivec4(s));}
ivec2 maxs(ivec2 v, ivec1 s){ return max(v, ivec2(s));}
ivec3 maxs(ivec3 v, ivec1 s){ return max(v, ivec3(s));}
ivec4 maxs(ivec4 v, ivec1 s){ return max(v, ivec4(s));}
ivec2 mins(ivec1 s, ivec2 v){ return min(v, ivec2(s));}
ivec3 mins(ivec1 s, ivec3 v){ return min(v, ivec3(s));}
ivec4 mins(ivec1 s, ivec4 v){ return min(v, ivec4(s));}
ivec2 maxs(ivec1 s, ivec2 v){ return max(v, ivec2(s));}
ivec3 maxs(ivec1 s, ivec3 v){ return max(v, ivec3(s));}
ivec4 maxs(ivec1 s, ivec4 v){ return max(v, ivec4(s));}

float maxv( vec2 a){ return                 max(a.x,a.y)  ;}
float maxv( vec3 a){ return         max(a.z,max(a.x,a.y)) ;}
float maxv( vec4 a){ return max(a.w,max(a.z,max(a.x,a.y)));}
float minv( vec2 a){ return                 min(a.x,a.y)  ;}
float minv( vec3 a){ return         min(a.z,min(a.x,a.y)) ;}
float minv( vec4 a){ return min(a.w,min(a.z,min(a.x,a.y)));}
 int maxv(ivec2 a){ return                 max(a.x,a.y)  ;}
 int maxv(ivec3 a){ return         max(a.z,max(a.x,a.y)) ;}
 int maxv(ivec4 a){ return max(a.w,max(a.z,max(a.x,a.y)));}
 int minv(ivec2 a){ return                 min(a.x,a.y)  ;}
 int minv(ivec3 a){ return         min(a.z,min(a.x,a.y)) ;}
 int minv(ivec4 a){ return min(a.w,min(a.z,min(a.x,a.y)));}

vec3 signv(vec3 v){ return vec3(sign(v.x),sign(v.y),sign(v.z));}
vec3 steps(vec3 v,float s){ return vec3(step(v.x,s),step(v.y,s),step(v.z,s));}

vec3 nozero(vec3 v){//if v has 0 component assign it eta, often to prevent div 0
    vec3 iszero= 1.-step(SMALL,abs(v));
    return v+iszero*SMALL;
}


//normalized map to signed
//[ 0,1]->[-1,1]
vec1 nmaps(vec1 x){ return x*2.-1.; }
vec2 nmaps(vec2 x){ return x*2.-1.; }
vec3 nmaps(vec3 x){ return x*2.-1.; }
vec4 nmaps(vec4 x){ return x*2.-1.; }
//normalized map to unsigned
//[-1,1]->[ 0,1]
vec1 nmapu(vec1 x){ return x*.5+.5; }
vec2 nmapu(vec2 x){ return x*.5+.5; }
vec3 nmapu(vec3 x){ return x*.5+.5; }
vec4 nmapu(vec4 x){ return x*.5+.5; }

//[0,1]
float saw(float x){ return mod(x,1.); }
vec1 tri(vec1 x){ return abs( mod (x,2.) -1.); }
vec2 tri(vec2 x){ return abs( mods(x,2.) -1.); }
vec3 tri(vec3 x){ return abs( mods(x,2.) -1.); }
  int tri(int x, int a){ return abs( abs(x%(a*2))-a ); }

float sum ( vec2 v){ return dot(v,vec2(1));}
float sum ( vec3 v){ return dot(v,vec3(1));}
float sum ( vec4 v){ return dot(v,vec4(1));}
  int sum (ivec2 v){ return v.x+v.y;}
  int sum (ivec3 v){ return v.x+v.y+v.z;}
  int sum (ivec4 v){ return v.x+v.y+v.z+v.w;}
float prod( vec2 v){ return v.x*v.y;}
float prod( vec3 v){ return v.x*v.y*v.z;}
float prod( vec4 v){ return v.x*v.y*v.z*v.w;}
  int prod(ivec2 v){ return v.x*v.y;}
  int prod(ivec3 v){ return v.x*v.y*v.z;}
  int prod(ivec4 v){ return v.x*v.y*v.z*v.w;}

#define sqrtabs(x) sqrt(abs(x))
#define powabs(x,p) pow(abs(x),p)

vec1 saturate(vec1 x){ return clamp (x, 0.,1.);}
vec2 saturate(vec2 x){ return clamps(x, 0.,1.);}
vec3 saturate(vec3 x){ return clamps(x, 0.,1.);}
vec4 saturate(vec4 x){ return clamps(x, 0.,1.);}
#define lerpsat(a,b,x) lerp(a,b,saturate(x))

vec1 saturate_signed(vec1 x){ return clamp (x, -1.,1.);}
vec2 saturate_signed(vec2 x){ return clamps(x, -1.,1.);}
vec3 saturate_signed(vec3 x){ return clamps(x, -1.,1.);}
vec4 saturate_signed(vec4 x){ return clamps(x, -1.,1.);}

#define smoother(x) (x*x*x * (x*(x*6.-15.)+10.) )


float pow2i(int x){ return float(1<<x); }

//nearest power of
int npo2(float x){ return int(log2(x)); }
int npo3(float x){ return int(log(x)/log(3.)); }

float angle(vec2 v){ return atan(v.y,v.x); }
vec1 angn(vec1 t){ return t-ceil(t/TAU-.5)*TAU; }
vec2 angn(vec2 t){ return t-ceil(t/TAU-.5)*TAU; }

bool real(vec1 x){ return !( isnan(x)||isinf(x) ); }
bool real(vec2 x){ return real(prod(x)); }
bool real(vec3 x){ return real(prod(x)); }
bool real(vec4 x){ return real(prod(x)); }

vec1 rationalize(vec1 x){ return real(x)? x:vec1(0.); }
vec2 rationalize(vec2 x){ return real(x)? x:vec2(0.); }
vec3 rationalize(vec3 x){ return real(x)? x:vec3(0.); }
vec4 rationalize(vec4 x){ return real(x)? x:vec4(0.); }

#define count(_n) for(int n=0; n!=_n; n++)

//im not sure if this is linear or srgb, or if that even matters much
#define LUMVEC vec3(0.2126, 0.7152, 0.0722)
float lum(vec3 c){ return dot(c,vec3(LUMVEC)); }

vec3 rgb2hsv(vec3 c){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c){
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
vec3 reinhard(vec3 c, float e){
	float l = maxv(c);
	float l1= l*(1+(l/(e*e)))/(1+l);
	return c*(l1/l);
}

#define BLACK  vec3(0.,0.,0.)
#define RED    vec3(1.,0.,0.)
#define GREEN  vec3(0.,1.,0.)
#define BLUE   vec3(0.,0.,1.)
#define YELLOW vec3(1.,1.,0.)
#define CYAN   vec3(0.,1.,1.)
#define MAGENTA vec3(1.,0.,1.)
#define WHITE  vec3(1.,1.,1.)

#define ORANGE vec3(1.,.5,0.)

#define INT_MAX     0x7FFFFFFF
#define INT_HALFMAX 0x00010000
#define INT_MAXF     float(INT_MAX)
#define INT_HALFMAXF float(INT_HALFMAX)
vec1 unfix16(vec1 x){ return vec1(x)/INT_HALFMAXF; }
vec2 unfix16(vec2 x){ return vec2(x)/INT_HALFMAXF; }
vec3 unfix16(vec3 x){ return vec3(x)/INT_HALFMAXF; }
vec4 unfix16(vec4 x){ return vec4(x)/INT_HALFMAXF; }
ivec1 fixed16(vec1 x){ return ivec1(INT_HALFMAXF*x); }
ivec2 fixed16(vec2 x){ return ivec2(INT_HALFMAXF*x); }
ivec3 fixed16(vec3 x){ return ivec3(INT_HALFMAXF*x); }
ivec4 fixed16(vec4 x){ return ivec4(INT_HALFMAXF*x); }

ivec4 hash(ivec4 x){
	x= ((x>>16)^x)*0x45d9f3b;
	x= ((x>>16)^x)*0x45d9f3b;
	//x=  (x>>16)^x;
    return x;
}
//[-max,+max]->[0,1]
vec1 hashf(vec1 x){ return abs(vec1(hash(ivec4(fixed16(x),0.,0.,0.)).x  ))/INT_MAXF; }
vec2 hashf(vec2 x){ return abs(vec2(hash(ivec4(fixed16(x),0.,0.   )).xy ))/INT_MAXF; }
vec3 hashf(vec3 x){ return abs(vec3(hash(ivec4(fixed16(x),0.      )).xyz))/INT_MAXF; }
vec4 hashf(vec4 x){ return abs(vec4(hash(ivec4(fixed16(x)         ))    ))/INT_MAXF; }

#define R2A vec2(.99231, .9933)
#define R2B vec2(.99111, .9945)
#define R3A vec3(.99312, .98313, .9846)
#define R3B vec3(.99111, .98414, .9935)
#define R4A vec4(.99412, .99343, .99565, .99473)
#define R4B vec4(.99612, .99836, .99387, .99376)
vec1 rand11 (vec1 x){ return hashf(x);   }
vec2 rand22 (vec2 x){ return hashf(x*hashf(x+x.yx)); }
vec3 rand23 (vec2 x){ return hashf((x.xyx*R3A+R3B)+hashf(R3A-x.yxy*R3B)); }
vec3 rand33 (vec3 x){ return hashf(x*1.e2*hashf(R3A+x+x.yzx+x.zxy)); }
vec4 rand44 (vec4 x){ return hashf(x*hashf(x+x.yzwx+x.zwxy+x.wxyz)); }
vec1 rand21(vec2 x){ return hashf(dot(x*R2A-R2B,-x*R2B+R2A)/x.x);  }
vec1 rand31(vec3 x){ return hashf(dot(x+R3A-R3B,-x+R3B+R3A));  }
vec1 rand41(vec4 x){ return hashf(dot(x+R4A-R4B,-x+R4B+R4A));  }
vec2 rand12(vec1 x){ return hashf(x+R2A);   }
vec3 rand13(vec1 x){ return hashf(x+R3A);   }

float bilerp(
	float nn, float np,
	float pn, float pp,
	vec2 l
){
	vec2 lx= lerp(
		vec2(nn,np),
		vec2(pp,pp),
		l.x
		);
	return lerp(lx.x,lx.y,l.y);
}
vec2 bilerp(
	vec2 nn, vec2 np,
	vec2 pn, vec2 pp,
	vec2 l
){
	vec4 lx= lerp(
		vec4(nn,np),
		vec4(pp,pp),
		l.xxxx
		);
	return lerp(lx.xy,lx.zw,l.yy);
}

float trilerp(float nnn,float nnp,float npn,float npp,float pnn,float pnp,float ppn,float ppp,  vec3 l){
	float lnn= lerp(nnn, pnn, l.x);
	float lnp= lerp(nnp, pnp, l.x);
	float lpn= lerp(npn, ppn, l.x);
	float lpp= lerp(npp, ppp, l.x);

	float lln= lerp(lnn,lpn, l.y);
	float llp= lerp(lnp,lpp, l.y);

	return lerp(lln,llp, l.z);
}
vec3 trilerp(vec3 nnn,vec3 nnp,vec3 npn,vec3 npp,vec3 pnn,vec3 pnp,vec3 ppn,vec3 ppp,  vec3 l){
	vec3 lnn= lerp(nnn, pnn, l.x);
	vec3 lnp= lerp(nnp, pnp, l.x);
	vec3 lpn= lerp(npn, ppn, l.x);
	vec3 lpp= lerp(npp, ppp, l.x);

	vec3 lln= lerp(lnn,lpn, l.y);
	vec3 llp= lerp(lnp,lpp, l.y);

	return lerp(lln,llp, l.z);
}


float vnse(vec1 x){ return lerp(rand11(floor(x)),rand11(ceil(x)),fract(x)); }
float vnse(vec2 p){
	vec2 fr= fract(p);
	vec2 f= floor(p);
	vec2 c= ceil(p);
	float nn= rand21(vec2(f.x,f.y));
	float np= rand21(vec2(f.x,c.y));
	float pn= rand21(vec2(c.x,f.y));
	float pp= rand21(vec2(c.x,c.y));
	vec4 v= vec4(nn,np,pn,pp);
	vec2 lx= lerp(v.xy,v.zw, fr.xx);
	return lerp( lx.x,lx.y, fr.y );
}
float vnse(vec3 p){
	vec3 fr= fract(p);
	vec3 f= floor(p);
	vec3 c= ceil(p);
	float nnn= rand31(vec3(f.x,f.y,f.z));
	float nnp= rand31(vec3(f.x,f.y,c.z));
	float npn= rand31(vec3(f.x,c.y,f.z));
	float npp= rand31(vec3(f.x,c.y,c.z));
	float pnn= rand31(vec3(c.x,f.y,f.z));
	float pnp= rand31(vec3(c.x,f.y,c.z));
	float ppn= rand31(vec3(c.x,c.y,f.z));
	float ppp= rand31(vec3(c.x,c.y,c.z));
	vec4 zn= vec4(
		nnn,
		npn,
		pnn,
		ppn
	);
	vec4 zp= vec4(
		nnp,
		npp,
		pnp,
		ppp
	);
	vec4 lx= lerp(zn,zp, fr.zzzz);
	vec2 ly= lerp(lx.xz, lx.yw, fr.yy);
	return lerp(ly.x,ly.y, fr.x);
}

float perlin(float p){
	float fr= fract(p);
	float frn= fr-1.;
	float f= floor(p);
	float c= ceil(p);
	float a= nmaps(rand11(f));
	float b= nmaps(rand11(c));
	return lerp(a,b,smooth(fr));
}
float perlin(vec3 p){
	vec3 fr= fract(p);
	vec3 frn= fr-1.;
	vec3 f= floor(p);
	vec3 c= ceil(p);
	vec3 nnn= nmaps(rand33(vec3(f.x,f.y,f.z)));
	vec3 nnp= nmaps(rand33(vec3(f.x,f.y,c.z)));
	vec3 npn= nmaps(rand33(vec3(f.x,c.y,f.z)));
	vec3 npp= nmaps(rand33(vec3(f.x,c.y,c.z)));
	vec3 pnn= nmaps(rand33(vec3(c.x,f.y,f.z)));
	vec3 pnp= nmaps(rand33(vec3(c.x,f.y,c.z)));
	vec3 ppn= nmaps(rand33(vec3(c.x,c.y,f.z)));
	vec3 ppp= nmaps(rand33(vec3(c.x,c.y,c.z)));
	float d_nnn= dot(nnn, vec3(fr .x, fr .y, fr .z));
	float d_nnp= dot(nnp, vec3(fr .x, fr .y, frn.z));
	float d_npn= dot(npn, vec3(fr .x, frn.y, fr .z));
	float d_npp= dot(npp, vec3(fr .x, frn.y, frn.z));
	float d_pnn= dot(pnn, vec3(frn.x, fr .y, fr .z));
	float d_pnp= dot(pnp, vec3(frn.x, fr .y, frn.z));
	float d_ppn= dot(ppn, vec3(frn.x, frn.y, fr .z));
	float d_ppp= dot(ppp, vec3(frn.x, frn.y, frn.z));
	vec4 zn= vec4(
		d_nnn,
		d_npn,
		d_pnn,
		d_ppn
	);
	vec4 zp= vec4(
		d_nnp,
		d_npp,
		d_pnp,
		d_ppp
	);
	vec4 lx= lerp(zn,zp, smooth(fr.zzzz));
	vec2 ly= lerp(lx.xz, lx.yw, smooth(fr.yy));
	return nmapu(lerp(ly.x,ly.y, smooth(fr.x)));
}


//value noise smooth vector
vec2 vnsesv(vec2 p){
	vec2 fr= fract(p);
	vec2 frn= fr-1.;
	vec2 f= floor(p);
	vec2 c= ceil(p);
	vec2 nn= rand22(vec2(f.x,f.y));
	vec2 np= rand22(vec2(f.x,f.y));
	vec2 pn= rand22(vec2(f.x,c.y));
	vec2 pp= rand22(vec2(f.x,c.y));

	return bilerp(nn,np,pn,pp, smooth(fr));
}
vec3 vnsesv(vec3 p){
	vec3 fr= fract(p);
	vec3 frn= fr-1.;
	vec3 f= floor(p);
	vec3 c= ceil(p);
	vec3 nnn= rand33(vec3(f.x,f.y,f.z));
	vec3 nnp= rand33(vec3(f.x,f.y,c.z));
	vec3 npn= rand33(vec3(f.x,c.y,f.z));
	vec3 npp= rand33(vec3(f.x,c.y,c.z));
	vec3 pnn= rand33(vec3(c.x,f.y,f.z));
	vec3 pnp= rand33(vec3(c.x,f.y,c.z));
	vec3 ppn= rand33(vec3(c.x,c.y,f.z));
	vec3 ppp= rand33(vec3(c.x,c.y,c.z));

	return trilerp(nnn,nnp,npn,npp,pnn,pnp,ppn,ppp, smooth(fr));
}


float worley(vec3 c){
    float acc= 1.;
    vec3 cfl= floor(c);
    vec3 cfr= fract(c);
    for(int i=-1; i<=1; i++){
    for(int j=-1; j<=1; j++){
    for(int k=-1; k<=1; k++){
        vec3 g= vec3(i,j,k)+cfl;
        vec3 p= rand33(g)+g;
        float l= len(p-c);
        acc= min(acc,l);
    }}}
	return acc;
}

#define dFdxy(x) (vec2(dFdx(x),dFdy(x)))
#define grad2(f,x) \
	((vec2( \
    	f(x+vec2(ETA,0)), \
		f(x+vec2(0,ETA)) \
	  )-f(x))/ETA)
#define grad3(f,x) \
	((vec3( \
    	f(x+vec3(ETA,0,0)), \
		f(x+vec3(0,ETA,0)), \
		f(x+vec3(0,0,ETA)) \
	  )-f(x))/ETA)

#define gradnorm2(f,x)  \
	norm(vec3(grad2(f,x),1.))
#define gradnorm3(f,x)  \
	norm(grad3(f,x))

mat2 rot2d(float t){
    float c= cos(t);
    float s= sin(t);
    return mat2(
        c,-s,
        s, c
    );
    
}
mat3 rotx(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
        1, 0, 0,
        0, c,-s,
        0, s, c
    );
}
mat3 roty(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
         c,0,s,
         0,1,0,
    	-s,0,c
    );
}
mat3 rotz(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
        c,-s,0,
        s, c,0,
    	0, 0,1
    );
}

//azimuth, inclination
vec3 azincl(vec2 a){
    a.x+= PI/2.;
    vec2 s= sin(a);//sin theta, sin phi
    vec2 c= cos(a);//cos theta, cos phi
    vec3 ret= vec3(c.x,s);
    ret.xy*= c.y;
    return ret;
}

//i am able to use quats, with barely any understanding of them
//versor from axis-angle
vec4 vrsr(vec3 w){
    w.z*= -1.;
	vec3 wn= norm(w);
    float th2= len(w)/2.;
    return vec4(sin(th2)*wn,cos(th2));
}
vec3 rot(vec3 v, vec3 w){
	vec4 q= vrsr(w);
    //copypasta
	return v + 2.*cross(cross(v, q.xyz) + q.w*v, q.xyz);
}

struct ray{
	vec3 a;
    vec3 c;
};

float _FOV= .5;
#define NEAR .0

ray look_persp(vec2 uvn, vec2 a){
	ray o;
    o.a= norm( roty(a.x) * rotx(-a.y) * vec3(uvn*_FOV,1.));
    o.c= o.a*NEAR;
    return o;
}
ray look_persp_orbit(vec2 uvn, vec2 a, float d){
    ray o;
    mat3x3 mat= roty(a.x) * rotx(-a.y);
    o.a= norm( mat * vec3(uvn*_FOV,1.));
    o.c= mat[2]*-d + o.a*NEAR;
	return o;
}
ray look_pano(vec2 uvn, vec2 a){
    ray o;
    mat3x3 mat= roty(a.x) * rotx(-a.y);
    o.a= mat * vec3(uvn,1.);
    o.a= o.a-sin(PI*.125*len(uvn))*mat*vec3(0.,0.,1.);
    o.a= norm(o.a);
    o.c= o.a;
	return o;
}

int doti(ivec2 a, ivec2 b){ return a.x*b.x + a.y*b.y; }
int doti(ivec3 a, ivec3 b){ return a.x*b.x + a.y*b.y + a.z*b.z; }
int doti(ivec4 a, ivec4 b){ return a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w; }

//hacky
int sqrti(int x){return int(sqrt(float(x)));}
int cbrti(int x){return int( pow(float(x),1./3.));}


//#define DEBUG
#ifdef DEBUG
    vec3 _err= BLACK;
    #define ass(pred,color) \
        if(!(pred)){ _err= color; return color; }
    #define checkD { if(_err==BLACK){ fragColor= _err; return; }} 
#else
    #define ass(_,__) void;
    #define checkD    void;
#endif

