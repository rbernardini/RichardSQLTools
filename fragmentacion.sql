select 
    object_schema_name(ps.object_id) sch,
    OBJECT_NAME(ps.object_id) objeto,
    si.name,
	ps.index_type_desc,
	ps.alloc_unit_type_desc,
	ds.name,
	ps.avg_fragmentation_in_percent,	
    page_count/128 as MBs,
    (page_count/128)*(avg_fragmentation_in_percent/100) as waste
from sys.dm_db_index_physical_stats(db_id(),0,-1,0,NULL) ps
join sys.indexes si on si.object_id = ps.object_id and si.index_id = ps.index_id
join sys.partitions p on p.object_id = ps.object_id and p.index_id = ps.index_id
join sys.allocation_units au on au.container_id = p.hobt_id and  au.type_desc = ps.alloc_unit_type_desc COLLATE DATABASE_DEFAULT
join sys.data_spaces ds on au.data_space_id = ds.data_space_id 
order by waste desc