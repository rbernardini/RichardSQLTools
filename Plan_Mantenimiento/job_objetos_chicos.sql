USE [msdb]
GO

/****** Object:  Job [Mantenimiento_Objetos_Chicos]    Script Date: 17/4/2020 15:26:08 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 17/4/2020 15:26:08 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Mantenimiento_Objetos_Chicos', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'REBUILD de objetos hasta 2097152 páginas y más de 15% de fragmentación. Se recomienda ejecutar todos los días por la mañana, FUERA DE HORARIO PRODUCTIVO - Tambien realiza actualización de estadísticas con más de 20% de cambios', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'NBRICHARD\rbern', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Rebuild]    Script Date: 17/4/2020 15:26:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rebuild', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec IndexOptimize @Databases=''USER_DATABASES'', 
                                @FragmentationMedium=''INDEX_REBUILD_OFFLINE'',
                                @FragmentationHigh=''INDEX_REBUILD_OFFLINE'',
                                @FragmentationLevel1=15, 
                                @MaxNumberOfPages=2097152,
                                @UpdateStatistics=''ALL'',
                                @StatisticsModificationLevel=20,
                                @PartitionLevel=''Y'',
                                @LogToTable=''Y''', 
		@database_name=N'Boreal_Mant', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


