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
-- не забывайте удалять сами файлы тейблспейсов если че (выше скрипт чтобы найти сами файлы)
create temporary tablespace VAD_TS_TEMP
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

alter session set "_ORACLE_SCRIPT" = true;
create role VAD_RL;
grant connect, create session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VAD_RL;
select * from dba_roles where ROLE like '%RL%';



-----------------------------------------  TASK 5  -------------------------------------------

-- Вывести привилегии для созданной роли XXX_RL
select PRIVILEGE
from sys.dba_sys_privs
where grantee = 'VAD_RL'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_RL';

-- Вывести все привилегии
select * from dba_sys_privs

-- Вывести все роли
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

-- Список всех профилей
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles order by PROFILE;

-- Список параметров нашего профиля
select PROFILE, RESOURCE_NAME, LIMIT from dba_profiles 
where PROFILE = 'VAD_PFCORE' order by RESOURCE_NAME;

-- Список параметров профиля default
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

-- зайдите в SQLPLUS и вам сразу должно выдаться сообщение "Enter a username",
-- вводите свой XXXCORE, вводите пароль (identified by *пароль*), и должно
-- выйти сообщение The password has expired. Enter new password"



-----------------------------------------  TASK 10  ------------------------------------------

-- даём юзеру XXXCORE привилегии
grant connect, create session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VADCORE;

-- далее создаем новое подключение и в этом подключении вводим этот код:
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



-- Код ниже выполняем в соединении VADCORE

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
