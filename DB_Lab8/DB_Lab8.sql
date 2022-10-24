-- ����� ������������ � PDB:
alter session set container = PDBORCL;
-- ����� ������������� ������� � CDB:
alter session set container = CDB$ROOT;


-- 2. �������� �������� ���������� ���������� Oracle
select NAME, DESCRIPTION, VALUE from v$parameter;


-- 3.	����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM
--    SQLPLUS:   conn system/password@//localhost:1521/PDBORCL;    (ezconnect)
--    � ����� ����� ��� ���� ������ �������� � PDB

-- ������ ��������� �����������:
select * from dba_tablespaces;

-- ����� ��������� �����������:
select TABLESPACE_NAME, FILE_NAME from dba_data_files;

-- ������ �����:
select * from dba_roles;

-- ������ �������������:
select * from dba_data_files;



-- 5. ������ ����������� ����� system
-- conn system/GxJKl7355@pdb_lab8;


-- 6. ������ ����������� ����� ���������� ����� 
-- (� ������� conn vadcore /as sysdba � ���� ����� create session �� ���� pdb\cdb)
-- conn VADCORE/GxJKl7355@vadcore_lab8          (vad_pdb)
-- conn VADCORE/GxJKl7355@vadcore_cdb_lab8      (cdb$root)


-- 7. select � ������� ����� VADCORE (����������� �� ����� VADCORE � CDB$ROOT)
select * from VADCORE_SONGS;


-- 8. ������������ � help, �������� ������� �� timing
-- help timing � ������� �� �������
-- ������� ���� ����������� � ������� ������������, � ������� ����� ��������� �������:
timi start;
select * from dba_roles;
timi stop;


-- 9. ������������ � ��������� describe
-- desc [�������� �������\�����] � ������� ��������� �������; ������� � �� data type
desc dba_tablespaces;


-- 10. �������� ������������
select * from user_segments;


-- 11. ������������� � ����������, ����������, ������� � �� ���������
create view vadcore_segments as
select count(segment_name) ���_��_���������, sum(extents) ���_��_���������, 
sum(blocks) ���_��_������, sum(bytes) ������_�_������
from user_segments;

select * from vadcore_segments;