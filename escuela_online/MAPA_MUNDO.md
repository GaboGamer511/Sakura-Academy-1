# Mapa de Sakura Academy — plano de producción

## Objetivo de escala
Mapa mediano, conectado y denso. La academia debe ocupar aproximadamente la mitad del espacio jugable y dominar la composición visual. Las zonas exteriores funcionan como destinos cercanos, no como continentes enormes. Las distancias definitivas se ajustarán después de montar un primer bloque jugable con modelos reales.

## Distribución conceptual
La orientación es ilustrativa; no fija coordenadas definitivas ni obliga a rehacer los controles.

- **Centro: Sakura Academy (prioridad 1).** Campus principal con edificio académico dominante, alas de aulas, biblioteca, gimnasio, cafetería, clubes, residencias, patio central, cancha, jardines y caminos cubiertos. Debe tener interiores accesibles y espacios donde coincidan jugadores.
- **Noroeste: distrito urbano (prioridad 2).** Unas pocas manzanas compactas: calle comercial, cafetería, tienda, viviendas, parada/estación y una plaza. Fachadas variadas y algunos interiores funcionales; evitar calles largas sin actividad.
- **Noreste: recinto tradicional (prioridad 3).** Santuario sintoísta con acceso marcado por torii y sendero arbolado; templo budista y jardín tranquilo en un sector cercano, pero visualmente distinguible.
- **Sur: costa (prioridad 4).** Playa, paseo corto, muelle y pequeño conjunto de comercios. La costa debe cerrar el recorrido con vistas al mar, sin convertirse en una extensión vacía.
- **Oeste: parque natural (prioridad 5).** Bosque de cerezos frondosos, lago pequeño, puente, senderos y mirador. El cerezo debe tener copa abundante y silueta atractiva; el modelo anteriormente rechazado no se reutiliza.

## Recorrido y densidad
- Desde el patio principal debe ser fácil orientarse hacia las demás regiones.
- Usar caminos, plazas pequeñas, vegetación, mobiliario, señalización y puntos de interés para dar continuidad.
- Evitar grandes campos vacíos, carreteras interminables y edificios decorativos inaccesibles que ocupen mucho espacio.
- Cada región debe ofrecer al menos una actividad, interacción o punto memorable.
- El campus tiene más variedad de interiores y espacios sociales que cualquier otra región.

## Diseño online
- Diseñar el patio, cafetería, plaza urbana, playa y santuario como puntos naturales de reunión.
- Mantener spawn seguro y legible para jugadores que se conectan tarde.
- Las actividades compartidas deben ejecutarse con autoridad del servidor; los elementos puramente cosméticos pueden ser locales.
- Las zonas de combate deben estar delimitadas para evitar daño accidental en espacios sociales.
- No hacer que el cambio de región reinicie o desconecte a los jugadores.
- Probar con varios clientes: entrada tardía, movimiento simultáneo, chat, interacción, combate y reconexión.

## Producción por etapas
1. **Bloqueo del campus:** modelo de escuela y patio principal, colisiones, navegación y puntos de spawn.
2. **Campus jugable:** interiores esenciales, zonas de misión, NPC y actividades online.
3. **Distrito urbano:** manzanas compactas con comercios y puntos sociales.
4. **Santuario/templo y parque:** arquitectura, jardines y vegetación de calidad.
5. **Costa:** playa, muelle y paseo.
6. **Pulido:** iluminación, ambientación, audio, eventos, optimización y pruebas de red.

## Reglas de producción
- Los edificios, árboles, personajes, mobiliario y escenario deben proceder de modelos/escenas 3D reales creados o licenciados; no generarlos con primitivas desde scripts.
- Los scripts pueden controlar carga por sectores, colisiones, navegación, NPC, interacciones, animaciones, red y efectos.
- No aceptar assets low poly como sustituto del estilo anime 3D moderno.
- No expandir el mapa hasta que el campus principal tenga densidad y actividades suficientes.
- Mantener Godot 3.6.3 como objetivo y no alterar Player.gd/cámara sin necesidad.
- Toda integración se valida abriendo el proyecto y probando la escena; la documentación no equivale a una implementación terminada.
