// varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// todo -- TASK B
uniform float texScale;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec4 LightPosition;
uniform mat4 ModelView;
uniform float Shininess;
// todo -- TASK I
uniform vec3 AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform vec4 LightPosition2;
// todo -- TASK J
uniform vec3 AmbientProduct3, DiffuseProduct3, SpecularProduct3;
uniform vec4 LightPosition3;
uniform vec4 ConeDirection;
// uniform float ConeAngle;


varying vec3 Position;
varying vec3 Normal;

void main()
{
    // todo -------------------------------------------------------------
    // todo -- TASK G ---------------------
    
    vec3 pos = (ModelView * vec4(Position, 1.0)).xyz;

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;
    
    // todo -- TASK H
    // The vector to the light from origin vec3( 0.0 , 0.0 , 0.0 )
    vec3 Ldir = LightPosition2.xyz;

    // todo -- TASK J
    // The vector to the light from the vertex    
    vec3 Lvec3 = LightPosition3.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source  ( l )
    vec3 E = normalize( -pos );   // Direction to the eye/camera    ( v )
    vec3 H = normalize( L + E );  // Halfway vector

    // todo -- TASK H
    vec3 L2 = normalize( Ldir );   // Direction to the light source
    vec3 H2 = normalize( L2 );  // Halfway vector
    
    // todo -- TASK J
    vec3 L3 = normalize( Lvec3 );
    vec3 H3 = normalize( L3 + E );

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView * vec4(Normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );   // (l * n)
    vec3  diffuse = Kd * DiffuseProduct;
    
    float Ks = pow( max(dot(N, H), 0.0), Shininess );   // (n * h)^shininess
    vec3  specular =  Ks * SpecularProduct;

    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 
    
    // todo -- TASK F
    float distFromLight = length( Lvec );

    // todo -- TASK H
    vec3 ambient2 = AmbientProduct2;

    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Kd2 * DiffuseProduct2;

    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3  specular2 = Ks2 * SpecularProduct2; 
    
    if (dot(L2, N) < 0.0 ) {
	    specular2 = vec3(0.0, 0.0, 0.0);
    } 
    
    // todo -- TASK J
    vec3 ambient3 = AmbientProduct3;

    float Kd3 = max( dot(L3, N), 0.0 );
    vec3  diffuse3 = Kd3 * DiffuseProduct3;

    float Ks3 = pow( max(dot(N, H3), 0.0), Shininess );
    vec3  specular3 = Ks3 * SpecularProduct3;
    if (dot(L3, N) < 0.0 ) {
	    specular3 = vec3(0.0, 0.0, 0.0);
    } 

    float theta = dot(normalize(Lvec3), normalize(-ConeDirection).xyz);
    
    float distFromLight3 = length( Lvec3 );

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    vec4 color;
    float a = 0.3;
    float b = 0.3;
    float c = 0.3;
    // color.rgb = globalAmbient + ( (ambient + diffuse + specular) / pow( distFromLight , 2.0) );  // lect 16 , pg 4
    color.rgb = globalAmbient + ambient + ( (diffuse) / (a + b * distFromLight + c * pow( distFromLight , 2.0)) );  // lect 16 , pg 4
    color.rgb += ambient2 + diffuse2;  // lect 16 , pg 4
    color.a = 1.0;

    // todo -- TASK G ---------------------------------------------------
    // todo -------------------------------------------------------------
    
    if (theta > 0.5) 
    {       
        color.rgb += globalAmbient + ambient3 + ( (diffuse3) / (a + b * distFromLight3 + c * pow( distFromLight3 , 2.0)) );
        color.a = 1.0;
    }
    else  // else, use ambient light so scene isn't completely dark outside the spotlight.
    {
        color = vec4(globalAmbient, 1.0);
    }

    // todo -- TASK B
    gl_FragColor = color * texture2D( texture, texCoord * 2.0 * texScale);
    gl_FragColor += vec4((specular) / ((a + b * distFromLight + c * pow( distFromLight , 2.0)) ), 1.0 );
    gl_FragColor += vec4(specular2 , 1.0 );

}
