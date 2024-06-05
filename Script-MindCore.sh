readonly USERNAME=root
readonly PASSWORD=mindcore123grupo6
readonly DATABASE=bd-mindcore

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10)Olá, eu sou a Maya, sua assistente virtual e vou te ajudar a iniciar nosso aplicativo!!"
sleep 2

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10)Primeiro vou atualizar o seu sistema!"
sleep 2

sudo apt update
sudo apt upgrade

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Agora verificar se você tem o docker"
sleep 2

docker --version

if [ $? = 0 ]
then
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker Instalado"
        sleep 2
else
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker Instalado"
        sleep 2

        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update -y

        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl start docker
        sudo systemctl enable Docker
        sudo usermod -aG docker ubuntu
fi



echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Verificando se você possui o docker-compose"

docker-compose --version
if [ $? = 0 ]
then
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker-compose instalado."
        sleep 2
else
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Não possui o docker-compose instalado"
        sleep 2

        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
fi




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

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Iniciando aplicação..."
sleep 2

sudo docker-compose up

docker start bd-mindcore > /dev/null

LOGIN=0
touch docker.env
while [ "$LOGIN" -eq 0 ]; do
echo "Digite o email"
read email

echo "Digite a senha"
read senha

query=$(sudo docker exec -it bd-mindcore bash -c "MYSQL_PWD="$PASSWORD" mysql --batch -u root -D "$DATABASE" -e 'SELECT idUsuario, email, senha FROM usuario where email = \"$email\" AND senha = \"$senha\" LIMIT 1;'")

if [ -z "$query" ]; then
echo "Usuário não encontrados"

else

echo "Login efetuado com sucesso"
LOGIN=1
sleep 3
