 
   SELECT
    ja.job_id,
    j.name AS job_name,
    ja.start_execution_date,      
    ISNULL(last_executed_step_id,0)+1 AS current_executed_step_id,
    Js.step_name
FROM msdb.dbo.sysjobactivity ja 
LEFT JOIN msdb.dbo.sysjobhistory jh 
    ON ja.job_history_id = jh.instance_id
JOIN msdb.dbo.sysjobs j 
    ON ja.job_id = j.job_id
JOIN msdb.dbo.sysjobsteps js
    ON ja.job_id = js.job_id
    AND ISNULL(ja.last_executed_step_id,0)+1 = js.step_id
WHERE ja.session_id = (SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY agent_start_date DESC)
AND start_execution_date is not null
AND stop_execution_date is null
and j.name = 'RebadgeETL'

SELECT 
  ErrorMessage = om.message 
, om.message_time
, em.execution_path
, em.package_name
, em.event_name
, em.message_source_name
, o.start_time
, o.end_time
, o.caller_name
, o.server_name
, o.machine_name
, *
  FROM [SSISDB].internal.event_messages em
  inner join ssisdb.internal.operations o on em.operation_id =o.operation_id
  inner join ssisdb.internal.operation_messages om on om.operation_message_id = em.event_message_id
  where o.operation_id = (select operation_id = max(operation_id) from ssisdb.internal.operations o where object_name = 'ETL' )
  and event_name = 'OnError'
 --and execution_path = '\0-Main\1-Source to Staging\1-Staging\Sequence Container\DataMall\Staging EmployeeList'
 
  order by o.operation_id, em.event_message_id

  select top 3 [Last Three Events Execution Path] = em.execution_path, latest = om.message_time, event_name, em.event_message_id
 FROM [SSISDB].internal.event_messages em
  inner join ssisdb.internal.operations o on em.operation_id =o.operation_id
  inner join ssisdb.internal.operation_messages om on om.operation_message_id = em.event_message_id
  where o.operation_id = (select operation_id = max(operation_id) from ssisdb.internal.operations o where object_name = 'ETL' ) 
  and event_name not in ('OnPreValidate','OnPostValidate','OnInformation')
  --group by execution_path, event_name, em.event_message_id
  order by latest desc, em.event_message_id desc


   
   select  DataSyncExecutionID, ExecutionStart, StartedBy, ImportCompleted, StageCompleted, TransformCompleted, ExecutionEnd
  , totalduration_min = datediff(mi, ExecutionStart, ExecutionEnd)
   from BloomRebadgePortalStaging.transform.DataSyncExecution order by DataSyncExecutionID desc

  /*

    --longest running portions
 --select execution_path, first = min(start_time), last = max(end_time), Duration_s = datediff(s, min(message_time), max(message_time)   ) 
 --FROM [SSISDB].internal.event_messages em
 -- inner join ssisdb.internal.operations o on em.operation_id =o.operation_id
 -- inner join ssisdb.internal.operation_messages om on om.operation_message_id = em.event_message_id
 -- where o.operation_id = (select operation_id = max(operation_id) from ssisdb.internal.operations o 
 -- where object_name = 'ETL' ) and event_name not in ('OnPreValidate','OnPostValidate','OnInformation')
 -- group by execution_path
 -- order by 4 desc


    select  [LExecution Path] = em.execution_path, o.operation_id, latest = max(om.message_time),   Duration_s = datediff(s, min(message_time), max(message_time)   ) 
 FROM [SSISDB].internal.event_messages em
  inner join ssisdb.internal.operations o on em.operation_id =o.operation_id
  inner join ssisdb.internal.operation_messages om on om.operation_message_id = em.event_message_id
  where execution_path = '\0-Main\1-Source to Staging\1-Staging\Sequence Container\MyMSPIC\Staging MyMSPic'
  or execution_path = '\0-Main\1-Source to Staging\1-Staging\Sequence Container\MyMSPIC\Source MyMSPic'

  group by execution_path, o.operation_id
  order by em.execution_path, latest desc, o.operation_id desc



    update BloomRebadgePortalStaging.transform.DataSyncExecution 
  set stagecompleted = getutcdate()
  where datasyncexecutionid = 125 and executionend  is null
  

  select * from transform.DataSyncExecution where datasyncexecutionid = 126
  update BloomRebadgePortalStaging.transform.DataSyncExecution 
  set transformcompleted = getutcdate(), executionend = getutcdate()
  where datasyncexecutionid = 129 and executionend  is null
  

  --for azure
  update transform.DataSyncExecution 
set ExecutionStart	 = '2015-12-04 12:25:02.233'
,StartedBy	 = 	'REDMOND\v-stsmit'
,ImportCompleted	 = '2015-12-04 12:39:07.610'
,StageCompleted	 = '2015-12-04 12:59:05.280	'
,TransformCompleted	= '2015-12-04 12:59:05.280'
,ExecutionEnd	= '2015-12-04 14:55:09.520'
where datasyncexecutionid = 126
  
  */
