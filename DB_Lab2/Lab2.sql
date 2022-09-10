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
-- �� ��������� ������� ���� ����� ������������ ���� �� (���� ������ ����� ����� ���� �����)
create temporary tablespace VAD_TS_TEMP
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

alter session set "_ORACLE_SCRIPT" = true;
create role VAD_RL;
grant connect, create session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VAD_RL;
select * from dba_roles where ROLE like '%RL%';



-----------------------------------------  TASK 5  -------------------------------------------

-- ������� ���������� ��� ��������� ���� XXX_RL
select PRIVILEGE
from sys.dba_sys_privs
where grantee = 'VAD_RL'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_RL';

-- ������� ��� ����������
select * from dba_sys_privs

-- ������� ��� ����
select * from dba_roles



-----------------------------------------  TASK 6  -------------------------------------------

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

-- ������ ���� ��������
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles order by PROFILE;

-- ������ ���������� ������ �������
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles 
where PROFILE = 'VAD_PFCORE' order by RESOURCE_NAME;

-- ������ ���������� ������� default
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles 
where PROFILE = 'DEFAULT' order by RESOURCE_NAME;



-----------------------------------------  TASK 8  -------------------------------------------

create user VADCORE identified by 9900
default tablespace VAD_TS quota unlimited on VAD_TS
temporary tablespace VAD_TS_TEMP
profile VAD_PFCORE
account unlock
password expire;



-----------------------------------------  TASK 9  -------------------------------------------

-- ������� � SQLPLUS � ��� ����� ������ �������� ��������� "Enter a username",
-- ������� ���� XXXCORE, ������� ������ (identified by *������*), � ������
-- ����� ��������� The password has expired. Enter new password"



-----------------------------------------  TASK 10  ------------------------------------------

-- ��� ����� XXXCORE ����������
grant connect, create session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VADCORE;

-- ����� ������� ����� ����������� � � ���� ����������� ������ ���� ���:
create table VADCORE_KANYE_SONGS 
(
  TITLE varchar(50),
  ALBUM varchar(50), 
  RATE number
);

insert into VADCORE_KANYE_SONGS values ('Runaway', 'MBDTF', 10);
insert into VADCORE_KANYE_SONGS values ('Ghost Town', 'ye', 10);
insert into VADCORE_KANYE_SONGS values ('On Sight', 'Yeezus', 10);
insert into VADCORE_KANYE_SONGS values ('Bound 2', 'Yeezus', 10);
insert into VADCORE_KANYE_SONGS values ('Gold Digger', 'The Colledge Dropout', 9);
insert into VADCORE_KANYE_SONGS values ('Im In It', 'Yeezus', 8);
insert into VADCORE_KANYE_SONGS values ('Yikes', 'ye', 9);
insert into VADCORE_KANYE_SONGS values ('Gorgeous', 'MBDTF', 9);
select * from VADCORE_KANYE_SONGS;

create view VADCORE_YEEZUS as 
select TITLE, RATE from VADCORE_KANYE_SONGS
where ALBUM = 'Yeezus';
select * from VADCORE_YEEZUS;



-----------------------------------------  TASK 11  ------------------------------------------

create tablespace VAD_QDATA
  datafile 'VAD_QDATA.dbf' --change this if you need to
  size 10M
  offline;
  
select TABLESPACE_NAME, STATUS, CONTENTS from SYS.dba_tablespaces;

alter tablespace VAD_QDATA ONLINE;

alter user VADCORE quota 2M on VAD_QDATA;



-- ��� ���� ��������� � ���������� VADCORE

create table VADCORE_SONGS
(
  TITLE varchar(50),
  ARTIST varchar(50)
) tablespace VAD_QDATA;

insert into VADCORE_SONGS values ('Dimitriadi Diss', 'secxndary');
insert into VADCORE_SONGS values ('Sanya Diss', 'Toxich');
insert into VADCORE_SONGS values ('Psarnya Diss', 'Toxich');
insert into VADCORE_SONGS values ('Demka 2', 'Toxich x Nazar');

select * from VADCORE_SONGS;
