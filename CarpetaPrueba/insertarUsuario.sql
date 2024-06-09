-- Insertar un Usuario
create table usuario
(
	id_usuario int,
	contrasenia nvarchar(12) not null,
	fecha_de_creacion datetime default getdate(),
	constraint pk_usuario primary key(id_usuario),
	--constraint fk_usuario foreign key(id_usuario) references paciente(numero_de_documento) Para probar si funciona
)
CREATE OR ALTER PROCEDURE insertarUsuario
    @id_usuario int,@password NVARCHAR(12)
AS
begin
	SET NOCOUNT ON;
	if NOT EXISTS (select 1 from usuario where @id_usuario = id_usuario)
	begin
		insert into usuario(id_usuario,contrasenia) values(@id_usuario,@password)
		PRINT 'El usuario ha sido insertado correctamente'
	end
	else
	begin
		PRINT 'El usuario que intentas insertar ya existe'
	end
	SET NOCOUNT OFF;
end

exec insertarUsuario 126,'hola'