# Sakura Academy — dirección artística del campus

## Idea central
Sakura Academy debe sentirse como un campus japonés de primavera: bonito, luminoso, acogedor, colorido y lleno de actividad cotidiana. Los cerezos en flor son un símbolo central de la identidad del juego, no un adorno aislado.

## Paisaje y vegetación
- Árboles de sakura de modelos 3D reales, con copas rosadas abundantes y troncos/ramas bien definidos.
- Distribuir cerezos en avenidas peatonales, patios, jardines, entradas y zonas de descanso. Crear pequeños túneles de cerezos en los caminos principales.
- Añadir modelos reales de arbustos, césped, flores de temporada, macetas, setos y árboles complementarios para que el campus no sea monocromático.
- Pétalos en el suelo mediante texturas/decals o meshes artísticos ya preparados. Si se incorporan partículas de pétalos, deben ser un efecto ligero y opcional, no una sustitución de los modelos de árboles.
- Bancos, faroles, puentes pequeños, fuentes y pérgolas como recursos 3D reales, donde encajen con el diseño del campus.

## Arquitectura
- Escuela japonesa moderna y acogedora: edificios de varios pisos, grandes ventanales, fachadas claras, detalles de madera y señalización escolar.
- Patios amplios y legibles, pasillos cubiertos, escaleras, balcones y entradas reconocibles.
- Zonas con identidad: entrada principal, patio central de sakura, aulas, biblioteca, cafetería, gimnasio, dojo, clubes y jardines.
- Evitar una distribución caótica o una repetición evidente del mismo edificio. Mantener una arquitectura coherente entre zonas.

## Color, luz y atmósfera
- Paleta principal: rosa sakura, blanco cálido, verde primaveral, madera clara y azul cielo.
- Iluminación diurna suave y agradable, sombras moderadas y materiales con colores vivos pero no saturados.
- Cielo claro y sensación de aire libre. Los cambios de hora pueden aportar amaneceres y atardeceres cálidos sin perder legibilidad.
- El campus debe seguir siendo atractivo con los ajustes gráficos bajos del equipo objetivo.

## Vida y animación ambiental
- Estudiantes con modelos y animaciones reales recorriendo rutas, conversando, sentándose y reuniéndose en grupos.
- Banderines, carteles escolares y elementos decorativos que ayuden a dar movimiento visual.
- Animación de árboles y flores solo si se puede lograr de forma ligera y sin scripts que construyan geometría.
- Pétalos animados opcionales con límites estrictos de cantidad y distancia; opción para desactivarlos en equipos modestos.
- Sonido ambiental suave: pájaros, viento y actividad escolar, con controles de volumen.

## Reglas técnicas y de producción
1. Todo árbol, edificio, banco, farol, planta, fuente, mobiliario y decoración debe proceder de un asset 3D real o de un recurso artístico importado. No construir el campus mediante cubos, primitivas ni geometría generada por scripts.
2. No generar el escenario de forma procedural. Los scripts pueden colocar, cargar, activar/desactivar y optimizar assets existentes, pero no fabricarlos.
3. Preferir modelos low-poly estilizados de buena calidad o modelos anime optimizados, con materiales y texturas eficientes para Intel HD 3000 y 4 GB de RAM.
4. Usar LOD si está disponible, instancing de recursos repetidos, occlusion culling cuando sea compatible y límites de distancia para vegetación/efectos.
5. No llenar el campus con miles de pétalos ni efectos costosos. Mantener una opción de calidad baja.
6. Conservar el controlador, la cámara y los controles actuales del proyecto `escuela_online`. La mejora del ambiente debe centrarse en escenas y recursos, no en reescribir el movimiento.
7. No declarar terminado ni probado ningún elemento hasta que el modelo exista en el proyecto, Godot 3.6.3 lo importe y la escena se compruebe en ejecución.

## Prioridad de implementación
1. Modelos reales de árboles de sakura y vegetación complementaria.
2. Entrada principal y patio central como espacios visualmente memorables.
3. Edificios escolares y mobiliario coherentes.
4. Jardines, caminos, bancos, faroles y decoración.
5. Vida ambiental: estudiantes con animaciones, sonido y pétalos opcionales.
