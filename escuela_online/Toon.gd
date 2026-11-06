extends Reference
# Armoniza materiales importados sin destruir sus texturas PBR.
# No añade geometría ni intenta ocultar siluetas low-poly con contornos.

static func apply(node, _outline_thickness = 0.0):
	_polish_recursive(node)


static func _polish_recursive(node):
	if node is MeshInstance and node.mesh:
		for i in range(node.mesh.get_surface_count()):
			var source = node.get_surface_material(i)
			if source == null:
				source = node.mesh.surface_get_material(i)
			var polished = _make_polished_material(source)
			if polished != null:
				node.set_surface_material(i, polished)

	for child in node.get_children():
		_polish_recursive(child)


static func _make_polished_material(source):
	# No reemplazar ShaderMaterial ni materiales desconocidos: podrían contener
	# lógica propia del asset. Tampoco inventar materiales para superficies vacías.
	if not (source is SpatialMaterial):
		return null

	# Duplicar evita modificar el recurso importado compartido por otros modelos.
	var material = source.duplicate()
	# Conservar albedo, mapas normal/roughness/metallic, transparencia y emisión.
	# Solo limitar reflejos excesivos y evitar brillos plásticos en kits estilizados.
	material.roughness = clamp(material.roughness, 0.58, 0.88)
	material.specular = min(material.specular, 0.42)
	return material
