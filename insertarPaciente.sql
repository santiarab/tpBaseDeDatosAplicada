-- Insertar un Paciente

use Prueba

create table domicilio
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


create table paciente
(
	id_historia_clinica int identity(1,1),
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	apellido_materno varchar(50) not null,
	fecha_de_nacimiento date not null,
	tipo_documento char(3) not null,
	numero_de_documento int not null unique,
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
	--usuario_actualizacion --preguntar a jair 
	activo bit not null, /*usado para el borrado logico*/
	id_domicilio int,
	nro_de_socio varchar(25),
	id_cobertura int,
	constraint pk_paciente primary key(numero_de_documento,id_historia_clinica),
	constraint tipo_sexo check (sexo_biologico in ('H','M')),
	constraint fk_paciente_domicilio foreign key(id_domicilio) references domicilio(id_domicilio),
	--constraint fk_paciente_cobertura foreign key(nro_de_socio,id_cobertura) references cobertura(nro_de_socio,id_cobertura)
)
go
create table usuario
(
	id_usuario int,
	contrasenia nvarchar(12) not null,
	fecha_de_creacion datetime default getdate(),
	constraint pk_usuario primary key(id_usuario),
	constraint fk_usuario foreign key(id_usuario) references paciente (numero_de_documento) 
)
go
drop table paciente
CREATE OR ALTER PROCEDURE insertarPaciente
	@nombre varchar(50) ,
	@apellido varchar(50) ,
	@apellido_materno varchar(50) ,
	@fecha_de_nacimiento date ,
	@tipo_documento char(3),
	@numero_de_documento int,
	@sexo_biologico char(1),
	@genero char(1),
	@nacionalidad varchar(20) ,
	@mail varchar(50),
	@telefono_fijo varchar(20),
	@id_domicilio int,
	@nro_de_socio varchar(25),
	@id_cobertura int
AS
begin
	SET NOCOUNT ON;
	if NOT EXISTS (select 1 from Paciente where @numero_de_documento = numero_de_documento)
	begin
		
	end
	else
	begin
		PRINT 'El usuario que intentas insertar ya existe'
	end
	SET NOCOUNT OFF;
end

exec insertarPaciente 126,'hola'