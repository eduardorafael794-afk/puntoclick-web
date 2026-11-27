# DESIGN.md — PuntoClick Studio 3D

Guía de diseño de puntoclick3d.com para personas y agentes de IA. Antes de cambiar la página, léela y respétala.

## Idea central
Taller de impresión 3D en Punto Fijo. La página debe sentirse **limpia, oscura y precisa**, como una pieza recién salida de la impresora. Un solo elemento llamativo: el efecto **"capas de impresión"** en los titulares grandes. Todo lo demás, tranquilo.

## Colores
| Token | Hex | Uso |
|---|---|---|
| bg | #06080d | Fondo de toda la página |
| surface | #0c1018 | Paneles (buscador, servicio técnico) |
| line | #1b2230 | Divisores finos |
| line-2 | #283246 | Bordes de botones y paneles |
| text | #eef2f8 | Texto principal |
| muted | #8e98ab | Texto secundario |
| blue | #2f8cff | Marca, botón Buscar, números de pasos |
| blue-2 | #7cc0ff | Precios, enlaces |
| wa | #22b45e | Solo botones de WhatsApp |
| gamer | #b65cff | Solo el letrero TU_GAMERTAG |

## Tipografía
- **Unbounded** 600/800: solo titulares (h1, h2), precios y nombres de la cinta de clientes.
- **Figtree** 400–700: todo lo demás.
- Títulos en oración normal, nunca en MAYÚSCULAS. Nada de etiquetas pequeñas encima de los títulos.

## Efecto capas (sello de la marca)
Franjas horizontales de 3 px alternando #7cc0ff y #2f8cff, recortadas al texto, con un brillo azul suave. Clase `.layers`. Se usa **solo** en el h1 del hero y en "¿Lo imprimimos?" del cierre. El h1 se "imprime" de abajo hacia arriba al cargar (una sola animación).

## Estructura de la página (en orden)
1. Header: logo, menú (en celular, botón "Menú"), botón Cotizar.
2. Hero: titular + buscador de MakerWorld (con las 10 categorías visibles sin deslizar) + botones.
3. Cinta de clientes en movimiento.
4. Productos: 4 fotos grandes con nombre, frase y precio. Debajo, una línea de "También a medida".
5. Trabajos: 8 fotos cuadradas, se amplían al tocar.
6. Gamer: lista de precios en filas + letrero TU_GAMERTAG.
7. Próximamente: recargas, entretenimiento, licencias, suscripciones (borde punteado).
8. Páginas web: 3 demos con captura.
9. Cómo trabajamos: 4 pasos numerados + envíos, pagos, mayor.
10. Servicio técnico (un solo panel).
11. Cierre "¿Lo imprimimos?" + footer.

## Reglas
- Separar secciones con espacio, no con cajas. Pocas tarjetas, pocos bordes.
- Máximo 4 elementos por fila en PC, 2 en tablet y 1–2 en celular.
- Números solo donde hay una secuencia real (los pasos).
- Todo botón de compra abre WhatsApp: `<a class="wa" data-msg="...">`.
- Precios: solo los aprobados por el dueño (ver skill puntoclick-reels). No inventar precios.
- Fotos: solo trabajos propios. Nada de imágenes de MakerWorld, stock o Google.
- Sin `loading="lazy"` en imágenes.
- Botón flotante "Atrás/Inicio" abajo a la izquierda y WhatsApp abajo a la derecha.
- Respetar "reducir movimiento" (sin animaciones).
- Cada cambio publicado debe subir el número en `version.txt` y en `<meta name="pc-version">` (iguales), para que la página se recargue sola en los visitantes.
- Revisar con capturas a 1366 px y 390 px antes de publicar.
