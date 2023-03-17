//BSD license
//author khlorghaal

layout(location=0) uniform mat4 ModelViewMat;
layout(location=1) uniform mat4 ProjMat;

layout(location=0) in vec3 Position;
layout(location=1) in vec2 UV0;
layout(location=2) in vec3 Normal;
in vec4 Color;
in vec2 UV2;

smooth out vec4 vertexColor;
smooth out vec2 texCoord0;
smooth out vec3 normal;
smooth out vec3 pos;

vec3 snap_axis(vec3 v){  
  vec3 av= abs(v);
  float m= maxv(av);
  return vec3(equal(av,vec3(m))) * sign(v);
}

void main() {
    pos= Position;
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1);
    //should premultipy mats, but that would violate rig interface
    //rig format precedes badness
    
    vertexColor = Color;
    texCoord0 = UV0;

    //vec3 N= snap_axis(Normal);//todo are of the use this be is needinged?
    vec3 N= Normal;
    //normal = N;
    normal = norm((ModelViewMat * vec4(N,0) ).rgb);

    pos= Position* 16;
}