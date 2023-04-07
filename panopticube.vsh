//BSD license
//author khlorghaal

layout(location=0) uniform mat4 ModelViewMat;
layout(location=1) uniform mat4 ProjMat;

layout(location=0) in vec3 Position;
layout(location=1) in vec2 UV0;
layout(location=2) in vec3 Normal;
in vec4 Color;
in vec2 UV2;

//worldspace elided onto modelspace

smooth out vec4 vertexColor;
smooth out vec2 texCoord0;
smooth out vec3 normal;
smooth out vec3 Pm;//position modelspace
smooth out vec3 Pv;//position viewspace
smooth out vec3 Vm;//viewvector modelspace
//modelspace is basically worldspace in this instance

vec3 snap_axis(vec3 v){  
  vec3 av= abs(v);
  float m= maxv(av);
  return vec3(equal(av,vec3(m))) * sign(v);
}

void main() {
    Pm= Position;
    Pv= mat3(ModelViewMat)*Pm;
    Vm= (transpose(ModelViewMat)*vec4(Pm,-1.)).xyz;//incorrect but okay
    gl_Position = ProjMat*vec4(Pv, 1);
    //should premultipy mats, but that would violate rig interface
    //rig format precedes badness
    
    vertexColor = Color;
    texCoord0 = UV0;

    //vec3 N= snap_axis(Normal);//todo are of the use this be is needinged?
    vec3 N= Normal;
    //normal = N;
    normal = norm((ModelViewMat * vec4(N,0) ).rgb);

    vec2 uv;
    if(     N.x!=0.) uv= Pm.yz;
    else if(N.y!=0.) uv= Pm.xz;
    else if(N.z!=0.) uv= Pm.xy;
    uv= nmapu(uv);
    texCoord0= uv;

}