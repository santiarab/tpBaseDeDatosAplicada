CREATE OR ALTER PROCEDURE procedimientos.insertar_prestador
    @nombre_prestador varchar(40),@plan_prestador varchar(30)
AS
begin
	SET NOCOUNT ON;
	set @nombre_prestador = LOWER(LTRIM(RTRIM(@nombre_prestador)))
	set @plan_prestador = LOWER(LTRIM(RTRIM(@plan_prestador)))
	if NOT EXISTS (select 1 from tabla.prestador where nombre_prestador COLLATE Latin1_General_CI_AS = @nombre_prestador COLLATE Latin1_General_CI_AS 
	AND 
	plan_prestador COLLATE Latin1_General_CI_AS = @plan_prestador COLLATE Latin1_General_CI_AS
	)
	begin
		insert into prestador(nombre_prestador,plan_prestador) values(@nombre_prestador,@plan_prestador)
		PRINT ''
	end
	else
	begin
		PRINT ''
	end
	SET NOCOUNT OFF;
end
