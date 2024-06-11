# Atualizar a lista de pacotes
sudo apt update

# Instalar o Python 3 e o gerenciador de pacotes pip
sudo apt install -y python3 python3-pip

# Criar um script Python
cat << 'EOF' > load_test.py
import threading
import time
import os

def cpu_load():
    """Função para sobrecarregar a CPU"""
    while True:
        _ = [x ** 2 for x in range(10000)]

def disk_load(file_path):
    """Função para sobrecarregar o disco"""
    while True:
        with open(file_path, 'w') as f:
            f.write('0' * 1024 * 1024)  # Escreve 1MB de dados
        with open(file_path, 'r') as f:
            f.read()

def memory_load():
    """Função para sobrecarregar a memória"""
    data = []
    while True:
        data.append(' ' * 1024 * 1024)  # Aloca 1MB de memória

if __name__ == "__main__":
    # Define o caminho do arquivo para teste de disco
    file_path = "disk_test_file"
    
    # Cria threads para CPU, disco e memória
    threads = [
        threading.Thread(target=cpu_load),
        threading.Thread(target=disk_load, args=(file_path,)),
        threading.Thread(target=memory_load)
    ]

    # Inicia as threads
    for thread in threads:
        thread.start()
    
    # Mantém o script em execução
    while True:
        time.sleep(1)
EOF

# Executar o script Python
python3 load_test.py
