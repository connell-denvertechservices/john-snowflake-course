# John Snowflake Course

Coursework for CIS 355, covering SQL fundamentals and Snowpark/Python notebooks on Snowflake. Files are organized by class session, with a sample academic database used throughout.

## Sample database

[`Academic sample C1.sql`](Academic%20sample%20C1.sql) builds the `DB_MODULE1.ACADEMIC` schema used by the class exercises: `students`, `classes`, and `classes_students` tables (with array and VARIANT/JSON columns), plus the `v_avg_gpa_by_advisor` and `v_pass_rates` views. Run this first to set up the database before working through the class files below.

## Class SQL files

| File | Topics |
| --- | --- |
| [`SQL Test Folder/Class 1 Aug 24.sql`](SQL%20Test%20Folder/Class%201%20Aug%2024.sql) | Intro queries: `SHOW TABLES`, `DESCRIBE TABLE`, sampling rows |
| [`SQL Test Folder/Class 2 Aug 26.sql`](SQL%20Test%20Folder/Class%202%20Aug%2026.sql) | `SELECT`, `WHERE`, `ORDER BY`, `JOIN`, `LIMIT`/`SAMPLE` |
| [`Class 3 Aug 31.sql`](Class%203%20Aug%2031.sql) | Inner joins, semi-structured (JSON/VARIANT) data |
| [`Class 4.sql`](Class%204.sql) | Querying VARIANT fields (e.g. `syllabus:textbook::string`) |
| [`Class 5.sql`](Class%205.sql) | Continued VARIANT field challenges |

## Notebook

[`Noteboob.ipynb`](Noteboob.ipynb) is a Snowflake Notebook that combines SQL and Python to query and analyze the academic database:

- Imports Snowpark (`snowflake.snowpark`), pandas, and Altair
- Runs a `%%sql` cell against `db_module1.academic.classes` and loads the result into a pandas DataFrame
- Uses `get_active_session()` and `session.sql(...)` to run the same kind of query from the Snowpark Python API

## Getting started

1. Open a Snowflake worksheet and run [`Academic sample C1.sql`](Academic%20sample%20C1.sql) to create the database, schema, and sample data.
2. Work through the class SQL files in order (Class 1 → Class 5) to practice querying the schema.
3. Open [`Noteboob.ipynb`](Noteboob.ipynb) in Snowflake Notebooks to see the same data explored with SQL and Python/Snowpark together.
