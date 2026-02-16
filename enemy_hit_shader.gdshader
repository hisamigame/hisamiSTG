shader_type canvas_item;

void fragment() {
	vec4 input_colour = texture(TEXTURE, UV);
	COLOR = vec4(input_colour.r * 2.0, input_colour.g * 2.0, input_colour.b * 2.0, input_colour.a);
}
