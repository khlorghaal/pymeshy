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
#define ETA 1e-4
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
float tri(float x){ return abs( mod(x,2.) -1.); }
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
vec1 rand (vec1 x){ return hashf(x);   }
vec2 rand (vec2 x){ return hashf(x*hashf(x+x.yx)); }
vec3 rand (vec3 x){ return hashf(x*1.e2*hashf(R3A+x+x.yzx+x.zxy)); }
vec4 rand (vec4 x){ return hashf(x*hashf(x+x.yzwx+x.zwxy+x.wxyz)); }
vec1 rand1(vec2 x){ return hashf(dot(x*R2A-R2B,-x*R2B+R2A)/x.x);  }
vec1 rand1(vec3 x){ return hashf(dot(x+R3A-R3B,-x+R3B+R3A));  }
vec1 rand1(vec4 x){ return hashf(dot(x+R4A-R4B,-x+R4B+R4A));  }
vec2 rand2(vec1 x){ return hashf(x+R2A);   }
vec3 rand3(vec1 x){ return hashf(x+R3A);   }

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


float vnse(vec1 x){ return lerp(rand(floor(x)),rand(ceil(x)),fract(x)); }
float vnse(vec2 p){
	vec2 fr= fract(p);
	vec2 f= floor(p);
	vec2 c= ceil(p);
	float nn= rand1(vec2(f.x,f.y));
	float np= rand1(vec2(f.x,c.y));
	float pn= rand1(vec2(c.x,f.y));
	float pp= rand1(vec2(c.x,c.y));
	vec4 v= vec4(nn,np,pn,pp);
	vec2 lx= lerp(v.xy,v.zw, fr.xx);
	return lerp( lx.x,lx.y, fr.y );
}
float vnse(vec3 p){
	vec3 fr= fract(p);
	vec3 f= floor(p);
	vec3 c= ceil(p);
	float nnn= rand1(vec3(f.x,f.y,f.z));
	float nnp= rand1(vec3(f.x,f.y,c.z));
	float npn= rand1(vec3(f.x,c.y,f.z));
	float npp= rand1(vec3(f.x,c.y,c.z));
	float pnn= rand1(vec3(c.x,f.y,f.z));
	float pnp= rand1(vec3(c.x,f.y,c.z));
	float ppn= rand1(vec3(c.x,c.y,f.z));
	float ppp= rand1(vec3(c.x,c.y,c.z));
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
	float a= nmaps(rand(f));
	float b= nmaps(rand(c));
	return lerp(a,b,smooth(fr));
}
float perlin(vec3 p){
	vec3 fr= fract(p);
	vec3 frn= fr-1.;
	vec3 f= floor(p);
	vec3 c= ceil(p);
	vec3 nnn= nmaps(rand(vec3(f.x,f.y,f.z)));
	vec3 nnp= nmaps(rand(vec3(f.x,f.y,c.z)));
	vec3 npn= nmaps(rand(vec3(f.x,c.y,f.z)));
	vec3 npp= nmaps(rand(vec3(f.x,c.y,c.z)));
	vec3 pnn= nmaps(rand(vec3(c.x,f.y,f.z)));
	vec3 pnp= nmaps(rand(vec3(c.x,f.y,c.z)));
	vec3 ppn= nmaps(rand(vec3(c.x,c.y,f.z)));
	vec3 ppp= nmaps(rand(vec3(c.x,c.y,c.z)));
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
	vec2 nn= rand(vec2(f.x,f.y));
	vec2 np= rand(vec2(f.x,f.y));
	vec2 pn= rand(vec2(f.x,c.y));
	vec2 pp= rand(vec2(f.x,c.y));

	return bilerp(nn,np,pn,pp, smooth(fr));
}
vec3 vnsesv(vec3 p){
	vec3 fr= fract(p);
	vec3 frn= fr-1.;
	vec3 f= floor(p);
	vec3 c= ceil(p);
	vec3 nnn= rand(vec3(f.x,f.y,f.z));
	vec3 nnp= rand(vec3(f.x,f.y,c.z));
	vec3 npn= rand(vec3(f.x,c.y,f.z));
	vec3 npp= rand(vec3(f.x,c.y,c.z));
	vec3 pnn= rand(vec3(c.x,f.y,f.z));
	vec3 pnp= rand(vec3(c.x,f.y,c.z));
	vec3 ppn= rand(vec3(c.x,c.y,f.z));
	vec3 ppp= rand(vec3(c.x,c.y,c.z));

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
        vec3 p= rand(g)+g;
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
    vec3 _err= vec3(0.);
    #define ass(pred,color) \
        if(!(pred)){ _err= color; return color; }
#else
    #define ass(_,__) void;
#endif







































//Copyright 2019 khlorghaal most rights reserved

//Cubes make me happy.

//#define PANORAMIC
#define LOCK
#define INTERNAL_REFLECTION
//#define ANIMATE_IOR
//#define MOUSE_IOR
//#define ORBIT_CAM

//these are mutex
//#define BRDF_EMISSIVE_0
//#define BRDF_EMISSIVE_1
#define BRDF_PHONG
//#define BRDF_BOUNCE


layout(location=0) uniform  vec2  res;
layout(location=1) uniform ivec2 ires;
layout(location=2) uniform ivec2 iuv_offs;
layout(location=3) uniform int ss;
layout(location=4) uniform float time;
layout(location=5) uniform int MAX_I;//distance
layout(location=6) uniform int MAX_BOUNCE;//reflections


//const float time= 1.;



const float TRANSMITTANCE= .8;//this affects lumianance spatial freqenz of result; .84 is especially magical
const float EXPOSURE= .24;
const float GAMMA=  1.28;

//PERF SETTINGS
//
const vec4  FOGCOLOR= vec4(.2,.65,.99, 1.);


const vec3 COLOR_B = vec3( 1.0,0.0,0.0);
const vec3 COLOR_C = vec3( 0.0,1.0,0.0);
const vec3 COLOR_A = vec3( 0.0,0.0,1.0);

const float IOR= .05;//high abs ior will cause rapid extinction



bool stagger(vec3 p){
	int n= 1;
	return 
	((int(int(p.x)+int(p.x<0.))&n)==0)&&
	((int(int(p.y)+int(p.y<0.))&n)==0)&&
	((int(int(p.z)+int(p.z<0.))&n)==0);
}
vec3 img(vec2 uv){
    vec2 uvn= nmaps(uv);
    uvn.x*= asp;
    

    vec3 ra= vec3( uvn, -1.);
    vec3 rc= vec3( uvn, .0 );

    _FOV= .35;
    ray r= look_persp_orbit(uvn, vec2((5.+time*.01)/8.,1./8.)*TAU, .5);
    ra= r.a;
    rc= r.c;

    rc+=-.5;

    
    float ior= IOR;
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
        s= stagger(p);
		if(s^^ps){//transmission
			ass(len(v)>ETA, WHITE);
			vec3 r;
			r= refract(v,n, s?ior:iorrcp);
            ass(real(r),GREEN);//FIXME
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
			v= norm(r);
            if(s){//hit
                //brdf

                #ifdef BRDF_EMISSIVE_0
                    vec3 C= abs(n);
                    vec3 c= 
                          C.x*COLOR_A
                        + C.y*COLOR_B
                        + C.z*COLOR_C;
                #endif
				#ifdef BRDF_EMISSIVE_1
					const vec3 COLOR_XP = vec3( 1.,0.,0.);
					const vec3 COLOR_YP = vec3( 0.,1.,0.);
					const vec3 COLOR_ZP = vec3( 0.,0.,1.);
					const vec3 COLOR_XN = vec3( 1.,1.,0.);
					const vec3 COLOR_YN = vec3( 0.,1.,1.);
					const vec3 COLOR_ZN = vec3( 1.,0.,1.);
                    vec3 CP= sat( n);
                    vec3 CN= sat(-n);
                    vec3 c= 
                          CP.x*COLOR_XP
                        + CP.y*COLOR_YP
                        + CP.z*COLOR_ZP
                        + CN.x*COLOR_XN
                        + CN.y*COLOR_YN
                        + CN.z*COLOR_ZN;
                #endif

                #ifdef BRDF_PHONG
                    //tell the rendering equation to fuckoff
                    float l= minv(1.-abs(r));
                    //float l= sum(1.-abs(r));
                    //float l= 1.-abs(r.y);
                    l= cos(l*PI*2.8)*1.;
                    //l= pow(l,1.25)*1.4;
                    //l= nmapu(cos(l*100000.));
                    //l= pow(l,.50)*.95;
                    //l= pow(l,.20)*.65;
                    l=nmapu(l);
                    l= pow(l,2.);
                    vec3 c= vec3(l);
                #endif

                #ifdef BRDF_BOUNCE
                    vec3 _c[]= vec3[](

						vec3( 0.0, .95 , 0.0),
						vec3(  .9, 0.  , .7),
						vec3( 0.0,  .125,  .94),
						-WHITE*.25
                    );
                    c*= _c[b/1%4];
                #endif

                //c.r+= float(b>)*64.;

                if(v.z>0)
                	c+= BLUE*v.z*.32;
                else
                	c+= GREEN*-v.z*.14;

                if(p.y<-44)
                	c+= c*-.4 + vec3(5.55,.85,0.);

                if(p.z>17)
                	c+= WHITE*.01*length(p);

                a+= c*cmag;
                cmag*= TRANSMITTANCE;
                b++;
            }
		}
		ass(real(dt), CYAN);
		ass(real(v), YELLOW);
		ass(real(n), MAGENTA);
    }

    if(uvn.x>0)
    	a=lerp(a,(norm(a)-.2)*9.,.5);

    float cnorm= 1.;///(1.-pow(1.-TRANSMITTANCE,float(maxb)));
    //luminance normalization is empirical
    //meaning i have no fucking clue how it works
    
    return a*cnorm;
}










layout(binding=0, rgba32f) writeonly restrict uniform image2D img_o;

layout(
	local_size_x= 4,
	local_size_y= 4,
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
                col+=vec4(img( uv + vec2(x,y)/((ss+1)*res)  ),1.);
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
    col*= 1.-1./(1.+lum(col.rgb));//rheinhard
 	//col = vec4(1)- 1./(vec4(1) + 1.50*pow(col, vec4(1.25)));//parnell
 	//col = vec4(1)- 1./(exp(col)+1);

    col= pow(col,vec4(GAMMA));
    col.a= 1.;

    col= sat(col);
	imageStore(img_o, iuv, col);
}
