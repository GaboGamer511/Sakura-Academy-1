# Sakura Academy — inventario y criterios de calidad 3D

## Dirección artística (no low poly)
Sakura Academy busca un acabado anime 3D moderno: personajes estilizados con rostros expresivos y cabello trabajado; edificios con arquitectura cuidada; vegetación frondosa; materiales PBR o toon bien pintados; iluminación cálida y composición colorida.

**No se usará low poly como estilo artístico.** La optimización no significa degradar todos los modelos. Se priorizan recursos de buena calidad visual, con geometría y texturas razonables para el equipo objetivo.

## Primer recurso de cerezo seleccionado
**Flowering Cherry Tree — Innerscene**
- https://www.innerscene.com/tools/library/3d-parts/flowering-cherry-tree-6d80049e
- GLB, aproximadamente 5.1 MB.
- Licencia declarada: CC0.
- Cerezo en flor con materiales y dimensiones reales.
- Modelo estático; no incluye animación de ramas.
- No probado aún en Godot 3.6.3 ni en Intel HD 3000.

Es un candidato inicial para probar calidad, materiales y rendimiento, no una afirmación de que el árbol ya esté integrado.

## Instalación y estado
La conexión disponible para editar GitHub permite actualizar archivos de texto, pero no transferir directamente este binario GLB al repositorio. Por eso el recurso todavía no está incluido en `models/`.

Cuando se descargue, colócalo en `escuela_online/models/environment/flowering-cherry-tree.glb`. Abre Godot 3.6.3 y permite importar solo ese archivo. Comprueba escala, materiales, transparencia de flores y tiempo de importación antes de poblar el campus.

## Cómo conseguir calidad sin desperdiciar rendimiento
- Modelos principales detallados a corta distancia y LOD/modelos de menor detalle solo a distancia, sin cambiar la identidad artística.
- Reutilizar materiales y atlas cuando sea posible.
- Compartir meshes/materiales para objetos repetidos y evitar cientos de materiales únicos.
- Usar frustum culling y visibilidad por zonas; no dibujar interiores o edificios que el jugador no puede ver.
- Limitar sombras dinámicas a elementos importantes; probar sombras horneadas donde convenga.
- Controlar tamaño de texturas según el tamaño en pantalla; no cargar 4K por defecto.
- Mantener efectos transparentes (pétalos, partículas) contenidos.
- Cargar el campus por sectores si el tamaño crece.
- Medir FPS, RAM y tiempo de importación en el PC objetivo.

## Próximos recursos
1. Edificio escolar japonés moderno con interiores y exteriores modulares, de calidad anime/stylized y licencia compatible.
2. Personajes anime riggeados con expresiones, ropa y animaciones utilizables.
3. Vegetación secundaria, faroles, bancos, fuentes y mobiliario de calidad coherente.
4. Animación de pétalos y movimiento sutil de árboles, opcional y escalable.

Cada recurso se evalúa por calidad visual, licencia, formato, tamaño, texturas, rig/animaciones y compatibilidad real con Godot 3.6.3.
