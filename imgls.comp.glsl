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

const int INT_MAX=     0x7FFFFFFF;
const int INT_HALFMAX= 0x00010000;
const float INT_MAXF=     float(INT_MAX);
const float INT_HALFMAXF= float(INT_HALFMAX);
#define fix16_i_f(x) ((x)/INT_HALFMAXF)
#define fix16_f_i(x) ((x)*INT_HALFMAXF)

#define _hash(x) (((x>>16)^x)*0x45d9f3b)
#define hash_i_i(x) _hash(_hash((x)))
#define hash_i_f(x) (hash_i_i((x))/INT_MAXF)
#define hash_f_f(x) (hash_i_i((x))/INT_MAXF)

#define vnse_2i_1f(p) hash_i_f(hash_i_i(p.x)*hash_i_i(p.y))

#define bilerp(f,xy,dx,dy)

void main(){
	ivec2 iuv= ivec2(gl_GlobalInvocationID.xy);
	vec4 bb= imageLoad(img, iuv);
	uvec2 wh= imageSize(img);
	vec2 uv= vec2(iuv)/vec2(wh);

	float h= vnse_2i_1f(iuv);

	vec4 col= vec4(0.,uv,1.);

	col.rgb= vec3(h);

	barrier();
	imageStore(img, iuv, col);
}