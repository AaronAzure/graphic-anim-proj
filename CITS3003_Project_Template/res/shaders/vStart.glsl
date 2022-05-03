attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;   // per vertex

varying vec2 texCoord;
// varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;   // similar to static var
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

// todo -- TASK G
varying vec3 fNormal;
varying vec4 fPosition;
varying vec3 fAmbientProduct, fDiffuseProduct, fSpecularProduct;
varying mat4 fModelView;
varying vec4 fLightPosition;
varying float fShininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // todo -- TASK G
    fNormal             = vNormal;
    fPosition           = vpos;
    fAmbientProduct     = AmbientProduct;
    fDiffuseProduct     = DiffuseProduct;
    fSpecularProduct    = SpecularProduct;
    fModelView          = ModelView;
    fLightPosition      = LightPosition;
    fShininess          = Shininess;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
