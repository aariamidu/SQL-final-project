CREATE DATABASE Members_info;
USE Members_info;
CREATE TABLE Members_info(ID varchar(20), First_name varchar(20),Last_name varchar(20),Email varchar(50),Total_points integer);
SELECT * FROM Members_info;
INSERT INTO Members_info(ID,First_name,Last_name,Email,Total_points)
VALUES(