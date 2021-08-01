#version 450

layout(
	local_size_x= 2,//dfdxy
	local_size_y= 2,
	local_size_z= 1
	) in;

layout(binding=0, location=0, rgba32f) restrict uniform image2D img;
//GL_READ_WRITE
//format=rgba16f

void main(){
	ivec2 iuv= ivec2(gl_GlobalInvocationID.xy);
	vec4 bb= imageLoad(img, iuv);
	uvec2 wh= imageSize(img);
	vec2 uv= vec2(iuv)/vec2(wh);

	vec4 col= vec4(.2);

	barrier();
	imageStore(img, iuv, col);
}