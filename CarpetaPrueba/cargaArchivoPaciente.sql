--Cargar Archivo Paciente mediante un store procedure 
CREATE OR ALTER PROCEDURE cargarPaciente
    @data_file NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
	CREATE TABLE #TempPacientes
	(
		nombre varchar(200),
		apellido varchar(200),
		fechaNacimiento varchar(200),
		tipo_documento varchar(20),
		dni varchar(50),
		femenino varchar(50),
		genero varchar(50),
		telefono varchar(50),
		nacionalidad varchar(50),
		mail varchar(50),
		calle varchar(150),
		localidad varchar(100),
		provincia varchar(100)
	)

    BEGIN TRY
        -- Construir la consulta BULK INSERT dinámica
       DECLARE @sql NVARCHAR(MAX);
        -- Construct the dynamic SQL for BULK INSERT
        SET @sql = N'
            BULK INSERT #TempPacientes
            FROM ''' + @data_file + N'''
            WITH
            (
                FIELDTERMINATOR = '';'',
                ROWTERMINATOR = ''\n'',
                CODEPAGE = ''ACP'',
                FIRSTROW = 2
            );';
        
        -- Execute the constructed SQL
        EXEC sp_executesql @sql;
        -- Aquí puedes manipular los datos en @Pacientes según sea necesario
        -- Por ejemplo, imprimir los datos para verificar
        SELECT * FROM #TempPacientes;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        -- Lanzar un error con el mismo mensaje y severidad
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
EXEC cargarPaciente 'A:\Ingenieria\BDA\Tp\Datasets-Informacion-necesaria\Dataset\Pacientes.csv';