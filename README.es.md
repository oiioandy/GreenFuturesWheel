# Green Futures Wheel

**Idiomas:** [English](README.md) · [中文](README.zh-TW.md) · [ไทย](README.th.md) · [العربية](README.ar.md) · [Français](README.fr.md) · [Русский](README.ru.md) · **Español**

Una herramienta gratuita de una sola página para dirigir talleres de **Rueda de Futuros** (Futures Wheel, Glenn, 1971) — un grupo de personas puede construir una rueda juntos, en vivo, cada uno en su propio idioma, en el dispositivo que tenga a mano. Sin instalación, sin cuenta, sin paso de compilación.

> **Este es un trabajo en curso**, no un producto terminado — sigue cambiando conforme se usa en talleres reales. Si algo no está claro, no funciona o podría mejorarse, no dudes en [abrir un issue](https://github.com/oiioandy/GreenFuturesWheel/issues) o iniciar una discusión. Cualquier sugerencia es sinceramente bienvenida y muy apreciada.

## Lo más destacado

- **Un solo archivo HTML.** Sin instalación de npm, sin paso de compilación. Ábrelo o sírvelo — eso es todo.
- **Edición multiusuario en tiempo real.** Todos los conectados a la misma sala ven cada cambio al instante (impulsado por Yjs).
- **Idioma de la interfaz intercambiable.** Chino, inglés, tailandés, árabe, francés, ruso y español — elige en el desplegable, sin recargar. La elección de cada persona es suya; nunca cambia lo que ven los demás.
- **Traducción de visualización personal.** Por separado, puedes traducir automáticamente *tu propia vista* del texto de otras personas al idioma que elijas, sin tocar el contenido compartido que todos ven.
- **Asistencia opcional de GenAI.** Pide a Gemini, ChatGPT, Claude, Grok o a un modelo local de LM Studio unas cuantas sugerencias para el siguiente anillo. Son solo puntos de partida para la discusión — nunca se aceptan automáticamente, siempre se pueden editar o eliminar.
- **Exportación.** La rueda completa o una sola rama, directamente a un archivo de PowerPoint editable, más exportación de imagen PNG e importación/exportación JSON.
- **Modo de clase.** Un solo equipo del instructor puede servir la página a todos los dispositivos en el mismo Wi-Fi — la parte de red local no necesita internet.

## Inicio rápido

**Opción A — simplemente ábrelo (un solo usuario).**
Haz doble clic en `index.html`. Funciona bien en solitario, pero la colaboración en tiempo real no puede funcionar sobre `file://`: los navegadores bloquean la conexión WebSocket que necesita la coedición en vivo.

**Opción B — ejecuta un servidor local (necesario para colaborar).**
- Windows: haz doble clic en `Startup.bat`. Inicia un pequeño servidor HTTP integrado, copia un enlace compartible a tu portapapeles y lo abre en tu navegador.
- Cualquier sistema con Node.js instalado: ejecuta `npx serve .` en esta carpeta, luego abre la URL impresa.

En cualquier caso, abre la misma URL — con el mismo `?room=XXXX` — en cada dispositivo que deba compartir una rueda.

## Cómo dirigir un taller / sesión de clase

1. (Opcional) Edita `workshop-room.txt` con un número de sala de 4 dígitos de tu elección. Por defecto es `2026`.
2. En el equipo del instructor, ejecuta `Startup.bat`.
3. Comparte la URL de red local que imprime (algo como `http://192.168.x.x:3456/?room=XXXX`) con todos en el mismo Wi-Fi.
4. Deja esa ventana de consola abierta durante toda la sesión — cerrarla desconecta a todos del servidor.

## Cosas a tener en cuenta

- **Las salas compartidas son públicas por defecto.** Sin una clave configurada, esta aplicación se conecta a servidores de retransmisión públicos y gratuitos (`demos.yjs.dev` y un relé alojado en Glitch) para sincronizar las salas. Cualquiera que conozca o adivine tu número de sala de 4 dígitos puede unirse y editarla — no hay contraseña. No pongas en una sala compartida nada que no quisieras que un desconocido viera o cambiara. Para una sesión cerrada, ejecuta tu propio relé con `start-collab-server.ps1` (o `.cmd`) — escucha en `ws://localhost:4455` y solo funciona para personas en tu red local.
- **`file://` desactiva la colaboración.** Abrir `index.html` con doble clic desactiva por completo la sincronización en tiempo real. Usa un servidor local (ver Inicio rápido) siempre que más de una persona necesite editar junta.
- **Las claves de GenAI nunca salen de tu navegador.** Si añades una clave de API para Gemini, ChatGPT, Claude o Grok, se almacena solo en el `localStorage` de ese navegador y se envía solo a la API de ese proveedor — nunca a ningún servidor gestionado por este proyecto. LM Studio no necesita ninguna clave; simplemente activa "Enable CORS" en la configuración del propio servidor de LM Studio, y todo permanece en tu equipo.
- **La mayor parte de la aplicación funciona completamente sin conexión.** La rueda principal — dibujo, edición, disposición, colores, formas — está incluida localmente (vis-network viene en `vendor/`) y no necesita conexión a internet. Solo unas pocas funciones opcionales se conectan a internet: colaboración en tiempo real, traducción de visualización personal (la API gratuita de MyMemory), sugerencias de GenAI y exportación a PowerPoint.
- **La rueda por defecto es una plantilla inicial en blanco, no un ejemplo terminado.** "Core Topic", "Direct Impact 1–3" y un marcador de posición para un impacto indirecto/en cadena están todos pensados para que los sobrescribas — son pistas, no contenido real, hasta que los edites.

## Archivos de un vistazo

| Archivo | Propósito |
| --- | --- |
| `index.html` | La aplicación entera. |
| `vendor/` | Biblioteca vis-network incluida (para que la aplicación funcione sin conexión). |
| `Startup.bat` / `workshop-server.ps1` | Servidor web local de un clic para uso en clase/taller. |
| `workshop-room.txt` | El número de sala de 4 dígitos que usa `Startup.bat`. |
| `start-collab-server.ps1` / `.cmd` | Opcional: ejecuta tu propio relé de colaboración local en lugar de los servidores de demostración públicos. |
| `bump-version.ps1` | Herramienta de mantenimiento: incrementa el número de versión que se muestra en la aplicación. |

## Uso y difusión

Eres libre de usar, adaptar y redistribuir esta herramienta —incluso transformarla en algo completamente propio, para uso personal, educativo o comercial— bajo la Licencia MIT. La única condición: mantener un crédito al autor original y un enlace de vuelta a este repositorio.

**Línea de crédito sugerida:**
> Green Futures Wheel by An-Ting Kuo — https://github.com/oiioandy/GreenFuturesWheel

Para una cita formal (APA, BibTeX, etc.), usa el botón **"Cite this repository"** en la página de GitHub, o consulta [`CITATION.cff`](CITATION.cff).

## Licencia

MIT — ver [`LICENSE`](LICENSE). Los componentes de terceros están listados en [`NOTICE`](NOTICE).
