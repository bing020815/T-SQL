--------------------------------
-----  Environment Setup   -----
--------------------------------

-- Create a customized database
if not exists(select * from sys.databases where name = 'mydatabase')
    CREATE DATABASE [mydatabase];
Use mydatabase
GO

-- A list of current database
SELECT name FROM sys.databases
GO

-- Create a groceries tables
if exists(select * from sys.objects where name = 'groceries')
    DROP TABLE [dbo].[groceries]

CREATE TABLE [dbo].[groceries] (
	id INTEGER PRIMARY KEY, 
	name VARCHAR(40), 
	quantity INTEGER, 
	aisle INTEGER);
INSERT INTO groceries VALUES (1, 'Bananas', 56, 7);
INSERT INTO groceries VALUES(2, 'Peanut Butter', 1, 2);
INSERT INTO groceries VALUES(3, 'Dark Chocolate Bars', 2, 2);
INSERT INTO groceries VALUES(4, 'Ice cream', 1, 12);
INSERT INTO groceries VALUES(5, 'Cherries', 6, 2);
INSERT INTO groceries VALUES(6, 'Chocolate syrup', 1, 4);
GO

-- Create a exercise_logs tables with auto-increment feature
if exists(select * from sys.objects where name = 'exercise_logs')
    DROP TABLE [dbo].[exercise_logs]
CREATE TABLE exercise_logs(
	id INT IDENTITY(1,1) PRIMARY KEY,  --IDENTITY keyword to perform an auto-increment feature. The starting value is 1, and it will increment by 1.
    type VARCHAR(30),
    minutes INT, 
    calories INT,
    heart_rate INT
	);

INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('biking', 30, 100, 110);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('biking', 10, 30, 105);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('dancing', 15, 200, 120);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('dancing', 15, 165, 120);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('tree climbing', 30, 70, 90);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('tree climbing', 25, 72, 80);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('rowing', 30, 70, 90);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ('hiking', 60, 80, 85);
GO
-- Create a drs_favorites tables with auto-increment feature that can be combined with exercise_logs table
if exists(select * from sys.objects where name = 'drs_favorites')
    DROP TABLE [dbo].[drs_favorites]
CREATE TABLE drs_favorites
    (id INTEGER IDENTITY(1,1) PRIMARY KEY,
    type varchar(30),
    reason TEXT);   -- TEXT type can be use LIKE operator to search but cannot be compared with equal operator

INSERT INTO drs_favorites(type, reason) VALUES ('biking', 'Improves endurance and flexibility.');
INSERT INTO drs_favorites(type, reason) VALUES ('hiking', 'Increases cardiovascular health.');
GO 

 -- Create students and student_grades tables for JOIN 
if exists(select * from sys.objects where name = 'students')
    DROP TABLE [dbo].[students]
CREATE TABLE students (
	id INTEGER PRIMARY KEY IDENTITY(1,1),
    first_name Varchar(20),
    last_name Varchar(20),
    email Varchar(40),
    phone Varchar(12),
    birthdate Varchar(12),
	buddy_id INT
	);

INSERT INTO students (first_name, last_name, email, phone, birthdate, buddy_id)
    VALUES ('Peter', 'Rabbit', 'peter@rabbit.com', '555-6666', '2002-06-24', 2);
INSERT INTO students (first_name, last_name, email, phone, birthdate, buddy_id)
    VALUES ('Alice', 'Wonderland', 'alice@wonderland.com', '555-4444', '2002-07-04', 1);
INSERT INTO students (first_name, last_name, email, phone, birthdate, buddy_id)
    VALUES ('Aladdin', 'Lampland', 'aladdin@lampland.com', '555-3333', '2001-05-10', 4);
INSERT INTO students (first_name, last_name, email, phone, birthdate, buddy_id)
    VALUES ('Simba', 'Kingston', 'simba@kingston.com', '555-1111', '2001-12-24', 3);


if exists(select * from sys.objects where name = 'student_grades')
    DROP TABLE [dbo].[student_grades]
CREATE TABLE student_grades (
	id INTEGER PRIMARY KEY IDENTITY(1,1),
    student_id INTEGER,
    test Varchar(20),
    grade INTEGER);

INSERT INTO student_grades (student_id, test, grade)
    VALUES (1, 'Nutrition', 95);
INSERT INTO student_grades (student_id, test, grade)
    VALUES (2, 'Nutrition', 92);
INSERT INTO student_grades (student_id, test, grade)
    VALUES (1, 'Chemistry', 85);
INSERT INTO student_grades (student_id, test, grade)
    VALUES (2, 'Chemistry', 95);

if exists(select * from sys.objects where name = 'student_projects')
    DROP TABLE [dbo].[student_projects]
CREATE TABLE student_projects (
	id INTEGER PRIMARY KEY identity(1,1),
    student_id INTEGER,
    title TEXT);
    
INSERT INTO student_projects (student_id, title)
    VALUES (1, 'Carrotapault');
INSERT INTO student_projects (student_id, title)
    VALUES (2, 'Mad Hattery');
INSERT INTO student_projects (student_id, title)
    VALUES (3, 'Carpet Physics');
INSERT INTO student_projects (student_id, title)
    VALUES (4, 'Hyena Habitats');

if exists(select * from sys.objects where name = 'project_pairs')
    DROP TABLE [dbo].[project_pairs]
CREATE TABLE project_pairs (
	id INTEGER PRIMARY KEY identity(1,1),
    project1_id INTEGER,
    project2_id INTEGER);

INSERT INTO project_pairs (project1_id, project2_id)
    VALUES(1, 2);
INSERT INTO project_pairs (project1_id, project2_id)
    VALUES(3, 4);
GO





---------------------------
-----  Intro to SQL   -----
---------------------------

-- Querying the table
SELECT * FROM groceries WHERE aisle > 5 ORDER BY aisle;

-- Aggregating data
SELECT aisle, SUM(quantity) as sub_total 
FROM groceries 
group by aisle
order by sub_total desc;

-- Complex queries with AND/OR
SELECT * FROM exercise_logs WHERE calories > 50 ORDER BY calories;

/* AND */
SELECT * FROM exercise_logs WHERE calories > 50 AND minutes < 30;

/* OR */
SELECT * FROM exercise_logs WHERE calories > 50 OR heart_rate > 100;
GO


-- Querying IN subqueries 
SELECT * FROM exercise_logs WHERE type = 'biking' OR type = 'hiking' OR type = 'tree climbing' OR type = 'rowing';

/* Using IN can get the same result*/
SELECT * FROM exercise_logs WHERE type  IN ('biking', 'hiking', 'tree climbing', 'rowing');

/* list of record in drs_favorites table */
SELECT * FROM drs_favorites;

/* finding the exercise log that is listing in the drs_favorites table */
SELECT * FROM exercise_logs WHERE type IN (
    SELECT type FROM drs_favorites);

/* Using LIKE operator to search the record with 'cardiovascular' in the reason (text type)*/
SELECT * FROM exercise_logs WHERE type IN (
    SELECT type FROM drs_favorites WHERE reason LIKE '%cardiovascular%');
GO


-- Restricting grouped results with HAVING
/* Exercise logs overview*/
SELECT * FROM exercise_logs;

/* Calculate the total calories by type using GROUP BY*/
SELECT type, SUM(calories) AS total_calories FROM exercise_logs GROUP BY type;

/* Get the type of exercises that have total calories more than 150 */
SELECT type, SUM(calories) AS total_calories FROM exercise_logs
    GROUP BY type
    HAVING SUM(calories) > 150;   -- mssql wont allow using alias in HAVING clause
								  -- HAVING filters the condition in group not in individual record

/* Get the type of exercise having log more than 1 using GROUP BY and HAVING clauses*/
SELECT type FROM exercise_logs GROUP BY type HAVING COUNT(*) >= 2;
GO

-- Calculating results with CASE
/* 50-90% of max*/
SELECT COUNT(*) FROM exercise_logs WHERE  
    heart_rate >= ROUND(0.50 * (220-30),1) 
    AND  heart_rate <= ROUND(0.90 * (220-30),1);

/* CASE */
SELECT type, heart_rate,
    CASE 
        WHEN heart_rate > 220-30 THEN 'above max'
        WHEN heart_rate > ROUND(0.90 * (220-30),1) THEN 'above target'
        WHEN heart_rate > ROUND(0.50 * (220-30),1) THEN 'within target'
        ELSE 'below target'    
		END as 'hr_zone'
FROM exercise_logs;

SELECT COUNT(*), hr_zone
FROM
(SELECT type, heart_rate,
    CASE 
        WHEN heart_rate > 220-30 THEN 'above max'
        WHEN heart_rate > ROUND(0.90 * (220-30),1) THEN 'above target'
        WHEN heart_rate > ROUND(0.50 * (220-30),1) THEN 'within target'
        ELSE 'below target'    
		END as 'hr_zone'
FROM exercise_logs
) as sub
GROUP BY hr_zone   -- mssql does not allow GROUP BY refer alias, use the sub query in FROM statement instead
GO


-- JOINing related tables
/* Each table */
SELECT * FROM student_grades;			 -- 4 records
SELECT * FROM students;					 -- 4 records

/* cross join   -- least useful technique*/
SELECT * FROM student_grades, students;  -- 16 records

/* implicit inner join */
SELECT * FROM student_grades, students
    WHERE student_grades.student_id = students.id;

/* explicit inner join - JOIN */
SELECT a.first_name, a.last_name, email, b.test, b.grade FROM students as a
    JOIN student_grades as b
    ON a.id = b.student_id
    WHERE grade > 90;
GO

-- Joining related tables with left outer joins
/* inner join - JOIN  students and student_projects tables*/ 
SELECT students.first_name, students.last_name, student_projects.title
    FROM students
    JOIN student_projects
    ON students.id = student_projects.student_id;				-- 1 record, matching record which is Peter

/* outer join - JOIN  students and student_projects tables */ 
SELECT students.first_name, students.last_name, student_projects.title
    FROM students
    LEFT OUTER JOIN student_projects
    ON students.id = student_projects.student_id;				-- 4 records, Alice, Aladdin, Simba do not have project title
GO

-- Joining tables to themselves with self-joins
/* look at the students */ 
SELECT id, first_name, last_name, buddy_id FROM students;
/* self join - look at the buddy's name and email */ 
SELECT students.first_name, students.last_name, CONCAT(buddies.first_name,', ',buddies.last_name) as buddy_full_name, buddies.email as buddy_email
    FROM students
    JOIN students buddies
    ON students.buddy_id = buddies.id;
GO

-- Combining multiple joins
/* self join - showing two project title with multiple joins */ 
SELECT project1_id, a.title, project2_id, b.title FROM project_pairs
    JOIN student_projects a
    ON project_pairs.project1_id = a.id
    JOIN student_projects b
    ON project_pairs.project2_id = b.id;
GO


-- Changing rows with UPDATE and DELETE
if exists(select * from sys.objects where name = 'users')
    DROP TABLE [dbo].[users]
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name varchar(30));
if exists(select * from sys.objects where name = 'diary_logs')
    DROP TABLE [dbo].[diary_logs]   
CREATE TABLE diary_logs (
    id INTEGER PRIMARY KEY identity(1,1),
    user_id INTEGER,
    date varchar(12),
    content TEXT
    );
    
	/* After user submitted their new diary log */
INSERT INTO diary_logs (user_id, date, content) VALUES (1, '2015-04-01',
    'I had a horrible fight with OhNoesGuy and I buried my woes in 3 pounds of dark chocolate.');
INSERT INTO diary_logs (user_id, date, content) VALUES (1, '2015-04-02',
    'We made up and now we''re best friends forever and we celebrated with a tub of ice cream.');

SELECT * FROM diary_logs;

UPDATE diary_logs SET content = 'I had a horrible fight with OhNoesGuy' WHERE id = 1;

SELECT * FROM diary_logs;

DELETE FROM diary_logs WHERE id = 1;

SELECT * FROM diary_logs;
GO 

-- Altering tables after creation
ALTER TABLE diary_logs ADD emotion varchar(30) default 'unknown';
GO

INSERT INTO diary_logs (user_id, date, content, emotion) VALUES (1, '2015-04-03',
    'We went to Disneyland!', 'happy');
    
SELECT * FROM diary_logs;

/* look up the table schema */ 
select *
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='diary_logs'
GO