# Dirección visual y diseño del mundo de Sakura Academy

## Visión general
Sakura Academy será un mundo abierto japonés de exploración libre, no solamente un campus aislado. La academia será uno de sus centros principales, dentro de una región amplia con ciudad, costa, naturaleza y lugares históricos. Las regiones deben sentirse conectadas y habitadas.

## Regiones del mundo
- **Sakura Academy:** campus japonés contemporáneo con aulas, patios, biblioteca, gimnasio, clubes, residencias, cafetería, jardines y zonas deportivas.
- **Ciudad:** calles comerciales, tiendas, cafeterías, restaurantes, viviendas, apartamentos, estación, plazas, callejones y zonas residenciales.
- **Santuarios y templos:** santuarios sintoístas con torii, patios y senderos; templos budistas con arquitectura, jardines, campanas y espacios de contemplación. Diferenciar respetuosamente ambos tipos de lugar.
- **Costa:** playas, muelles, puerto o pueblo pesquero, paseos marítimos, acantilados y miradores.
- **Naturaleza y pueblos:** bosques, montañas, lagos, ríos, cascadas, caminos rurales y pequeñas poblaciones.
- **Zonas adicionales:** parques, mercados, festivales, miradores y áreas secretas que puedan incorporarse a medida que crezca el proyecto.

Las regiones se conectarán mediante carreteras, caminos peatonales, rutas naturales y, cuando el diseño lo permita, transporte público. La exploración será libre y habrá puntos de interés, actividades, NPC y eventos.

## Identidad visual
- Anime 3D moderno y detallado; **no low poly**.
- No usar geometría procedural como sustituto de modelos artísticos.
- Personajes con siluetas diferenciadas, rostros expresivos, cabello trabajado y ropa con pliegues y materiales.
- Arquitectura con geometría real, ventanas, marcos, aleros, barandillas, interiores y mobiliario.
- Cerezos con copas densas, ramas naturales y flores abundantes. Rechazar modelos visiblemente pelones o con copas pobres.
- Vegetación secundaria frondosa, jardines, faroles, bancos, fuentes, señalización y detalles propios de cada región.
- Diferenciar materiales y arquitectura entre ciudad moderna, campus, templos, costa y pueblos.
- Iluminación cuidada, colores vivos, atmósfera primaveral y cambios ambientales por región.

## Calidad de los assets
Todo modelo ambiental o personaje debe evaluarse visualmente antes de aceptarlo. Revisar densidad y forma de la copa en los cerezos, proporciones, materiales, texturas, escala, licencia y compatibilidad con Godot 3.6.3. Un archivo pequeño no es automáticamente un buen recurso. No aceptar un asset solo por su peso o número de polígonos.

## Rendimiento sin degradar el estilo
- Reutilizar recursos, materiales y atlas donde sea posible.
- LOD únicamente para objetos lejanos; conservar detalle cerca del jugador.
- Culling y visibilidad por sectores para no renderizar regiones ocultas.
- Texturas con resolución adecuada a su tamaño en pantalla y compresión compatible.
- Sombras dinámicas selectivas y lightmaps cuando sean viables.
- Controlar transparencia y overdraw en pétalos, hojas y partículas.
- Cargar o activar regiones por sectores para gestionar memoria.
- Medir FPS, RAM y tiempos de importación en el equipo objetivo antes de ampliar el mundo.

## Restricciones del proyecto
- Godot 3.6.3 como versión objetivo.
- Conservar cámara, movimiento y controles existentes.
- No crear edificios, árboles, personajes, mobiliario ni escenarios mediante geometría procedural de scripts.
- Los scripts sí pueden gestionar lógica, streaming/carga de regiones, visibilidad, interacción, animación, multijugador y efectos.
- No dar por integrado ni probado ningún asset hasta que exista dentro del proyecto y se haya abierto en Godot.
- Construir el mundo por regiones compatibles entre sí, evitando intentar cargar todo el mapa a máxima calidad al mismo tiempo.
