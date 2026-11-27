# PuntoClick Studio 3D · puntoclick3d.com

Página principal de PuntoClick Studio 3D (impresión 3D y páginas web, Punto Fijo).

- `index.html` y `img/`: la página que se publica en https://puntoclick3d.com
- El servidor (VPS con aaPanel) descarga los cambios de la rama `main` automáticamente.
- La carpeta `/catalogo` vive solo en el servidor y no está en este repositorio.

## Auto-actualización
- `version.txt` y `<meta name="pc-version">` en `index.html` deben tener el MISMO valor.
- En cada cambio, poner un valor nuevo en los dos (por ejemplo la fecha y hora `AAAAMMDDHHMM`).
- La página revisa `version.txt` al abrir, cada 60 segundos y al volver a la pestaña; si cambió, se recarga sola con `?v=` para saltarse el caché.
