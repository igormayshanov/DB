USE [university]
--1.�������� ������� �����
ALTER TABLE [university].[dbo].[student]
	ADD CONSTRAINT FK_student_id_group FOREIGN KEY (id_group)
		REFERENCES [university].[dbo].[group] (id_group)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [university].[dbo].[mark]
	ADD CONSTRAINT FK_mark_id_student FOREIGN KEY (id_student)
		REFERENCES [university].[dbo].[student] (id_student)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [university].[dbo].[mark]
	ADD CONSTRAINT FK_mark_id_lesson FOREIGN KEY (id_lesson)
		REFERENCES [university].[dbo].[lesson] (id_lesson)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [university].[dbo].[lesson]
	ADD CONSTRAINT FK_mark_id_teacher FOREIGN KEY (id_teacher)
		REFERENCES [university].[dbo].[teacher] (id_teacher)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [university].[dbo].[lesson]
	ADD CONSTRAINT FK_mark_id_subject FOREIGN KEY (id_subject)
		REFERENCES [university].[dbo].[subject] (id_subject)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [university].[dbo].[lesson]
	ADD CONSTRAINT FK_mark_id_group FOREIGN KEY (id_group)
		REFERENCES [university].[dbo].[group] (id_group)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

-- 2. ������ ������ ��������� �� ����������� ���� ��� ��������� �������
-- ��������. �������� ������ ������ � �������������� view.

SELECT * FROM [dbo].[group];

SELECT * FROM [dbo].[student]
WHERE id_group = 2 OR id_group = 4;

SELECT * FROM [dbo].[subject];

SELECT * FROM [dbo].[mark]
ORDER BY id_student;

SELECT * FROM [dbo].[lesson]
WHERE id_subject = 2
ORDER BY id_lesson;

SELECT * FROM [dbo].[lesson] l
LEFT JOIN [dbo].[mark] m ON m.id_lesson = l.id_lesson
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject 
WHERE id_subject = 2
ORDER BY id_lesson;


SELECT * FROM [dbo].[teacher];

CREATE VIEW informatics_marks AS
SELECT st.name AS student, m.mark, s.name AS subject FROM student st
JOIN [dbo].[mark] m ON m.id_student = st.id_student
JOIN [dbo].[group] g ON g.id_group = st.id_group
JOIN [dbo].[lesson] l ON l.id_lesson = m.id_lesson
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
WHERE s.name = '�����������';

SELECT * FROM informatics_marks;

--3. ���� ���������� � ��������� � ��������� ������� �������� � ��������
--��������. ���������� ��������� ��������, �� ������� ������ �� ��������,
--������� ������� � ������. �������� � ���� ���������, �� �����
--������������� ������

--������� ��� ��������, ������� ������� � ������
SELECT g.name AS group_name, s.name AS subject_name FROM [dbo].[group] g
JOIN [dbo].[lesson] l ON l.id_group = g.id_group
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
GROUP BY s.name, g.name
ORDER BY g.name;

SELECT * FROM [dbo].[student] st
LEFT JOIN [dbo].[mark] m ON m.id_student = st.id_student
--JOIN [dbo].[group] g ON g.id_group = st.id_group
JOIN (SELECT g.id_group, g.name AS group_name, s.id_subject, s.name AS subject_name FROM [dbo].[group] g
		JOIN [dbo].[lesson] l ON l.id_group = g.id_group
		JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
		GROUP BY s.id_subject, s.name, g.id_group, g.name) AS gr ON gr.id_group = g.id_group

WHERE st.id_student NOT IN (SELECT m.id_student FROM [dbo].[mark] m
							LEFT JOIN [dbo].[student] st ON st.id_student = m.id_student);

CREATE PROCEDURE debtors_on_subject_by_group
	@groupID AS INT
AS
SELECT st.name AS student, s.name AS subject_name 
FROM (SELECT st.id_student, s.id_subject, COUNT(m.mark) AS mark_cnt, g.id_group  FROM [dbo].[group] g
		LEFT JOIN [dbo].[lesson] l ON l.id_group = g.id_group
		LEFT JOIN [dbo].[student] st ON st.id_group = g.id_group
		LEFT JOIN [dbo].[mark] m ON m.id_student = st.id_student AND m.id_lesson = l.id_lesson
		LEFT JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
		GROUP BY st.id_student, s.id_subject, g.id_group
		HAVING COUNT(m.mark) = 0) AS debtor
LEFT JOIN [dbo].[student] st ON st.id_student = debtor.id_student
LEFT JOIN [dbo].[subject] s ON s.id_subject = debtor.id_subject
WHERE debtor.id_group = @groupID
GO

EXECUTE debtors_on_subject_by_group @groupID = 3;

IF OBJECT_ID('debtors_on_subject_by_group','P') IS NOT NULL
	DROP PROC debtors_on_subject_by_group
GO

--4. ���� ������� ������ ��������� �� ������� �������� ��� ��� ���������, ��
-- ������� ���������� �� ����� 35 ���������.
--������� ���� �� ���������
SELECT m.id_student, m.mark FROM [dbo].[mark] m
--GROUP BY m.id_student
ORDER BY m.id_student;

--����� ��������, �� ������� ���������� �� ����� 35 ���������
SELECT s.id_subject, s.name AS subject_name, COUNT(st.id_student) AS student_cnt FROM [dbo].[lesson] l
		 JOIN [dbo].[group] g ON l.id_group = g.id_group
		 JOIN [dbo].[student] st ON st.id_group = g.id_group
		 JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
		GROUP BY s.id_subject, s.name
		HAVING COUNT(st.id_student) >= 35;

--������� ��� ��������, ������� ������� � ������
SELECT g.name AS group_name, s.name AS subject_name FROM [dbo].[group] g
JOIN [dbo].[lesson] l ON l.id_group = g.id_group
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
GROUP BY s.name, g.name
ORDER BY g.name;

SELECT s.id_subject, st.id_student, g.id_group FROM [dbo].[subject] s
JOIN [dbo].[lesson] l ON l.id_subject = s.id_subject
JOIN [dbo].[group] g ON g.id_group = l.id_group
JOIN [dbo].[student] st ON st.id_group = g.id_group
GROUP BY s.id_subject, st.id_student, g.id_group
ORDER BY s.id_subject, st.id_student, g.id_group;

SELECT g.id_group, COUNT(st.id_student) FROM [dbo].[group] g
JOIN [dbo].[student] st ON st.id_group = g.id_group
GROUP BY g.id_group

--���-�� ��������� � ������
SELECT id_group, COUNT(id_student) AS student_cnt FROM [dbo].[student]
GROUP BY id_group

SELECT l.id_subject, s.name, ROUND(AVG(CAST(m.mark AS FLOAT)), 2) AS avg_mark FROM [dbo].[lesson] l
JOIN [dbo].[mark] m ON m.id_lesson = l.id_lesson 
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
WHERE l.id_subject IN (SELECT ss.id_subject FROM (SELECT l.id_subject, sig.student_cnt FROM [dbo].[lesson] l
						JOIN (SELECT id_group, COUNT(id_student) AS student_cnt FROM [dbo].[student]
							GROUP BY id_group) AS sig ON sig.id_group = l.id_group
						GROUP BY l.id_subject, sig.student_cnt) AS ss
						GROUP BY ss.id_subject
						HAVING SUM(ss.student_cnt) >= 35)
GROUP BY l.id_subject, s.name;

--5. ���� ������ ��������� ������������� �� �� ���� ���������� ��������� �
--��������� ������, �������, ��������, ����. ��� ���������� ������ ���������
--���������� NULL ���� ������.

--������� ��� �������� ������ ��
SELECT g.name, s.name FROM [dbo].[group] g
JOIN [dbo].[lesson] l ON l.id_group = g.id_group
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
WHERE g.name = '��'
GROUP BY s.name, g.name;


SELECT g.name AS group_name, st.name AS FIO, s.name AS [subject], l.date, m.mark FROM [dbo].[student] st
LEFT JOIN [dbo].[mark] m ON m.id_student = st.id_student
LEFT JOIN [dbo].[lesson] l ON l.id_lesson = m.id_lesson
LEFT JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
LEFT JOIN [dbo].[group] g ON g.id_group = st.id_group
WHERE st.id_group IN (SELECT g.id_group FROM [dbo].[group] g
						WHERE g.name = '��'
						GROUP BY g.id_group)
ORDER BY st.name, m.id_lesson;

--6. ���� ��������� ������������� ��, ���������� ������ ������� 5 �� ��������
--�� �� 12.05, �������� ��� ������ �� 1 ����.

UPDATE mark SET mark = mark + 1
WHERE id_mark IN 
(
SELECT m.id_mark FROM [dbo].[student] st
JOIN [dbo].[mark] m ON m.id_student = st.id_student
JOIN [dbo].[lesson] l ON l.id_lesson = m.id_lesson
JOIN [dbo].[subject] s ON s.id_subject = l.id_subject
JOIN [dbo].[group] g ON g.id_group = st.id_group
WHERE l.date < '2019.05.12' 
	AND s.name = '��'
	AND m.mark < 5 
	AND st.id_group IN (SELECT g.id_group FROM [dbo].[group] g
						WHERE g.name = '��'
						GROUP BY g.id_group)
)

--7. �������� ����������� �������.
CREATE NONCLUSTERED INDEX [IX_lesson_id_subject] ON [dbo].[lesson]
(
	[id_subject] ASC
);

CREATE NONCLUSTERED INDEX [IX_mark_id_lesson] ON [dbo].[mark]
(
	[id_lesson] ASC
);

CREATE NONCLUSTERED INDEX [IX_mark_id_student] ON [dbo].[mark]
(
	[id_student] ASC
);