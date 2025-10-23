# Medidor de parámetros de red (IPv6) — Script Bash

Herramienta para automatizar la medición de distintos parámetros de red (resolución DNS IPv6, latencia y pérdida de paquetes) desarrollada como parte del Trabajo Fin de Grado.

## Requisitos
- Sistema Linux con IPv6 habilitado
- `dig` (dnsutils)
- `ping6` (iputils-ping)
- `bash`, `awk`, `sed`, `grep`, `tail`, `head`
- Ejecutar con permisos para modificar `/etc/resolv.conf` (se usa `sudo`)

Instalación (Debian/Ubuntu):
```bash
sudo apt update
sudo apt install -y dnsutils iputils-ping
