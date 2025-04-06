shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform float zoom = 10.0;

uniform vec4 background_color : source_color;
uniform vec4 foreground_color : source_color;

uniform sampler2D noise;

varying vec2 vertex_world;

void vertex() {
	vertex_world = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 calculate_uv(vec2 world_vertex, vec2 offset) {
	vec2 new_uv = vec2(0.0, 0.0);

	vec2 v_zoom = vec2((vertex_world.x + offset.x) / zoom, (vertex_world.y + offset.y) / zoom);

	new_uv.x = v_zoom.x;
	new_uv.y = v_zoom.y;

	new_uv.x += TIME * 0.01;
	new_uv.x += sin(TIME + (v_zoom.y * 20.0)) * 0.02;

	new_uv.y += (TIME * 0.99) * 0.01;
	new_uv.y += sin((TIME*0.99) + (v_zoom.x * 20.0)) * 0.02;

	new_uv.x = mod(new_uv.x, 1.0);
	new_uv.y = mod(new_uv.y, 1.0);

	return new_uv;
}

void fragment() {
	vec2 r_uv = calculate_uv(vertex_world, vec2(TIME * 0.1, TIME * 0.2) + vec2(zoom / 3.0, zoom / 30.));
	vec2 g_uv = calculate_uv(vertex_world, vec2(TIME * 0.3, TIME * 0.4) + vec2((zoom * 2.0) / 3.0, (zoom * 2.0) / 3.0));
	vec2 b_uv = calculate_uv(vertex_world, vec2(TIME * 0.5, TIME * 0.6) + vec2(0.0, 0.0));

	float r = round(texture(noise, r_uv).r + 0.1);
	float g = round(texture(noise, g_uv).r + 0.1);
	float b = round(texture(noise, b_uv).r + 0.1);

	COLOR = vec4(1.0, 1.0, 1.0, 1.0);

	vec2 r_screen_uv = SCREEN_UV + vec2(0.0, 2.0 * SCREEN_PIXEL_SIZE.y);
	vec2 g_screen_uv = SCREEN_UV + vec2(2.0 * SCREEN_PIXEL_SIZE.x, 2.0 * SCREEN_PIXEL_SIZE.y);
	vec2 b_screen_uv = SCREEN_UV + vec2(2.0 * SCREEN_PIXEL_SIZE.x, 0.0);

	COLOR.r = r * texture(SCREEN_TEXTURE, r_screen_uv).r;
	COLOR.g = g * texture(SCREEN_TEXTURE, b_screen_uv).g;
	COLOR.b = b * texture(SCREEN_TEXTURE, g_screen_uv).b;

	COLOR.r = max(COLOR.r, (1.0 - r) * 0.2);
	COLOR.g = max(COLOR.g, (1.0 - g) * 0.2);
	COLOR.b = max(COLOR.b, (1.0 - b) * 0.2);

	COLOR.r = clamp(COLOR.r, 0.0, 1.0);
	COLOR.g = clamp(COLOR.g, 0.0, 1.0);
	COLOR.b = clamp(COLOR.b, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
