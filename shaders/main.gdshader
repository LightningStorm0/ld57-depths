shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform vec2 resolution = vec2(640.0, 360.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 get_color(vec2 thisUV) {
	vec2 modified_screen_uv = thisUV;
	vec4 thisCOLOR = vec4(1.0);

	float delta = pow(abs(thisUV.x - 0.5) * abs(thisUV.y - 0.5), 2.0) * 2.0;

	modified_screen_uv.x -= (sin((modified_screen_uv.x + 0.5) * PI) / PI) * delta;
	modified_screen_uv.y -= (sin((modified_screen_uv.y + 0.5) * PI) / PI) * delta;

	modified_screen_uv -= vec2(0.5, 0.5);
	modified_screen_uv *= vec2(0.98, 0.92);
	modified_screen_uv += vec2(0.5, 0.5);

	modified_screen_uv.x = clamp(modified_screen_uv.x, 0.001, 0.999);
	modified_screen_uv.y = clamp(modified_screen_uv.y, 0.001, 0.999);

	thisCOLOR.r = texture(SCREEN_TEXTURE, modified_screen_uv + vec2(0.0, 0.5 / resolution.y)).r;
	thisCOLOR.g = texture(SCREEN_TEXTURE, modified_screen_uv + vec2(0.5 / resolution.x, 0.5 / resolution.y)).g;
	thisCOLOR.b = texture(SCREEN_TEXTURE, modified_screen_uv + vec2(0.5 / resolution.x, 0.0)).b;

	float sampled_mod = abs(mod(modified_screen_uv.y * resolution.y, 2.0) - 1.0);

	sampled_mod /= 2.0;

	thisCOLOR.rgb *= (1.0 + sampled_mod) / 2.0;

	thisCOLOR.r = tan(thisCOLOR.r - 0.5) + 0.5;
	thisCOLOR.g = tan(thisCOLOR.g - 0.5) + 0.5;
	thisCOLOR.b = tan(thisCOLOR.b - 0.5) + 0.5;

	thisCOLOR.rgb *= 1.5;

	return thisCOLOR;
}

void fragment() {
	COLOR = get_color(SCREEN_UV + (vec2(1.0, 1.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(-1.0, 1.0) * SCREEN_PIXEL_SIZE * 0.5));

	COLOR += get_color(SCREEN_UV + (vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(0.0, 0.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(-1.0, 0.0) * SCREEN_PIXEL_SIZE * 0.5));

	COLOR += get_color(SCREEN_UV + (vec2(1.0, -1.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(0.0, -1.0) * SCREEN_PIXEL_SIZE * 0.5));
	COLOR += get_color(SCREEN_UV + (vec2(-1.0, -1.0) * SCREEN_PIXEL_SIZE * 0.5));

	COLOR.rgb /= 9.0;
	COLOR.a = 1.0;
}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
