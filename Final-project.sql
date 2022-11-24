CREATE DATABASE Members_info;
USE Members_info;
CREATE TABLE Members_info(ID varchar(20), First_name varchar(20),Last_name varchar(20),Email varchar(50),Total_points integer);
SELECT * FROM Members_info;
INSERT INTO Members_info(ID,First_name,Last_name,Email,Total_points)
VALUES(1,"Sam","Jones","samjones@mail.com",20),(2,"Jenny","Hill","jennyhill@mail.com",15),(3, "Sarah","Smith","sarahsmith@mail.com",12),(4,"Max","Green","maxgreen@mail.com",5),(6,"Jessica","Jackson","jessicajackson@mail.com",10),(7,"Abbie","Mitchell","abbiemitchell@mail.com",1),(8,"Nia","Bonadie","niabonadie@mail.com",18),(9,"Scott","Cooper","scottcooper@mail.com",25),(10,"Reece","Walsh","reecewalsh@mail.com",17);
SHOW TABLES;

