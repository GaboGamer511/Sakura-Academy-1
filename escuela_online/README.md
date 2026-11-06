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
- `MAPA_MUNDO.md`: distribución conceptual y prioridades de construcción.
- `PERSONAJES.md`: dirección de diseño de personajes.

## Recursos 3D
Los modelos se detectan dentro de `models/` en formatos glTF/GLB. Antes de aceptar un recurso hay que revisar calidad visual, licencia, formato, materiales, texturas y compatibilidad con Godot 3.6.3. Un modelo pequeño no es automáticamente adecuado.

El cerezo de Innerscene revisado anteriormente fue descartado por su copa demasiado escasa. No se debe reutilizar como árbol principal.

## Online
El modo online forma parte central del proyecto. Mantener lobby, ENet, sincronización, chat, autoridad del servidor y aparición de jugadores. Las nuevas regiones y actividades deben diseñarse para varios jugadores simultáneos. No modificar `Player.gd` ni su cámara/controles sin una necesidad concreta y sin preservar su comportamiento.

## Estructura principal
- `Main.gd` / `Main.tscn`: lobby.
- `Network.gd`: conexión ENet, jugadores y chat.
- `World.gd` / `World.tscn`: mundo, luz, zonas, NPCs y sistemas de juego.
- `Level.gd`: construcción/carga del escenario (pendiente de migración completa a escenas y modelos 3D reales).
- `Player.gd`: movimiento, cámara y sincronización del jugador.
- `Avatar.gd`: modelo visual y animaciones.
- `Models.gd`: búsqueda de modelos.
- `HUD.gd`, `NPC.gd`, `Enemy.gd`, `Stats.gd`, `GameClock.gd`, `Quests.gd`: sistemas de juego.

## Estado honesto
La documentación y el instalador de ZIP están preparados, pero todavía no hay modelos 3D ambientales binarios integrados en `models/`. El escenario visual definitivo no está construido ni probado. No se debe confundir el plan de mundo con contenido ya implementado.
