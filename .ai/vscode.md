# VS Code (home install)

Purpose: install Visual Studio Code into the home folder with a single version.

Command:
```bash
./vscode/setup.sh
```

Install layout:
- `~/vscode` contains the VS Code files (single version)
- `~/.local/bin/code` launcher symlink
- Desktop entry: `~/.local/share/applications/code.desktop`
- Desktop shortcut: `~/Desktop/Visual Studio Code.desktop` (symlink)

Behavior:
- If a system-wide VS Code is detected (apt or snap), the script asks to remove it first.
- Fixes `chrome-sandbox` permissions via sudo (required on Linux).
- Installs default extensions from `vscode/extensions.txt`.
- Prints the module README at the end.

Usage:
- Launch from terminal: `code` (or `~/vscode/bin/code`)
- Reinstall/update: rerun `./vscode/setup.sh`

Notes:
- No multi-version support for VS Code; single install is intentional.
