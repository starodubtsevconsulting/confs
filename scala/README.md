# Scala setup

Installs Scala 3 from GitHub releases into your home directory.

What it gives you:
- Scala 3.4.1 in `~/scala/3.4.1` (version controlled via `v_matrix.json`)
- Latest Scala 3 release in `~/scala/latest` when enabled in `v_matrix.json`
- sbt 1.10.2 in `~/scala/sbt/1.10.2` with `~/scala/sbt/current` symlink
- `~/scala/current` symlink pointing at the selected version
- `~/scala/switch.sh` (or `scala-switch`) to switch between installed versions
- Optional: set `SCALA_VERSION_OVERRIDE=<version>` when running `./setup.sh` to override the matrix.

Run:

```bash
./setup.sh
```

The script adds `~/scala/current/bin` to your PATH in `~/.profile`.
Note: setup may update `~/.profile` and `~/.zshrc` for PATH defaults.
Scala requires a JDK (run `./java/setup.sh` first if needed).
