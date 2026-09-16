-- STRUCTURED DATA QUERIES

-- Query 1: Which students have a scholarship and a GPA above 3.5?
SELECT student_id,
       first_name,
       last_name,
       gpa
FROM students
WHERE scholarship = TRUE
  AND gpa > 3.5
ORDER BY gpa DESC;

-- Query 2: Which students are enrolled in online classes, and what grades did they receive?
SELECT s.first_name,
       s.last_name,
       c.class_name,
       c.department,
       cs.grade,
       cs.numeric_grade
FROM classes_students cs
INNER JOIN students s ON s.student_id = cs.student_id
INNER JOIN classes c ON c.class_id = cs.class_id
WHERE c.modality = 'Online'
ORDER BY s.last_name, c.class_name;

-- SEMI-STRUCTURED DATA QUERIES

-- Query 3: What clubs does each online student belong to? (ARRAY + LATERAL FLATTEN)
SELECT s.student_id,
       s.first_name,
       s.last_name,
       f.value::STRING AS club
FROM students s
INNER JOIN classes_students cs ON cs.student_id = s.student_id
INNER JOIN classes c ON c.class_id = cs.class_id,
LATERAL FLATTEN(input => s.clubs) f
WHERE c.modality = 'Online'
ORDER BY s.last_name, club;

-- Query 4: What textbook is required for each class where a student earned an 'A'? (VARIANT)
SELECT s.first_name,
       s.last_name,
       c.class_name,
       c.syllabus:textbook::STRING AS textbook
FROM classes_students cs
INNER JOIN students s ON s.student_id = cs.student_id
INNER JOIN classes c ON c.class_id = cs.class_id
WHERE cs.grade = 'A'
ORDER BY s.last_name, c.class_name;

-- UNSTRUCTURED DATA QUERY

-- Query 5: What is an AI-generated summary of personal statements by state for students with a GPA above 3.0?
SELECT state,
       AI_SUMMARIZE_AGG(personal_statement) AS statement_summary
FROM students
WHERE gpa > 3.0
GROUP BY state
ORDER BY state;