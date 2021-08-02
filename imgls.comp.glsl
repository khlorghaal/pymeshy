#version 450

layout(
	local_size_x= 2,//dfdxy
	local_size_y= 2,
	local_size_z= 1
	) in;

layout(binding=0, location=0, rgba32f) restrict uniform image2D img;
//GL_READ_WRITE
//format=rgba16f


#define vec1 float
#define ivec1 int
#define uvec1 uint
#define len length
#define lerp mix
#define norm normalize
#define sat saturate
#define sats saturate_signed



 vec1 v_i_f(ivec1 v){return  vec1(v);}
 vec2 v_i_f(ivec2 v){return  vec2(v);}
 vec3 v_i_f(ivec3 v){return  vec3(v);}
 vec4 v_i_f(ivec4 v){return  vec4(v);}
ivec1 v_f_i( vec1 v){return ivec1(v);}
ivec2 v_f_i( vec2 v){return ivec2(v);}
ivec3 v_f_i( vec3 v){return ivec3(v);}
ivec4 v_f_i( vec4 v){return ivec4(v);}


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

//normalized map to signed
//[ 0,1]->[-1,1]
#define nmaps(v) ((v)*2.-1.)
//normalized map to unsigned
//[-1,1]->[ 0,1]
#define nmapu(v) ((v)*.5+.5)

#define INT_MAX     0x7FFFFFFF
#define INT_HALFMAX 0x00010000
//using macros preserves generic literal ops
#define fix16_i_f(x) ((x)/INT_HALFMAXF)
#define fix16_f_i(x) ((x)*INT_HALFMAXF)

#define _hash(x) (((x>>16)^x)*0x45d9f3b)
#define hash_i_i(x) _hash(_hash((x)))
#define hash_f_i(x) (      hash_i_i(v_f_i(x))         )
#define hash_f_f(x) (v_i_f(hash_i_i(v_f_i(x)))/INT_MAX)
#define hash_i_f(x) (v_i_f(hash_i_i(     (x)))/INT_MAX)

float vnse_2i_1f(ivec2 p){return nmapu(hash_i_f(hash_i_i(p.x)+hash_i_i(p.y)));}

void main(){
	ivec2 iuv= ivec2(gl_GlobalInvocationID.xy);
	vec4 bb= imageLoad(img, iuv);
	uvec2 wh= imageSize(img);
	vec2 uv= vec2(iuv)/vec2(wh);

	float h= vnse_2i_1f(iuv);
	h= step(h,.01);//star concentration

	float m= vnse_2i_1f(iuv+INT_HALFMAX);
	m= exp(-m*m*.95);//magnitude distribution

	float l= m*h;

	vec4 col= vec4(0.,uv,1.);

	col.rgb= vec3(l);

	barrier();
	imageStore(img, iuv, col);
}