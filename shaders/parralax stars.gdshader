shader_type canvas_item;

uniform sampler2D noise;

varying vec2 vertex_world;

void vertex() {
	vertex_world = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec4 stars(vec4 start_color, vec2 screen_uv, float parralax) {
	vec2 new_uv = vertex_world / (parralax * 100.0);

	//new_uv.y *= parralax;

	new_uv.x = mod(new_uv.x, 1.0);
	new_uv.y = mod(new_uv.y + (screen_uv.y * 0.01), 1.0);

	float star = texture(noise, new_uv).r;

	star -= 0.34;

	star = round(star);

	start_color += vec4(1.0, 1.0, 1.0, 1.0) * star;

	start_color.r = clamp(start_color.r, 0.0, 1.0);
	start_color.g = clamp(start_color.g, 0.0, 1.0);
	start_color.b = clamp(start_color.b, 0.0, 1.0);
	start_color.a = clamp(start_color.a, 0.0, 1.0);

	return start_color;
}

vec4 sample_around(vec4 start_color, vec2 screen_uv, float parralax, vec2 screen_pixel_size) {
	vec4 new_color = vec4(0.0, 0.0, 0.0, 0.0);

	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * -5.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * -4.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * -3.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * -2.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * -1.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 0.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 1.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 2.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 3.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 4.0), parralax);
	new_color += stars(start_color, screen_uv + vec2(0.00, (screen_pixel_size.y / 10.0) * 5.0), parralax);

	return new_color / 3.0;
}

void fragment() {
	COLOR += sample_around(vec4(0.0, 0.0, 0.0, 0.0), SCREEN_UV, 2.0, SCREEN_PIXEL_SIZE);
	COLOR += sample_around(vec4(0.0, 0.0, 0.0, 0.0), SCREEN_UV, 4.0, SCREEN_PIXEL_SIZE);
	COLOR += sample_around(vec4(0.0, 0.0, 0.0, 0.0), SCREEN_UV, 8.0, SCREEN_PIXEL_SIZE);
	COLOR += sample_around(vec4(0.0, 0.0, 0.0, 0.0), SCREEN_UV, 16.0, SCREEN_PIXEL_SIZE);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
