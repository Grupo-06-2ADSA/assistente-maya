create database Individual;
use Individual;

create table LeituraJanelas(
idColeta int primary key auto_increment,
idJanela int,
pid int,
titulo varchar(200),
totalJanelas int,
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP
);

select * from leituraJanelas;






