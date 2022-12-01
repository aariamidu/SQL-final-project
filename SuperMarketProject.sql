CREATE DATABASE Supermarket;
USE Supermarket; 
​
CREATE TABLE Product_Information 
(Product_ID INT NOT NULL PRIMARY KEY, 
Product_Name VARCHAR (50) NOT NULL, 
Category VARCHAR (30) NOT NULL, 
Price DECIMAL (4,2) NOT NULL); 
​
CREATE TABLE Category_Points 
(Category VARCHAR (20) NOT NULL PRIMARY KEY, 
Points INT NOT NULL);
​
ALTER table Product_Information ADD FOREIGN KEY (Category) REFERENCES Category_Points(Category); 
​
INSERT INTO Category_Points (Category, Points)
VALUES ('Bakery', 8),
('Cereals & Grains', 10),
('Confectionery', 5),
('Dairy', 8),
('Drinks', 8),
('Food to Go', 5),
('Fresh Meat', 10),
('Fruit & Veg',	5),
('Ready Meal', 10),
('Snacks', 5);
​
INSERT INTO Product_Information (Product_ID, Product_Name, Category, Price)
VALUES ('1', 'Apples', 'Fruit & Veg', 1.50),
('2', 'Crisps', 'Snacks', 1.00),
('3', 'Ham Sandwich', 'Food to Go', 2.00),
('4', 'Pizza', 'Ready Meal', 3.50),
('5', 'Milk', 'Dairy', 1.50),
('6', 'Chicken Salad', 'Food to Go', 4.00),
('7', 'Rice', 'Cereals & Grains', 5.00),
('8', 'Chocolate Cake', 'Bakery', 3.00),
('9', 'Gummy Sweets', 'Confectionery', 2.00),
('10', 'Mac & Cheese', 'Ready Meal', 3.50),
('11', 'Orange Juice', 'Drinks', 1.50),
('12', 'Soft Drink', 'Drinks', 1.50),
('13', 'Turkey Slices', 'Fresh Meat', 2.00),
('14', 'Salmon', 'Fresh Meat', 2.50),
('15', 'Cupcakes', 'Bakery', 3.00),
('16', 'Pasta', 'Cereals & Grains', 4.00),
('17', 'Cheese', 'Dairy', 3.00),
('18', 'Bananas', 'Fruit & Veg', 1.00),
('19', 'Lasagne', 'Ready Meal', 4.00),
('20', 'Lemonade', 'Drinks', 2.50),
('21', 'Whole Chicken', 'Fresh Meat', 5.00),
('22', 'Truffles', 'Confectionery', 3.00),
('23', 'Doughnuts', 'Bakery', 4.00),
('24', 'Biscuits', 'Snacks', 2.50),
('25', 'Lamb Leg', 'Fresh Meat', 5.00);
​
#Left Join Example (To see how many points each product is worth)
SELECT P.Product_ID, P.Product_Name, P.Price, C.Category, C.Points 
FROM Product_Information AS P 
LEFT JOIN Category_Points AS C 
ON P.Category = C.Category;
​
#View created to show product information and points, using left join from Product_information to Category_Points table
CREATE VIEW Product_Points AS  
(SELECT P.Product_ID, P.Product_Name, P.Price, C.Category, C.Points 
FROM Product_Information AS P 
LEFT JOIN Category_Points AS C 
ON P.Category = C.Category);
​
SELECT * FROM Product_Points;
​
#Statement to return the view Product_points ordered by Category
SELECT * FROM Product_Points ORDER BY Category ASC;
​
CREATE TABLE Members_Information
(Member_ID INT NOT NULL PRIMARY KEY,
First_Name VARCHAR(20) NOT NULL,
Last_Name VARCHAR(20) NOT NULL,
Email VARCHAR(50) NOT NULL,
Total_Points INT);
​
INSERT INTO Members_Information (Member_ID, First_Name, Last_Name, Email, Total_Points)
VALUES('1','Sam','Jones','samjones@mail.com',20),
('2','Jenny','Hill','jennyhill@mail.com',16),
('3','Sarah','Smith','sarahsmith@mail.com',43),
('4','Max','Green','maxgreen@mail.com',5),
('5','Jessica','Jackson','jessicajackson@mail.com',10),
('6','Abbie','Mitchell','abbiemitchell@mail.com', 0),
('7','Nia','Bonadie','niabonadie@mail.com',15),
('8','Scott','Cooper','scottcooper@mail.com',48),
('9','Reece','Walsh','reecewalsh@mail.com',18),
('10','Connie','Spencer','conniespencer@mail.com',25);
​
​
CREATE TABLE Sales_Record 
(Sale_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
Purchase_Date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
Member_ID INT NOT NULL,
Product_ID INT NOT NULL,
FOREIGN KEY (Member_ID) REFERENCES Members_Information (Member_ID)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Product_ID) REFERENCES Product_Information(Product_ID)
ON UPDATE CASCADE ON DELETE CASCADE);

#View created to show sale record, price and points
CREATE VIEW Sales_Points AS 
(SELECT S.Sale_ID, S.Purchase_Date, S.Member_ID, S.Product_ID, P.Price, C.Points
FROM Sales_Record AS S
LEFT JOIN Product_Information AS P ON S.Product_ID = P.Product_ID
JOIN Category_points AS C ON P.Category = C.Category);
SELECT * FROM Sales_Points;

#Querying database using CONCAT to make the member and product IDs distinct 
SELECT S.Sale_ID, S.Purchase_Date, 
CONCAT('M', S.Member_ID) AS Member_ID, 
CONCAT('P', S.Product_ID) AS Product_ID,
P.Price, C.Points
FROM Sales_Record AS S
LEFT JOIN Product_Information AS P ON S.Product_ID = P.Product_ID
JOIN Category_points AS C ON P.Category = C.Category;​

#Query used to show the total price of the shopping for each member on different days
SELECT Member_ID, Purchase_Date,
SUM(Product_ID) as price_total 
FROM Sales_Record GROUP BY Member_ID, Purchase_Date;
#Sub-Query used to show members with less than 30 points
SELECT *
   FROM Members_Information
   WHERE First_Name IN (SELECT First_Name
         FROM Members_Information
         WHERE Total_Points < 30);
​
#View created to show all points earned from shopping trip (recorded in sales points) grouped by members
Create View Daily_shop AS
SELECT Member_ID, SUM(Points) AS Daily_Points 
FROM Sales_Points GROUP BY Member_ID;

#Shows  members info, new points earned from daily shop, current points and overall points in  members account
SELECT M.Member_ID, M.First_Name, M.Last_Name, Email, 
D.Daily_Points AS New_Points, 
M.Total_Points AS Current_Points,
(D.Daily_Points + M.Total_Points) AS Overall_Points
FROM Daily_Shop AS D
LEFT JOIN Members_Information AS M ON D.Member_ID = M.Member_ID
GROUP BY Member_ID
ORDER BY Member_ID;

#STORED FUNCTION to combine first and last names of members 
DELIMITER $$
CREATE FUNCTION Full_Name(First_Name VARCHAR(20), Last_Name VARCHAR(20)) RETURNS VARCHAR (30)
DETERMINISTIC 
BEGIN 
RETURN CONCAT(First_name, ' ', Last_name);
END$$
DELIMITER ;
​
#Stored function used in a query to extract data
SELECT M.Member_ID, Full_Name(first_name, Last_name) as Full_Name, (D.Daily_Points + M.Total_Points) AS Overall_Points
FROM Daily_Shop AS D
LEFT JOIN Members_Information AS M ON D.Member_ID = M.Member_ID
GROUP BY Member_ID
ORDER BY Member_ID;
​
​
#STORED FUNCTION to show the overall points in members accounts 
DELIMITER $$
CREATE FUNCTION Overall_points(Total_Points INT, Daily_Points INT) Returns INT
DETERMINISTIC 
BEGIN
  DECLARE Overall_points INT;
  SET Overall_points = Total_Points + Daily_Points;
  RETURN Overall_points;
END$$
DELIMITER ;

#Stored function Overall_Points used in a Query
SELECT M.Member_ID, Overall_points(M.Total_Points, D.Daily_Points) AS Overall_points 
FROM Members_Information AS M
LEFT JOIN Daily_Shop AS D ON M.Member_ID = D.Member_ID;
​
​#STORED FUNCTION to combine first and last names of members 
DELIMITER $$
CREATE FUNCTION Full_Name(First_Name VARCHAR(20), Last_Name VARCHAR(20)) RETURNS VARCHAR (30)
DETERMINISTIC 
BEGIN 
RETURN CONCAT(First_name, ' ', Last_name);
END$$
DELIMITER ;
​
#Stored function used in a query to extract data
SELECT M.Member_ID, Full_Name(first_name, Last_name) as Full_Name, (D.Daily_Points + M.Total_Points) AS Overall_Points
FROM Daily_Shop AS D
LEFT JOIN Members_Information AS M ON D.Member_ID = M.Member_ID
GROUP BY Member_ID
ORDER BY Member_ID;
​
​
#STORED FUNCTION to show the overall points in members accounts 
DELIMITER $$
CREATE FUNCTION Overall_points(Total_Points INT, Daily_Points INT) Returns INT
DETERMINISTIC 
BEGIN
  DECLARE Overall_points INT;
  SET Overall_points = Total_Points + Daily_Points;
  RETURN Overall_points;
END$$
DELIMITER ;

#Stored function Overall_Points used in a Query
SELECT M.Member_ID, Overall_points(M.Total_Points, D.Daily_Points) AS Overall_points 
FROM Members_Information AS M
LEFT JOIN Daily_Shop AS D ON M.Member_ID = D.Member_ID;
​
​
#STORED PROCEDURE example
DELIMITER $$
CREATE PROCEDURE Overall_points()
BEGIN
  SELECT M.Total_Points + D.Daily_Points AS Overall_points 
FROM Members_Information AS M
LEFT JOIN Daily_Shop AS D ON M.Member_ID = D.Member_ID;
END$$
DELIMITER ;
CALL Overall_points();

#Data combined from 3 tables to be exported in CSV & analysed in Tableau
SELECT S.Sale_ID, S.Purchase_Date, 
CONCAT('P', S.Product_ID) AS Product_ID, 
CONCAT ('M', M.Member_ID) AS Member_ID,
M.First_Name, M.Last_Name, M.Email,
M.Total_Points AS Current_Points, 
D.Daily_Points AS New_Points,
(D.Daily_Points + M.Total_Points) AS Overall_Points
FROM Sales_record AS S
LEFT JOIN Members_Information AS M ON M.Member_ID = S.Member_ID
JOIN Daily_Shop AS D ON D.Member_ID = S.Member_ID