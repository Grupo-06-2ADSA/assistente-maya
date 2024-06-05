readonly USERNAME=mindcore
readonly PASSWORD=mindcore123grupo6
readonly DATABASE=MindCore

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
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker não instalado"
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

        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Adicionando o docker ao grupo sudo..."
        sudo systemctl status docker
        sudo usermod -aG docker ${USER}
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

        sudo apt-get update
        sudo apt-get install -y curl

        sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sleep 2
fi

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Criando o arquivo docker-compose.yml, ao final, clique Ctrl + C para terminar a criação do arquivo"
sleep 2

# Cria o arquivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.3'
services:
  bd:
    container_name: bd-mindcore
    build: .
    image: helosalgado/atividadeso:v1
    restart: always
    ports:
      - "3307:3306"

  java_app:
    container_name: javaApp
    build: .
    image: helosalgado/atividadeso:app
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

sudo docker-compose up -d

#docker start bd-mindcore > /dev/null

#LOGIN=0
#touch docker.env
#while [ "$LOGIN" -eq 0 ]; do
#echo "Digite o email"
#read email

#echo "Digite a senha"
#read senha

#query=$(sudo docker exec -it bd-mindcore bash -c "MYSQL_PWD="$PASSWORD" mysql --batch -u root -D "$DATABASE" -e 'SELECT idFunc, email, senha FROM Funcionario where email = \"$email\" AND senha = \"$senha\" LIMIT 1;'")

#if [ -z "$query" ]; then
#echo "Usuário não encontrados"

#else

#echo "Login efetuado com sucesso"
#LOGIN=1
#sleep 3
