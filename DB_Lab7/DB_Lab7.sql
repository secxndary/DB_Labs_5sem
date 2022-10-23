-- 1.	Получите полный список фоновых процессов. 
select paddr, name, description from v$bgprocess order by name;

-- 2.	Определите фоновые процессы, которые запущены и работают в настоящий момент.
select sid, process, name, description, program
from v$session s join v$bgprocess using (paddr)
where s.status = 'ACTIVE';
  
-- 3.	Определите, сколько процессов DBWn работает в настоящий момент.
show parameter db_writer_processes;

-- 4.	Получите перечень текущих соединений с экземпляром.
select USERNAME, SID, STATUS, SERVER, MACHINE, PROGRAM from v$session order by USERNAME, SID;

-- 5.	Определите режимы этих соединений.
select USERNAME, SID, STATUS, SERVER from v$session order by USERNAME, SID;

-- 6.	Определите сервисы (точки подключения экземпляра).
select NAME, NETWORK_NAME, PDB from v$services;

-- 7.	Получите известные вам параметры диспетчера и их значений.
alter system set max_dispatchers = 10;
show parameter dispatcher;

-- 8.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
-- services.msc -> OracleOraDB12Home1TNSListener

-- 9.	Получите перечень текущих соединений с инстансом. (dedicated, shared). 
select USERNAME, sid, PADDR, PROCESS, SERVER, STATUS, PROGRAM from v$session where USERNAME is not null;
select ADDR, SPID, PNAME from v$process order by ADDR;

-- 10.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
-- C:\app\oraora\product\12.1.0\dbhome_1\NETWORK\ADMIN\listener.ora

-- 11.	Запустите утилиту lsnrctl и поясните ее основные команды. 
-- start, stop, status, services, version, reload, save_config, trace, quit, exit, set, show

-- 12.	Получите список служб инстанса, обслуживаемых процессом LISTENER. 
-- lsnrctl -> services
