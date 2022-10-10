-- TASK 1
select SUM(VALUE) TOTAL_SGA_IN_BYTES from v$sga;


-- TASK 2
select NAME POOL_NAME, VALUE SIZE_IN_BYTES from v$sga;


-- TASK 3
select COMPONENT, CURRENT_SIZE, MAX_SIZE, LAST_OPER_TIME,
GRANULE_SIZE, CURRENT_SIZE/GRANULE_SIZE as RATIO
from v$sga_dynamic_components
where CURRENT_SIZE > 0;


-- TASK 4
select CURRENT_SIZE from v$sga_dynamic_free_memory;


-- TASK 5
select COMPONENT, MIN_SIZE, MAX_SIZE, CURRENT_SIZE from v$sga_dynamic_components
where COMPONENT in ('KEEP buffer cache', 'RECYCLE buffer cache', 'DEFAULT buffer cache');


-- TASK 6
alter system set db_keep_cache_size = 100M;
alter system set db_recycle_cache_size = 100M;

create table KEEP_TABLE (num number) storage (buffer_pool keep) tablespace users;
insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (25);

select * from KEEP_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'KEEP%';


-- TASK 7
create table DEFAULT_CACHE_TABLE (num number) cache tablespace users;
insert into DEFAULT_CACHE_TABLE values (4);
insert into DEFAULT_CACHE_TABLE values (8);

select * from DEFAULT_CACHE_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'DEFAULT_CACHE%';


-- TASK 8
show parameter log_buffer;


-- TASK 9
select POOL, NAME, BYTES from v$sgastat
where pool = 'shared pool'
order by BYTES desc
offset 0 rows fetch next 10 rows only;


-- TASK 10
select sum(BYTES) CURRENT_SIZE 
from v$sgastat where pool = 'large pool';

select (MAX_SIZE - CURRENT_SIZE) AVIABLE_SPACE
from v$sga_dynamic_components where component = 'large pool';


-- TASK 11, 12
select SID, STATUS, SERVER, LOGON_TIME, PROGRAM, OSUSER, MACHINE, USERNAME, STATE
from v$session
where STATUS = 'ACTIVE';


-- TASK 13
select TYPE, EXECUTIONS, NAME from v$db_object_cache order by EXECUTIONS desc;