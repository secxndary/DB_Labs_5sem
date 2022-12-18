-- Заметки для себя: используется соединение SYSTEM_Connection (user: system, sid: orcl), всего триггеров: 18
-- Вывести все триггеры:
select OBJECT_NAME, STATUS from USER_OBJECTS where OBJECT_TYPE = 'TRIGGER';



-- 0. Установить формат даты для сессии
alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';


-- 1. Создать таблицу
    create table SEMESTER_5 (SUBJECT varchar(200) primary key, EXAMS varchar(100));


-- 2. Заполнить 10 строками
    delete SEMESTER_5;
    insert into SEMESTER_5 values ('ПСКП', 'экзамен');
    insert into SEMESTER_5 values ('БД',   'экзамен');
    insert into SEMESTER_5 values ('НПО',  'экзамен');
    insert into SEMESTER_5 values ('БЖЧ',  'экзамен');
    insert into SEMESTER_5 values ('ОСИ',  'зачет');
    insert into SEMESTER_5 values ('ПБСП', 'зачет');
    insert into SEMESTER_5 values ('СТП',  'зачет');
    insert into SEMESTER_5 values ('Физкультура', 'зачет');
    insert into SEMESTER_5 values ('Политология и идеология', 'зачет');
    
    select SUBJECT, EXAMS from SEMESTER_5;



------------------------------------------------------------------------------

    insert into SEMESTER_5 values ('Философия', 'экзамен');
    update SEMESTER_5 set EXAMS = 'зачет' where SUBJECT = 'Философия';
    delete SEMESTER_5 where SUBJECT = 'Философия';
    select * from AUDITS;
    delete AUDITS;
    
------------------------------------------------------------------------------



-- 3. Before-триггер уровня оператора
    create or replace trigger INSERT_TRIGGR_BEFORE_STATEMENT
    before insert on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] Before Insert'); 
    end;
    
    create or replace trigger UPDATE_TRIGGR_BEFORE_STATEMENT
    before update on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] Before Update'); 
    end;
    
    create or replace trigger DELETE_TRIGGR_BEFORE_STATEMENT
    before delete on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] Before Delete'); 
    end;
    
      
       
-- 5. Before-триггер уровня строки
    create or replace trigger INSERT_TRIGGER_BEFORE_ROW
    before insert on SEMESTER_5
    for each row
      begin DBMS_OUTPUT.PUT_LINE('[ROW] Before Insert'); 
    end;

    create or replace trigger UPDATE_TRIGGER_BEFORE_ROW
    before update on SEMESTER_5
    for each row
      begin DBMS_OUTPUT.PUT_LINE('[ROW] Before Update'); 
    end;

    create or replace trigger DELETE_TRIGGER_BEFORE_ROW
    before delete on SEMESTER_5
    for each row
      begin DBMS_OUTPUT.PUT_LINE('[ROW] Before Delete');
    end;
    
    
    
-- 6. Before-триггер с предикатами INSERTING, UPDATING, DELETING
    create or replace trigger TRIGGER_DML
    before insert or update or delete on SEMESTER_5
    begin
    if INSERTING then
        DBMS_OUTPUT.PUT_LINE('[DML] Before Insert');
    ELSIF UPDATING then
        DBMS_OUTPUT.PUT_LINE('[DML] Before Update');
    ELSIF DELETING then
        DBMS_OUTPUT.PUT_LINE('[DML] Before Delete');
    end if;
    end;    
    
    
    
--7. After-триггер уровня оператора
    create or replace trigger INSERT_TRIGGER_AFTER_STATEMENT
    after insert on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] After Insert'); 
    end;

    create or replace trigger UPDATE_TRIGGER_AFTER_STATEMENT
    after update on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] After Update'); 
    end;
    
    create or replace trigger DELETE_TRIGGER_AFTER_STATEMENT
    after delete on SEMESTER_5
    begin DBMS_OUTPUT.PUT_LINE('[STM] After Delete'); 
    end;



--8. After-триггер уровня строки
    create or replace trigger INSERT_TRIGGER_AFTER_ROW
    after insert on SEMESTER_5
    for each row
    begin DBMS_OUTPUT.PUT_LINE('[ROW] After Insert'); 
    end;
    
    create or replace trigger UPDATE_TRIGGER_AFTER_ROW
    after update on SEMESTER_5
    for each row
    begin DBMS_OUTPUT.PUT_LINE('[ROW] After Update'); 
    end;

    create or replace trigger DELETE_TRIGGER_AFTER_ROW
    after delete on SEMESTER_5
    for each row
    begin DBMS_OUTPUT.PUT_LINE('[ROW] After Delete'); 
    end;
    


-- 9. Таблица AUDIT
    create table AUDITS
    (
        OPERATIONDATE timestamp, 
        OPERATIONTYPE varchar2(50), 
        TRIGGERNAME varchar2(30),
        DATA varchar2(300)   
    );
    


-- 10. Изменить триггеры под таблицу AUDIT
    create or replace trigger TRIGGER_DML_AUDIT
    before insert or update or delete on SEMESTER_5
    for each row
    begin
        if INSERTING then
            DBMS_OUTPUT.PUT_LINE('[DML] Before Insert (Audit)' );
            insert into AUDITS(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, data) values
            (
                localtimestamp,
                'Insert', 
                'TRIGGER_DML_AUDIT',
                :new.SUBJECT || ' ' || :new.EXAMS
            );
        elsif UPDATING then
            DBMS_OUTPUT.PUT_LINE('[DML] Before Update (Audit)');
            insert into AUDITS(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, DATA)
            values
            (
                localtimestamp, 
                'Update', 
                'TRIGGER_DML_AUDIT',
                :old.SUBJECT || ' ' ||  :old.EXAMS || ' -> ' || :new.SUBJECT || ' ' ||  :new.EXAMS
            );
            
        elsif DELETING then
            DBMS_OUTPUT.PUT_LINE('[DML] Before Delete (Audit)');
            insert into AUDITS(OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, data)
            values
            (
                localtimestamp, 
                'Delete', 
                'TRIGGER_DML_AUDIT',
                :old.SUBJECT || ' ' ||  :old.EXAMS
            );
        end if;
    end;
    


-- 12. Удалить изначальную таблицу  (все триггеры удалились)
    drop table SEMESTER_5;


-- 12. Триггер, запрещающий удаление таблицы
    create or replace trigger TRIGGER_PREVENT_TABLE_DROP
    before drop on SYSTEM.schema
    begin
        if DICTIONARY_OBJ_NAME = 'SEMESTER_5'
        then
          RAISE_APPLICATION_ERROR (-20000, '[ERROR] You can not drop table SEMESTER_5.');
        end if;
    end; 
    
        
-- 13. Удалить таблицу AUDITS  (триггер остался, вызвалось исключение)
    drop table AUDITS;



-- 14. INSTEAD OF INSERT триггер
    create view VIEW_SEMESTER_5 as 
    select * 
    from SEMESTER_5;
    
    create or replace trigger TRIGGER_INSTEAD_OF_INSERT
    instead of insert on VIEW_SEMESTER_5
    begin
        if INSERTING then
            DBMS_OUTPUT.PUT_LINE('Instead of Update trigger called.');
            insert into SEMESTER_5 values ('ОАиП', 'экзамен');
        end if;
    end TRIGGER_INSTEAD_OF_INSERT;
    
    insert into VIEW_SEMESTER_5 values('ASP.NET', 'зачет');
    select * from VIEW_SEMESTER_5;
