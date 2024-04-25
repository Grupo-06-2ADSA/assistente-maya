#!/bin/bash

echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Olá, te ajudarei a instalar nossa aplicação!"
sleep 2

echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Primeiro irei atualizar os pacotes do seu sistema."
sleep 2

sudo apt update && sudo apt upgrade -y

echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0) $(tput setaf 10)Irei verificar se você já tem o Java."
sleep 2

java --version

if [ $? = 0 ]; 
	then 
	echo java instalado
else 
	echo java não instalado 

  echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0) $(tput setaf 10)Instalando java..."

	  sudo apt install openjdk-17-jre -y

  echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0) $(tput setaf 10)java instalado com sucesso"
fi 

  
  echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Irei iniciar a instalação do nosso aplicativo"
   sleep 2
	

 if [ -d "aplicacao" ]
        then
            echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)A pasta 'Aplicação' está ok, indo até ela"
			      sleep 2

        cd aplicacao

        chmod 777 login-mind-core-1.0-SNAPSHOT-jar-with-dependencies.jar
        sleep 2

        echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Aplicação concluida!! obrigado por instalar a nossa aplicação!"
        sleep 2

        echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Você quer executar a aplicação agora? (Y/n)"
        read execMindCore
        if [ "$execMindCore" == "Y" ]
        then
            echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Iniciando a aplicação... Até logo!"
            sleep 2
            java -jar login-mind-core-1.0-SNAPSHOT-jar-with-dependencies.jar
		else
            echo "$(tput setaf 5)[Instalador MindCore]: $(tput sgr0)$(tput setaf 10)Você pode iniciar a aplicação quando desejar! Até logo!"
            sleep 2
            exit 0
		fi
  fi
fi
