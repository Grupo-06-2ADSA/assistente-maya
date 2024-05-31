echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10)Olá, eu sou a Maya, sua assistente virtual e vou te ajudar a iniciar nosso aplicativo!!"
sleep 2

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10)Primeiro vou atualizar o seu sistema!"
sleep 2

sudo apt update
sudo apt upgrade

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Agora irei instalar o docker e para poder rodar nossas aplicações no contêiner"
sleep 2

sudo apt update
sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Adicionar chave GPG e repositório Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualizar e instalar Docker
sudo apt update
sudo apt install docker-ce -y

# Verificar instalação e adicionar usuário ao grupo Docker
echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Adicionando o docker ao grupo sudo..."

sudo systemctl status docker
sudo usermod -aG docker ${USER}

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Instalando o docker-compose..."

sudo apt-get update
sudo apt-get install -y curl

sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version

IMAGE_DB="helosalgado/atividadeso:v1"
IMAGE_APP="helosalgado/atividadeso:app"

# Baixa as imagens do Docker Hub, caso não estejam no sistema
docker pull ${IMAGE_DB}
docker pull ${IMAGE_APP}

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Imagens baixadas com sucesso."
sleep 2

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Criando o arquivo docker-compose.yml, ao final, clique Ctrl + C para terminar a criação do arquivo"
# Cria o arquivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.3'
services:
  bd:
    container_name: bd-mindcore
    build: .
    image: ${IMAGE_DB}
    restart: always
    ports:
      - "3307:3306"

  java_app:
    container_name: javaApp
    build: .
    image: ${IMAGE_APP}
    restart: always
    ports:
      - "8080:8080"
    depends_on:
      - bd

volumes:
  mysql_data:
EOL

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker-compose.yml Criado"
sleep 2

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Reinicie sua VM para iniciar o docker-compose com as imagens"
