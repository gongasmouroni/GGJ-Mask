shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D normal_roughness_texture : hint_normal_roughness_texture, filter_linear_mipmap;

uniform float brightness = 0.8;
uniform float contrast = 1.0;
uniform float saturation = 0.2;

uniform float noise_scale = 4;
uniform float noise_intensity = 0.01;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

// intensity at a pixel at given UV
float intensity(in vec2 uv){
	vec4 color = textureLod(screen_texture, uv, 0.0);
	return sqrt((color.x*color.x)+(color.y*color.y)+(color.z*color.z));
}

vec3 sobel(float stepx, float stepy, vec2 center) {
	// Sobel masks (see http://en.wikipedia.org/wiki/Sobel_operator)
	//        1 0 -1     -1 -2 -1
	//    X = 2 0 -2  Y = 0  0  0
	//        1 0 -1      1  2  1
	float tleft = intensity(center + vec2(-stepx,stepy));
    float left = intensity(center + vec2(-stepx,0));
    float bleft = intensity(center + vec2(-stepx,-stepy));
    float top = intensity(center + vec2(0,stepy));
    float bottom = intensity(center + vec2(0,-stepy));
    float tright = intensity(center + vec2(stepx,stepy));
    float right = intensity(center + vec2(stepx,0));
    float bright = intensity(center + vec2(stepx,-stepy));
	
    float x = tleft + 2.0*left + bleft - tright - 2.0*right - bright;
    float y = -tleft - 2.0*top - tright + bleft + 2.0 * bottom + bright;
    float color = sqrt((x*x) + (y*y));
    return vec3(color,color,color);
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 orig = textureLod(screen_texture, SCREEN_UV, 0.0).xyz;
	vec2 step_xy = 2.0/VIEWPORT_SIZE.xy;
	vec2 screen_uv = SCREEN_UV + noise(SCREEN_UV*noise_scale)*noise_intensity;
	vec3 c = sobel(step_xy.x, step_xy.y, screen_uv);
	
	c = (1.0-c);
	
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
    c.rgb = mix(vec3(0.5), c.rgb, contrast);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

	ALBEDO = c;
}
