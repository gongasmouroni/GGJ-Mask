shader_type canvas_item;

uniform float speed : hint_range(0.0, 200.0, 0.01) = 1.0;
uniform float intensity : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform sampler2D screen_texture : hint_screen_texture;


float rand(float x) {
    return fract(sin(x * 12345.6789) * 98765.4321);
}

void fragment( )
{
	vec2 uv = SCREEN_UV;
	vec3 pixel = texture(screen_texture, SCREEN_UV).rgb;
	float n = rand(uv.y * 50.0);
    float wave = sin(TIME * speed + n * 6.283);
    float offset = wave * 0.01 * intensity;

    vec3 glitch = texture(screen_texture, uv + vec2(offset, 0.0)).rgb;

    COLOR = vec4(mix(pixel, glitch, intensity), 1.0);
}