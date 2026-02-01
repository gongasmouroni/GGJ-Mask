shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
uniform sampler2D normal_roughness_texture : hint_normal_roughness_texture, filter_nearest;

uniform float noise_scale = 4;
uniform float noise_intensity = 0.01;

uniform float post_levels = 6.0;

uniform vec2 crosshatch_scale = vec2(1.0);

uniform sampler2D crosshatch_texture : repeat_enable, filter_linear_mipmap;

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
	vec4 color = texture(normal_roughness_texture, uv);
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

    // Screen space hatching
	vec3 orig = texture(screen_texture, SCREEN_UV).xyz;
    // Posterize pixel brightness
	float greyscale = max(orig.r, max(orig.g, orig.b));
    float post = floor(greyscale * post_levels) / post_levels;
    float post_inv = 1.0 - post;
    vec3 crosshatch = texture(crosshatch_texture, SCREEN_UV*crosshatch_scale).rgb;
    float diag_hatch = step(1.0, post_inv) * crosshatch.r;
    float vert_hatch = step(0.75, post_inv) * crosshatch.b;
    float horiz_hatch = step(0.5, post_inv) * crosshatch.g;
    float final_hatch = max(horiz_hatch, max(diag_hatch, vert_hatch));
    final_hatch = pow(1.0-final_hatch, 5.0);

	vec3 nor = texture(normal_roughness_texture, SCREEN_UV).xyz;
    float sky_mask = step(0.1, length(abs(nor - vec3(0.2, 0.2, 0.2))));

    final_hatch = mix(1, final_hatch, sky_mask);

    // Sobel
	vec2 step_xy = 1.0/VIEWPORT_SIZE.xy;
	vec2 screen_uv = SCREEN_UV + noise(SCREEN_UV*noise_scale)*noise_intensity;
	vec3 c = sobel(step_xy.x, step_xy.y, screen_uv);
	c = pow(1.0-c, vec3(10));
	
	ALBEDO = min(c, vec3(final_hatch))+orig*0.4;
    ALBEDO = clamp(ALBEDO, 0.0, 1.0);
}
