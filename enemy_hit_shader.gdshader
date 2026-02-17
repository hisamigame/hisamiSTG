shader_type canvas_item;

void fragment() {
	vec4 input_colour = texture(TEXTURE, UV);
	COLOR = vec4(1, 1, 1, input_colour.a);
}
