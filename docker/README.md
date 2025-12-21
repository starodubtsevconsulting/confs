# Docker setup

Installs Docker Engine and the Compose plugin on Ubuntu using the official
Docker repo.

What it gives you:
- docker engine (daemon + CLI)
- docker compose plugin
- docker group access for the current user

Run:

```bash
./setup.sh
```

After install, log out/in (or run `newgrp docker`) to use Docker without sudo.
If you previously had the Ubuntu `docker.io` package installed, this setup
will remove it to avoid conflicts.
