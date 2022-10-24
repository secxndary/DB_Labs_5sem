-- Чтобы подключиться к PDB:
alter session set container = PDBORCL;
-- Чтобы переключаться обратно в CDB:
alter session set container = CDB$ROOT;


-- 2. Получить перечень параметров экземпляра Oracle
select NAME, DESCRIPTION, VALUE from v$parameter;


-- 3.	Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM
--    SQLPLUS:   conn system/password@//localhost:1521/PDBORCL;    (ezconnect)
--    В самом верху еще один способ коннекта к PDB

-- Список табличных пространств:
select * from dba_tablespaces;

-- Файлы табличных простарнств:
select TABLESPACE_NAME, FILE_NAME from dba_data_files;

-- Список ролей:
select * from dba_roles;

-- Список пользователей:
select * from dba_data_files;



-- 5. Строка подключения через system
-- conn system/GxJKl7355@pdb_lab8;


-- 6. Строка подключения через созданного юзера 
-- (в склплюс conn vadcore /as sysdba и дать права create session во всех pdb\cdb)
-- conn VADCORE/GxJKl7355@vadcore_lab8          (vad_pdb)
-- conn VADCORE/GxJKl7355@vadcore_cdb_lab8      (cdb$root)


-- 7. select к таблице юзера VADCORE (выполняется от юзера VADCORE в CDB$ROOT)
select * from VADCORE_SONGS;


-- 8. Ознгакомтесь с help, получите справку по timing
-- help timing — справка по команде
-- команды ниже вставляются в склплюс одновременно, с энтером после последней строчки:
timi start;
select * from dba_roles;
timi stop;


-- 9. Ознакомьтесь с командной describe
-- desc [название таблицы\вьюхи] — покажет структуру таблицы; столбцы и их data type
desc dba_tablespaces;


-- 10. Сегменты пользователя
select * from user_segments;


-- 11. Представление с сегментами, экстентами, блоками и их размерами
create view vadcore_segments as
select count(segment_name) кол_во_сегментов, sum(extents) кол_во_экстентов, 
sum(blocks) кол_во_блоков, sum(bytes) размер_в_байтах
from user_segments;

select * from vadcore_segments;