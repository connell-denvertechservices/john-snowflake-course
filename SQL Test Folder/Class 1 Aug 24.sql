-- First queries

-- Make sure we are using the correct database and schema
use database DB_MODULE1;
use schema academic;

-- See what tables are available
show tables;

-- Describe the structure of each table
describe table students;
describe table classes;
describe table classes_students;

-- Look at a sample of rows in each table
select *
from students
limit 5;

select *
from classes sample (5 rows);

select *
from classes_students;

-- Can also use copilot to create queries
-- Prompt: Write a query that joins students and classes 
-- and selects students in Biology classes
SELECT DISTINCT s.*, c.*
FROM DB_MODULE1.ACADEMIC.STUDENTS s
JOIN DB_MODULE1.ACADEMIC.CLASSES_STUDENTS cs ON s.STUDENT_ID = cs.STUDENT_ID
JOIN DB_MODULE1.ACADEMIC.CLASSES c ON cs.CLASS_ID = c.CLASS_ID
WHERE UPPER(c.DEPARTMENT) = 'BIOLOGY';


