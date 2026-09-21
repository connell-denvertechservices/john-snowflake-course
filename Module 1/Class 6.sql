-- Class 6 

-- STRUCTURED

-- Activity Part 1

use database db_module1;
use schema module1_final_activity;
show tables;

describe table cars;
describe table dealers;
describe table cars_dealers;

select *
from cars;

select *
from dealers;

select *
from cars_dealers;

-- Example query (in the slides)
select car_id,
    make,
    model
from cars
where category = 'Electric';

-- Activity Part 2: Wrirte a query using SELECT, FROM, INNER JOIN, WHERE, ORDER BY
select d.dealer_id,
    d.dealer_name,
    c.car_id,
    c.make,
    c.model,
    cd.inventory_count,
    cd.price
from cars_dealers cd
inner join cars c on c.car_id = cd.car_id
inner join dealers d on d.dealer_id = cd.dealer_id
where c.category = 'Electric'
order by dealer_name, make, model;

-- SEMI-STUCTURED

-- What would this SQL return (for the slides)
select f.key,
    f.value
from cars_dealers cd,
    lateral flatten(input => special_offers) f
where dealer_id = 1 and car_id = 1;

-- Activity Part 3: Semi-structured queries
select dealer_id,
    car_id,
    price,
    special_offers:discount::number as discount
from cars_dealers;

select dealer_id,
    dealer_name,
    specialties[0]::string as specialties_first
from dealers;

-- UNSTRUCTURED


-- INTERVIEW STYLE QUESTIONS
select car_id,
    dealer_id,
    special_offers
from cars_dealers;

--Activity--

show tables;

describe table cars;
describe table dealers;
describe table cars_dealers;

--
select * 
from cars_dealers;

--activity 2: structured data--

select cd.dealer_id,
cd.car_id,
d.dealer_name,
d.dealer_rating,
c.make,
c.model,
from cars_dealers cd
inner join cars c on c.car_id = cd.car_id
inner join dealers d on d.dealer_id = cd.dealer_id
where c.make = 'Tesla'
order by d.dealer_name;

--activity-3 semi structured data --
select cd.dealer_id,
cd.car_id,
d.dealer_name,
d.dealer_rating,
c.make,
c.model,
cd.special_offers,
from cars_dealers cd
inner join cars c on c.car_id = cd.car_id
inner join dealers d on d.dealer_id = cd.dealer_id
where c.make = 'Tesla'
order by d.dealer_name;

--lateral flattening--

select *
from cars_dealers cd, 
lateral flatten(input => special_offers) f
where cd.dealer_id = 1 and cd.car_id = 1;

select f.key, 
f.value
from cars_dealers cd, 
lateral flatten(input => special_offers) f
where cd.dealer_id = 1 and cd.car_id = 1;


--array--
select dealer_id,
dealer_name,
specialties[0]:: string as specialities_first,
specialties[1]:: string as specialities_second
from dealers;

select dealer_id,
car_id,
special_offers:discount::number as discount
from cars_dealers;


