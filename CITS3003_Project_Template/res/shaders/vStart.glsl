attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;   // per vertex

varying vec2 texCoord;
// varying vec4 color;

uniform mat4 ModelView;
uniform mat4 Projection;

varying vec3 Position;
varying vec3 Normal;


// todo -- TASK G

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    Position = vPosition;
    Normal = vNormal;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
