-- 1. Список всех файлов табличных пространств 
select FILE_ID, TABLESPACE_NAME, FILE_NAME from DBA_DATA_FILES;
select * from DBA_DATA_FILES;


-- 2. Создать VAD_QDATA, дать VADCORE квоту на тейблспейс и создать таблицу
create tablespace VAD_QDATA
  datafile 'VAD_QDATA.dbf'
  size 10M
  offline;

select TABLESPACE_NAME, STATUS, contents from DBA_TABLESPACES;

alter tablespace VAD_QDATA ONLINE;

alter user VAD_PDB_SYS_USER quota 2M on VAD_QDATA;


-- Код ниже выполняем в соединении VADCORE
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


-- 3. Сегменты VAD_QDATA и сегменты, относящиеся к нашей таблице
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, blocks, extents 
from USER_SEGMENTS
where SEGMENT_NAME like '%VAD%';


-- 4. Удалить таблицу и просмотреть сегменты и корзину
drop table VADCORE_SONGS;
select * from USER_RECYCLEBIN;
purge table VADCORE_SONGS;  -- очистка корзины USER_RECYCLEBIN и удаление сегмента


-- 5. Восстановление таблицы
flashback table VADCORE_SONGS to before drop;


-- 6. Вставить 10000 строк в таблицы
begin
  for x in 8..10008
  LOOP
    insert into VADCORE_SONGS values(x, 'Genius', 'Kanye West');
  end loop;
end;

select count(*) from VADCORE_SONGS;



-- 7. Сколько экстентов в таблице, их размер в блоках и байтах
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS 
from USER_SEGMENTS
where SEGMENT_NAME = 'VADCORE_SONGS';

-- Список всех экстентов
select * from USER_EXTENTS
where TABLESPACE_NAME = 'VAD_QDATA';



-- 8. Удалить тейблспейс и его файл
drop tablespace VAD_QDATA including contents and datafiles;


-- 9. Группа журналов повтора [здесь и далее — SYSDBA connection]
select * from V$LOG order by GROUP#;


-- 10. Все журналы повтора инстанса
select * from V$LOGFILE order by GROUP#;


-- 11. Пройти цикл журнала переключений 
-- (выполняем switch logfile для переключения на следующую группу: 1-> 2 -> 3)
alter system switch logfile;
select * from V$LOG order by GROUP#;


-- 12. Создать свою группу журналов повтора и 3 журнала в ней
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

select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;


-- 13. Удалить созданную группу журналов повтора
alter database drop logfile member 'C:\app\oraora\oradata\orcl\REDO04_2.LOG';
alter database drop logfile member 'C:\app\oraora\oradata\orcl\REDO04_1.LOG';
alter database drop logfile group 4;

select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;


-- 14. Проверить, выполняется ли архивирование
-- Должны быть значения: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;


-- 15. Номер последнего архива (при отсутствии архивирования - таблица пустая)
select * from V$ARCHIVED_LOG;


-- 16. Включить архивирование
--      SQLPLUS:
-- connect /as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;

-- Теперь будут значения: LOG_MODE = ARCHIVEMODE; ARCHIVER = STARTED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;



-- 17. Теперь тут должны появиться файлы архивации
-- (для их создания можно просто переключиться между 
-- журналами повтора и файлы автоматически создадутся)
select * from V$ARCHIVED_LOG;


-- 18. Отключить архивирование
--      SQLPLUS:
-- connect /as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database noarchivelog;
-- alter database open;

-- Теперь опять будут значения: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, name, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;



-- 19. Список управляющих файлов
select * from V$CONTROLFILE;


-- 20. Параметры управляющего файла CONTROL01.ctl
show parameter control;
select * from V$CONTROLFILE_RECORD_SECTION;


-- 21. Местоположение файла параметров SPFILE.ora
-- C:\APP\ORAORA\PRODUCT\12.1.0\DBHOME_3\DATABASE\SPFILEORCL.ORA
show parameter spfile;
select NAME, DESCRIPTION from V$PARAMETER;


-- 22. Создать собственный файл параметров
-- C:\app\oraora\product\12.1.0\dbhome_3\database\VAD_PFILE.ora
create pfile = 'VAD_PFILE.ora' from spfile;


-- 23. Файл паролей
select * from V$PWFILE_USERS;     -- пользователи и их роли в файле паролей
show parameter remote_login_passwordfile;   -- exclusive/shared/none


-- 24. Файл сообщений (протоколы работы, дампы, трассировки)
select * from V$DIAG_INFO;


-- 25. Файл протокола работы инстанса LOG.xml
-- C:\app\oraora\diag\rdbms\orcl\orcl\alert\log.xml