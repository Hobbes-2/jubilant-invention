shader_type canvas_item;
render_mode skip_vertex_transform, unshaded;


//The res its trying to reach in pixels
const vec2 target_res = vec2(640.0, 360.0);
//Original values were 320.0, 180.0

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

//Number of colors per r g and b
const float colors_per_channel = 50.0;

void fragment() {
	vec2 uv = floor(SCREEN_UV * target_res) / target_res;
	vec3 color = texture(screen_texture, uv).rgb;
	//Flooring rounds down to the nearest int i think
	vec3 quantized_color = floor(color * colors_per_channel) / colors_per_channel;
	//Samples whats under it, but it is still actually there
	COLOR = vec4(quantized_color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
