
--1. [PROC] Список преподов на кафедре
create or replace procedure PGET_TEACHERS (PCODE TEACHER.PULPIT%type) is
  cursor MY_CURS is
    select TEACHER_NAME, TEACHER 
    from TEACHER 
    where PULPIT = PCODE;
  T_NAME TEACHER.TEACHER_NAME%type;
  T_CODE TEACHER.TEACHER%type;
begin
  open MY_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(T_CODE||' '||T_NAME);
    FETCH MY_CURS into T_NAME, T_CODE;
    EXIT when MY_CURS%NOTFOUND;
  end LOOP;
  close MY_CURS;
end;


begin
    PGET_TEACHERS('ИСиТ');
end;



--2. [FUNC] Кол-во преподов на определенной кафедре
create or replace function FGET_NUM_TEACHERS(PCODE TEACHER.PULPIT%type)
  return number is
    TCOUNT number;
begin
  select COUNT(*) 
  into TCOUNT 
  from TEACHER 
  where PULPIT = PCODE;
  
  return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE(FGET_NUM_TEACHERS('ИСиТ'));
end;



--3. [PROC] Список преподов на факультете
create or replace procedure PGET_TEACHERS(FCODE FACULTY.FACULTY%type) is
  cursor MY_CURS is
    select T.TEACHER_NAME, T.TEACHER, P.FACULTY
    from TEACHER T
    join PULPIT P
      on T.PULPIT = P.PULPIT
    where P.FACULTY = FCODE;
  T_NAME TEACHER.TEACHER_NAME%type;
  T_CODE TEACHER.TEACHER%type;
  T_FACULTY PULPIT.FACULTY%type;
begin
  open MY_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(T_NAME || ' ' || rtrim(T_CODE) || ' ' || T_FACULTY);
    FETCH MY_CURS into T_NAME, T_CODE, T_FACULTY;
    EXIT when MY_CURS%NOTFOUND;
  end LOOP;
  close MY_CURS;
end;


begin
    PGET_TEACHERS('ИДиП');
end;



-- 4. [PROC] Дисциплины на кафедре
create or replace procedure PGET_SUBJECTS (PCODE SUBJECT.PULPIT%type) is
  cursor MY_CURS is
    select SUBJECT, SUBJECT_NAME, S.PULPIT
    from SUBJECT S
    where S.PULPIT = PCODE;
  S_SUBJECT SUBJECT.SUBJECT%type;
  S_SUBJECT_NAME SUBJECT.SUBJECT_NAME%type;
  S_PULPIT SUBJECT.PULPIT%type;
begin
  open MY_CURS;
  LOOP
    DBMS_OUTPUT.PUT_LINE(S_SUBJECT || ' ' || S_SUBJECT_NAME || ' ' || S_PULPIT);
    FETCH MY_CURS into S_SUBJECT, S_SUBJECT_NAME, S_PULPIT;
    EXIT when MY_CURS%NOTFOUND;
  end LOOP;
  close MY_CURS;
end;


begin
  PGET_SUBJECTS('ИСиТ');
end;



--5. [FUNC] Кол-во преподов на факультете
create or replace function FGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type)
  return number is
    TCOUNT number;
begin
  select COUNT(*) 
  into TCOUNT 
  from TEACHER T
  join PULPIT P
    on T.PULPIT = P.PULPIT
  where P.FACULTY = FCODE;
  
  return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE('Кол-во преподавателей на факультете: ' || FGET_NUM_TEACHERS('ИДиП'));
end;



-- 6. [FUNC] Кол-во дисциплин на кафедре
create or replace function FGET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%type)
  return number is
    TCOUNT number := 0;
begin
    select COUNT(*) 
    into TCOUNT
    from SUBJECT
    where SUBJECT.PULPIT = PCODE;
    
    return TCOUNT;
end;


begin
  DBMS_OUTPUT.PUT_LINE('Кол-во предметов на кафедре: ' || FGET_NUM_SUBJECTS('ИСиТ'));
end;



--7. [PACKAGE] Пакет с процедурами и функциями
create or replace package TEACHERS as
  FCODE FACULTY.FACULTY%type;
  PCODE SUBJECT.PULPIT%type;
  procedure PGET_TEACHERS(FCODE FACULTY.FACULTY%type);
  procedure PGET_SUBJECTS (PCODE SUBJECT.PULPIT%type);
  function FGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number;
  function FGET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%type) return number;
end TEACHERS;



-- Тело пакета
create or replace package body TEACHERS as
  function FGET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number
    is TCOUNT number;
      begin
        select COUNT(*) 
        into TCOUNT 
        from TEACHER T
        join PULPIT P
          on T.PULPIT = P.PULPIT
        where P.FACULTY = FCODE;
        return TCOUNT;
      end FGET_NUM_TEACHERS;
      
  function FGET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%type)
    return number is
    TCOUNT number:=0;
    begin
      select COUNT(*) 
      into TCOUNT
      from SUBJECT
      where SUBJECT.PULPIT = PCODE;
      return TCOUNT;
    end FGET_NUM_SUBJECTS;
    
  procedure PGET_SUBJECTS (PCODE SUBJECT.PULPIT%type) is
    cursor MY_CURS is
      select SUBJECT, SUBJECT_NAME, S.PULPIT
      from SUBJECT S
      where S.PULPIT = PCODE;
      S_SUBJECT SUBJECT.SUBJECT%type;
      S_SUBJECT_NAME SUBJECT.SUBJECT_NAME%type;
      S_PULPIT SUBJECT.PULPIT%type;
    begin
      open MY_CURS;
      LOOP
        DBMS_OUTPUT.PUT_LINE(S_SUBJECT || ' ' || S_SUBJECT_NAME || ' ' || S_PULPIT);
        FETCH MY_CURS into S_SUBJECT, S_SUBJECT_NAME, S_PULPIT;
        EXIT when MY_CURS%NOTFOUND;
      end LOOP;
      close MY_CURS;
    end PGET_SUBJECTS;
    
  procedure PGET_TEACHERS(FCODE FACULTY.FACULTY%type) is
    cursor MY_CURS is
      select T.TEACHER_NAME, T.TEACHER, P.FACULTY
      from TEACHER T
      join PULPIT P
        on T.PULPIT = P.PULPIT
      where P.FACULTY = FCODE;
      T_NAME TEACHER.TEACHER_NAME%type;
      T_CODE TEACHER.TEACHER%type;
      T_FACULTY PULPIT.FACULTY%type;
    begin
      open MY_CURS;
      LOOP
        DBMS_OUTPUT.PUT_LINE(T_NAME || ' ' || rtrim(T_CODE) || ' ' || T_FACULTY);
        FETCH MY_CURS into T_NAME, T_CODE, T_FACULTY;
        EXIT when MY_CURS%NOTFOUND;
      end LOOP;
      close MY_CURS;
    end PGET_TEACHERS;
end TEACHERS;
  


-- 8. Выполнение пакета 
begin
  DBMS_OUTPUT.PUT_LINE('Кол-во преподавателей на факультете: ' || TEACHERS.FGET_NUM_TEACHERS('ИДиП'));
  DBMS_OUTPUT.PUT_LINE('Кол-во предметов на кафедре: ' || TEACHERS.FGET_NUM_SUBJECTS('ИСиТ'));
  TEACHERS.PGET_TEACHERS('ИДиП');
  TEACHERS.PGET_SUBJECTS('ИСиТ');
end;
