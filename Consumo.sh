# Atualizar a lista de pacotes
sudo apt update

# Instalar o OpenJDK
sudo apt install -y openjdk-11-jdk

# Verificar a instalação do Java
java -version

# Criar o arquivo Java
cat << 'EOF' > LoadTest.java
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class LoadTest {

    public static void main(String[] args) {
        // Define o caminho do arquivo para teste de disco
        String filePath = "disk_test_file";

        // Limite de memória em MB
        int memoryLimitMB = 5000; // 3GB

        // Limite de disco em MB
        int diskLimitMB = 3000; // 3GB

        // Cria e inicia threads para CPU, disco e memória
        new Thread(new CpuLoad()).start();
        new Thread(new DiskLoad(filePath, diskLimitMB)).start();
        new Thread(new MemoryLoad(memoryLimitMB)).start();
    }

    static class CpuLoad implements Runnable {
        public void run() {
            while (true) {
                double x = 0;
                for (int i = 0; i < 10000; i++) {
                    x += Math.pow(i, 2);
                }
            }
        }
    }

    static class DiskLoad implements Runnable {
        private final String filePath;
        private final int diskLimitMB;

        DiskLoad(String filePath, int diskLimitMB) {
            this.filePath = filePath;
            this.diskLimitMB = diskLimitMB;
        }

        public void run() {
            while (true) {
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                    for (int i = 0; i < diskLimitMB * 1024; i++) { // Escreve 1MB por iteração
                        writer.write(new char[1024 * 1024]);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

                try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
                    while (reader.read() != -1) {
                        // Simula a leitura do arquivo
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    static class MemoryLoad implements Runnable {
        private final int memoryLimitMB;

        MemoryLoad(int memoryLimitMB) {
            this.memoryLimitMB = memoryLimitMB;
        }

        public void run() {
            List<byte[]> memoryConsumers = new ArrayList<>();
            while (true) {
                if (memoryConsumers.size() * 1024 * 1024 >= memoryLimitMB * 1024 * 1024) {
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else {
                    memoryConsumers.add(new byte[1024 * 1024]); // Aloca 1MB de memória
                }
            }
        }
    }
}
EOF

# Compilar o arquivo Java
javac LoadTest.java

# Executar o programa Java
java LoadTest
