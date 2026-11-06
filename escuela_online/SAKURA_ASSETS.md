# Sakura Academy — inventario y criterios de calidad 3D

## Dirección artística
Sakura Academy busca un acabado anime 3D moderno y detallado. **No se utilizará low poly como estilo artístico.** La optimización debe conservar la calidad visual, no reemplazarla por modelos simples.

## Criterios obligatorios para aceptar modelos
- Calidad de silueta y proporciones a la distancia normal de juego.
- Materiales y texturas coherentes con el estilo anime 3D moderno.
- Geometría suficiente para evitar formas toscas o angulosas visibles.
- Licencia clara y compatible con el uso previsto.
- Formato y compatibilidad comprobables con Godot 3.6.3.
- Peso, memoria y tiempo de importación razonables para el equipo objetivo.
- Evaluación visual antes de incorporarlo al proyecto.

## Cerezos y vegetación
El modelo Flowering Cherry Tree de Innerscene queda **descartado**: su copa se ve demasiado escasa/pelona para la identidad visual buscada. No se debe recomendar ni incorporar como árbol principal.

Buscar cerezos con copas abundantes, volumen de flores, ramas naturales y una silueta atractiva. Conviene evaluar varios modelos y variantes antes de seleccionar uno. Combinar árboles principales de alta calidad con vegetación secundaria coherente, sin recurrir a modelos low poly.

## Mundo abierto: categorías de recursos
1. Campus japonés contemporáneo: edificios, aulas, gimnasio, biblioteca, residencias, cafetería y mobiliario.
2. Ciudad: fachadas, tiendas, viviendas, estación, plazas, calles y elementos urbanos.
3. Cultura y patrimonio: santuarios sintoístas, torii, templos budistas, jardines, escalinatas y faroles.
4. Costa: playas, muelles, embarcaciones, comercios costeros y acantilados.
5. Naturaleza: cerezos frondosos, árboles, arbustos, flores, rocas, lagos, ríos y montañas.
6. Vida del mundo: vehículos, señalización, mobiliario, objetos interactivos y recursos para NPC.

## Estado del recurso de cerezo anterior
El candidato Flowering Cherry Tree de Innerscene fue revisado por el usuario y rechazado por su apariencia pelona. No está aprobado y no debe tratarse como recurso seleccionado ni integrado.

## Optimización
- Modelos de alta calidad cerca del jugador y LOD para distancia.
- Materiales compartidos y atlas para reducir cambios de material.
- Culling y visibilidad por zonas.
- Texturas dimensionadas según su uso real, evitando resoluciones excesivas.
- Sombras selectivas, lightmaps y control de transparencias.
- Carga por regiones/sectores para que el mundo abierto no consuma toda la memoria a la vez.
- Medir rendimiento real en Godot 3.6.3 y en el PC objetivo.

## Estado de integración
La edición disponible del repositorio permite modificar archivos de texto, pero no transferir directamente modelos 3D binarios. No afirmar que un asset está integrado hasta que el archivo exista en `models/` y haya sido importado y probado en Godot.
