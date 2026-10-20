create database city_zones;
use city_zones;
CREATE TABLE city_zones (
zone_name varchar(100) PRIMARY KEY,
population_density varchar(50) INTEGER,
traffic_index REAL,
avg_speed_kmph REAL,
zone_type TEXT
);
INSERT INTO city_zones VALUES ('Zone_1', null, 2.43, 30.9, 'Residential');
INSERT INTO city_zones VALUES ('Zone_2', 6371, 0.91, 58.4, 'Residential');
INSERT INTO city_zones VALUES ('Zone_3', 12971, 2.11, 38.0, 'Business');
INSERT INTO city_zones VALUES ('Zone_4', 4038, null, 48.2, 'Business');
INSERT INTO city_zones VALUES ('Zone_5', 2590, 1.31, 43.9, 'Business');
INSERT INTO city_zones VALUES ('Zone_6', null, 0.54, 37.6, 'Mixed');
INSERT INTO city_zones VALUES ('Zone_7', 11070, 0.64, null, 'Industrial');
INSERT INTO city_zones VALUES ('Zone_8', 4516, 1.93, 31.0, 'Business');
INSERT INTO city_zones VALUES ('Zone_9', 11037, null, 56.1, 'Mixed');
INSERT INTO city_zones VALUES ('Zone_10', 2440, 1.54, null, 'Industrial');