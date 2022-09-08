-----------------------------------------  TASK 1  -------------------------------------------

-- drop tablespace VAD_TS
create tablespace VAD_TS
  datafile 'VAD_TS.dbf' --change this if you need to
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;
-- ����������� ���� � ������ �� (����� ����� ��������� ����������):
-- select * from dba_data_files
--
-- ������� ��� ��������� ������������:
-- select TABLESPACE_NAME, STATUS, CONTENTS from SYS.dba_tablespaces



-----------------------------------------  TASK 2  -------------------------------------------

-- drop tablespace VAD_TS_TEMP
create temporary tablespace vad_ts_temp
  tempfile 'VAD_TS_TEMP.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;
  
  

-----------------------------------------  TASK 3  -------------------------------------------

-- ��� ��������� ������������
select TABLESPACE_NAME ��������, STATUS ������, CONTENTS ���, 
EXTENT_MANAGEMENT �����_����������, BLOCK_SIZE ������_������, NEXT_EXTENT ������_����������,
MAX_EXTENTS ����_���������, MAX_SIZE ����_������_�_������, BIGFILE ���_BIGFILE
from SYS.dba_tablespaces;

-- ������ ���� ������ dba
select FILE_NAME ����_�_�����, BYTES ������_�_������, MAXBYTES ����_������, 
INCREMENT_BY �����_���_����������, ONLINE_STATUS ������_������, STATUS ������
from SYS.dba_data_files;



-----------------------------------------  TASK 4  -------------------------------------------

---- !!! ��� ����������� � SQLPLUS � PLUGGABLE DATABASE !!!
create role VAD_RL;
grant connect, create table, drop any table, create view, 
drop any view, create procedure, drop any procedure to VAD_RL;
select * from dba_roles;



-----------------------------------------  TASK 5  -------------------------------------------

-- ������� ���������� ��� ��������� ���� XXX_RL
---- !!! ��� ����������� � SQLPLUS !!! ----
select PRIVILEGE
from sys.dba_sys_privs
where grantee = 'VAD_RL'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_RL';

-- � ��� ����� � � SQL Developer
-- ������� ��� ����������
select * from dba_sys_privs

-- ������� ��� ����
select * from dba_roles



-----------------------------------------  TASK 6  -------------------------------------------

-- !!! ��� ����������� � SQLPLUS !!! --
create profile VAD_PFCORE limit
  password_life_time 365
  sessions_per_user 5
  failed_login_attempts 5
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 45



-----------------------------------------  TASK 7  -------------------------------------------

-- !!! ��� ������� 7-�� ������� � SQLPLUS !!! --
-- ������ ���� ��������
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles;

-- ������ ���������� ������ �������
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles where PROFILE = 'VAD_PFCORE';

-- ������ ���������� ������� default
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles where PROFILE = 'DEFAULT';



-----------------------------------------  TASK 8  -------------------------------------------

---- !!! ��� ��������� � SQLPLUS � �� � SQLDEVELOPER !!! ----
-- ������� ���� ������� ���������� � PDB:
create tablespace VAD_TS_PDB
  datafile 'VAD_TS_PDB.dbf' --change this if you need to
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;
create temporary tablespace vad_ts_temp_pdb
  tempfile 'VAD_TS_TEMP_PDB.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;

create user VADCORE identified by 9900
default tablespace VAD_TS_PDB quota unlimited on VAD_TS_PDB
temporary tablespace VAD_TS_TEMP_PDB
profile VAD_PFCORE
account unlock
password expire;












