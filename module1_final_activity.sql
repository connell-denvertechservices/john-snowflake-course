CREATE OR REPLACE SCHEMA db_module1.module1_final_activity;

CREATE OR REPLACE TABLE db_module1.module1_final_activity.dealers (
    dealer_id NUMBER,
    dealer_name VARCHAR,
    location VARCHAR,
    contact_info VARIANT,
    specialties ARRAY,
    dealer_rating NUMBER(2,1),
    description VARCHAR,
    established_date DATE,
    PRIMARY KEY (dealer_id)
);

CREATE OR REPLACE TABLE db_module1.module1_final_activity.cars (
    car_id NUMBER,
    make VARCHAR,
    model VARCHAR,
    year NUMBER,
    specifications VARIANT,
    features ARRAY,
    description VARCHAR,
    category VARCHAR,
    PRIMARY KEY (car_id)
);

CREATE OR REPLACE TABLE db_module1.module1_final_activity.cars_dealers (
    dealer_id NUMBER,
    car_id NUMBER,
    inventory_count NUMBER,
    price NUMBER(10,2),
    last_updated DATE,
    special_offers VARIANT,
    FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);

INSERT INTO db_module1.module1_final_activity.dealers 
SELECT column1, column2, column3, parse_json(column4), parse_json(column5)::ARRAY, column6, column7, column8 FROM VALUES
(1, 'Luxury Motors', 'New York, NY', '{"phone": "212-555-0123", "email": "info@luxurymotors.com", "website": "www.luxurymotors.com"}', '["Luxury", "Sports Cars", "Electric Vehicles"]', 4.8, 'Premium luxury car dealership with exceptional service', '2000-03-15'),
(2, 'Family Auto Hub', 'Los Angeles, CA', '{"phone": "323-555-0124", "email": "sales@familyautohub.com", "website": "www.familyautohub.com"}', '["SUVs", "Minivans", "Sedans"]', 4.5, 'Family-friendly dealership with great selection', '1995-06-22'),
(3, 'EcoWheels', 'Seattle, WA', '{"phone": "206-555-0125", "email": "info@ecowheels.com", "website": "www.ecowheels.com"}', '["Hybrid", "Electric", "Eco-friendly"]', 4.7, 'Specializing in eco-friendly vehicles', '2010-01-10'),
(4, 'Classic Cars Plus', 'Miami, FL', '{"phone": "305-555-0126", "email": "sales@classiccarsplus.com", "website": "www.classiccarsplus.com"}', '["Classic", "Vintage", "Collector"]', 4.6, 'Premier classic car dealership', '1985-11-30'),
(5, 'Budget Auto Sales', 'Chicago, IL', '{"phone": "312-555-0127", "email": "info@budgetauto.com", "website": "www.budgetauto.com"}', '["Economy", "Used Cars", "Budget"]', 4.2, 'Affordable vehicles for every budget', '2005-08-15'),
(6, 'Sport Auto Gallery', 'Houston, TX', '{"phone": "713-555-0128", "email": "info@sportautogallery.com", "website": "www.sportautogallery.com"}', '["Sports Cars", "Performance", "Luxury"]', 4.9, 'High-performance sports car specialist', '2008-04-01'),
(7, 'Reliable Motors', 'Phoenix, AZ', '{"phone": "602-555-0129", "email": "sales@reliablemotors.com", "website": "www.reliablemotors.com"}', '["Used Cars", "Service", "Parts"]', 4.3, 'Trusted used car dealer with full service center', '1998-09-12'),
(8, 'Green Valley Auto', 'Denver, CO', '{"phone": "303-555-0130", "email": "info@greenvalleyauto.com", "website": "www.greenvalleyauto.com"}', '["SUVs", "Trucks", "Off-road"]', 4.4, 'Specializing in outdoor and adventure vehicles', '2012-07-20'),
(9, 'Premium Auto House', 'Boston, MA', '{"phone": "617-555-0131", "email": "sales@premiumauto.com", "website": "www.premiumauto.com"}', '["Luxury", "Import", "Executive"]', 4.7, 'Exclusive luxury vehicle dealership', '2003-12-05'),
(10, 'City Motors', 'San Francisco, CA', '{"phone": "415-555-0132", "email": "info@citymotors.com", "website": "www.citymotors.com"}', '["Compact", "Electric", "Urban"]', 4.5, 'Urban mobility solutions and city cars', '2015-02-28');

INSERT INTO db_module1.module1_final_activity.cars 
SELECT column1, column2, column3, column4, parse_json(column5), parse_json(column6)::ARRAY, column7, column8 FROM VALUES
(1, 'Tesla', 'Model S', 2023, '{"engine": "Electric", "horsepower": 670, "range": "405 miles"}', '["Autopilot", "Premium Sound", "Air Suspension"]', 'Luxury electric sedan with cutting-edge technology', 'Electric'),
(2, 'Toyota', 'RAV4', 2023, '{"engine": "2.5L 4-cylinder", "horsepower": 203, "mpg": "30 city/38 highway"}', '["Safety Sense", "AWD", "Apple CarPlay"]', 'Popular compact SUV with excellent reliability', 'SUV'),
(3, 'Porsche', '911', 2023, '{"engine": "3.0L Twin-Turbo", "horsepower": 443, "acceleration": "0-60 in 3.5s"}', '["Sport Chrono", "PDK", "Sport Exhaust"]', 'Iconic sports car with exceptional performance', 'Sports Car'),
(4, 'Honda', 'Odyssey', 2023, '{"engine": "3.5L V6", "horsepower": 280, "seating": "8 passengers"}', '["Magic Slide", "Vacuum", "Rear Entertainment"]', 'Family-friendly minivan with innovative features', 'Minivan'),
(5, 'Ford', 'F-150', 2023, '{"engine": "3.5L EcoBoost", "horsepower": 400, "towing": "14000 lbs"}', '["Pro Power", "Sync 4", "Trail Control"]', 'Best-selling pickup truck with powerful capabilities', 'Truck'),
(6, 'BMW', 'M3', 2023, '{"engine": "3.0L Twin-Turbo", "horsepower": 503, "transmission": "8-speed auto"}', '["M Drive", "Carbon Roof", "Sport Seats"]', 'High-performance luxury sports sedan', 'Sports Car'),
(7, 'Chevrolet', 'Bolt', 2023, '{"engine": "Electric", "horsepower": 200, "range": "259 miles"}', '["One Pedal", "Fast Charging", "Sport Mode"]', 'Affordable electric vehicle with good range', 'Electric'),
(8, 'Mercedes-Benz', 'S-Class', 2023, '{"engine": "3.0L Inline-6", "horsepower": 429, "transmission": "9-speed auto"}', '["MBUX", "Air Balance", "Burmester 4D"]', 'Ultimate luxury sedan with advanced technology', 'Luxury'),
(9, 'Jeep', 'Wrangler', 2023, '{"engine": "3.6L V6", "horsepower": 285, "ground_clearance": "10.8 inches"}', '["4x4", "Removable Top", "Trail Rated"]', 'Iconic off-road vehicle with great capability', 'SUV'),
(10, 'Volkswagen', 'ID.4', 2023, '{"engine": "Electric", "horsepower": 201, "range": "275 miles"}', '["IQ.Drive", "Massage Seats", "Panoramic Roof"]', 'Electric SUV with modern design and comfort', 'Electric');

INSERT INTO db_module1.module1_final_activity.cars_dealers 
SELECT column1, column2, column3, column4, column5, parse_json(column6) FROM VALUES
(1, 1, 5, 89999.99, '2023-05-15', '{"discount": 5000, "financing": "0.9% APR", "warranty": "Extended"}'),
(1, 3, 3, 125000.00, '2023-05-15', '{"discount": 7500, "financing": "1.9% APR", "track_day": "Included"}'),
(2, 2, 10, 32999.99, '2023-05-15', '{"discount": 2000, "financing": "0% APR", "maintenance": "2 years free"}'),
(2, 4, 8, 45999.99, '2023-05-15', '{"discount": 3000, "financing": "0.9% APR", "warranty": "Basic"}'),
(3, 1, 6, 88999.99, '2023-05-15', '{"discount": 4000, "financing": "1.9% APR", "charging": "Free installation"}'),
(3, 7, 12, 35999.99, '2023-05-15', '{"discount": 2500, "financing": "0% APR", "charging": "Credits included"}'),
(4, 6, 4, 79999.99, '2023-05-15', '{"discount": 6000, "financing": "2.9% APR", "track_day": "Optional"}'),
(5, 2, 15, 31999.99, '2023-05-15', '{"discount": 1500, "financing": "0.9% APR", "warranty": "Basic"}'),
(6, 3, 2, 127000.00, '2023-05-15', '{"discount": 8000, "financing": "2.9% APR", "track_day": "Included"}'),
(7, 5, 8, 55999.99, '2023-05-15', '{"discount": 3500, "financing": "1.9% APR", "warranty": "Extended"}');