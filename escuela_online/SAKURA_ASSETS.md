# Sakura Academy — inventario y criterios de calidad 3D

## Dirección artística y escala
Sakura Academy busca un acabado anime 3D moderno y detallado. **El estilo definitivo no será low-poly**, pero se permite utilizar temporalmente y de forma selectiva algunos modelos low-poly gratuitos, sobre todo en el distrito urbano y elementos secundarios, para cuidar el rendimiento y avanzar sin presupuesto. La academia y los personajes principales conservan la prioridad de detalle.

El mapa será de tamaño mediano y estará densamente ambientado. La academia será claramente la zona más grande e imponente. Las demás áreas serán destinos compactos con identidad propia: distrito urbano, zona de santuarios/templos, costa y naturaleza. Evitar kilómetros de terreno vacío.

## Online como requisito
Todos los recursos y la organización del mundo deben considerar el modo online existente. No eliminar ni sustituir la red, la sincronización o la autoridad del proyecto para construir el mapa.
- Revisar si las interacciones y actividades deben replicarse o permanecer locales.
- Evitar sincronizar efectos puramente visuales que no necesiten replicación.
- Mantener coherencia de aparición de jugadores y cambios de región.
- Comprobar el comportamiento con varios clientes antes de declarar una función online terminada.

## Criterios obligatorios para aceptar modelos
- Calidad de silueta y proporciones a la distancia normal de juego.
- Materiales y texturas coherentes con el estilo anime 3D moderno; en assets low-poly temporales, comprobar que el acabado no resulte demasiado caricaturesco.
- Los ajustes de iluminación, materiales, niebla y exposición pueden mejorar la integración visual, pero no añaden geometría ni corrigen proporciones.
- Geometría suficiente para evitar formas toscas o angulosas visibles.
- Licencia clara y compatible con el uso previsto.
- Formato y compatibilidad comprobables con Godot 3.6.3.
- Peso, memoria y tiempo de importación razonables para el equipo objetivo.
- Evaluación visual antes de incorporarlo al proyecto.

## Cerezos y vegetación
El modelo Flowering Cherry Tree de Innerscene queda **descartado**: su copa se ve demasiado escasa/pelona para la identidad visual buscada. No se debe recomendar ni incorporar como árbol principal.

Buscar cerezos con copas abundantes, volumen de flores, ramas naturales y una silueta atractiva. Conviene evaluar varios modelos y variantes antes de seleccionar uno. Combinar árboles principales de alta calidad con vegetación secundaria coherente. Se permiten piezas low-poly temporales para vegetación distante si su silueta funciona y no se convierten en protagonistas.

## Recursos por región
1. **Academia (prioridad máxima):** edificios, aulas, gimnasio, biblioteca, residencias, cafetería, patios, jardines y mobiliario.
2. **Distrito urbano compacto:** fachadas, tiendas, viviendas, estación, plazas, calles y elementos urbanos.
3. **Zona tradicional:** santuario sintoísta, torii, templo budista, jardines, escalinatas y faroles.
4. **Costa:** playa, muelle, embarcaciones, comercios costeros y acantilados.
5. **Naturaleza:** cerezos frondosos, árboles, arbustos, flores, rocas, lago, río y miradores.
6. **Vida del mundo:** vehículos, señalización, mobiliario, objetos interactivos y recursos para NPC.

## Estado del recurso de cerezo anterior
El candidato Flowering Cherry Tree de Innerscene fue revisado por el usuario y rechazado por su apariencia pelona. No está aprobado y no debe tratarse como recurso seleccionado ni integrado.

## Optimización sin degradar calidad
- Modelos detallados cerca del jugador y LOD para distancia.
- Materiales compartidos y atlas para reducir cambios de material.
- Culling y visibilidad por zonas.
- Texturas dimensionadas según su uso real, evitando resoluciones excesivas.
- Sombras selectivas, lightmaps y control de transparencias.
- Carga por regiones/sectores para que el mapa mediano no consuma toda la memoria a la vez.
- Evitar replicar por red efectos cosméticos locales innecesarios.
- Medir rendimiento, memoria y comportamiento con varios clientes en Godot 3.6.3.

## Estado de integración
La edición disponible del repositorio permite modificar archivos de texto, pero no transferir directamente modelos 3D binarios. No afirmar que un asset está integrado hasta que el archivo exista en `models/` y haya sido importado y probado en Godot.
