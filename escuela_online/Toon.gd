extends Reference
# Utilidades de estilo anime: convierte los materiales de un modelo en toon + contorno.

const TOON_SHADER = preload("res://shaders/toon.shader")
const OUTLINE_SHADER = preload("res://shaders/outline.shader")


static func make_material(src, outline_thickness = 0.02):
	var m = ShaderMaterial.new()
	m.shader = TOON_SHADER
	m.set_shader_param("use_texture", false)
	if src is SpatialMaterial:
		m.set_shader_param("albedo", src.albedo_color)
		if src.albedo_texture:
			m.set_shader_param("albedo_tex", src.albedo_texture)
			m.set_shader_param("use_texture", true)
	if outline_thickness > 0.0:
		var o = ShaderMaterial.new()
		o.shader = OUTLINE_SHADER
		o.set_shader_param("thickness", outline_thickness)
		m.next_pass = o
	return m


# Recorre el nodo y todos sus hijos cambiando los materiales de cada MeshInstance.
static func apply(node, outline_thickness = 0.02):
	if node is MeshInstance and node.mesh:
		for i in range(node.mesh.get_surface_count()):
			var src = node.get_surface_material(i)
			if src == null:
				src = node.mesh.surface_get_material(i)
			node.set_surface_material(i, make_material(src, outline_thickness))
	for c in node.get_children():
		apply(c, outline_thickness)
