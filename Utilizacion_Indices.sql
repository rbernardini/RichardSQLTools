select 
      DB_NAME(us.database_id) base,
  	  OBJECT_SCHEMA_NAME(us.object_id,us.database_id) sch,
--	  OBJECT_NAME(us.object_id,us.database_id) tabla,
--	  si.name indice,
--	  ds.name [filegroup],
	  sum(us.user_lookups+us.user_scans+us.user_seeks+us.system_lookups+us.system_scans+us.system_seeks) reads,
	  sum(us.user_updates+us.system_updates) writes,
	  sum(us.user_lookups+us.user_scans+us.user_seeks+us.system_lookups+us.system_scans+us.system_seeks+us.user_updates+us.system_updates) accesos
from sys.dm_db_index_usage_stats us
join sys.indexes si on si.object_id = us.object_id and si.index_id = us.index_id
join sys.data_spaces ds on si.data_space_id = ds.data_space_id
group by us.database_id,OBJECT_SCHEMA_NAME(us.object_id,us.database_id)
--group by us.database_id, ds.name
order by base,accesos desc