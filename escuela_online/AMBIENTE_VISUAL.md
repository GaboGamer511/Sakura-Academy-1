# Dirección visual y diseño del mundo de Sakura Academy

## Visión general y escala
Sakura Academy será un mundo abierto de tamaño mediano, compacto y densamente ambientado. **La academia debe ser, con diferencia, la zona más grande, importante e imponente del mapa.** El resto del mundo aportará variedad y lugares memorables, sin competir con la escuela ni crear grandes extensiones vacías.

No se busca un mundo gigantesco por kilómetros. Se busca un mapa continuo o conectado con distancias razonables, recorridos interesantes, buena densidad de detalles, actividades y puntos de interés.

## Distribución de regiones
- **Sakura Academy — zona principal:** el área más extensa y reconocible. Campus con varios edificios, aulas, patios, biblioteca, gimnasio, clubes, residencias, cafetería, zonas deportivas, jardines y espacios interiores/exteriores explorables.
- **Distrito urbano cercano:** zona compacta con calles comerciales, tiendas, cafeterías, restaurantes, viviendas, estación o plaza y callejones con personalidad.
- **Zona tradicional:** santuario sintoísta con torii, patios y senderos; templo budista con arquitectura y jardines. Un área cultural atractiva, no una región desproporcionada.
- **Zona costera:** playa, muelle, paseo marítimo, pequeño puerto o comercios junto al mar.
- **Zona natural:** bosque de cerezos frondosos, senderos, lago, río, miradores y pequeñas áreas de descanso.
- **Conexiones:** carreteras, caminos peatonales y rutas naturales cortas que unan las regiones sin convertir los desplazamientos en trayectos interminables.

La academia será el centro social y jugable. Las zonas secundarias funcionarán como destinos de exploración, actividades, eventos y descanso. Cada zona debe tener elementos visuales y actividades suficientes para no sentirse vacía.

## Online como pilar del proyecto
El juego debe conservar su modo online/multijugador como parte central de su diseño. El mapa, sus regiones y sus actividades deben planearse teniendo en cuenta a varios jugadores simultáneos.
- Mantener los sistemas de red, sincronización y autoridad existentes.
- No sustituir ni eliminar el multijugador para implementar el mundo abierto.
- Las interacciones relevantes, estados compartidos, actividades y eventos deben diseñarse para funcionar correctamente en red.
- Evitar que la carga de regiones, NPC y efectos locales interfiera con la sincronización.
- Probar desplazamiento, aparición de jugadores, interacciones y cambios de zona con más de un cliente.
- No afirmar que el online está probado si no se ha ejecutado una prueba real con varios clientes.

## Identidad visual
- Anime 3D moderno y detallado como identidad definitiva.
- Se permite low-poly temporal, gratuito y selectivo en el distrito urbano secundario y elementos de fondo para cuidar el rendimiento; no debe dominar la academia, los personajes protagonistas ni los elementos emblemáticos.
- No usar geometría procedural como sustituto de modelos artísticos.
- Personajes con siluetas diferenciadas, rostros expresivos, cabello trabajado y ropa con pliegues y materiales.
- Arquitectura con geometría real, ventanas, marcos, aleros, barandillas, interiores y mobiliario.
- Cerezos con copas densas, ramas naturales y flores abundantes. Rechazar modelos visiblemente pelones o con copas pobres.
- Vegetación secundaria frondosa, jardines, faroles, bancos, fuentes, señalización y detalles propios de cada región.
- Diferenciar materiales y arquitectura entre ciudad moderna, campus, templos, costa y pueblos.
- Iluminación cuidada, colores vivos, atmósfera primaveral y cambios ambientales por región.

## Calidad de los assets
Todo modelo ambiental o personaje debe evaluarse visualmente antes de aceptarlo. Los assets low-poly temporales requieren una revisión adicional de silueta y proporciones, y deben poder sustituirse sin rehacer la lógica del juego. Revisar densidad y forma de la copa en los cerezos, proporciones, materiales, texturas, escala, licencia y compatibilidad con Godot 3.6.3. Un archivo pequeño no es automáticamente un buen recurso. No aceptar un asset solo por su peso o número de polígonos.

## Acabado temporal de assets estilizados

Los modelos low-poly gratuitos pueden utilizarse en el distrito urbano secundario y props de fondo. Godot debe armonizarlos mediante materiales que conserven texturas y mapas PBR, reflejos moderados, iluminación ambiental, sombras selectivas, niebla y corrección de color. Evitar contornos gruesos y efectos de postprocesado costosos. No prometer que el sombreado convierte una malla simple en una detallada: las piezas son provisionales y reemplazables. La academia, protagonistas y elementos emblemáticos conservan la prioridad visual.

## Rendimiento sin degradar el estilo
- Reutilizar recursos, materiales y atlas donde sea posible.
- Usar low-poly solo como compromiso temporal y selectivo; no asumir que una iluminación bonita puede reparar una malla pobre.
- LOD únicamente para objetos lejanos; conservar el modelo detallado cerca del jugador.
- Culling y visibilidad por sectores para no renderizar zonas ocultas.
- Texturas con resolución adecuada a su tamaño en pantalla y compresión compatible.
- Sombras dinámicas selectivas y lightmaps cuando sean viables.
- Controlar transparencia y overdraw en pétalos, hojas y partículas.
- Cargar o activar regiones por sectores para gestionar memoria y mantener fluido el online.
- Medir FPS, RAM, tráfico de red y tiempos de importación en el equipo objetivo antes de ampliar el mundo.

## Restricciones del proyecto
- Godot 3.6.3 como versión objetivo.
- Conservar cámara, movimiento y controles existentes.
- Conservar el modo online y los sistemas de red existentes.
- No crear edificios, árboles, personajes, mobiliario ni escenarios mediante geometría procedural de scripts.
- Los scripts sí pueden gestionar lógica, carga de regiones, visibilidad, interacción, animación, multijugador y efectos.
- No dar por integrado ni probado ningún asset o sistema hasta que exista dentro del proyecto y se haya probado en Godot.
- Priorizar un mapa mediano, denso y bien conectado sobre un mundo enorme y vacío.
