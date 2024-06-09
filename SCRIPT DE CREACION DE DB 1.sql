/*
Entrega 3
Luego de decidirse por un motor de base de datos relacional, lleg� el momento de generar la base de 
datos.
Deber� instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle las 
configuraciones aplicadas (ubicaci�n de archivos, memoria asignada, seguridad, puertos, etc.) en un 
documento como el que le entregar�a al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deber� entregar un 
archivo .sql con el script completo de creaci�n (debe funcionar si se lo ejecuta �tal cual� es entregado). 
Incluya comentarios para indicar qu� hace cada m�dulo de c�digo. 
Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde, tambi�n 
debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con �SP�. 
Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto en la 
creaci�n de objetos. NO use el esquema �dbo�.
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha de 
entrega, n�mero de grupo, nombre de la materia, nombres y DNI de los alumnos. 
Entregar todo en un zip cuyo nombre sea Grupo_XX.zip mediante la secci�n de pr�cticas de MIEL. 
Solo uno de los miembros del grupo debe hacer la entrega.
*/

--drop database COM5600G11


create database COM5600G11
go
use COM5600G11
go
create schema tablas
go

---Comentar las decisiones tomadas y porque
create table tablas.domicilio
(
	id_domicilio int identity(1,1),
	calle varchar(30) not null,
	numero int not null,
	piso int,
	departamento char(2),
	codigo_postal int not null,
	pais varchar(20) not null,
	provincia varchar(30) not null ,
	localidad varchar(35) not null,
	constraint pk_domicilio primary key(id_domicilio)
)
go

create table tablas.prestador
(
	id_prestador int identity(1,1),
	nombre_prestador varchar(40) not null,
	plan_prestador varchar(30) not null,
	constraint pk_prestador primary key (id_prestador)
)
go
create table tablas.cobertura
(
	id_cobertura int,
	imagen_de_la_credencial varchar(300) not null,
	nro_de_socio varchar(25) not null,
	fecha_de_registro date not null,
	id_prestador int,
	constraint pk_cobertura primary key (nro_de_socio,id_cobertura),
	constraint fk_cobertura foreign key(id_prestador) references tablas.prestador(id_prestador)
)
go

create table tablas.paciente
(
	id_historia_clinica int identity(1,1),
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	apellido_materno varchar(50) not null,
	fecha_de_nacimiento date not null,
	tipo_documento char(3) not null,
	numero_de_documento int not null,
	sexo_biologico char(1) not null,
	genero char(1) not null,
	nacionalidad varchar(20) not null,
	foto_de_perfil varchar(300),
	mail varchar(50) not null,
	telefono_fijo varchar(20) not null,
	telefono_de_contacto_alternativo varchar(20) not null,
	telefono_laboral varchar(20) not null,
	fecha_de_registro datetime default getdate(),
	fecha_de_actualizacion date,
	usuario_actualizacion int not null,
	fecha_eliminacion datetime default NULL, /*Utilizado para el borrado logico, en lugar de eliminar el registro, se actualizara la fecha de eliminacion*/
	id_domicilio int,
	nro_de_socio varchar(25),
	id_cobertura int,
	constraint pk_paciente primary key(id_historia_clinica,numero_de_documento),
	constraint tipo_sexo check (sexo_biologico in ('H','M')),
	constraint fk_paciente_domicilio foreign key(id_domicilio) references tablas.domicilio(id_domicilio),
	constraint fk_paciente_cobertura foreign key(nro_de_socio,id_cobertura) references tablas.cobertura(nro_de_socio,id_cobertura)
)
go
create table tablas.estudio
(
	id_estudio int identity(1,1),
	numero_de_documento int not null,
	fecha date not null,
	nombre_estudio varchar(50) not null,
	autorizado bit not null,
	documento_resultado varchar(300),
	imagen_resultado varchar(300),
	id_historia_clinica int,
	fecha_eliminacion datetime default NULL, /*Utilizado para el borrado logico, en lugar de eliminar el registro, se actualizara la fecha de eliminacion*/
	constraint pk_estudio primary key(id_estudio),
	constraint fk_estudio foreign key (id_historia_clinica,numero_de_documento) references tablas.paciente(id_historia_clinica,numero_de_documento)
)
go

create table tablas.usuario
(
	id_usuario int,
	id_historia_clinica int,
	numero_de_documento int not null,
	contrasenia nvarchar(12) not null,
	fecha_de_creacion datetime default getdate(),
	constraint pk_usuario primary key(id_usuario),
	constraint fk_usuario foreign key(id_historia_clinica,numero_de_documento) references tablas.paciente(id_historia_clinica,numero_de_documento)
)
go

create table tablas.especialidad
(
	id_especialidad int identity(1,1),
	nombre_especialidad varchar(50) not null,
	constraint pk_especialidad primary key(id_especialidad)
)
go
create table tablas.medico
(
	id_medico int identity(1,1),
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	numero_matricula int unique not null,
	id_especialidad int,
	constraint pk_medico primary key(id_medico),
	constraint fk_medico foreign key(id_especialidad) references tablas.especialidad(id_especialidad)
)
go
create table tablas.tipo_turno
(
	id_tipo_turno int identity(1,1),
	descripcion_tipo_turno varchar(10),
	constraint pk_tipo_turno primary key(id_tipo_turno),
	constraint check_tipo_turno check(descripcion_tipo_turno in ('virtual','presencial')) 
)
go

create table tablas.estado_turno
(
	id_estado int identity(1,1),
	nombre_estado varchar(10) DEFAULT 'Disponible',
	constraint pk_estado_turno primary key(id_estado),
	constraint check_estado_turno check (nombre_estado in ('Atendido','Ausente','Cancelado', 'Disponible')) /* Atendido.Ausente.Cancelado.Disponible*/
)
go


create table tablas.reserva_de_turno_medico
(
	id_turno int identity(1,1),
	fecha date not null,
	hora_inicio varchar(5) CONSTRAINT CHECH_HORA_RESERVA_TURNO CHECK (hora_inicio LIKE '__:15' OR hora_inicio LIKE '__:30' OR hora_inicio LIKE '__:45' OR hora_inicio LIKE '__:00') not null, -- los turnos son de 15mn*/
	id_medico int,
	id_especialidad int,
	id_direccion_atencion int,
	id_estado_turno int,
	id_tipo_turno int,
	constraint pk_reserva_de_turno_medico primary key(id_turno,fecha,hora_inicio),
	constraint fk_reserva_de_turno_medico_id_medico foreign key(id_medico) references tablas.medico(id_medico),
	constraint fk_reserva_de_turno_medico_id_especialidad foreign key(id_especialidad) references tablas.especialidad(id_especialidad),
	constraint fk_reserva_de_turno_medico_id_estado_turno foreign key(id_estado_turno) references tablas.estado_turno(id_estado),
	constraint fk_reserva_de_turno_medico_id_tipo_turno foreign key (id_tipo_turno)references tablas.tipo_turno(id_tipo_turno)
)
go

create table tablas.dias_por_sede
(
	id_sede int identity(1,1),
	id_medico int,
	id_turno int,
	dia date,
	hora_inicio varchar(5) CONSTRAINT CHECH_HORA_DIAS_SEDE CHECK (hora_inicio LIKE '__:15' OR hora_inicio LIKE '__:30' OR hora_inicio LIKE '__:45' OR hora_inicio LIKE '__:00'), -- los turnos son de 15mn*/
	constraint pk_dias_por_sede primary key(id_sede),
	constraint fk_dias_por_sede_medico foreign key(id_medico) references tablas.medico(id_medico),
	constraint fk_dias_por_sede_dia foreign key(id_turno,dia,hora_inicio) references tablas.reserva_de_turno_medico(id_turno,fecha,hora_inicio)
)
go
create table tablas.sede_de_atencion
(
	id_sede int identity(1,1),
	nombre_de_sede varchar(50) not null,
	direccion_sede varchar(100) not null,
	constraint pk_sede_de_atencion primary key(id_sede)
)
go



