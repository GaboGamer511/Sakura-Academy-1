# Escuela Online — BETA (Godot 3.2+, GLES2)

Simulador de vida escolar japonesa, multijugador (host + amigos por IP).

## Cómo abrirlo
1. Ejecuta `descargar_assets.bat` (baja los muebles y descomprime lo que pongas en `_descargas`).
2. Abre `project.godot` en Godot 3.2+ y deja que importe (la primera vez tarda).
3. F5. Elige tu nombre y personaje, **Crear partida** (o **Unirse** con la IP del host) y **Empezar**.

## Controles
WASD mover · Espacio esquivar (gasta stamina, eres invulnerable mientras ruedas) · Clic izquierdo atacar ·
E hablar con NPCs · Enter chat · Rueda del mouse zoom · Esc suelta el mouse

## Qué trae la beta
- **Reloj escolar**: 1 s real = 1 min del juego (un día = 24 min). Periodos: Mañana, Clases, Almuerzo,
  Clubes, Atardecer, Noche, y fin de semana. Ciclo día/noche con el sol moviéndose.
- **Misiones** (cada jugador lleva las suyas, se guardan solas en `user://escuela_save.json`):
  1. Bienvenido a la escuela (entra a un aula) — Prof. Sato
  2. Atención en clase (estudia 60 s en un aula en horario de clases) — Prof. Sato
  3. Libros perdidos (recoge 5 libros azules, reaparecen cada día) — Mika
  4. Prueba del club de kendo (derrota 3 muñecos en el dojo) — Capitán Takeda
  5. El rival del patio oeste (derrota a Kurogane en la arena de piedra) — Capitán Takeda
- **Progreso**: nivel, XP, dinero (¥) y estudio; subir de nivel da más vida y más daño.
- **Combate**: el servidor (host) decide el daño. Los muñecos reaparecen; Kurogane persigue y ataca
  con aviso (esquiva cuando levante la espada). Si mueres pierdes 10% del dinero y reapareces.
- **Duelos entre jugadores** solo dentro del dojo (hacen la mitad de daño).
- **Chat**, nombres y barras de vida sobre los personajes.
- **Estilo anime**: cel-shading con contorno (`Toon.gd`, `shaders/`).

## Dirección visual Sakura
El campus busca un acabado anime 3D moderno (no low poly): cerezos detallados, jardines, edificios escolares cuidados y una atmósfera primaveral. La optimización se hará con LOD, visibilidad, materiales compartidos y control de sombras/texturas. Consulta `AMBIENTE_VISUAL.md` y `SAKURA_ASSETS.md`.

## Modelos
Se detectan solos dentro de `models/` (cualquier subcarpeta): `.glb` / `.gltf`.
- El selector del lobby lista los personajes encontrados; los modelos de árboles, flores y vegetación se excluyen del selector.
- Escuela propia: un modelo con "school" o "classroom" en el nombre reemplaza la escuela de cajas.
- Pupitres: un modelo con "desk" en el nombre (`.glb/.gltf/.obj/.dae`) reemplaza las cajas de pupitres.
- Si el modelo no trae animaciones, el juego anima solo (rebote al caminar, estocada al atacar).
  Si trae animaciones llamadas idle / run (o walk) / attack, las usa.

## Jugar con amigos por Internet
Abre el puerto **UDP 7777** en el router hacia el PC del host, o usa ZeroTier / Radmin VPN.

## Estructura
- Autoloads: `Network.gd` (conexión, chat), `Stats.gd` (nivel, dinero, guardado), `GameClock.gd`
  (hora y periodos), `Quests.gd` (misiones).
- `Main.gd` lobby · `World.gd` mundo/luz/zonas/combate · `Level.gd` geometría · `HUD.gd` interfaz.
- `Player.gd`, `NPC.gd`, `Enemy.gd`, `Avatar.gd` (cuerpo visual y animación procedural).
- `Models.gd` busca modelos · `Toon.gd` + `shaders/` estilo anime.

## Ideas para después
Más NPCs y misiones diarias, clubes con minijuegos, tienda con el dinero, uniformes, animaciones de
Mixamo, servidor dedicado con instancias, cuentas y base de datos.
