package Main;

import Entidades.Computador;
import Entidades.MemoriaRam;
import Entidades.SistemaOperacional;
import Entidades.Usuario;
import Models.*;
import com.github.britooo.looca.api.core.Looca;
import com.github.britooo.looca.api.group.discos.Disco;
import com.github.britooo.looca.api.group.discos.DiscoGrupo;
import com.github.britooo.looca.api.group.janelas.Janela;
import com.github.britooo.looca.api.group.janelas.JanelaGrupo;
import com.github.britooo.looca.api.group.memoria.Memoria;
import com.github.britooo.looca.api.group.processador.Processador;
import com.github.britooo.looca.api.group.processos.ProcessoGrupo;
import com.github.britooo.looca.api.group.rede.Rede;
import com.github.britooo.looca.api.group.sistema.Sistema;

import java.time.LocalTime;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class App {
    public static void main(String[] args) {
        System.out.println("""
                Seja Bem Vindo(a) a
                
                **      **  **  **   **  *******         ********  **********  *********    *********
                ** **** **  **  ***  **  **     **      **         **      **  **      **   **
                **  **  **  **  ** * **  **      **    **          **      **  *********    *****
                **      **  **  **  ***  **     **      **         **      **  **   **      **
                **      **  **  **   **  *******         ********  **********  **     **    *********
                
                """);

        Usuario.FazerLogin();
    }

    public static void CapturarDados(){
        Looca looca = new Looca();
//        ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);

//        Runnable task = () -> {
        Sistema sistema = looca.getSistema();
        Memoria memoria = looca.getMemoria();
        DiscoGrupo disco = looca.getGrupoDeDiscos();
        Processador processador = looca.getProcessador();
        Rede rede = looca.getRede();
        ProcessoGrupo grupoDeProcessos = looca.getGrupoDeProcessos  ();
        JanelaGrupo grupoDeJanelas = looca.getGrupoDeJanelas();

        // Sistemas Operacional
        String nomeSO = sistema.getSistemaOperacional();
        Long tempoAtivdadeSO = sistema.getTempoDeAtividade() / 3600; // em horas
            System.out.println("------ Sistema Operacional ------");
            System.out.println("Nome: " + nomeSO);
            System.out.println("Tempo de atividade: " + tempoAtivdadeSO);


        // Memória RAM
        Double memoriaUso = Double.valueOf(memoria.getEmUso()) / 1e+9;
        memoriaUso = Math.round(memoriaUso * 20.0) / 20.0;
        Double memoriaDisponivel = Double.valueOf(memoria.getDisponivel()) / 1e+9;
        memoriaDisponivel = Math.round(memoriaDisponivel * 20.0) / 20.0;
        Double memoriaTotal = Double.valueOf(memoria.getTotal()) / 1e+9;
        memoriaTotal = Math.round(memoriaTotal * 20.0) / 20.0;
            System.out.println("------ Mémoria RAM ------");
            System.out.println("Mémoria em uso: " + memoriaUso);
            System.out.println("Mémoria disponível: " + memoriaDisponivel);
            System.out.println("Mémoria total: " + memoriaTotal);

        // Disco
        List<Disco> discos = disco.getDiscos();
        Double tamanho = 0.0;
        Double leituras = 0.0;
        Double bytesLeitura = 0.0;
        Double escritas = 0.0;
        Double bytesEscrita = 0.0;
        Long tempoTranferencia = 0l;
            System.out.println("------ Disco ------");

        for (Disco disco1 : discos) {
            tamanho = disco1.getTamanho() / 1e+9;
            leituras = Double.valueOf(disco1.getLeituras());
            bytesLeitura = Double.valueOf(disco1.getBytesDeLeitura());
            escritas = Double.valueOf(disco1.getEscritas());
            bytesEscrita = Double.valueOf(disco1.getBytesDeEscritas());
            tempoTranferencia = disco1.getTempoDeTransferencia();

            System.out.println("Tamanha: " + tamanho);
            System.out.println("Leituras: " + leituras);
            System.out.println("Bytes de leitura: " + bytesLeitura);
            System.out.println("Escritas: " + escritas);
            System.out.println("Bytes de escrita: " + bytesEscrita);
            System.out.println("Tempo de transferência: " + tempoTranferencia);
        }


        // CPU
        String nomeCpu = processador.getNome();
        Double usoCPU = processador.getUso();
            System.out.println("------ CPU ------");
            System.out.println("Nome: " + nomeCpu);
            System.out.println("Uso: " + usoCPU);

        List<Janela> janela1 = grupoDeJanelas.getJanelas();
        Integer totalJanelas = grupoDeJanelas.getTotalJanelas();
        System.out.println("------ Janelas ------");
        System.out.println("Total de janelas: " + totalJanelas);

        for (Janela janela : janela1) {
            System.out.println("Título: " + janela.getTitulo());
            System.out.println("Pid: " + janela.getPid());
        }

//        Computador computador = new Computador(hostName, ipv4);
//        SistemaOperacional sistemaOperacional = new SistemaOperacional(nomeSO, tempoAtivdadeSO);
//        Entidades.Disco disco00 = new Entidades.Disco(tamanho, leituras, bytesLeitura, escritas, bytesEscrita, tempoTranferencia);
//        MemoriaRam memoriaRam = new MemoriaRam(memoriaUso, memoriaDisponivel, memoriaTotal);
//        Entidades.Rede rede00 = new Entidades.Rede(nomeRede, bytesRecebidos, bytesEnviados, pacotesRecebidos, pacotesEnviados);
//        Entidades.Processador cpu = new Entidades.Processador(nomeCpu, usoCPU);

//        ComputadorDAO.cadastrarComputador(computador);
//        SistemaOperacionalDAO.cadastrarSO(sistemaOperacional);
//        DiscoDAO.cadastrarDisco(disco00);
//        MemoriaRamDAO.cadastrarRAM(memoriaRam);
//        RedeDAO.cadastrarRede(rede00);
//        ProcessadorDAO.cadastrarCPU(cpu);
//        };

//        executor.scheduleAtFixedRate(task, 0, 10, TimeUnit.SECONDS);

        LocalTime horaAtual = LocalTime.now();

//        if (horaAtual.getHour() == 17){
//            executor.shutdown();
//        }

    }
}
