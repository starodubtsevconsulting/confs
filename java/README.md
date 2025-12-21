# Java setup

Installs AWS Corretto JDK tarballs into your home directory.

What it gives you:
- Java 21 in `~/java/21-aws`
- the latest Corretto JDK in `~/java/latest-aws`
- `~/java/current` symlink to the latest installed JDK

Run:

```bash
./setup.sh
```

The script adds `~/java/current/bin` to your PATH in `~/.profile`.
