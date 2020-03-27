select description,
       name,
       user_name,
       backup_start_date,
       type,
       database_name
	   , recovery_model
from msdb..backupset 
where type !='L'
order by backup_set_id desc

