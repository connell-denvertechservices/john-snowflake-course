/* ============================================================================
   DB_MODULE1 • ACADEMIC
   Rich demo schema with arrays, JSON (VARIANT), and long text fields
   Author: M365 Copilot
   ============================================================================ */

-- ============================================================================
-- 0) Database & Schema
-- ============================================================================
USE DATABASE DB_MODULE1;

CREATE SCHEMA IF NOT EXISTS ACADEMIC;
USE SCHEMA ACADEMIC;

-- (Optional clean-up: drop views first if re-running)
DROP VIEW IF EXISTS v_avg_gpa_by_advisor;
DROP VIEW IF EXISTS v_pass_rates;

-- ============================================================================
-- 1) Tables (expanded columns for analysis)
-- ============================================================================

-- Students table
CREATE OR REPLACE TABLE students (
    student_id         INT PRIMARY KEY,
    first_name         VARCHAR(50),
    last_name          VARCHAR(50),
    email              VARCHAR(100),
    phone              VARCHAR(20),
    birth_date         DATE,
    gender             VARCHAR(10),
    city               VARCHAR(50),
    state              VARCHAR(30),
    country            VARCHAR(50),
    enrollment_date    DATE,
    graduation_target  DATE,
    interests          ARRAY,         -- e.g., ['Math','Physics']
    clubs              ARRAY,         -- e.g., ['Robotics','Chess']
    student_profile    VARIANT,       -- JSON profile details
    personal_statement TEXT,
    advisor            VARCHAR(100),
    scholarship        BOOLEAN,
    gpa                NUMBER(3,2)
);

-- Classes table
CREATE OR REPLACE TABLE classes (
    class_id         INT PRIMARY KEY,
    class_code       VARCHAR(10),
    class_name       VARCHAR(100),
    department       VARCHAR(50),
    instructor_name  VARCHAR(100),
    instructor_email VARCHAR(100),
    max_capacity     INT,
    credits          NUMBER(2,1),
    level            VARCHAR(20),     -- Lower, Upper, Graduate
    modality         VARCHAR(20),     -- In-Person, Online, Hybrid
    campus           VARCHAR(50),
    semester         VARCHAR(20),     -- e.g., 'Fall 2023'
    prerequisites    ARRAY,           -- e.g., ['MATH201']
    meeting_days     ARRAY,           -- e.g., ['Mon','Wed']
    time_slot        VARCHAR(20),     -- e.g., '09:00-09:50'
    syllabus         VARIANT,         -- JSON (textbook, outline, etc.)
    description      TEXT
);

-- Enrollments table (rich fact table for analytics)
CREATE OR REPLACE TABLE classes_students (
    class_id          INT,
    student_id        INT,
    enrollment_date   DATE,
    status            VARCHAR(20),     -- ENROLLED, DROPPED, COMPLETED, WAITLISTED
    term              VARCHAR(20),     -- e.g., 'Fall 2023'
    grade             VARCHAR(2),      -- A, B+, etc.
    numeric_grade     NUMBER(5,2),     -- 0-100 scale
    attendance_pct    NUMBER(5,2),     -- 0-100
    credits_earned    NUMBER(2,1),     -- actual credits earned (0 if dropped)
    exam_scores       ARRAY,           -- e.g., [88, 92]
    assignment_scores ARRAY,           -- e.g., [10, 9, 8, 10]
    notes             TEXT,
    PRIMARY KEY (class_id, student_id, term),
    FOREIGN KEY (class_id)   REFERENCES classes(class_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- ============================================================================
-- 2) Data: Students (INSERT … SELECT with ARRAY literals)
--   NOTE: Use SELECT (not VALUES) when inserting arrays
-- ============================================================================

INSERT INTO students (
    student_id, first_name, last_name, email, phone, birth_date, gender,
    city, state, country, enrollment_date, graduation_target,
    interests, clubs, student_profile, personal_statement, advisor,
    scholarship, gpa
)
SELECT
  1, 'John',  'Doe',     'john.doe@email.com',  '970-555-0001', '2003-02-11', 'Male',
  'Fort Collins', 'CO', 'USA', '2023-08-21', '2027-05-15',
  ['Math','Physics']::ARRAY, ['Robotics','Chess']::ARRAY,
  PARSE_JSON('{"major":"Computer Science","year":"Junior","minor":"Math"}'),
  'Passionate about technology and innovation', 'Dr. Smith', TRUE, 3.82
UNION ALL SELECT
  2, 'Jane',  'Smith',   'jane.smith@email.com', '970-555-0002', '2002-11-05', 'Female',
  'Loveland', 'CO', 'USA', '2022-08-22', '2026-05-15',
  ['Biology','Chemistry']::ARRAY, ['PreMed','Volunteering']::ARRAY,
  PARSE_JSON('{"major":"Biology","year":"Senior","research":"Cell Biology"}'),
  'Aspiring medical researcher', 'Dr. Johnson', TRUE, 3.93
UNION ALL SELECT
  3, 'Mike',  'Johnson', 'mike.j@email.com',     '970-555-0003', '2004-03-19', 'Male',
  'Greeley', 'CO', 'USA', '2023-08-21', '2027-05-15',
  ['History','Literature']::ARRAY, ['Writing','Debate']::ARRAY,
  PARSE_JSON('{"major":"English","year":"Sophomore"}'),
  'Creative writer focused on historical fiction', 'Prof. Williams', FALSE, 3.68
UNION ALL SELECT
  4, 'Sarah', 'Williams','sarah.w@email.com',    '970-555-0004', '2001-07-07', 'Female',
  'Boulder', 'CO', 'USA', '2021-08-23', '2025-05-15',
  ['Art','Music']::ARRAY, ['DesignClub','Choir']::ARRAY,
  PARSE_JSON('{"major":"Fine Arts","year":"Senior","focus":"Digital Media"}'),
  'Multimedia artist exploring digital formats', 'Prof. Davis', FALSE, 3.61
UNION ALL SELECT
  5, 'David', 'Brown',   'david.b@email.com',    '970-555-0005', '2003-12-30', 'Male',
  'Denver', 'CO', 'USA', '2022-08-22', '2026-05-15',
  ['Economics','Statistics']::ARRAY, ['Investing','Analytics']::ARRAY,
  PARSE_JSON('{"major":"Economics","minor":"Statistics","year":"Junior"}'),
  'Interested in behavioral economics', 'Dr. Brown', TRUE, 3.54
UNION ALL SELECT
  6, 'Emma',  'Davis',   'emma.d@email.com',     '970-555-0006', '2002-05-12', 'Female',
  'Longmont', 'CO', 'USA', '2021-08-23', '2025-05-15',
  ['Psychology','Sociology']::ARRAY, ['ResearchClub']::ARRAY,
  PARSE_JSON('{"major":"Psychology","year":"Senior","lab":"Cognitive Dev"}'),
  'Research focus on cognitive development', 'Dr. Wilson', TRUE, 3.91
UNION ALL SELECT
  7, 'James', 'Wilson',  'james.w@email.com',    '970-555-0007', '2004-08-18', 'Male',
  'Fort Collins', 'CO', 'USA', '2023-08-21', '2027-05-15',
  ['Computer Science','Mathematics']::ARRAY, ['AIClub','MathClub']::ARRAY,
  PARSE_JSON('{"major":"Data Science","year":"Junior"}'),
  'Passionate about AI and machine learning', 'Prof. Martinez', FALSE, 3.80
UNION ALL SELECT
  8, 'Linda', 'Martinez','linda.m@email.com',    '970-555-0008', '2003-10-25', 'Female',
  'Fort Collins', 'CO', 'USA', '2022-08-22', '2026-05-15',
  ['Spanish','French']::ARRAY, ['LanguageClub']::ARRAY,
  PARSE_JSON('{"major":"Languages","year":"Sophomore"}'),
  'Multilingual communication enthusiast', 'Prof. Garcia', FALSE, 3.72
UNION ALL SELECT
  9, 'Robert','Taylor',  'robert.t@email.com',   '970-555-0009', '2001-09-02', 'Male',
  'Loveland', 'CO', 'USA', '2021-08-23', '2025-05-15',
  ['Physics','Engineering']::ARRAY, ['EnergyClub']::ARRAY,
  PARSE_JSON('{"major":"Engineering","track":"Renewable","year":"Senior"}'),
  'Focused on renewable energy solutions', 'Dr. Taylor', TRUE, 3.63
UNION ALL SELECT
 10,'Maria',  'Garcia',  'maria.g@email.com',    '970-555-0010', '2003-04-16', 'Female',
  'Greeley', 'CO', 'USA', '2022-08-22', '2026-05-15',
  ['Chemistry','Biology']::ARRAY, ['LabAssistants']::ARRAY,
  PARSE_JSON('{"major":"Biochemistry","year":"Junior"}'),
  'Pursuing research in molecular biology', 'Dr. Anderson', TRUE, 3.94
UNION ALL SELECT
 11,'Ethan',  'Nguyen',  'ethan.n@email.com',    '970-555-0011', '2004-01-22', 'Male',
  'Boulder', 'CO', 'USA', '2023-08-21', '2027-05-15',
  ['Statistics','CS']::ARRAY, ['DataViz']::ARRAY,
  PARSE_JSON('{"major":"Statistics","year":"Sophomore"}'),
  'Data visualization and inference', 'Dr. Chen', FALSE, 3.47
UNION ALL SELECT
 12,'Ava',    'Lopez',   'ava.l@email.com',      '970-555-0012', '2002-06-09', 'Female',
  'Denver', 'CO', 'USA', '2021-08-23', '2025-05-15',
  ['Business','Economics']::ARRAY, ['Entrepreneurship']::ARRAY,
  PARSE_JSON('{"major":"Business","year":"Senior","concentration":"Finance"}'),
  'Entrepreneurship and fintech', 'Dr. Patel', TRUE, 3.76
UNION ALL SELECT
 13,'Noah',   'Kim',     'noah.k@email.com',     '970-555-0013', '2003-03-03', 'Male',
  'Longmont', 'CO', 'USA', '2022-08-22', '2026-05-15',
  ['Math','CS']::ARRAY, ['CodingDojo']::ARRAY,
  PARSE_JSON('{"major":"Computer Science","year":"Junior"}'),
  'Systems and algorithms', 'Dr. Lee', FALSE, 3.59
UNION ALL SELECT
 14,'Olivia', 'Brown',   'olivia.b@email.com',   '970-555-0014', '2004-12-01', 'Female',
  'Fort Collins', 'CO', 'USA', '2023-08-21', '2027-05-15',
  ['Art','Design']::ARRAY, ['UXClub']::ARRAY,
  PARSE_JSON('{"major":"Design","year":"Sophomore"}'),
  'UX/UI and visual design', 'Prof. Davis', TRUE, 3.66
UNION ALL SELECT
 15,'Liam',   'Hernandez','liam.h@email.com',    '970-555-0015', '2002-02-28', 'Male',
  'Loveland', 'CO', 'USA', '2021-08-23', '2025-05-15',
  ['Physics','Math']::ARRAY, ['Astronomy']::ARRAY,
  PARSE_JSON('{"major":"Physics","year":"Senior"}'),
  'Quantum computing enthusiast', 'Dr. Taylor', FALSE, 3.71
;

-- ============================================================================
-- 3) Data: Classes (INSERT … SELECT with ARRAY literals)
-- ============================================================================

INSERT INTO classes (
    class_id, class_code, class_name, department, instructor_name, instructor_email,
    max_capacity, credits, level, modality, campus, semester,
    prerequisites, meeting_days, time_slot, syllabus, description
)
SELECT
  1, 'CS101', 'Intro to Programming',     'Computer Science', 'Dr. Smith',    'smith@univ.edu',
  30, 3.0, 'Lower', 'In-Person', 'Main',      'Fall 2023',
  []::ARRAY,               ['Mon','Wed','Fri']::ARRAY, '09:00-09:50',
  PARSE_JSON('{"textbook":"Python Basics","outline":["variables","loops","functions"]}'),
  'Fundamentals using Python'
UNION ALL SELECT
  2, 'BIO201','Cell Biology',             'Biology',          'Dr. Johnson',  'johnson@univ.edu',
  25, 3.0, 'Upper', 'Hybrid',   'Science',    'Fall 2023',
  ['BIO101']::ARRAY,         ['Tue','Thu']::ARRAY,     '10:30-11:45',
  PARSE_JSON('{"textbook":"Cell Biology 101","lab_required":true}'),
  'Study of cellular structures and functions'
UNION ALL SELECT
  3, 'HIST301','World History',           'History',          'Prof. Williams','williams@univ.edu',
  35, 3.0, 'Upper', 'Online',   'Virtual',   'Fall 2023',
  ['HIST101','HIST201']::ARRAY,['Wed']::ARRAY,         '11:00-12:15',
  PARSE_JSON('{"readings":["Primary Sources","Modern Era"]}'),
  'Global historical overview'
UNION ALL SELECT
  4, 'ART202','Digital Design',           'Art & Design',     'Prof. Davis',  'davis@univ.edu',
  20, 3.0, 'Lower', 'In-Person','Arts',      'Fall 2023',
  ['ART101']::ARRAY,         ['Tue','Thu']::ARRAY,     '14:00-15:15',
  PARSE_JSON('{"software":["Photoshop","Illustrator"]}'),
  'Principles of digital art'
UNION ALL SELECT
  5, 'ECON301','Microeconomics',          'Economics',        'Dr. Brown',    'brown@univ.edu',
  40, 3.0, 'Upper', 'Hybrid',   'Business',  'Fall 2023',
  ['ECON101']::ARRAY,        ['Mon','Wed']::ARRAY,      '13:00-13:50',
  PARSE_JSON('{"textbook":"Principles of Microeconomics"}'),
  'Market behavior and consumer choice'
UNION ALL SELECT
  6, 'PSY401','Advanced Psychology',      'Psychology',       'Dr. Wilson',   'wilson@univ.edu',
  30, 4.0, 'Upper', 'In-Person','SocialSci', 'Fall 2023',
  ['PSY101','PSY201']::ARRAY, ['Tue','Thu']::ARRAY,     '15:30-16:45',
  PARSE_JSON('{"textbook":"Advanced Psychological Theory"}'),
  'Research topics and methods'
UNION ALL SELECT
  7, 'MATH301','Linear Algebra',          'Mathematics',      'Prof. Martinez','martinez@univ.edu',
  25, 3.0, 'Upper', 'In-Person','Math',      'Fall 2023',
  ['MATH201']::ARRAY,        ['Mon','Wed']::ARRAY,      '10:00-10:50',
  PARSE_JSON('{"textbook":"Linear Algebra Concepts"}'),
  'Matrices and vector spaces'
UNION ALL SELECT
  8, 'LANG201','Spanish Intermediate',    'Languages',        'Prof. Garcia', 'garcia@univ.edu',
  20, 3.0, 'Lower', 'In-Person','Languages', 'Fall 2023',
  ['LANG101']::ARRAY,        ['Tue','Thu']::ARRAY,      '11:00-11:50',
  PARSE_JSON('{"textbook":"Spanish Grammar","oral_exam":true}'),
  'Intermediate Spanish language and culture'
UNION ALL SELECT
  9, 'PHYS301','Quantum Physics',         'Physics',          'Dr. Taylor',   'taylor@univ.edu',
  25, 4.0, 'Upper', 'Hybrid',   'Physics',   'Fall 2023',
  ['PHYS201','MATH201']::ARRAY,['Mon','Wed','Fri']::ARRAY, '14:00-14:50',
  PARSE_JSON('{"textbook":"Quantum Mechanics"}'),
  'Intro to quantum mechanics principles'
UNION ALL SELECT
 10,'CHEM401','Organic Chemistry',        'Chemistry',        'Dr. Anderson', 'anderson@univ.edu',
  30, 4.0, 'Upper', 'In-Person','Chemistry', 'Fall 2023',
  ['CHEM201','CHEM301']::ARRAY,['Mon','Wed']::ARRAY,     '09:00-09:50',
  PARSE_JSON('{"textbook":"Organic Chemistry","lab":"Org Lab II"}'),
  'Advanced organic concepts'
UNION ALL SELECT
 11,'STAT210','Applied Statistics',       'Statistics',       'Dr. Chen',     'chen@univ.edu',
  45, 3.0, 'Lower', 'Online',   'Virtual',   'Spring 2024',
  ['MATH101']::ARRAY,        ['Mon','Wed']::ARRAY,      '12:00-12:50',
  PARSE_JSON('{"software":["R","Python"],"projects":3}'),
  'Descriptive and inferential statistics'
UNION ALL SELECT
 12,'ENGL220','Technical Writing',        'English',          'Dr. Lee',      'lee@univ.edu',
  35, 3.0, 'Lower', 'Hybrid',   'Humanities', 'Spring 2024',
  []::ARRAY,               ['Tue','Thu']::ARRAY,     '16:00-16:50',
  PARSE_JSON('{"portfolio_required":true}'),
  'Professional and technical communication'
;

-- ============================================================================
-- 4) Data: Enrollments (INSERT … SELECT with ARRAY literals)
-- ============================================================================

INSERT INTO classes_students (
    class_id, student_id, enrollment_date, status, term,
    grade, numeric_grade, attendance_pct, credits_earned,
    exam_scores, assignment_scores, notes
)
SELECT 1,  1, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A',  95.0, 98.0, 3.0,
       [92, 98]::ARRAY, [10, 10, 9, 10]::ARRAY, 'Excellent performance'
UNION ALL SELECT 1,  2, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A-', 90.0, 96.5, 3.0,
       [88, 92]::ARRAY, [9, 10, 9, 9]::ARRAY, 'Strong overall'
UNION ALL SELECT 2,  3, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B+', 88.0, 93.0, 3.0,
       [86, 90]::ARRAY, [8, 9, 9, 9]::ARRAY, 'Solid grasp'
UNION ALL SELECT 3,  4, '2023-09-01', 'DROPPED',   'Fall 2023', NULL, NULL, 18.0, 0.0,
       []::ARRAY, []::ARRAY, 'Dropped due to schedule conflict'
UNION ALL SELECT 4,  5, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B',  85.0, 92.0, 3.0,
       [84, 86]::ARRAY, [8, 8, 9, 9]::ARRAY, 'Consistent work'
UNION ALL SELECT 5,  6, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A',  94.0, 97.0, 3.0,
       [93, 95]::ARRAY, [10, 9, 10, 10]::ARRAY, 'Outstanding'
UNION ALL SELECT 6,  7, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A-', 91.0, 95.0, 4.0,
       [90, 92]::ARRAY, [9, 9, 10, 9]::ARRAY, 'Great engagement'
UNION ALL SELECT 7,  8, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B+', 88.5, 93.5, 3.0,
       [87, 90]::ARRAY, [9, 8, 9, 9]::ARRAY, 'Improved over term'
UNION ALL SELECT 8,  9, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A',  96.0, 99.0, 3.0,
       [95, 97]::ARRAY, [10, 10, 10, 10]::ARRAY, 'Top marks'
UNION ALL SELECT 9, 10, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A-', 91.5, 96.0, 4.0,
       [90, 93]::ARRAY, [9, 10, 9, 9]::ARRAY, 'Excellent comprehension'
UNION ALL SELECT 10,11, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B',  84.0, 90.0, 4.0,
       [82, 86]::ARRAY, [8, 9, 8, 9]::ARRAY, 'Good lab skills'
UNION ALL SELECT 11,12, '2024-01-15', 'ENROLLED',  'Spring 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Currently enrolled'
UNION ALL SELECT 12,13, '2024-01-15', 'ENROLLED',  'Spring 2024', NULL, NULL, 98.0, 0.0,
       []::ARRAY, []::ARRAY, 'Currently enrolled'
UNION ALL SELECT 7,  1, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A',  95.0, 97.0, 3.0,
       [94, 96]::ARRAY, [10, 10, 10]::ARRAY, 'Strong linear algebra'
UNION ALL SELECT 11, 2, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A',  93.0, 95.5, 3.0,
       [92, 94]::ARRAY, [10, 10, 9]::ARRAY, 'Great statistics projects'
UNION ALL SELECT 12, 3, '2024-01-15', 'COMPLETED', 'Spring 2024', 'B+', 89.0, 94.0, 3.0,
       [88, 90]::ARRAY, [9, 9, 8]::ARRAY, 'Clear technical writing'
UNION ALL SELECT 3,  5, '2024-08-26', 'WAITLISTED','Fall 2024', NULL, NULL, 0.0, 0.0,
       []::ARRAY, []::ARRAY, 'Awaiting seat availability'
UNION ALL SELECT 1,  6, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Intro CS retake for prerequisite'
UNION ALL SELECT 2,  7, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'New enrollment'
UNION ALL SELECT 5,  8, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'New enrollment'
UNION ALL SELECT 9, 15, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A',  94.5, 97.5, 4.0,
       [93, 96]::ARRAY, [10, 9, 10, 10]::ARRAY, 'Excellent quantum foundations'
UNION ALL SELECT 6,  6, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A',  96.0, 98.0, 4.0,
       [95, 97]::ARRAY, [10, 10, 10, 10]::ARRAY, 'Capstone research success'
UNION ALL SELECT 4, 14, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A-', 90.5, 95.0, 3.0,
       [89, 92]::ARRAY, [9, 10, 9, 9]::ARRAY, 'Strong portfolio'
UNION ALL SELECT 7, 13, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B+', 88.0, 92.5, 3.0,
       [87, 90]::ARRAY, [9, 8, 9, 9]::ARRAY, 'Good conceptual understanding'
UNION ALL SELECT 10,10, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Advanced organic lab scheduled'
UNION ALL SELECT 8,  8, '2024-08-26', 'COMPLETED', 'Spring 2024', 'A', 93.0, 96.0, 3.0,
       [92, 94]::ARRAY, [10, 9, 9, 10]::ARRAY, 'Strong oral proficiency'
UNION ALL SELECT 11,11, '2024-01-15', 'COMPLETED', 'Spring 2024', 'B', 85.0, 92.0, 3.0,
       [84, 86]::ARRAY, [8, 9, 8]::ARRAY, 'Solid applied stats'
UNION ALL SELECT 5,  5, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B+', 88.5, 93.0, 3.0,
       [87, 90]::ARRAY, [9, 9, 8, 9]::ARRAY, 'Improved participation'
UNION ALL SELECT 12,12, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A', 94.0, 97.0, 3.0,
       [93, 95]::ARRAY, [10, 10, 9]::ARRAY, 'Excellent portfolio'
UNION ALL SELECT 2,  2, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Advanced cell module'
UNION ALL SELECT 3,  3, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Research seminar add'
UNION ALL SELECT 7,  7, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Linear algebra TA support'
UNION ALL SELECT 1,  4, '2023-09-01', 'DROPPED',   'Fall 2023', NULL, NULL, 35.0, 0.0,
       []::ARRAY, []::ARRAY, 'Dropped Week 4'
UNION ALL SELECT 9,  9, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'Advanced quantum apps'
UNION ALL SELECT 11, 1, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A', 95.5, 98.0, 3.0,
       [95, 96]::ARRAY, [10, 10, 10]::ARRAY, 'Top of class'
UNION ALL SELECT 5,  2, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A', 93.5, 96.0, 3.0,
       [92, 94]::ARRAY, [10, 10, 9, 9]::ARRAY, 'Excellent analysis'
UNION ALL SELECT 8, 12, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A-', 91.0, 95.0, 3.0,
       [90, 92]::ARRAY, [9, 10, 9, 9]::ARRAY, 'Strong writing in Spanish'
UNION ALL SELECT 6,  3, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B', 84.5, 90.0, 4.0,
       [83, 86]::ARRAY, [8, 9, 8, 8]::ARRAY, 'Good research design'
UNION ALL SELECT 4,  8, '2023-09-01', 'COMPLETED', 'Fall 2023', 'B+', 88.0, 92.0, 3.0,
       [87, 89]::ARRAY, [9, 9, 8, 9]::ARRAY, 'Nice visual work'
UNION ALL SELECT 10,15, '2023-09-01', 'COMPLETED', 'Fall 2023', 'A-', 90.0, 95.0, 4.0,
       [89, 91]::ARRAY, [9, 9, 10, 9]::ARRAY, 'Great organic synthesis'
UNION ALL SELECT 3, 11, '2024-08-26', 'ENROLLED',  'Fall 2024', NULL, NULL, 100.0, 0.0,
       []::ARRAY, []::ARRAY, 'World history deep dive'
UNION ALL SELECT 12, 5, '2024-01-15', 'COMPLETED', 'Spring 2024', 'A', 93.0, 96.0, 3.0,
       [92, 94]::ARRAY, [10, 9, 10]::ARRAY, 'Excellent technical documentation'
;

-- ============================================================================
-- 5) Helper Views (quick analytics demos)
-- ============================================================================

-- Average GPA by advisor
CREATE OR REPLACE VIEW v_avg_gpa_by_advisor AS
SELECT advisor,
       ROUND(AVG(gpa), 2) AS avg_gpa,
       COUNT(*) AS student_count
FROM students
GROUP BY advisor;

-- Pass rates by department and term
CREATE OR REPLACE VIEW v_pass_rates AS
SELECT
  c.department,
  cs.term,
  COUNT(*) AS total_enrollments,
  SUM(CASE WHEN cs.status='COMPLETED' AND cs.numeric_grade >= 60 THEN 1 ELSE 0 END) AS passes,
  ROUND(100.0 * SUM(CASE WHEN cs.status='COMPLETED' AND cs.numeric_grade >= 60 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 2) AS pass_pct
FROM classes_students cs
JOIN classes c ON c.class_id = cs.class_id
GROUP BY c.department, cs.term;

-- ============================================================================
-- 6) Enrich long text for AISQL analysis (append multi-paragraph text)
-- ============================================================================

-- Append richer personal statements for selected students
UPDATE students s
SET personal_statement = CONCAT_WS(
    '\n\n',
    NVL(s.personal_statement, ''),
    src.personal_statement_append
)
FROM (
    SELECT 1 AS student_id,
           'I am driven by a curiosity for systems that learn from data. Over the past year, I built a recommendation engine for our campus book exchange using Python and SQL, then iterated it with feedback from users in the Robotics and Chess clubs. The most rewarding insight was that good models are as much about thoughtful features as they are about algorithms.

In the long term, I hope to research human-centered AI: designing interfaces that explain model predictions, reduce cognitive load, and help people make better decisions. Outside the lab, you’ll likely find me playing blitz chess, sketching ideas for interactive dashboards, or volunteering at local STEM events.' AS personal_statement_append
    UNION ALL
    SELECT 2,
           'My work in cell morphology has taught me patience and precision. I collaborated with a lab team to segment microscopy images using classical techniques before experimenting with deep learning to improve boundary detection. The most exciting moment was validating predictions with wet-lab results and seeing data align with biology.

As a future clinician-scientist, I want to bridge rigorous research with compassionate practice. Mentoring underclassmen in our PreMed group has reinforced that science is a team effort and that clear communication magnifies impact.'
    UNION ALL
    SELECT 7,
           'I am passionate about end-to-end machine learning: from data acquisition to deployment and monitoring. A recent project involved building a streaming pipeline for sensor data and a lightweight model to detect anomalies. After we shipped the MVP, we discovered the real work begins—observability, retraining policies, and feedback loops.

The next frontier I want to explore is responsible AI: auditing datasets, identifying drift, and documenting assumptions. In my spare time, I contribute to open-source notebooks that demystify core math behind ML models for newcomers.'
    UNION ALL
    SELECT 10,
           'Biochemistry fascinates me because of the delicate choreography of molecules. In our lab, I help maintain protocols, track reagent lots, and automate data capture with a small LIMS script. Those improvements freed us to spend more time interpreting results.

I am eager to study molecular pathways that inform sustainable healthcare, and I hope to mentor peers—especially those new to lab work—in reproducible practices and ethical research.'
    UNION ALL
    SELECT 15,
           'Quantum computing feels like learning a new language—one that is probabilistic and elegant. I started with toy circuits and gradually learned to reason about gates, states, and measurement. My current interest is hybrid workflows, where classical optimization meets quantum kernels.

I enjoy organizing study sessions for classmates and writing short explainers that translate dense papers into approachable diagrams and examples.'
) AS src
WHERE s.student_id = src.student_id;

-- Append richer descriptions for selected classes
UPDATE classes c
SET description = CONCAT_WS(
    '\n\n',
    NVL(c.description, ''),
    src.description_append
)
FROM (
    SELECT 1 AS class_id,
           'This course emphasizes practical problem-solving and clear code communication. Weekly labs use small, real-world datasets to practice iteration, modular design, and error handling. By midterm, students refactor a partner’s codebase, document assumptions, and propose a test suite.

The final showcases a capstone: a small application or analysis with a README that explains trade-offs, limitations, and next steps. Grading is balanced across style, correctness, tests, and reflection.' AS description_append
    UNION ALL
    SELECT 5,
           'Microeconomics is presented through market simulations, experiment-based learning, and policy analysis. Students compare outcomes under perfect competition, monopoly, and oligopoly structures; we explore consumer choice using utility models and empirical datasets.

Assignments involve short memos designed for decision-makers, with an emphasis on clarity and evidence. The culminating project is a policy brief critiquing an intervention using demand elasticity and welfare analysis.'
    UNION ALL
    SELECT 7,
           'Linear Algebra highlights matrices as data structures and transformations. Labs connect eigenvalues/eigenvectors to dimensionality reduction and stability analysis. Students implement simple decompositions, build geometric intuition with plots, and interpret results in the context of real datasets.

Assessment includes proofs (concise, structured), computational notebooks (clear, reproducible), and practical reflections (what the math reveals and conceals).'
    UNION ALL
    SELECT 9,
           'Quantum Physics introduces core postulates and the math machinery underpinning them. We use simulations to visualize superposition, interference, and tunneling. Students practice deriving results step-by-step, then compare analytic solutions with numerical experiments.

Projects encourage responsible reporting of assumptions and uncertainties, with rubrics that value clarity of reasoning as highly as numerical precision.'
    UNION ALL
    SELECT 11,
           'Applied Statistics balances theory with hands-on projects: exploratory data analysis, inference, modeling, diagnostics, and communication. Students learn to design questions, clean data, and evaluate models through holdout and cross-validation.

Deliverables include short reports, reproducible notebooks, and slide decks tailored to non-technical audiences. The final project emphasizes ethical considerations in data collection and model deployment.'
) AS src
WHERE c.class_id = src.class_id;

-- ============================================================================
-- 7) Optional: Add extra long-form text columns & populate
-- ============================================================================

ALTER TABLE students ADD COLUMN IF NOT EXISTS personal_projects TEXT;
ALTER TABLE classes  ADD COLUMN IF NOT EXISTS learning_outcomes TEXT;

UPDATE students s
SET personal_projects = src.personal_projects
FROM (
    SELECT 1 AS student_id,
           'Built a recommendation engine for campus exchanges; designed A/B tests; wrote a postmortem documenting false-positive causes and fairness trade-offs.' AS personal_projects
    UNION ALL SELECT 2,
           'Automated microscopy image labeling pipeline; co-authored a lab SOP; mentored peers on reproducible notebooks and data hygiene.'
    UNION ALL SELECT 7,
           'Created a streaming anomaly detector for sensor data; productionized model with monitoring dashboards; introduced a retraining schedule and drift checks.'
    UNION ALL SELECT 10,
           'Set up a small LIMS-like tracker; standardized reagent metadata and protocols; improved data capture and traceability across trials.'
    UNION ALL SELECT 15,
           'Led a quantum study group; wrote concise summaries with diagrams; explored hybrid classical-quantum optimization patterns.'
) AS src
WHERE s.student_id = src.student_id;

UPDATE classes c
SET learning_outcomes = src.learning_outcomes
FROM (
    SELECT 1 AS class_id,
           'Students will write readable, tested programs; explain algorithmic trade-offs; and communicate results effectively to non-technical peers.' AS learning_outcomes
    UNION ALL SELECT 5,
           'Students will analyze consumer/producer behavior; compute and interpret elasticities; and prepare evidence-based policy memos.'
    UNION ALL SELECT 7,
           'Students will apply matrix decompositions; reason about linear systems; and connect theory to real data transformations.'
    UNION ALL SELECT 9,
           'Students will model quantum phenomena; compare analytic and numeric solutions; and report assumptions transparently.'
    UNION ALL SELECT 11,
           'Students will design data analyses; evaluate models ethically; and deliver clear, reproducible artifacts and presentations.'
) AS src
WHERE c.class_id = src.class_id;

-----------
-- Create a stage and can upload the syllabus for this course as an exmaple
----------

CREATE OR REPLACE STAGE pdf_stage
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE') 
    DIRECTORY = (ENABLE = true)
    COMMENT = 'Stage for storing PDF files for academic demo';


-- ============================================================================
-- 8) (Optional) Sanity checks
-- ============================================================================
-- SELECT COUNT(*) AS students_count FROM students;
-- SELECT COUNT(*) AS classes_count FROM classes;
-- SELECT COUNT(*) AS enrollments_count FROM classes_students;

-- ============================================================================
-- 9) Demo Queries (run as needed)
--    These do not modify state; useful for classroom demos
-- ============================================================================

-- 9.1 Longest personal statements
-- SELECT student_id, first_name, last_name, LENGTH(personal_statement) AS chars
-- FROM students
-- ORDER BY chars DESC
-- LIMIT 10;

-- 9.2 Most detailed class descriptions
-- SELECT class_id, class_code, class_name, LENGTH(description) AS chars
-- FROM classes
-- ORDER BY chars DESC
-- LIMIT 10;

-- 9.3 Average GPA by advisor (via view)
-- SELECT * FROM v_avg_gpa_by_advisor ORDER BY avg_gpa DESC;

-- 9.4 Classes per department in Fall 2023
-- SELECT department, COUNT(*) AS class_count
-- FROM classes
-- WHERE semester = 'Fall 2023'
-- GROUP BY department
-- ORDER BY class_count DESC;

-- 9.5 Top Spring 2024 students by numeric grade (completed only)
-- SELECT s.first_name, s.last_name, c.class_code, c.class_name, cs.numeric_grade
-- FROM classes_students cs
-- JOIN students s ON s.student_id = cs.student_id
-- JOIN classes c ON c.class_id = cs.class_id
-- WHERE cs.term = 'Spring 2024' AND cs.status = 'COMPLETED'
-- ORDER BY cs.numeric_grade DESC
-- LIMIT 10;

-- 9.6 Average attendance by modality
-- SELECT c.modality, ROUND(AVG(cs.attendance_pct), 2) AS avg_attendance
-- FROM classes_students cs
-- JOIN classes c ON c.class_id = cs.class_id
-- GROUP BY c.modality
-- ORDER BY avg_attendance DESC;

-- 9.7 Students with "Math" in interests (simple string search)
-- SELECT student_id, first_name, last_name, interests
-- FROM students
-- WHERE ARRAY_TO_STRING(interests, ',') ILIKE '%Math%';

-- 9.8 Average exam score across enrollments (two-exam mean)
-- SELECT c.department, cs.term,
--        ROUND(AVG((cs.exam_scores[0] + cs.exam_scores[1]) / 2), 2) AS avg_exam
-- FROM classes_students cs
-- JOIN classes c ON c.class_id = cs.class_id
-- WHERE cs.status = 'COMPLETED' AND ARRAY_SIZE(cs.exam_scores) = 2
-- GROUP BY c.department, cs.term
-- ORDER BY c.department, cs.term;

-- 9.9 Credits issued by department & term (completed only)
-- SELECT c.department, cs.term, ROUND(SUM(cs.credits_earned),1) AS total_credits
-- FROM classes_students cs
-- JOIN classes c ON c.class_id = cs.class_id
-- WHERE cs.status = 'COMPLETED'
-- GROUP BY c.department, cs.term
-- ORDER BY total_credits DESC;

-- 9.10 Pass rates by department & term (via view)
-- SELECT * FROM v_pass_rates ORDER BY pass_pct DESC;

-- 9.11 AISQL corpus (students + classes combined text)
-- WITH student_text AS (
--   SELECT s.student_id::STRING AS id,
--          'student' AS kind,
--          CONCAT_WS('\n\n', s.first_name||' '||s.last_name,
--                    'Advisor: '||COALESCE(s.advisor,'N/A'),
--                    'Interests: '||ARRAY_TO_STRING(COALESCE(s.interests, []::ARRAY), ', '),
--                    'Clubs: '||ARRAY_TO_STRING(COALESCE(s.clubs, []::ARRAY), ', '),
--                    COALESCE(s.personal_statement,''),
--                    COALESCE(s.personal_projects,'')) AS text
--   FROM students s
-- ),
-- class_text AS (
--   SELECT c.class_id::STRING AS id,
--          'class' AS kind,
--          CONCAT_WS('\n\n', c.class_code||' - '||c.class_name,
--                    'Dept: '||c.department||' | Instructor: '||c.instructor_name,
--                    'Prereqs: '||ARRAY_TO_STRING(COALESCE(c.prerequisites, []::ARRAY), ', '),
--                    'Meeting: '||ARRAY_TO_STRING(COALESCE(c.meeting_days, []::ARRAY), ', ')
--                      ||' '||COALESCE(c.time_slot,''),
--                    COALESCE(c.description,''),
--                    COALESCE(c.learning_outcomes,'')) AS text
--   FROM classes c
-- )
-- SELECT * FROM student_text
-- UNION ALL
-- SELECT * FROM class_text;
