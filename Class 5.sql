
---Class 5

use database db_module1;
use schema academic;

select class_id,
    class_code,
    class_name,
    syllabus:textbook::string as textbook
from classes
where textbook is null;
-- SQL Challenge (Activity)
-- Which classes do not have a specified textbook?