shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

varying vec2 vertex_world;

void vertex() {
    vertex_world = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 offset = vec2(sin((TIME * 2.0) + (vertex_world.y * 0.5)), 0.0);

	vec4 original_color = COLOR;

	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + (offset * 0.001));
	COLOR.rgb += original_color.rgb * original_color.a;

	COLOR.rgb /= 1.0 + original_color.a;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
