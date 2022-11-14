-- 1. Даем нашему юзеру все необходимые привилегии
grant connect, create table, create view, create sequence, create cluster,
create synonym, create public synonym, create materialized view TO VAD_PDB_SYS_USER;

-- Проверяем, что все ок
select PRIVILEGE
from SYS.DBA_SYS_PRIVS
where grantee = 'VAD_PDB_SYS_USER'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_PDB_SYS_USER';



-- 2. Создать обрыганскую последовательность
create sequence VAD_PDB_SYS_USER.S1
start with 1000
increment by 10
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select VAD_PDB_SYS_USER.S1.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S1.CURRVAL from DUAL;



-- 3. Последовательность с попыткой вызода за MAXVALUE
create sequence VAD_PDB_SYS_USER.S2
start with 10
increment by 10
maxvalue 100
nocycle;

select VAD_PDB_SYS_USER.S2.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S2.CURRVAL from DUAL;



--4. Обратная последовательность с попыткой выхода за минимальное значение
create sequence VAD_PDB_SYS_USER.S3
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

select VAD_PDB_SYS_USER.S3.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S3.CURRVAL from DUAL;



--5. Последовательность 
create sequence VAD_PDB_SYS_USER.S
start with 
increment by 
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select VAD_PDB_SYS_USER.S.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S.CURRVAL from DUAL;



--6. Последовательность 
create sequence VAD_PDB_SYS_USER.S
start with 
increment by 
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select VAD_PDB_SYS_USER.S.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S.CURRVAL from DUAL;



--7. Последовательность 
create sequence VAD_PDB_SYS_USER.S
start with 
increment by 
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select VAD_PDB_SYS_USER.S.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S.CURRVAL from DUAL;



