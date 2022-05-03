// varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;   // similar to static var
uniform mat4 ModelView;
uniform vec4 LightPosition;
uniform vec4 LightPosition2;
uniform float Shininess;

varying vec3 Position;
varying vec3 Normal;

void main()
{
    // todo -------------------------------------------------------------
    // todo -- TASK G ---------------------------------------------------

    vec3 pos = (ModelView * vec4(Position, 1.0)).xyz;

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView * vec4(Normal, 0.0)).xyz );
    vec3 white = vec3(1.0 , 1.0, 1.0);

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd * DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular =  Ks * SpecularProduct;
    
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
    // color.rgb = globalAmbient + ( (ambient + diffuse + specular) / pow( distFromLight , 2.0) );  // lect 16 , pg 4
    color.rgb = globalAmbient + ambient + ( (diffuse) / (a + b * distFromLight + c * pow( distFromLight , 2.0)) );  // lect 16 , pg 4
    color.a = 1.0;

    // todo -- TASK G ---------------------------------------------------
    // todo -------------------------------------------------------------

    gl_FragColor = color * texture2D( texture, texCoord * 2.0 ) + vec4((specular) / ((a + b * distFromLight + c * pow( distFromLight , 2.0)) ), 1.0 );
}
