shader_type spatial;
render_mode cull_back;

// Cel-shading estilo anime: dos tonos (luz / sombra) con borde suave.

uniform vec4 albedo : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D albedo_tex : hint_albedo;
uniform bool use_texture = false;

uniform vec4 shade_color : hint_color = vec4(0.62, 0.58, 0.78, 1.0); // tono de la sombra (violeta suave)
uniform float threshold : hint_range(-1.0, 1.0) = 0.05;             // dónde empieza la sombra
uniform float softness : hint_range(0.001, 0.5) = 0.03;             // suavidad del borde
uniform float flash : hint_range(0.0, 1.0) = 0.0;                   // destello rojo al recibir daño

void fragment() {
	vec3 base = albedo.rgb;
	if (use_texture) {
		base *= texture(albedo_tex, UV).rgb;
	}
	ALBEDO = base;
	EMISSION = vec3(1.0, 0.15, 0.1) * flash;
}

void light() {
	float ndl = dot(NORMAL, LIGHT);
	float lit = smoothstep(threshold - softness, threshold + softness, ndl) * ATTENUATION;
	vec3 tone = mix(shade_color.rgb, vec3(1.0), lit);
	// Si los colores se ven demasiado oscuros o sin textura, prueba quitando "ALBEDO *" o "/ PI".
	DIFFUSE_LIGHT += ALBEDO * tone * LIGHT_COLOR / PI;
}
