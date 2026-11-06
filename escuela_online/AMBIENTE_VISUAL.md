# Dirección visual de Sakura Academy

## Identidad
Un campus japonés contemporáneo durante la primavera, con una atmósfera encantadora, acogedora y viva. La flor de sakura define la silueta y la paleta: copas rosadas, pétalos suaves, senderos limpios, jardines cuidados y arquitectura escolar atractiva.

## Calidad visual
- Anime 3D moderno, no low poly.
- Personajes con siluetas diferenciadas, rostros expresivos, ojos trabajados, cabello en mechones y ropa con pliegues/materiales.
- Edificios con geometría arquitectónica real, ventanas, marcos, aleros, barandillas, interiores y mobiliario.
- Árboles de cerezo con troncos y ramas naturales, copas densas y flores volumétricas/texturizadas.
- Vegetación secundaria, jardineras, bancos, faroles japoneses, fuentes y detalles de campus.
- Materiales cuidados, iluminación suave, sombras selectivas y colores primaverales.
- HUD moderno, colorido, legible y coherente con la identidad Sakura.

## Rendimiento: conservar calidad, administrar coste
- Reutilizar recursos y materiales; evitar materiales únicos innecesarios.
- LOD para objetos lejanos, manteniendo el modelo de alta calidad cerca del jugador.
- Visibilidad por sectores y culling para evitar renderizar zonas ocultas.
- Texturas con resolución acorde a su tamaño en pantalla; compresión adecuada.
- Sombras dinámicas selectivas y lightmaps cuando sean viables.
- Pétalos y partículas con límites configurables.
- Medir FPS y memoria en el Intel HD 3000; ajustar opciones gráficas, no rebajar por defecto todos los assets.

## Restricciones del proyecto
- Godot 3.6.3 como versión objetivo.
- Conservar cámara, movimiento y controles existentes.
- No crear edificios, árboles, personajes ni mobiliario mediante geometría procedural de scripts.
- Los scripts pueden gestionar lógica, carga de modelos, visibilidad, interacción, animación y efectos.
- No dar por integrado ni probado ningún asset hasta que exista dentro del proyecto y se haya abierto en Godot.
