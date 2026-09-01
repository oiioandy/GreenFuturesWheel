# Green Futures Wheel

A free, single-page tool for running **Futures Wheel** workshops (Glenn, 1971) — a group of people can build one wheel together, live, each in their own language, on whatever device they have. No installation, no account, no build step.

## Highlights

- **One HTML file.** No npm install, no build step. Open it or serve it — that's it.
- **Real-time multi-user editing.** Everyone connected to the same room sees every change instantly (powered by Yjs).
- **Switchable interface language.** Chinese, English, Thai, Arabic, French, Russian, and Spanish — pick from the dropdown, no reload. Each person's choice is their own; it never changes what others see.
- **Personal display translation.** Separately, you can machine-translate *your own view* of other people's text into a language of your choice, without touching the shared content everyone else sees.
- **Optional GenAI assist.** Ask Gemini, ChatGPT, Claude, Grok, or a local LM Studio model for a few next-ring suggestions. They're only starting points for discussion — never auto-accepted, always editable or removable.
- **Export.** Whole wheel or a single branch, straight to an editable PowerPoint file, plus PNG image export and JSON import/export.
- **Classroom mode.** One instructor machine can serve the page to every device on the same Wi-Fi — no internet required for the LAN part.

## Quick start

**Option A — just open it (single user).**
Double-click `index.html`. This works fine alone, but real-time collaboration cannot work over `file://`: browsers block the WebSocket connection that live co-editing needs.

**Option B — run a local server (needed for collaboration).**
- Windows: double-click `Startup.bat`. It starts a small built-in HTTP server, copies a shareable link to your clipboard, and opens it in your browser.
- Any OS with Node.js installed: run `npx serve .` in this folder, then open the printed URL.

Either way, open the same URL — with the same `?room=XXXX` — on every device that should share one wheel.

## Running a workshop / classroom session

1. (Optional) Edit `workshop-room.txt` to a 4-digit room number of your choice. It defaults to `2026`.
2. On the instructor's machine, run `Startup.bat`.
3. Share the LAN URL it prints (something like `http://192.168.x.x:3456/?room=XXXX`) with everyone on the same Wi-Fi.
4. Leave that console window open for the whole session — closing it stops the server for everyone.

## Things to watch out for

- **Shared rooms are public by default.** With no key set up, this app connects to free public relay servers (`demos.yjs.dev` and a Glitch-hosted relay) to sync rooms. Anyone who knows or guesses your 4-digit room number can join and edit it — there is no password. Don't put anything into a shared room that you wouldn't want a stranger to see or change. For a closed session, run your own relay with `start-collab-server.ps1` (or `.cmd`) — it listens on `ws://localhost:4455` and only works for people on your local network.
- **`file://` disables collaboration.** Opening `index.html` by double-clicking it turns off real-time sync entirely. Use a local server (see Quick start) whenever more than one person needs to edit together.
- **GenAI keys never leave your browser.** If you add an API key for Gemini, ChatGPT, Claude, or Grok, it's stored only in that browser's `localStorage` and sent only to that provider's own API — never to any server run by this project. LM Studio needs no key at all; just turn on "Enable CORS" in LM Studio's own server settings, and everything stays on your machine.
- **Most of the app works fully offline.** The core wheel — drawing, editing, layout, colors, shapes — is bundled locally (vis-network ships in `vendor/`) and needs no internet connection. Only a few optional features reach out to the internet: live collaboration, personal-display translation (MyMemory's free API), GenAI suggestions, and PowerPoint export.
- **The default wheel is a blank starting template, not a finished example.** "Core Topic," "Direct Impact 1–3," and one Indirect/Chain Impact placeholder are all meant to be typed over — they're hints, not real content, until you edit them.

## Files at a glance

| File | Purpose |
| --- | --- |
| `index.html` | The entire app. |
| `vendor/` | Bundled vis-network library (so the app can run offline). |
| `Startup.bat` / `workshop-server.ps1` | One-click local web server for classroom/workshop use. |
| `workshop-room.txt` | The 4-digit room number `Startup.bat` uses. |
| `start-collab-server.ps1` / `.cmd` | Optional: run your own local collaboration relay instead of the public demo servers. |
| `bump-version.ps1` | Maintainer tool: bumps the version string shown in the app. |

## License

MIT — see [`LICENSE`](LICENSE). Third-party components are listed in [`NOTICE`](NOTICE).
