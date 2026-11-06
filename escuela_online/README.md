# Sakura Academy — beta multijugador (Godot 3.6.3, GLES2)

Proyecto de simulación social escolar anime 3D con multijugador por ENet. El estilo principal apunta a anime 3D moderno y detallado. Se permite usar temporalmente algunos modelos low-poly gratuitos, de forma selectiva y sobre todo en zonas secundarias, para cuidar el rendimiento; no serán el estándar visual definitivo. No se construyen escenarios mediante geometría procedural.

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

## Recursos gratuitos seleccionados (sin pagos)

**No compres ningún paquete para este proyecto.** Los enlaces de esta sección son recursos gratuitos; algunos son candidatos individuales y no un escenario completo.

### Pueblo japonés
- [Casa japonesa tradicional — GLB gratuito, CC0](https://grab3d.com/models/buildings/japanese-house/): casa de madera con tejado de teja, paneles shoji y veranda. El sitio ofrece GLB de calidad completa y versión ligera; elegir GLB para Godot.
- [Casa de té — GLB gratuito, CC0](https://grab3d.com/models/buildings/tea-house/): edificio tradicional con veranda, puertas correderas y farol.
- [Japanese Town de Shuriken Studio](https://shuriken.studio/kits/japanese-town): **opción provisional gratuita** para probar casas, tiendas y elementos secundarios del distrito. Aceptamos temporalmente su estilo low-poly si encaja en escala y silueta; no usarlo como estilo de la academia ni como referencia definitiva.

Estos modelos gratuitos sirven como piezas iniciales, no forman todavía un pueblo completo. El distrito debe seguir siendo compacto y denso; no se deben fingir edificios que aún no tenemos.

### Academia
- [School building — GLB gratuito, CC0](https://www.innerscene.com/tools/library/3d-parts/school-building-1f9f21e3): escuela histórica de ladrillo a escala real. Es un candidato de estructura/estudio, no la academia anime definitiva.
- [University Building — GLB gratuito, CC0](https://grab3d.com/models/buildings/university-building/): edificio universitario de tres plantas. Candidato para comparar silueta y proporciones; no está aprobado como campus final.
- [School de Shuriken Studio — kit gratuito, GLB](https://shuriken.studio/kits/school): contiene 27 piezas escolares; excluir expresamente `Low-Poly Classroom Set`. El conjunto es estilizado y debe inspeccionarse antes de usarlo; no es una aprobación automática.

## Recursos 3D
Los modelos se detectan recursivamente dentro de `models/` en formatos glTF/GLB. Coloca los ZIP en `_descargas/` y ejecuta `descargar_assets.bat`; el escáner reconoce modelos por palabras clave en los nombres de archivo. Antes de aceptar un recurso hay que revisar calidad visual, licencia, formato, materiales, texturas y compatibilidad con Godot 3.6.3. Un modelo pequeño no es automáticamente adecuado.

El cerezo de Innerscene revisado anteriormente fue descartado por su copa demasiado escasa. No se debe reutilizar como árbol principal. La excepción low-poly es temporal y selectiva; los cerezos protagonistas, la academia y los personajes mantienen el estándar visual detallado.

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
