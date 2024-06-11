readonly SQL_SERVER_HOST="3.225.222.139"
readonly SQL_SERVER_PORT="1433"
readonly SQL_SERVER_USER="sa"
readonly SQL_SERVER_PASSWORD="mindcore123"
readonly SQL_SERVER_DATABASE="MindCore"

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



echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Estou verificando se você possui o docker-compose"

docker-compose --version
if [ $? = 0 ]
then
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Possui Docker-compose instalado."
        sleep 2
else
        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Não possui o Docker-compose instalado"
        sleep 2

        sudo apt-get update
        sudo apt-get install -y curl

        sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sleep 2

        echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Agora irei criar o arquivo docker-compose.yml, ao final, clique Ctrl + C para terminar a criação do arquivo"
        sleep 2
fi

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Digite o hostname da máquina: "
read -r hostname

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
    environment:
      FK_EMPRESA: ${FK_EMPRESA}
      EMAIL_USUARIO: ${EMAIL_USUARIO}
    hostname: ${hostname}

volumes:
  mysql_data:
EOL

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Docker-compose.yml Criado"
sleep 2

echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Iniciando aplicação..."
sleep 2

docker-compose up -d bd


# Função para executar consulta no banco de dados
executar_consulta() {
    local email="$1"
    local senha="$2"

    local FK_EMPRESA
    local EMAIL_USUARIO

    FK_EMPRESA=$(sqlcmd -S $SQL_SERVER_HOST,$SQL_SERVER_PORT -U $SQL_SERVER_USER -P $SQL_SERVER_PASSWORD -d $SQL_SERVER_DATABASE -h -1 -Q "SET NOCOUNT ON; SELECT fkEmpresa FROM Funcionario WHERE email = '$email' AND senha = '$senha';" | tail -n 1)
    EMAIL_USUARIO=$(sqlcmd -S $SQL_SERVER_HOST,$SQL_SERVER_PORT -U $SQL_SERVER_USER -P $SQL_SERVER_PASSWORD -d $SQL_SERVER_DATABASE -h -1 -Q "SET NOCOUNT ON; SELECT email FROM Funcionario WHERE email = '$email' AND senha = '$senha';" | tail -n 1)

    echo "$FK_EMPRESA, $EMAIL_USUARIO"
}

# Função para verificar se a consulta retornou resultado
verificar_resultado() {
  local query_result="$1"
  
    if [ -z "$query_result" ]; then
        echo "Usuário não encontrado"
        return 1
    else
        echo "Login efetuado com sucesso"
        return 0
    fi
}

main(){
  while true; do
      echo "
          ███╗   ███╗██╗███╗   ██╗██████╗      ██████╗ ██████╗ ██████╗ ███████╗
          ████╗ ████║██║████╗  ██║██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
          ██╔████╔██║██║██╔██╗ ██║██║  ██║    ██║     ██║   ██║██████╔╝█████╗ 
          ██║╚██╔╝██║██║██║╚██╗██║██║  ██║    ██║     ██║   ██║██╔══██╗██╔══╝ 
          ██║ ╚═╝ ██║██║██║ ╚████║██████╔╝    ╚██████╗╚██████╔╝██║  ██║███████╗
          ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
      "
      echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Digite o email: "
      read -r email

      echo "$(tput setaf 5)[Assistente Maya]: $(tput sgr0) $(tput setaf 10) Digite a senha: "
      read -r senha

      sleep 2

      local query_result
        query_result=$(executar_consulta "$email" "$senha")
        FK_EMPRESA=$(echo $query_result | cut -d',' -f1)
        EMAIL_USUARIO=$(echo $query_result | cut -d',' -f2)

        if verificar_resultado "$query_result"; then
            java --version > /dev/null || sudo apt install openjdk-17-jre -y

            export FK_EMPRESA
            export EMAIL_USUARIO

            # Iniciar o contêiner JavaApp com a variável de ambiente definida
            docker compose up -d java_app

            break
        else
            echo "Falha no login. Por favor, tente novamente."
        fi
  done
}

main
