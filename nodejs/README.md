# Node.js setup

Installs Node.js from official tarballs into your home directory.

What it gives you:
- Node.js 22.x in `~/node/22`
- `~/node/current` symlink to the latest installed 22.x
- `switch.sh` to switch between installed versions

Run:

```bash
./setup.sh
```

The script adds `~/node/current/bin` to your PATH in `~/.profile`.
