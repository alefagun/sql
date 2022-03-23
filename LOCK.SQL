column lock_type format a15
column mode_held format a11
column request_mode format a10
column lock_id1 format a8
column lock_id2 format a8

select a.sid,
  decode(a.type,'MR','Media Recovery',
		'RT','Redo Thread',
		'UN','User Name',
		'TX','Transaction',
		'TM','DML',
		'UL','PL/SQL User lock',
		'DX','Distributed Xaction',
		'CF','Control File',
		'IS','Instance State',
		'FS','File Set',
		'IR','Instance Recovery',
		'ST','Disk space transaction',
		'TS','Temp Segment',
		'IV','Library Cache Invalidation',
		'LS','Log Start or Switch',
		'RW','Row wait',
		'SQ','Sequence number',
		'TE','Extend Table',
		'TT','Temp Table', a.type) lock_type,
  decode(a.lmode,0, 'None',
		1, 'Null',
		2, 'Row-S (SS)',
		3, 'Row-X (SX)',
		4, 'Share',
		5, 'S/Row-S (SSX)',
		6, 'Exclusive', to_char(a.lmode)) mode_held,
  decode(a.request,0, 'None',
		1, 'Null',
		2, 'Row-S (SS)',
		3, 'Row-X (SX)',
		4, 'Share',
		5, 'S/Row-S (SSX)',
		6, 'Exclusive', to_char(a.request)) request_mode,
  to_char(a.id1) lock_id1, to_char(a.id2) lock_id2
from v$lock a
  where (id1,id2) in
	(select b.id1,b.id2
	 from v$lock b
	 where b.id1=a.id1
	 and   b.id2=a.id2
	 and b.request > 0)
/



set linesize 150
      set pagesize 150
      set tab      off
      col hold_wait  format a30     heading "Holder/Waiter"
      col username   format a15     heading "Username"
      col osuser     format a15     heading "OS User"
      col machine    format a25     heading "Machine"
      col lcall_et_m format 9999.99 heading "ET Min"
      col module     format a15     heading "Module"
      col action     format a25     heading "Action"
      select decode
            (a.request,0,'Holder: ','  Waiter: ') || '[' ||
             a.inst_id || '] (' || a.sid || ',' || b.serial# || ')' hold_wait,
             b.username, b.osuser, b.machine, b.status, trunc(b.last_call_et/60,2) lcall_et_m,
             b.module, 
             --b.action,
             b.sql_id
      from gv$lock a, gv$session b, sys.obj$ c, sys.obj$ d
      where (id1, id2, a.type) in (select id1, id2, type from gv$lock where request > 0)
        and a.inst_id = b.inst_id
        and a.sid     = b.sid
        and a.id1     = c.obj# (+)
        and a.id2     = d.obj# (+)
      order by id1, request;
/
