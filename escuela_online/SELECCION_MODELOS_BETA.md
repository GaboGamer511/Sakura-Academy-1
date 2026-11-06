# Selección preliminar de modelos 3D — Sakura Academy

Estado: selección inicial de descargas gratuitas. Los enlaces llevan a las fichas originales; revisa que el paquete se haya descargado completo. No se marca ningún asset como integrado hasta probarlo en Godot 3.6.3.

## Prioridad 1 — Academia

**No se aprueba todavía un campus principal.** Los resultados gratuitos que cumplen con el tema escolar tienen compromisos que no conviene ocultar:
- [Japanese School and City Street — 3DAssets.dev](https://3dassets.dev/packs/japanese-school-and-city-street): CC0, 46 modelos, 121.584 triángulos y escena inicial GLB; su estilo es geométrico estilizado y no llega a la dirección anime 3D buscada. Se reserva para prototipo/sector secundario, no como academia definitiva.
- [Haruhi Suzumiya 3D School — CC0](https://github.com/SquirrelModeller/Haruhi-Suzumiya-3D-School): recreación escolar con licencia CC0, pero el repositorio trabaja con Blender y está en desarrollo; requiere comprobar qué partes están completas y exportar GLB. Candidato de investigación, no descarga lista para el juego.
- Los modelos escolares gratuitos de Sketchfab con cientos de miles o más de un millón de triángulos no se seleccionan para el PC objetivo sin optimización y prueba.

## Prioridad 2 — Distrito japonés y zonas tradicionales

**Seleccionado para uso provisional secundario:**
- [Japanese Town — Shuriken Studio](https://shuriken.studio/kits/japanese-town): 25 modelos GLB, 2,1 MB, licencia gratuita del autor sin crédito. Incluye pagoda, santuario sintoísta, casas machiya, posada, casa de té, dojo, jardín koi, puente y set de cerezos. Es low-poly y queda limitado al distrito/zonas secundarias, tal como se acordó.
- [Japanese Rural Village — YumeForge](https://yumeforge.itch.io/japanese-rural-village): pack gratuito parcial, GLTF/FBX, licencia permite uso personal y comercial con restricciones de redistribución. Candidato alternativo; no mezclar estilos hasta revisar visualmente.

## Prioridad 3 — Interiores escolares y mobiliario

- [School — Shuriken Studio](https://shuriken.studio/kits/school): 27 modelos GLB, 1,4 MB, licencia gratuita del autor sin crédito. Se pueden aprovechar como utilería provisional de aulas/servicios; excluir el modelo “Low-Poly Classroom Set”. El edificio rojo no se declara academia final.
- [Japanese School and City Street — 3DAssets.dev](https://3dassets.dev/packs/japanese-school-and-city-street): sus piezas de aula, lockers, puertas, ventanas y árboles son CC0. Seleccionar piezas individuales solo después de comprobar su apariencia y compatibilidad con el proyecto.

## Personajes

- [Rigged Anime Girl — ArtStation Marketplace](https://www.artstation.com/marketplace/p/Mgxo5/rigged-anime-girl): GLB/FBX/Blend gratuitos según la ficha; licencia Standard, comprobar las condiciones vigentes antes de distribuir. Candidata visual, pendiente de revisar rig, animaciones y compatibilidad.
- [Grab3D Character Mixer](https://grab3d.com/tools/character-mixer/): exporta GLB riggeado con clips, CC0; sus estilos disponibles no son anime y no se aprueba como personaje definitivo.
- No usar personajes low-poly como protagonistas.

## Vegetación

- No se aprueba el modelo Flowering Cherry Tree de Innerscene (rechazado anteriormente).
- El set Cherry Blossom de Shuriken y los cerezos de 3DAssets.dev son candidatos únicamente para zonas secundarias tras inspección visual. La academia requiere árboles con copas florales abundantes.

## Instalación

1. Descarga los ZIP de los paquetes seleccionados.
2. Colócalos en `escuela_online/_descargas/`.
3. Ejecuta `descargar_assets.bat`.
4. Abre el proyecto en Godot 3.6.3 y espera la importación.
5. Comprueba que aparecen archivos `.glb` o `.gltf` dentro de `escuela_online/models/`.

**Importante:** el cargador actual busca escenas completas por palabras clave en el nombre del archivo. Los paquetes de piezas sueltas no forman automáticamente una academia; requieren ensamblado como escena 3D. No se debe renombrar un objeto suelto como `school_campus.glb` para simular que es un campus.
