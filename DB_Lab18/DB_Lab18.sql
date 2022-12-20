-- sqlldr system/GxJKl7355 CONTROL=ORDRS.ctl

drop table ORDRS;

create table ORDRS
(
    ORDER_NUM integer primary key,
    ORDER_DATE date,
    PRODUCT varchar2(10),
    AMOUNT float,
    TEXT clob,
    IMG blob,
    F_NAME varchar2(30),
    I_NAME varchar2(30) 
);

update ORDRS set TEXT = UPPER(TEXT);
update ORDRS set AMOUNT = ROUND(AMOUNT, 3);

select * from ORDRS;