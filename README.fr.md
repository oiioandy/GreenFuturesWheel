# Green Futures Wheel

**Langues :** [English](README.md) · [中文](README.zh-TW.md) · [ไทย](README.th.md) · [العربية](README.ar.md) · **Français** · [Русский](README.ru.md) · [Español](README.es.md)

Un outil gratuit, en une seule page, pour animer des ateliers de **roue des futurs** (Futures Wheel, Glenn, 1971) — un groupe peut construire une roue ensemble, en direct, chacun dans sa propre langue, sur l'appareil qu'il a sous la main. Sans installation, sans compte, sans étape de build.

> **Ceci est un travail en cours**, pas un produit fini — il continue d'évoluer au fil de son usage dans de vrais ateliers. Si quelque chose n'est pas clair, ne fonctionne pas, ou pourrait être amélioré, n'hésitez pas à [ouvrir une issue](https://github.com/oiioandy/GreenFuturesWheel/issues) ou à lancer une discussion. Toute suggestion est sincèrement bienvenue et appréciée.

## Points forts

- **Un seul fichier HTML.** Pas d'installation npm, pas de build. Ouvrez-le ou servez-le — c'est tout.
- **Édition multi-utilisateur en temps réel.** Toute personne connectée à la même salle voit chaque modification instantanément (propulsé par Yjs).
- **Langue de l'interface changeable.** Chinois, anglais, thaï, arabe, français, russe et espagnol — au choix dans le menu déroulant, sans recharger la page. Le choix de chacun lui est propre ; il ne change jamais ce que voient les autres.
- **Traduction d'affichage personnelle.** Séparément, vous pouvez traduire automatiquement *votre propre vue* du texte des autres dans la langue de votre choix, sans toucher au contenu partagé que tout le monde voit.
- **Assistance GenAI optionnelle.** Demandez à Gemini, ChatGPT, Claude, Grok ou à un modèle LM Studio local quelques suggestions pour le cercle suivant. Ce ne sont que des points de départ pour la discussion — jamais acceptées automatiquement, toujours modifiables ou supprimables.
- **Export.** Toute la roue ou une seule branche, directement vers un fichier PowerPoint modifiable, plus l'export en image PNG et l'import/export JSON.
- **Mode classe.** Un seul ordinateur d'enseignant peut servir la page à tous les appareils du même Wi-Fi — la partie réseau local ne nécessite pas Internet.

## Démarrage rapide

**Option A — l'ouvrir simplement (utilisateur unique).**
Double-cliquez sur `index.html`. Cela fonctionne bien seul, mais la collaboration en temps réel ne peut pas fonctionner via `file://` : les navigateurs bloquent la connexion WebSocket nécessaire à la co-édition en direct.

**Option B — lancer un serveur local (nécessaire pour la collaboration).**
- Windows : double-cliquez sur `Startup.bat`. Il démarre un petit serveur HTTP intégré, copie un lien partageable dans votre presse-papiers et l'ouvre dans votre navigateur.
- Tout système avec Node.js installé : lancez `npx serve .` dans ce dossier, puis ouvrez l'URL affichée.

Dans les deux cas, ouvrez la même URL — avec le même `?room=XXXX` — sur chaque appareil qui doit partager une roue.

## Animer un atelier / une session de classe

1. (Facultatif) Modifiez `workshop-room.txt` avec un numéro de salle à 4 chiffres de votre choix. Par défaut : `2026`.
2. Sur l'ordinateur de l'enseignant, lancez `Startup.bat`.
3. Partagez l'URL réseau local qu'il affiche (du type `http://192.168.x.x:3456/?room=XXXX`) avec tout le monde sur le même Wi-Fi.
4. Laissez cette fenêtre de console ouverte pendant toute la session — la fermer coupe la connexion de tout le monde.

## Points de vigilance

- **Les salles partagées sont publiques par défaut.** Sans clé configurée, cette application se connecte à des serveurs relais publics gratuits (`demos.yjs.dev` et un relais hébergé sur Glitch) pour synchroniser les salles. Quiconque connaît ou devine votre numéro de salle à 4 chiffres peut la rejoindre et la modifier — il n'y a pas de mot de passe. Ne mettez dans une salle partagée rien que vous ne voudriez pas voir vu ou modifié par un inconnu. Pour une session fermée, lancez votre propre relais avec `start-collab-server.ps1` (ou `.cmd`) — il écoute sur `ws://localhost:4455` et ne fonctionne que pour les personnes sur votre réseau local.
- **`file://` désactive la collaboration.** Ouvrir `index.html` par double-clic désactive entièrement la synchronisation en temps réel. Utilisez un serveur local (voir Démarrage rapide) dès que plus d'une personne doit éditer ensemble.
- **Les clés GenAI ne quittent jamais votre navigateur.** Si vous ajoutez une clé API pour Gemini, ChatGPT, Claude ou Grok, elle est stockée uniquement dans le `localStorage` de ce navigateur et envoyée uniquement à l'API de ce fournisseur — jamais à un serveur géré par ce projet. LM Studio n'a besoin d'aucune clé ; activez simplement « Enable CORS » dans les paramètres du serveur LM Studio lui-même, et tout reste sur votre machine.
- **La majeure partie de l'application fonctionne entièrement hors ligne.** La roue principale — dessin, édition, disposition, couleurs, formes — est intégrée localement (vis-network est fourni dans `vendor/`) et ne nécessite aucune connexion Internet. Seules quelques fonctionnalités optionnelles font appel à Internet : la collaboration en temps réel, la traduction d'affichage personnelle (l'API gratuite de MyMemory), les suggestions GenAI et l'export PowerPoint.
- **La roue par défaut est un modèle de départ vide, pas un exemple terminé.** « Core Topic », « Direct Impact 1–3 », ainsi qu'un espace réservé pour un impact indirect/en chaîne, sont tous destinés à être remplacés par votre saisie — ce sont des indices, pas du vrai contenu, jusqu'à ce que vous les modifiiez.

## Aperçu des fichiers

| Fichier | Rôle |
| --- | --- |
| `index.html` | L'application entière. |
| `vendor/` | Bibliothèque vis-network intégrée (pour que l'application fonctionne hors ligne). |
| `Startup.bat` / `workshop-server.ps1` | Serveur web local en un clic pour l'usage en classe/atelier. |
| `workshop-room.txt` | Le numéro de salle à 4 chiffres utilisé par `Startup.bat`. |
| `start-collab-server.ps1` / `.cmd` | Facultatif : lancez votre propre relais de collaboration local au lieu des serveurs de démonstration publics. |
| `bump-version.ps1` | Outil de mainteneur : incrémente le numéro de version affiché dans l'application. |

## Utilisation et partage

Vous êtes libre d'utiliser, d'adapter et de redistribuer cet outil — y compris en le transformant en quelque chose qui vous appartient entièrement, pour un usage personnel, éducatif ou commercial — sous licence MIT. La seule condition : conserver un crédit envers l'auteur original et un lien vers ce dépôt.

**Mention suggérée :**
> Green Futures Wheel by An-Ting Kuo — https://github.com/oiioandy/GreenFuturesWheel

Pour une citation formelle (APA, BibTeX, etc.), utilisez le bouton **« Cite this repository »** sur la page GitHub, ou consultez [`CITATION.cff`](CITATION.cff).

## Licence

MIT — voir [`LICENSE`](LICENSE). Les composants tiers sont listés dans [`NOTICE`](NOTICE).
