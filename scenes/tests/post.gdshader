shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain

uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

void fragment() {
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	
	float noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    c.rgb = mix(vec3(0.0), c.rgb, brightness);
    c.rgb = mix(vec3(0.5), c.rgb, contrast);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

	c.rgb += noise * grain_amount * grain_size;

    COLOR.rgb = clamp(c, 0.0, 1.0);
}