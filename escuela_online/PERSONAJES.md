# Sakura Academy — biblia de personajes

Documento de producción para los modelos 3D del elenco. **No sustituye los modelos**: cada personaje final debe ser un recurso 3D completo (GLB/GLTF), con malla, materiales, rostro, cabello, ropa y rig propios o correctamente reutilizados desde un modelo artístico real. No se crearán cuerpos, ropa ni accesorios con geometría procedural desde GDScript.

## Dirección visual

- Anime 3D estilizado, acabado limpio y expresivo, identidad visual original.
- Uniforme escolar propio de Sakura Academy: blazer azul noche, camisa clara, corbata/cinta color coral y detalles discretos de sakura. Variaciones permitidas: mangas, suéter, chaqueta deportiva, falda o pantalón reglamentario, medias, zapatos y accesorios.
- Los estudiantes deben leerse como individuos distintos a distancia: silueta, altura, postura, peinado, paleta y accesorios diferenciados.
- Diversidad corporal natural y respetuosa: estaturas bajas, medias y altas; complexiones delgadas, medias, robustas y atléticas; hombros, caderas y proporciones variadas sin convertir el cuerpo en el foco sexual del diseño.
- Personajes estudiantiles con presentación apropiada para un entorno escolar. La personalidad se comunica mediante vestuario, expresión, postura y accesorios.
- Rendimiento: priorizar mallas optimizadas, materiales compartidos cuando proceda, texturas de tamaño moderado y rigs compatibles con las animaciones del juego.

## Elenco principal

| ID | Rol | Diseño visual y silueta | Personalidad / lectura |
|---|---|---|---|
| sakura_player | Protagonista | Cabello oscuro, ojos violetas, estatura media, complexión media. Uniforme impecable con un pequeño detalle coral propio. | Cercana, adaptable; el jugador define su personalidad. |
| gyaru_leader | Gyaru | Estatura media-baja, silueta curvilínea natural, cabello rubio miel o castaño claro con capas, accesorios coloridos y uñas/accesorios discretos. | Extrovertida, segura, sociable. |
| popular_student | Popular | Estatura alta, postura elegante, complexión estilizada, cabello largo y bien cuidado; uniforme personalizado con accesorios finos. | Carismática, organizada, influyente. |
| athlete_student | Deportista | Estatura media-alta, complexión atlética y hombros fuertes; coleta o corte práctico, chaqueta del club y calzado deportivo. | Enérgica, competitiva, leal. |
| honor_student | Estudiante de honor | Estatura media, complexión delgada-media, postura recta, cabello ordenado, gafas opcionales y uniforme formal. | Metódica, inteligente, reservada. |
| rebel_student | Rebelde | Estatura alta, complexión robusta-media, cabello corto/despeinado, uniforme llevado de forma informal y accesorios alternativos no violentos. | Sarcástico, independiente, protector. |
| everyday_student | Estudiante normal | Estatura baja-media, complexión media, cabello sencillo y uniforme estándar; rasgos cálidos y cotidianos. | Amable, tranquilo, fácil de tratar. |

## Personajes secundarios para poblar el campus

Cada entrada debe tener un modelo o variante artística real identificable, no solo un cambio de color aplicado al mismo cuerpo.

| ID | Concepto | Rasgos distintivos |
|---|---|---|
| art_club_student | Club de arte | Estatura baja, complexión media, cabello corto con flequillo, bolso con materiales de dibujo. |
| music_club_student | Club de música | Estatura media, complexión delgada, cabello ondulado, auriculares o funda de instrumento. |
| science_club_student | Club de ciencias | Estatura media, complexión media, gafas y accesorios de laboratorio guardados en bolso. |
| bookworm_student | Lector/a | Estatura baja, complexión robusta-media, cabello recogido, libros y uniforme cómodo. |
| fashion_student | Moda | Estatura alta, silueta estilizada, peinado elaborado y accesorios coordinados. |
| gamer_student | Videojuegos | Estatura media, complexión media, cabello corto, mochila con insignias originales. |
| gardening_student | Jardinería | Estatura media-baja, complexión fuerte, coleta, guantes y bolso de herramientas. |
| transfer_student | Estudiante nuevo/a | Estatura media-alta, complexión media, peinado distintivo y uniforme todavía muy ordenado. |
| quiet_student | Reservado/a | Estatura media, complexión delgada, flequillo largo, paleta sobria y postura tímida. |
| cheerful_student | Optimista | Estatura baja, complexión media, cabello corto o coleta alta, accesorios alegres. |
| tall_student | Estudiante alto/a | Estatura notablemente alta, complexión media, cabello recogido y uniforme sencillo. |
| sturdy_student | Estudiante corpulento/a | Estatura media, complexión robusta, rostro amable, cabello corto y uniforme adaptado correctamente. |

## Reglas de producción de modelos

1. No usar cápsulas, cubos, maniquíes ni cuerpos de prueba como apariencia final.
2. No modificar la silueta corporal escalando un único modelo en GDScript. La altura y complexión deben venir del modelo 3D preparado para ese personaje.
3. Para cada personaje, registrar ruta del GLB/GLTF, escala de importación validada, orientación frontal, rig y nombres reales de animación.
4. Animaciones necesarias: idle, caminar, correr, sentarse, conversar, saludar y gestos sociales. Usar clips reales compatibles con el rig; no sustituirlos por rebotes o inclinaciones procedurales.
5. Mantener la cámara, movimiento y controles actuales de Player.gd. La integración visual debe hacerse en Avatar.gd o en una capa de presentación separada, sin reescribir el controlador.
6. No asignar un mismo modelo a todo el elenco como solución final. Se permiten bases compartidas solo si los personajes tienen variantes 3D reales y claramente diferenciadas.
7. Antes de activar un modelo en el juego, verificar que exista en `res://models/`, que Godot 3.6.3 lo importe y que sus animaciones se puedan reproducir.

## Estado actual del repositorio

En la revisión del repositorio, `escuela_online/models/` contiene únicamente `LEEME.txt`; todavía no hay modelos GLB/GLTF de personajes en esa carpeta. Por eso esta biblia define el elenco, pero **no afirma que los modelos o sus animaciones ya estén instalados**. La siguiente fase de integración depende de incorporar modelos 3D reales y verificar sus rigs y clips.
