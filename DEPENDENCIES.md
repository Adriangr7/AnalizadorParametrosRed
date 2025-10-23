Dependencias del sistema (Linux, Debian/Ubuntu):

- bash (shell)
- dig (paquete: dnsutils)
- ping6 (paquete: iputils-ping o iputils)
- awk, sed, grep, tail, head (herramientas coreutils / util-linux)
- sudo

Instalación (Debian/Ubuntu):
sudo apt update
sudo apt install -y dnsutils iputils-ping

Nota: En algunas distros ping6 viene con iputils o inetutils. Asegúrate de que ping6 y dig funcionen en tu sistema.
