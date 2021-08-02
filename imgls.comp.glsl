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

#define bilerp(st,nn,np,pn,pp) \
	lerp(\
		lerp(nn,pn,st.x),\
		lerp(np,pp,st.x),\
		st.y)






layout(binding=0, location=0, rgba16f) readonly  restrict uniform image2D img_i;
layout(binding=1, location=1, rgba16f) writeonly restrict uniform image2D img_o;

//"Store operations to any texel that is outside the boundaries of the bound image will do nothing."
layout(
		local_size_x= 8,//dfdxy
		local_size_y= 8,
		local_size_z= 1
		) in;

#ifndef STAGE0
	shared vec4 sh[8][8];
#endif

void main(){
	uvec2 ires= imageSize(img_i);
	vec2 res= vec2(ires);
	ivec2 iuv= ivec2(gl_GlobalInvocationID.xy);
	 vec2  uv=  vec2(iuv)/res;

	vec4 col;

	#ifdef STAGE0

		float h= vnse_2i_1f(iuv);
		h= step(h,.01);//star concentration

		float m= vnse_2i_1f(iuv+INT_HALFMAX);
		m= exp(-m*m*.98);//magnitude distribution

		float l= m*h;

		col= vec4(vec3(l),1.);//vec4(0.,uv,1.);

	#elif STAGE1
		uvec2 gid= gl_GlobalInvocationID.xy;
		uvec2 lid=  gl_LocalInvocationID.xy;
		uvec2 lsz= gl_WorkGroupSize.xy;
		sh[lid.x][lid.y]= imageLoad(img_i,ivec2(gid));
		barrier();
		{
			vec2 uv= uv;

			uv= uv+ .1;

			ivec2 iuv= ivec2(uv*res);
			vec2 st= fract(uv*res);
			uvec2 i0= iuv;
			uvec2 i1= i0+1;
			vec4 nn= sh[i0.x][i0.y];
			vec4 np= sh[i0.x][i1.y];
			vec4 pn= sh[i1.x][i0.y];
			vec4 pp= sh[i1.x][i1.y];
			vec4 samp= bilerp(st,nn,np,pn,pp);
		}
		col= vec4(0.,uv,1.);
	#elif STAGE2
		col= vec4(0.,uv,1.);

	#else
		#error no stage #defined
	#endif

	imageStore(img_o, iuv, col);
}