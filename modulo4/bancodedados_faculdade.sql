create database	faculdade;
use faculdade;
show tables;
CREATE table professor (
	nome_prof varchar (255) not null,
	cpf char (11) not null,	
	id_depto varchar (10) not null,
	inicio_contrato date,
	primary key (cpf)
);
CREATE table departamento (
	nome_dept varchar (255) not null,
	cpf_prof_chefe char (11) not null,	
	id_depto varchar (10) not null,
	local varchar (255),
	primary key (id_depto)
);
CREATE table disciplina (
	nome_disc varchar (255) not null,
	carga_horaria int,	
	ementa varchar (255),
	disc_pre_req varchar (255),
	primary key (nome_disc)
);

CREATE table aluno (
	nome_aluno varchar (255) not null,
	matricula char (10) not null,	
	endereco varchar (255),
	data_nascimento date,
	primary key (matricula)
);
ALTER TABLE departamento MODIFY COLUMN id_depto INT NOT NULL AUTO_INCREMENT;
ALTER TABLE disciplina MODIFY COLUMN ementa text;
ALTER TABLE disciplina MODIFY COLUMN carga_horaria int not null default 30;
ALTER TABLE professor MODIFY COLUMN id_depto INT NOT NULL;
ALTER TABLE professor
ADD CONSTRAINT fk_professor_departamento
FOREIGN KEY (id_depto) REFERENCES departamento(id_depto);

CREATE table contato_prof (
	cpf_prof char (11) not null,	
	contato varchar (14) not null,
	CONSTRAINT fk_contato_prof primary key (cpf_prof, contato),
    FOREIGN KEY (cpf_prof) REFERENCES professor(cpf));

CREATE table contato_prof (
	cpf_prof char (11) not null,	
	contato varchar (14) not null,
	CONSTRAINT fk_contato_prof primary key (cpf_prof, contato),
    FOREIGN KEY (cpf_prof) REFERENCES professor(cpf));

CREATE table avaliacao_prof (
	cpf_prof char (11) not null,
    data_hora datetime not null,
	comentario varchar (500),
    nota int, 
    
	CONSTRAINT fk_avaliacao_prof primary key (cpf_prof, data_hora),
    FOREIGN KEY (cpf_prof) REFERENCES professor(cpf));

ALTER TABLE departamento
ADD CONSTRAINT fk_prof_chefe
FOREIGN KEY (cpf_prof_chefe) REFERENCES professor(cpf); -- add foreing key

ALTER TABLE departamento MODIFY COLUMN cpf_prof_chefe char (11); -- remover notnull

ALTER TABLE disciplina
ADD FOREIGN KEY (disc_pre_req) REFERENCES disciplina(nome_disc);

-- tabelas de relacionamentos:
CREATE table aluno_disciplina (
	matricula char (10) not null,
    nome_disc varchar (255) not null,
    
	CONSTRAINT pk_aluno_disciplina primary key (matricula, nome_disc),
    FOREIGN KEY (matricula) REFERENCES aluno(matricula),
    FOREIGN KEY (nome_disc) REFERENCES disciplina(nome_disc)
);

CREATE table prof_disciplina (
	cpf_prof char (11) not null,
    nome_disc varchar (255) not null,
    
	CONSTRAINT pk_prof_disciplina primary key (cpf_prof, nome_disc),
    FOREIGN KEY (cpf_prof) REFERENCES professor(cpf),
    FOREIGN KEY (nome_disc) REFERENCES disciplina(nome_disc)
);

-- DROP TABLE pro_disciplina;

show tables;

ALTER TABLE departamento
MODIFY COLUMN cpf_prof_chefe CHAR(11) NULL;

INSERT INTO departamento (nome_dept, cpf_prof_chefe, id_depto, local) VALUES
('Departamento de Matemática', NULL, 1, 'Prédio A'),
('Departamento de Física', NULL, 2, 'Prédio B'),
('Departamento de História', NULL, 3, 'Prédio C'),
('Departamento de Biologia', NULL, 4, 'Prédio D'),
('Departamento de Química', NULL, 5, 'Prédio E');

INSERT INTO professor (nome_prof, cpf, id_depto, inicio_contrato) VALUES
('Ana Sophia Araújo', '12345678901', 1, '1972-02-29'),
('Bryan da Rosa', '23456789012', 2, '1998-05-15'),
('Emilly Almeida', '34567890123', 3, '1995-11-09'),
('João Gabriel Monteiro', '45678901234', 4, '2000-08-23'),
('Evelyn Moreira', '56789012345', 5, '1976-11-15');

UPDATE departamento
SET cpf_prof_chefe = '12345678901' WHERE id_depto = 1;
UPDATE departamento
SET cpf_prof_chefe = '23456789012' WHERE id_depto = 2;
UPDATE departamento
SET cpf_prof_chefe = '34567890123' WHERE id_depto = 3;
UPDATE departamento
SET cpf_prof_chefe = '45678901234' WHERE id_depto = 4;
UPDATE departamento
SET cpf_prof_chefe = '56789012345' WHERE id_depto = 5;

INSERT INTO contato_prof (cpf_prof, contato) VALUES 
('12345678901', '+5502180598262'),
('23456789012', '+5506145053315'),
('34567890123', '+5500000000000'), -- valor fictício para evitar erro de NOT NULL
('45678901234', '+558469232260'),
('56789012345', '+5505156342160');

INSERT INTO avaliacao_prof (cpf_prof, data_hora, comentario, nota) 
VALUES 
('12345678901', '2025-04-01 14:25:30', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod turpis et nulla mollis.', 8),
('23456789012', '2025-03-18 10:10:45', 'Quisque pharetra purus vitae magna fermentum, ut tristique lorem interdum.', 6),
('34567890123', '2025-04-03 16:00:12', 'Curabitur vitae neque vel erat pharetra convallis sit amet et augue. Integer et lorem felis.', 9),
('45678901234', '2025-01-20 11:50:25', 'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.', 7),
('56789012345', '2025-02-15 18:35:10', 'Mauris euismod orci ac libero fermentum, ac fermentum enim mollis. Donec at bibendum libero.', 5);

INSERT INTO disciplina (nome_disc, carga_horaria, ementa, disc_pre_req) 
VALUES 
('Dolor', 30, '', NULL),
('Sunt', 30, 'Harum nisi iusto dolorum. Similique accusamus quam placeat modi eaque odit. Eos culpa a quam. Voluptas quis magni autem numquam.', NULL),
('Dolore', 30, '', NULL),
('Vero', 30, 'Quisquam consectetur labore mollitia eaque sit incidunt. Ut quidem porro quae id.', NULL);

-- disciplinas com pre requisito
INSERT INTO disciplina (nome_disc, carga_horaria, ementa, disc_pre_req) 
VALUES 
('Geografia', 30, '', 'Sunt'),
('Desenho', 30, 'Quisquam consectetur labore mollitia eaque sit incidunt. Ut quidem porro quae id.', 'Dolore'),
('Nisi', 30, 'Atque inventore incidunt iure. Perferendis voluptates atque.\nReiciendis autem deleniti modi consequuntur delectus. Dolorum unde ipsam similique mollitia amet voluptatum. Voluptas unde sed.', 'Vero');

INSERT INTO aluno (nome_aluno, matricula, endereco, data_nascimento) VALUES 
('Mirella Rodrigues', '10000', 'Favela Carlos Eduardo Viana, 6\nBarreiro\n97882081 Campos / RN', NULL),
('Aluno Desconhecido 1', '10001', 'Passarela Costa, 139\nVila Atila De Paiva\n69985435 Ferreira / MG', '1927-03-07'),
('Melissa Jesus', '10002', 'Aeroporto Ramos, 291\nSão Jorge 2ª Seção\n84251354 Pires / TO', '1983-04-20'),
('Sra. Mariana Souza', '10003', 'Lagoa de Cavalcanti, 24\nFernão Dias\n82449353 Santos do Amparo / GO', '2024-07-10'),
('Aluno Desconhecido 2', '10004', 'Praça de Freitas\nAtila De Paiva\n52427868 Correia / AP', '2003-06-01');

INSERT INTO aluno_disciplina (matricula, nome_disc) VALUES 
('10004', 'Sunt'),
('10002', 'Sunt'),
('10001', 'Nisi'),
('10004', 'Dolore'),
('10004', 'Vero');

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'faculdade'
  AND table_rows = 0;
  
INSERT INTO prof_disciplina (cpf_prof, nome_disc) VALUES
('12345678901', 'Dolor'),
('23456789012', 'Desenho'),
('34567890123', 'Sunt'),
('45678901234', 'Geografia'),
('56789012345', 'Nisi');



