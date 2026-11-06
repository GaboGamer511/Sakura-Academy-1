# Guía de descarga e instalación de modelos 3D

Este documento conserva el flujo que ya preparó el proyecto: **tú descargas los paquetes, el BAT los extrae y Godot detecta los modelos desde `res://models/`**. No hay que editar scripts cada vez que agregues un ZIP.

## 1. Dónde descargar

Estas son fuentes y páginas para buscar recursos. No significa que todos los modelos de una página sean adecuados: revisa la vista 3D, licencia, texturas, escala y, para personajes, que incluyan esqueleto y animaciones cuando se necesiten.

### Personajes anime 3D
- [Sketchfab — modelos anime descargables](https://sketchfab.com/search?features=downloadable&type=models&q=anime%20character): filtra por descargables y revisa la licencia individual. Hay modelos con atribución obligatoria; conserva el crédito y el archivo de licencia.
- [Shuriken Studio — personajes y criaturas GLB](https://shuriken.studio/models/characters): catálogo de modelos GLB. Examina cada modelo; no selecciones los que tengan estética low-poly.

### Academia, edificios y mobiliario
- [Innerscene — School building (GLB, CC0)](https://www.innerscene.com/tools/library/3d-parts/school-building-1f9f21e3): edificio escolar de ladrillo de estilo histórico. Puede servir como referencia/estructura secundaria, pero **no está aprobado como academia final anime**; comprueba su aspecto antes de incorporarlo.
- [Shuriken Studio — edificios GLB](https://shuriken.studio/models/buildings): busca edificios y piezas de campus; inspecciona el estilo de cada descarga y evita cualquier recurso low-poly.
- [Shuriken Studio — muebles GLB](https://shuriken.studio/models/furniture): busca aulas, biblioteca, cafetería y oficinas. Revisa cada pieza individualmente.

### Japón tradicional, naturaleza y cerezos
- [Shuriken Studio — naturaleza GLB](https://shuriken.studio/models/nature): buscar árboles, arbustos y flores. Para cerezos exige copas frondosas, flores densas y ramas naturales. El cerezo pelón de Innerscene que ya se rechazó no debe volver a descargarse.
- [Sketchfab — santuarios japoneses descargables](https://sketchfab.com/search?features=downloadable&type=models&q=japanese%20shrine): revisa licencia y detalle. Evita los resultados low-poly.
- [Sketchfab — cerezos en flor descargables](https://sketchfab.com/search?features=downloadable&type=models&q=cherry%20blossom%20tree): inspecciona la copa en vista 3D; no aceptar árboles escasos o con aspecto de videojuego low-poly.

### Catálogo general
- [Shuriken Studio — todos los modelos GLB](https://shuriken.studio/models): catálogo gratuito. La licencia indicada por el sitio es para cada modelo/paquete; verifica los términos antes de usarlo.

## 2. Cómo instalarlos

1. Descarga un paquete que contenga archivos `.glb` o `.gltf` (preferiblemente ZIP).
2. Copia el ZIP, sin descomprimir, dentro de `escuela_online/_descargas/`.
3. Ejecuta `escuela_online/descargar_assets.bat`.
4. El BAT extraerá cada ZIP en una subcarpeta de `escuela_online/models/`. No borra los ZIP originales.
5. Abre el proyecto con **Godot 3.6.3** y deja que termine la importación de recursos.
6. En el lobby, comprueba si aparecen los personajes detectados. Inicia una partida y revisa el escenario.

También puedes poner directamente un GLB/GLTF en `models/`; el escáner busca recursivamente en las subcarpetas.

## 3. Nombres que el proyecto reconoce

El escáner busca palabras clave en el nombre del archivo, no en el nombre del ZIP. Puedes conservar las carpetas internas del paquete, pero conviene renombrar los archivos GLB/GLTF con nombres descriptivos.

| Recurso | El nombre del archivo debe contener una de estas palabras |
|---|---|
| Campus principal | `school_campus`, `academy`, `campus` o `school` |
| Distrito japonés | `urban_district`, `japanese_town`, `city_district` o `shopping_street` |
| Santuario sintoísta | `shinto_shrine`, `shrine` o `torii` |
| Templo budista | `buddhist_temple`, `temple` o `pagoda` |
| Costa / puerto | `coast`, `beach`, `harbor` o `pier` |
| Bosque de cerezos | `sakura_forest`, `cherry_grove`, `blossom_forest` o `cherry_forest` |
| Dojo | `kendo_dojo`, `martial_arts_dojo` o `dojo` |
| Personaje completo | `character`, `student`, `fullbody`, `body`, `player`, `avatar`, `humanoid`, `girl`, `boy`, `male` o `female` |

**Importante:** cada archivo de escenario debe ser una escena GLB/GLTF ensamblada que represente esa región o edificio. El cargador no combina automáticamente docenas de piezas sueltas para inventar una academia completa. Los muebles y props se descargan aparte y requieren una escena que los organice si no vienen ya agrupados.

Para los personajes, usa cuerpos completos; piezas sueltas como pelo, ojos, armas o ropa no son avatares. Los personajes deben incluir rig/esqueleto y animaciones compatibles para que idle/run/attack funcionen. El proyecto elige modelos detectados para el lobby y los NPC; revisa el resultado dentro del juego.

## 4. Reglas de calidad y licencia

- No usar low-poly como dirección artística.
- No usar geometría procedural como sustituto de edificios, árboles, muebles o personajes.
- No asumir que un modelo gratuito permite cualquier uso: guarda su licencia y atribuciones.
- Evitar archivos con texturas externas faltantes; GLB suele ser más sencillo porque puede incluirlas.
- Comprobar escala, orientación, materiales, rig y animaciones en Godot 3.6.3.
- No marcar un recurso como aprobado hasta verlo dentro del juego.
- El equipo objetivo es antiguo; empezar con texturas razonables y medir memoria/rendimiento, sin degradar la calidad artística.

## 5. Qué falta para que el mundo se vea completo

El repositorio contiene el sistema de extracción y reconocimiento, pero los modelos artísticos binarios no están incluidos. Hasta que se añadan los paquetes, el mapa no tendrá edificios/escenarios finales y los avatares pueden mostrar el recurso de respaldo. El instalador no descarga modelos por sí solo: tú eliges los paquetes y los colocas en `_descargas`.
