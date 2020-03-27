select (gs.avg_user_impact/100)*avg_total_user_cost*(user_seeks+user_scans) benef ,id.*,gs.* from sys.dm_db_missing_index_details id
join sys.dm_db_missing_index_groups ig on id.index_handle = ig.index_handle
join sys.dm_db_missing_index_group_stats gs on gs.group_handle = ig.index_group_handle
order by benef desc