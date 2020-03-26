/*
Este query lista los datos que se registran en cada traza
detallados por categoría, evento y columna
*/
select t.id [ID Traza],
       cat.name [Categoria],
	   cast(e.trace_event_id as nvarchar) + ' - ' + e.name [Evento],
	   cast(c.trace_column_id as nvarchar) + ' - ' + c.name [Columna],
	   c.type_name [Tipo Columna]
from sys.traces t
cross apply sys.fn_trace_geteventinfo(t.id) ei
join sys.trace_columns c on ei.columnid = c.trace_column_id
join sys.trace_events e on ei.eventid = e.trace_event_id
join sys.trace_categories cat on e.category_id = cat.category_id
