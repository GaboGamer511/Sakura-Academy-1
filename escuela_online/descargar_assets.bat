# Sakura Academy — inventario de recursos 3D

## Objetivo
Un campus japonés de primavera, luminoso y acogedor. Los cerezos en flor deben ser el rasgo visual principal, acompañados de jardines y mobiliario coherentes.

## Primer paquete ambiental seleccionado

**Low Poly Trees Pack — Riclmbr**
- Página de descarga: https://riclmbr.itch.io/low-poly-trees-pack
- Archivo: `LowPolyTreesPack.zip` (11 MB)
- Contenido anunciado: 26 modelos de árboles y elementos de naturaleza, incluido Cherry Blossom, arbustos y bonsái.
- Formato: un GLB con los modelos y tres atlas de textura compartidos.
- Presupuesto anunciado por el autor: aproximadamente 7.2K triángulos en todo el paquete.
- Licencia declarada: CC0 1.0; permite uso comercial y modificaciones sin atribución obligatoria.
- Motivo de selección: tamaño reducido, bajo recuento de triángulos, texturas compartidas y licencia clara.

### Instalación
1. Descarga el ZIP desde la página oficial del autor.
2. Copia `LowPolyTreesPack.zip` en `escuela_online/_descargas/`.
3. Ejecuta `descargar_assets.bat`.
4. El ZIP se extraerá en `escuela_online/models/LowPolyTreesPack/`.
5. Abre Godot y deja que importe únicamente este paquete nuevo.

El paquete todavía no se incluye como binario en Git: la conexión de edición del repositorio permite escribir archivos de texto, pero no transferir el ZIP binario desde itch.io. No se debe afirmar que los modelos ya están instalados hasta que el archivo exista en `models/` y Godot lo haya importado.

## Presupuesto de importación
- Incorporar un paquete pequeño y comprobado antes de sumar otro.
- No descargar colecciones completas de personajes, edificios y animaciones si no se van a utilizar.
- Mantener los ZIP originales en `_descargas/` para no volver a descargarlos.
- No importar variantes de 4K ni duplicados de texturas si existe un atlas compartido.
- Probar el tiempo de importación y el uso de memoria en Godot 3.6.3 antes de añadir más recursos.

## Siguientes recursos a buscar
1. Edificio escolar modular o campus japonés de bajo peso.
2. Bancos, faroles, macetas y mobiliario exterior.
3. Modelos de personajes anime riggeados con animaciones compatibles.
4. Efectos de pétalos opcionales y limitados.

Cada recurso nuevo debe tener formato, tamaño, licencia y compatibilidad verificados antes de añadirse.
