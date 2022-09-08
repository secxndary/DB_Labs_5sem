-----------------------------------------  TASK 1  -------------------------------------------

-- drop tablespace VAD_TS
create tablespace VAD_TS
  datafile 'VAD_TS.dbf' --change this if you need to
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;
-- стандартный путь к файлам бд (чтобы найти созданный тейблспейс):
-- select * from dba_data_files
--
-- Вывести все табличные пространства:
-- select TABLESPACE_NAME, STATUS, CONTENTS from SYS.dba_tablespaces



-----------------------------------------  TASK 2  -------------------------------------------

-- drop tablespace VAD_TS_TEMP
create temporary tablespace vad_ts_temp
  tempfile 'VAD_TS_TEMP.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;
  
  

-----------------------------------------  TASK 3  -------------------------------------------

-- Все табличные пространства
select TABLESPACE_NAME Название, STATUS Статус, CONTENTS Тип, 
EXTENT_MANAGEMENT Управ_экстентами, BLOCK_SIZE Размер_блоков, NEXT_EXTENT Размер_расширения,
MAX_EXTENTS Макс_экстентов, MAX_SIZE Макс_размер_в_блоках, BIGFILE Тип_BIGFILE
from SYS.dba_tablespaces;

-- Список всех файлов dba
select FILE_NAME Путь_к_файлу, BYTES Размер_в_байтах, MAXBYTES Макс_размер, 
INCREMENT_BY Блоки_для_расширения, ONLINE_STATUS Онлайн_статус, STATUS Статус
from SYS.dba_data_files;



-----------------------------------------  TASK 4  -------------------------------------------

---- !!! КОД ВЫПОЛНЯЕТСЯ В SQLPLUS В PLUGGABLE DATABASE !!!
create role VAD_RL;
grant connect, create table, drop any table, create view, 
drop any view, create procedure, drop any procedure to VAD_RL;
select * from dba_roles;



-----------------------------------------  TASK 5  -------------------------------------------

-- Вывести привилегии для созданной роли XXX_RL
---- !!! КОД ВЫПОЛНЯЕТСЯ В SQLPLUS !!! ----
select PRIVILEGE
from sys.dba_sys_privs
where grantee = 'VAD_RL'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_RL';

-- А это можно и в SQL Developer
-- Вывести все привилегии
select * from dba_sys_privs

-- Вывести все роли
select * from dba_roles



-----------------------------------------  TASK 6  -------------------------------------------

-- !!! КОД ВЫПОЛНЯЕТСЯ В SQLPLUS !!! --
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

-- !!! ВСЕ КОМАНДЫ 7-ГО ЗАДАНИЯ В SQLPLUS !!! --
-- Список всех профилей
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles;

-- Список параметров нашего профиля
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles where PROFILE = 'VAD_PFCORE';

-- Список параметров профиля default
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles where PROFILE = 'DEFAULT';



-----------------------------------------  TASK 8  -------------------------------------------

---- !!! ЭТО ВЫПОЛНЯЕМ В SQLPLUS А НЕ В SQLDEVELOPER !!! ----
-- Сначала надо создать тейблспейс в PDB:
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












