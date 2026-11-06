shader_type spatial;
render_mode cull_front, unshaded;

// Contorno por "casco invertido": se dibuja el modelo un poco inflado y por dentro.
// Se usa como "next_pass" del material toon.

uniform vec4 outline_color : hint_color = vec4(0.12, 0.06, 0.12, 1.0);
uniform float thickness = 0.02;

void vertex() {
	VERTEX += NORMAL * thickness;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
