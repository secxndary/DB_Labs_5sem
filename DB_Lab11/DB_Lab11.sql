SET serveroutput OFF;   -- ON для того, чтобы вывод вместо dbms шел в консоль



-- 1. Точная выборка неявным курсором
declare
  faculty_rec faculty%rowtype;
begin
  select * into faculty_rec from faculty where faculty = 'ИЭФ';
  DBMS_OUTPUT.PUT_LINE(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;



-- 2. Обработка when others
declare
  faculty_rec faculty%rowtype;
begin
  select * into faculty_rec from faculty;   -- точная выборка, более одной строки в резалтсете
  DBMS_OUTPUT.PUT_LINE(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception when others then 
  dbms_output.put_line('[ERROR] When others: ' || sqlerrm || sqlcode);
end;



-- 3. Ошибка When too many rows
declare
  faculty_rec faculty%rowtype;
begin
  select * into faculty_rec from faculty; -- та же ошибка, только типизированная
  DBMS_OUTPUT.PUT_LINE(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
  exception
    when too_many_rows
    then DBMS_OUTPUT.PUT_LINE('[ERROR] When too_many_rows: '|| sqlerrm || sqlcode);
end;



-- 4. No_data_found, атрибуты курсора
declare
  faculty_rec faculty%rowtype;
begin
  select * into faculty_rec from faculty where faculty = 'ИЭФ'; 
  DBMS_OUTPUT.PUT_LINE(rtrim(faculty_rec.faculty)||': '||faculty_rec.faculty_name);
  
  if sql%found then
    dbms_output.put_line('%found:     true');
  else
    dbms_output.put_line('%found:     false');
  end if;
  
  if sql%isopen then
    dbms_output.put_line('$isopen:    true');
  else
    dbms_output.put_line('$isopen:    false');
  end if;
  
  if sql%notfound then
    dbms_output.put_line('%notfound:  true');
  else
    dbms_output.put_line('%notfound:  false');
  end if;
  
  dbms_output.put_line('%rowcount:  '|| sql%rowcount);
  
  exception
    when no_data_found then
      dbms_output.put_line('[ERROR] When no_data_found: ' || sqlerrm || '-' || sqlcode);
    when others then
      dbms_output.put_line(sqlerrm);
end;



-- 5-6. Update, commit, rollback, exception
select * from auditorium order by auditorium;
begin
  update AUDITORIUM set 
    auditorium='500-5',
    auditorium_name = '500-5',
    auditorium_capacity = 90,
    auditorium_type = 'ЛК-К'
  where auditorium='429-4';
  --commit;    
  rollback;
  dbms_output.put_line('[OK] Successfully updated.');
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;



-- 7-8. Insert, commit, rollback, exception
select * from auditorium order by auditorium;
begin
  insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type)
  values('505-5', '505-5', 80, 'ЛК-К');
  --commit;    
  rollback;
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;



-- 9-10. Delete, commit, rollback, exception
select * from AUDITORIUM order by AUDITORIUM;
begin
  delete from auditorium where auditorium = '505-5';
  if(sql%rowcount= 0) then
    raise no_data_found;
  end if;
  --commit;
  rollback;
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;



-- 11. Явный курсор, данные в переменные (%type)   [TEACHER]
declare
  cursor curs_teacher is 
    select teacher, teacher_name, pulpit 
    from teacher;
  m_teacher teacher.teacher%type;
  m_teacher_name teacher.teacher_name%type;
  m_pulpit teacher.pulpit%type;
begin
  open curs_teacher;
  DBMS_OUTPUT.PUT_LINE('rowcount = '||curs_teacher%rowcount);
    loop
    fetch curs_teacher into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teacher%notfound;
      DBMS_OUTPUT.PUT_LINE(' '||curs_teacher%rowcount||' '
      ||m_teacher||' '
      ||m_teacher_name||' '
      ||m_pulpit);
    end loop;
  DBMS_OUTPUT.PUT_LINE('rowcount = '||curs_teacher%rowcount);
  close curs_teacher;
exception when others then
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;



-- 12. Явный курсор, данные в запись (%rowtype)   [SUBJECT]
declare
  cursor curs_subject is
    select subject, subject_name, pulpit 
    from subject;
  rec_subject subject%rowtype;
begin
  open curs_subject;
  DBMS_OUTPUT.PUT_LINE('rowcount = '||curs_subject%rowcount);
  fetch curs_subject into rec_subject;
  while (curs_subject%found)
  loop
    DBMS_OUTPUT.PUT_LINE(' '||curs_subject%rowcount||' '
    ||rec_subject.subject||' '
    ||rec_subject.subject_name||' '
    ||rec_subject.pulpit);
    fetch curs_subject into rec_subject;
  end loop;
  DBMS_OUTPUT.PUT_LINE('rowcount = '|| curs_subject%rowcount);
  close curs_subject;
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;



-- 13. Цикл FOR     [PULPIT join TEACHER]
declare
  cursor curs_pulpit is
    select pulpit.pulpit, teacher.teacher_name 
    from pulpit join teacher 
    on pulpit.pulpit = teacher.pulpit;
  rec_pulpit curs_pulpit%rowtype;
begin
  for rec_pulpit in curs_pulpit
  loop
    dbms_output.put_line(' ' ||curs_pulpit%rowcount||' '
    ||rec_pulpit.pulpit||' '
    ||rec_pulpit.teacher_name);
  end loop;
  exception when others then 
    dbms_output.put_line(sqlerrm);
end;



-- 14. Курсор с параметрами
declare
  cursor curs_auditorium(minCapacity number, maxCapacity number) is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >= minCapacity 
    and auditorium_capacity <= maxCapacity;
  curs_row curs_auditorium%rowtype;
begin
  dbms_output.put_line('CAPACITY < 20');
  for aum in curs_auditorium(0,20)
  loop
    dbms_output.put_line(' '||aum.auditorium||' '||aum.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('CAPACITY between 20 and 30');
  for aum in curs_auditorium(20,30)
  loop
    dbms_output.put_line(' '||aum.auditorium||' '||aum.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('CAPACITY between 30 and 60 ');
  for aum in curs_auditorium(30,60)
  loop
    dbms_output.put_line(' '||aum.auditorium||' '||aum.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('CAPACITY between 60 and 80 ');
  for aum in curs_auditorium(60,80)
  loop
    dbms_output.put_line(' '||aum.auditorium||' '||aum.auditorium_capacity);
  end loop;
  
  dbms_output.put_line('CAPACITY > 80 ');
  for aum in curs_auditorium(80,1000)
  loop
    dbms_output.put_line(' '||aum.auditorium||' '||aum.auditorium_capacity);
  end loop;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



-- 15. Ref cursor (with return)
declare
  type auditorium_ref is ref cursor return auditorium%rowtype;
  xcurs auditorium_ref;
  xcurs_row xcurs%rowtype;
begin
  open xcurs for select * from auditorium;
  fetch xcurs into xcurs_row;
  loop
    exit when xcurs%notfound;
    dbms_output.put_line(' '||xcurs_row.auditorium||' '||xcurs_row.auditorium_capacity);
    fetch xcurs into xcurs_row;
  end loop;
  close xcurs;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



-- 16. Курсорный подзапрос
declare
  cursor curs_aut
  is 
    select auditorium_type, cursor
    (
      select auditorium
      from auditorium aum
      where aut.auditorium_type = aum.auditorium_type
    )
    from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  txt varchar2(1000);
  aum auditorium.auditorium%type;
begin
  open curs_aut;
  fetch curs_aut into aut, curs_aum;
  while(curs_aut%found)
  loop
    txt:=rtrim(aut)||': ';
    
    loop
      fetch curs_aum into aum;
      exit when curs_aum%notfound;
      txt := txt||rtrim(aum)||'; ';
    end loop;
    
    dbms_output.put_line(txt);
    fetch curs_aut into aut, curs_aum;
  end loop;
  
  close curs_aut;
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



-- 17. Уменьшить вместимость на 10% (Update current of)
select * from auditorium order by auditorium;
declare
  cursor curs_auditorium(capacity auditorium.auditorium%type, capac auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >=capacity 
    and AUDITORIUM_CAPACITY <= capacity
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open curs_auditorium(40,80);
  fetch curs_auditorium into aum, cty;
  
  while(curs_auditorium%found)
  loop
    cty := cty * 0.9;
      update auditorium 
      set auditorium_capacity = cty 
      where current of curs_auditorium;
    dbms_output.put_line(' '||aum||' '||cty);
    fetch curs_auditorium into aum, cty;
  end loop;
  
  close curs_auditorium;
  rollback;
  exception when others then
   dbms_output.put_line(sqlerrm);
end;



-- 18. Удалить аудитории меньше 20 (Delete current of)
select * from auditorium order by auditorium;
declare
  cursor curs_auditorium(minCapacity auditorium.auditorium%type, maxCapacity auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >= minCapacity 
    and AUDITORIUM_CAPACITY <= maxCapacity 
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open curs_auditorium(0,20);
  fetch curs_auditorium into aum, cty;
  
  while(curs_auditorium%found)
  loop
    delete auditorium 
    where current of curs_auditorium;
    fetch curs_auditorium into aum, cty;
  end loop;
  close curs_auditorium;
  
  for pp in curs_auditorium(0,120)
  loop
    dbms_output.put_line(' '||pp.auditorium|| ' '||pp.auditorium_capacity);
  end loop;
  --rollback;
  exception
  when others then
    dbms_output.put_line(sqlerrm);
end;



-- 19. Псевдостолбец RowId, RowNum
select * from auditorium order by auditorium;
declare
  cursor curs_auditorium(capacity auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity, rowid 
    from auditorium
    where auditorium_capacity >= capacity
    and rownum <= 3
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  for aud in curs_auditorium(50)
  loop
    case
      when aud.auditorium_capacity >= 90 then
        delete auditorium where rowid = aud.rowid;
      when aud.auditorium_capacity >=50 then
        update auditorium 
        set auditorium_capacity = auditorium_capacity+10
        where rowid = aud.rowid;
    end case;
  end loop;
  
  for yyy in curs_auditorium(50)
  loop
    dbms_output.put_line(rtrim(yyy.auditorium) || '   ' || rtrim(yyy.auditorium_capacity) || '   ' || yyy.rowid);
  end loop;
  
  rollback;
  exception when others then
    dbms_output.put_line(sqlerrm);
end;



-- 20. TEACHER в группе по три
declare
  cursor curs_teacher is
    select teacher, teacher_name, pulpit 
    from teacher;
  m_teacher teacher.teacher%type;
  m_teacher_name teacher.teacher_name%type;
  m_pulpit teacher.pulpit%type;
  k integer :=1;
begin
  open curs_teacher;
  loop
    fetch curs_teacher into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teacher%notfound;
    DBMS_OUTPUT.PUT_LINE(' '||curs_teacher%rowcount ||' ' || m_teacher ||' ' || m_teacher_name || ' ' || m_pulpit);
    if (k mod 3 = 0) then DBMS_OUTPUT.PUT_LINE('-------------------------------------------'); end if;
    k:=k+1;
  end loop;
  close curs_teacher;
  
  exception when others then
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
end;



