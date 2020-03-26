/*
Este query lista la definición de los filtros
de todas las trazas
*/
select t.id [ID Traza],
       c.name [Columna],
       case logical_operator when 0 then 'AND' when 1 then 'OR' end [Op. Logico],
       case comparison_operator when 0 then '=' when 1 then '!=' when 7 then 'NOT LIKE'end [Operador],
	   fi.value [Valor]
       --,c.*,fi.* 
from sys.traces t
cross apply sys.fn_trace_getfilterinfo(t.id) fi
join sys.trace_columns c on fi.columnid = c.trace_column_id