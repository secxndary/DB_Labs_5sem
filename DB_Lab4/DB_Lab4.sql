-----------------------------------------  TASK 1  -------------------------------------------

select * from dba_pdbs;     -- get pdbs


-----------------------------------------  TASK 2  -------------------------------------------

select * from V$INSTANCE;   -- get instaces info


-----------------------------------------  TASK 3  -------------------------------------------

select * from v$option;     -- get db components info


-----------------------------------------  TASK 4  -------------------------------------------

-- created pdb VAD_PDB with admin VAD_PDB_ADMIN using DB Configuration Assistant


-----------------------------------------  TASK 5  -------------------------------------------

select * from dba_pdbs;     -- same 1st task


-----------------------------------------  TASK 6  -------------------------------------------

-- Чтобы подключиться к нашей новой PDB в SQL Dev, надо:
-- 1. Использовать Connection с ролью админа, например SYSDBA
-- 2. В панели сверху View -> DBA
-- 3. В открывшемся окошке добавить наш Connection
-- 4. Открыть Container Database: тут все наши PDB
-- 5. Если мы назжимаем ПКМ -> Modify State и выходит close, то PDB подключена
-- 6. Все действия будут записываться именно в эту PDB
-- Это пиздеж. надо прописать строчку ниже

--alter session set container = CDB$ROOT;
alter session set container = VAD_PDB;
--alter session set optimizer_dynamic_sampling=0;


-- Tablespaces
create tablespace VAD_PDB_SYS_TS
  datafile 'VAD_PDB_SYS_TS.dbf' --change this if you need to
  size 10M
  autoextend on next 5M
  maxsize 50M;
  
create temporary tablespace VAD_PDB_SYS_TS_TEMP
  tempfile 'VAD_PDB_SYS_TS_TEMP.dbf'
  size 5M
  autoextend on next 2M
  maxsize 40M;

select * from dba_tablespaces where TABLESPACE_NAME like '%VAD%';


-- Role
create role VAD_PDB_SYS_RL;

grant connect, create session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VAD_PDB_SYS_RL;

select * from dba_roles where ROLE like '%RL%';


-- Profile
create profile VAD_PDB_SYS_PROFILE limit
  password_life_time 365
  sessions_per_user 10
  failed_login_attempts 5
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default


-- User
create user VAD_PDB_SYS_USER identified by 9900
  default tablespace VAD_PDB_SYS_TS 
  quota unlimited on VAD_PDB_SYS_TS
  temporary tablespace VAD_PDB_SYS_TS_TEMP
  profile VAD_PDB_SYS_PROFILE;

grant connect, create session, alter session, create any table, drop any table, create any view, 
drop any view, create any procedure, drop any procedure to VAD_PDB_SYS_USER; 
grant SYSDBA to VAD_PDB_SYS_USER;

select * from dba_users where USERNAME like '%VAD%';


-----------------------------------------  TASK 7  -------------------------------------------

-- Теперь надо создать Connection с этим юзером и переключиться на него
-- Create table
create table VAD_PDB_SYS_KANYE_SONGS 
(
  TITLE varchar(50),
  ALBUM varchar(50), 
  RATE number
);

insert into VAD_PDB_SYS_KANYE_SONGS values ('Runaway', 'MBDTF', 10);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Ghost Town', 'ye', 10);
insert into VAD_PDB_SYS_KANYE_SONGS values ('On Sight', 'Yeezus', 10);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Bound 2', 'Yeezus', 10);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Gold Digger', 'The Colledge Dropout', 9);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Im In It', 'Yeezus', 8);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Yikes', 'ye', 9);
insert into VAD_PDB_SYS_KANYE_SONGS values ('Gorgeous', 'MBDTF', 9);

select * from VAD_PDB_SYS_KANYE_SONGS;



-----------------------------------------  TASK 8  -------------------------------------------

select * from dba_tablespaces where TABLESPACE_NAME like 'VAD%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'VAD%';
select * from dba_sys_privs where GRANTEE like 'VAD%';
select * from dba_profiles where PROFILE like 'VAD%';
select * from dba_users where USERNAME like 'VAD%';


-----------------------------------------  TASK 9  -------------------------------------------

-- надо изменить сессию на CDB
alter session set container = CDB$ROOT;
create user C##VAD_PDB_C identified by 9900
grant connect, create session, alter session, create any table,
drop any table to C##VAD_PDB_C container = all;

-- Run this with VAD_PDB_C_Connection
create table VAD_PDB_C (num number, str varchar(40));

-- Run this with VAD_CDB_C_Connection
create table VAD_CDB_C (num number, str varchar(40));
