#!/bin/sh

set -o errexit
set -o nounset
IFS=$(printf '\n\t')

# Docker
apt install sudo -y && apt install curl -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
printf '\nDocker instalado correctamente\n\n'

printf 'Esperando a que se inicie Docker...\n\n'
sleep 5

# Docker Compose
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
printf '\nDocker Compose instalado correctamente...\n\n'
sudo docker-compose -v
sleep 5

# Add local user to group Docker
sudo usermod -aG docker pi
printf '\nUsuario local metido al grupo...\n\n'
sleep 5

# Enable systemctl docker
sudo systemctl enable docker
printf '\nDocker habilitado en el arranque del sistema...\n\n'
sleep 5

# Portainer
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

printf '\nPortainer desplegado e iniciado. Reiniciando el sistema en 10" \n\n'
sleep 10
# Reboot
sudo reboot now
