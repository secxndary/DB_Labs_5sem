-- 1. Даем нашему юзеру все необходимые привилегии
grant connect, create table, create view, create sequence, create cluster,
create synonym, create public synonym, create materialized view TO VAD_PDB_SYS_USER;

-- Проверяем, что все ок
select PRIVILEGE
from DBA_SYS_PRIVS
where GRANTEE = 'VAD_PDB_SYS_USER'
union
select PRIVILEGE 
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'VAD_PDB_SYS_USER';



-- 2. Создать обрыганскую последовательность
drop sequence VAD_PDB_SYS_USER.S1;

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
drop sequence VAD_PDB_SYS_USER.S2;

create sequence VAD_PDB_SYS_USER.S2
start with 10
increment by 10
maxvalue 100
nocycle;

select VAD_PDB_SYS_USER.S2.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S2.CURRVAL from DUAL;



--4. Обратная последовательность с попыткой выхода за минимальное значение
drop sequence VAD_PDB_SYS_USER.S3;

create sequence VAD_PDB_SYS_USER.S3
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

select VAD_PDB_SYS_USER.S3.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S3.CURRVAL from DUAL;



--5. Циклическая последовательность от 1 до 10
drop sequence VAD_PDB_SYS_USER.S4;

create sequence VAD_PDB_SYS_USER.S4
start with 1
increment by 1
maxvalue 10
cycle
cache 5
noorder;

select VAD_PDB_SYS_USER.S4.NEXTVAL from DUAL;
select VAD_PDB_SYS_USER.S4.CURRVAL from DUAL;



--6. Список принадлежащих юзеру последловательностей (тот же коннекшен)
select * from ALL_SEQUENCES where SEQUENCE_OWNER like 'VAD%'



-- 7. Вставить в таблицу значения последовательностей
create table T1
(
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
) cache storage (buffer_pool keep);

begin
    for i in 1..7 loop
        insert into T1(N1, N2, N3, N4) values 
        (
            VAD_PDB_SYS_USER.S1.NEXTVAL, VAD_PDB_SYS_USER.S2.NEXTVAL,
            VAD_PDB_SYS_USER.S3.NEXTVAL, VAD_PDB_SYS_USER.S4.NEXTVAL
        );
    end loop;
end;

select * from T1;
drop table T1;



-- 8. Создать кластер
drop cluster VAD_PDB_SYS_USER.ABC;

create cluster VAD_PDB_SYS_USER.ABC 
(
    X number(10),
    V varchar2(12)
)
hashkeys 200 
tablespace VAD_TS_PDB;



-- 9-11. Таблицы A B и C
create table A
(
    XA number(10),
    VA varchar(12),
    TITLE varchar(200)
)
cluster VAD_PDB_SYS_USER.ABC(XA, VA);

create table B
(
    XB number(10),
    VB varchar(12),
    ALBUM varchar(200)
)
cluster VAD_PDB_SYS_USER.ABC(XB, VB);

create table C
(
    XC number(10),
    VC varchar(12),
    ARTIST varchar(200)
)
cluster VAD_PDB_SYS_USER.ABC(XC, VC);