# Sakura Academy — beta multijugador (Godot 3.6.3, GLES2)

Proyecto de simulación social escolar anime 3D con multijugador por ENet. El desarrollo visual apunta a modelos 3D reales y detallados; no low poly ni escenarios construidos proceduralmente.

## Cómo abrirlo
1. Ejecuta `descargar_assets.bat` para extraer los paquetes ZIP que hayas colocado en `_descargas/`.
2. Abre `project.godot` con Godot 3.6.3 y permite importar los recursos.
3. Ejecuta F5. Crea una partida como anfitrión o únete con la IP del host.

## Controles
WASD mover · Espacio esquivar · Clic izquierdo atacar · E hablar con NPCs · Enter chat · Rueda del mouse zoom · Esc suelta el mouse.

## Sistemas existentes de la beta
- Lobby para crear o unirse a partidas por IP.
- Red ENet con hasta 8 jugadores, sincronización de movimiento y chat.
- Reloj escolar y ciclo día/noche.
- Misiones, progreso, experiencia, dinero y guardado local.
- NPCs, combate, dojo y duelos entre jugadores.
- HUD, barras y nombres sobre jugadores.

Estos sistemas existentes deben conservarse durante la ampliación del mundo. La estabilidad online debe probarse con varios clientes; no se considera validada por una simple ejecución local.

## Escala y diseño del mundo
El objetivo es un **mapa mediano, compacto y densamente ambientado**. Sakura Academy será claramente la zona más grande e imponente. A su alrededor habrá regiones secundarias más pequeñas: distrito urbano, zona de santuario/templo, costa y naturaleza. No se busca un mundo enorme con largos trayectos vacíos.

Consulta:
- `AMBIENTE_VISUAL.md`: dirección artística, escala, regiones y reglas de desarrollo.
- `SAKURA_ASSETS.md`: criterios de calidad y recursos aceptables.
- `DESCARGA_MODELOS.md`: sitios de descarga, nombres de archivos y flujo ZIP → models/ → reconocimiento automático.
- `MAPA_MUNDO.md`: distribución conceptual y prioridades de construcción.
- `PERSONAJES.md`: dirección de diseño de personajes.

## Descargas seleccionadas (candidatos, no modelos finales aprobados)

- **Paquete de escuela Shuriken Studio (ZIP, GLB, 1.4 MB):** [descarga directa](https://shuriken.studio/kits/school/download). Incluye edificio escolar y conjuntos de interiores. Es una base de prueba estilizada; excluye el conjunto llamado `Low-Poly Classroom` y revisa la apariencia del resto antes de integrarlo.
- **Escuela japonesa y calle comercial — escena GLB (CC0):** [descarga directa del GLB](https://cdn.3dassets.dev/assets/30098/v1/model.glb). [Ficha del paquete y licencia](https://3dassets.dev/packs/japanese-school-and-city-street). Es un candidato para inspección visual, no una academia definitiva aprobada.
- **Pueblo japonés Shuriken:** [ficha del paquete](https://shuriken.studio/kits/japanese-town). **Descartado para el juego:** la propia ficha lo identifica expresamente como low-poly.

La iluminación, los materiales y el postprocesado pueden mejorar el acabado, pero no corrigen proporciones chibi ni geometría low-poly. La selección final debe tener siluetas y proporciones adecuadas antes de aplicar iluminación.

## Recursos 3D
Los modelos se detectan recursivamente dentro de `models/` en formatos glTF/GLB. Coloca los ZIP en `_descargas/` y ejecuta `descargar_assets.bat`; el escáner reconoce modelos por palabras clave en los nombres de archivo. Antes de aceptar un recurso hay que revisar calidad visual, licencia, formato, materiales, texturas y compatibilidad con Godot 3.6.3. Un modelo pequeño no es automáticamente adecuado.

El cerezo de Innerscene revisado anteriormente fue descartado por su copa demasiado escasa. No se debe reutilizar como árbol principal.

## Online
El modo online forma parte central del proyecto. Mantener lobby, ENet, sincronización, chat, autoridad del servidor y aparición de jugadores. Las nuevas regiones y actividades deben diseñarse para varios jugadores simultáneos. No modificar `Player.gd` ni su cámara/controles sin una necesidad concreta y sin preservar su comportamiento.

## Estructura principal
- `Main.gd` / `Main.tscn`: lobby.
- `Network.gd`: conexión ENet, jugadores y chat.
- `World.gd` / `World.tscn`: mundo, luz, zonas, NPCs y sistemas de juego.
- `Level.gd`: carga escenas/escenarios 3D importados y crea colisiones a partir de sus mallas.
- `Player.gd`: movimiento, cámara y sincronización del jugador.
- `Avatar.gd`: modelo visual y animaciones.
- `Models.gd`: búsqueda de modelos.
- `HUD.gd`, `NPC.gd`, `Enemy.gd`, `Stats.gd`, `GameClock.gd`, `Quests.gd`: sistemas de juego.

## Estado honesto
La documentación y el instalador de ZIP están preparados, pero todavía no hay modelos 3D ambientales binarios integrados en `models/`. El escenario visual definitivo no está construido ni probado. No se debe confundir el plan de mundo con contenido ya implementado.
