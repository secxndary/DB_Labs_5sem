--drop table VAD_t1
--drop table VAD_t

create table VAD_t 
(
  x number(3),
  s varchar2(50),
  PRIMARY KEY (s)
);
insert into VAD_t values (12, 'kanye');
insert into VAD_t values (42, 'west');
insert into VAD_t values (99, 'geniy');
insert into VAD_t values (100, 'no cap');
commit;
update VAD_t set x = 288 where s = 'kanye';
update VAD_t set s = 'genius' where x = 99;
commit;
select count(*) Кол_во_строк from VAD_t T where x > 80;
delete from VAD_t where s = 'west';
commit;

create table VAD_t1 (
  person varchar2(50),
  masterpiece varchar2(50),
  FOREIGN KEY (person) REFERENCES VAD_t (s) 
);

insert into VAD_t1 values ('kanye', 'ghost town');
insert into VAD_t1 values ('kanye', 'runaway');
insert into VAD_t1 values ('kanye', 'on sight');
insert into VAD_t1 values ('kanye', 'bound 2');
insert into VAD_t1 values ('kanye', 'touch the sky');
insert into VAD_t1 values ('kanye', 'all of the lights');

insert into VAD_t1 values ('genius', 'blvrd depo');
insert into VAD_t1 values ('genius', 'antoxa dimitriadi');
insert into VAD_t1 values ('genius', '163onmyneck');
insert into VAD_t1 values ('genius', 'dora');
insert into VAD_t1 values ('genius', 'machiine girl');
insert into VAD_t1 values ('genius', 'luna');
insert into VAD_t1 values ('genius', 'cream soda');
insert into VAD_t1 values ('genius', 'convolk');

select t0.x, t1.person, t1.masterpiece 
from VAD_t t0 join VAD_t1 t1 
on t0.s = t1.person
order by t1.person, t1.masterpiece;

select t0.x, t0.s, t1.masterpiece 
from VAD_t t0 left join VAD_t1 t1 
on t0.s = t1.person
where t0.x > 99
order by t0.s desc, t1.masterpiece;

select t0.s, t1.masterpiece
from VAD_t1 t1 right join VAD_t t0
on t0.s = t1.person
where t0.s in ('no cap', 'genius')
order by t0.s desc;

