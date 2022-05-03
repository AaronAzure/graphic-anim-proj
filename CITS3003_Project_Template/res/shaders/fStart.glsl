// varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// todo -- TASK G
varying vec3 fNormal;
varying vec4 fPosition;
varying vec3 fAmbientProduct, fDiffuseProduct, fSpecularProduct;
varying mat4 fModelView;
varying vec4 fLightPosition;
varying float fShininess;

void main()
{
    // todo -------------------------------------------------------------
    // todo -- TASK G ---------------------------------------------------

    vec3 pos = (fModelView * fPosition).xyz;

    // The vector to the light from the vertex    
    vec3 Lvec = fLightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (fModelView * vec4(fNormal, 0.0)).xyz );
    vec3 white = vec3(1.0 , 1.0, 1.0);

    // Compute terms in the illumination equation
    vec3 ambient = fAmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd * fDiffuseProduct;

    float Ks = pow( max(dot(L, N), 0.0), fShininess );
    vec3  specular =  Ks * fSpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    // todo -- TASK F
    float distFromLight = length( Lvec );

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    vec4 color;
    float a = 0.3;
    float b = 0.3;
    float c = 0.3;
    color.rgb = globalAmbient + ambient + ( ( diffuse + specular) / (a + b * distFromLight + c * pow( distFromLight , 2.0)) );  // lect 16 , pg 4
    color.a = 1.0;

    // todo -- TASK G ---------------------------------------------------
    // todo -------------------------------------------------------------

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 );
}
