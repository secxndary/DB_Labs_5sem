-- 1. ������ ���� ������ ��������� ����������� 
select FILE_ID, TABLESPACE_NAME, FILE_NAME from dba_data_files;
select * from dba_data_files;


-- 2. ������� VAD_QDATA, ���� VADCORE ����� �� ���������� � ������� �������
create tablespace VAD_QDATA
  datafile 'VAD_QDATA.dbf'
  size 10M
  offline;

select TABLESPACE_NAME, STATUS, CONTENTS from dba_tablespaces;

alter tablespace VAD_QDATA ONLINE;

alter user VADCORE quota 2M on VAD_QDATA;


-- ��� ���� ��������� � ���������� VADCORE
create table VADCORE_SONGS
(
  id number,
  title varchar(50),
  artist varchar(50),
  CONSTRAINT PK_VADCORE primary key (id)
) tablespace VAD_QDATA;

insert into VADCORE_SONGS values (1, 'Dimitriadi Diss', 'secxndary');
insert into VADCORE_SONGS values (2, 'Anton Diss', 'secxndary x Toxich x Brruuuhhhh');
insert into VADCORE_SONGS values (3, 'Sanya Diss', 'Toxich');
insert into VADCORE_SONGS values (4, 'Psarnya Diss', 'Toxich');
insert into VADCORE_SONGS values (5, 'Demka 2', 'Toxich x Nazar');
insert into VADCORE_SONGS values (6, 'Dota rep', 'Toxich x Nazar');
insert into VADCORE_SONGS values (7, 'Detroit', 'Toxich x Nazar');

select * from VADCORE_SONGS;


-- 3. �������� VAD_QDATA � ��������, ����������� � ����� �������
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS from user_segments;


-- 4. ������� ������� � ����������� �������� � �������
drop table VADCORE_SONGS;
select * from USER_RECYCLEBIN;
purge table VADCORE_SONGS;  -- ������� ������� USER_RECYCLEBIN � �������� ��������


-- 5. �������������� �������
flashback table VADCORE_SONGS to before drop;


-- 6. �������� 10000 ����� � �������
begin
  for x in 8..10008
  loop
    insert into VADCORE_SONGS values(x, 'Genius', 'Kanye West');
  end loop
end;

select count(*) from VADCORE_SONGS;



-- 7. ������� ��������� � �������, �� ������ � ������ � ������
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS 
from user_segments
where SEGMENT_NAME = 'VADCORE_SONGS';

-- ������ ���� ���������
select * from user_extents 
where TABLESPACE_NAME = 'VAD_QDATA';



-- 8. ������� ���������� � ��� ����
drop tablespace VAD_QDATA including contents and datafiles;


-- 9. ������ �������� ������� [����� � ����� � SYSDBA connection]
select * from v$log order by GROUP#;


-- 10. ��� ������� ������� ��������
select * from v$logfile order by GROUP#;


-- 11. ������ ���� ������� ������������ 
-- (��������� switch logfile ��� ������������ �� ��������� ������: 1-> 2 -> 3)
alter system switch logfile;
select * from v$log order by GROUP#;


-- 12. ������� ���� ������ �������� ������� � 3 ������� � ���
alter database add logfile 
    group 4 
    'C:\app\oraora\oradata\orcl\REDO04.LOG'
    size 50m 
    blocksize 512;
    
alter database add logfile 
    member 
    'C:\app\oraora\oradata\orcl\REDO04_1.LOG' 
    to group 4;
    
alter database add logfile 
    member 
    'C:\app\oraora\oradata\orcl\REDO04_2.LOG' 
    to group 4;

select * from v$log order by GROUP#;
select * from v$logfile order by GROUP#;


-- 13. ������� ��������� ������ �������� �������
alter database drop logfile member 'C:\app\oraora\oradata\orcl\REDO04_2.LOG';
alter database drop logfile member 'C:\app\oraora\oradata\orcl\REDO04_1.LOG';
alter database drop logfile group 4;

select * from v$log order by GROUP#;
select * from v$logfile order by GROUP#;


-- 14. ���������, ����������� �� �������������
-- ������ ���� ��������: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;


-- 15. ����� ���������� ������ (��� ���������� ������������� - ������� ������)
select * from V$ARCHIVED_LOG;


-- 16. �������� �������������
--      SQLPLUS:
-- connect /as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;

-- 17. 


-- 18. 


-- 19. 


-- 20. 


-- 21. 


-- 22. 


-- 23. 


-- 24. 


-- 25. 


-- 26. 

