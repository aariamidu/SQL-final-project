CREATE DATABASE Supermarket;
USE Supermarket; 

CREATE TABLE Product_Information 
(Product_ID INT NOT NULL PRIMARY KEY, 
Product_Name VARCHAR (50) NOT NULL, 
Category VARCHAR (30) NOT NULL, 
Price DECIMAL (4,2) NOT NULL); 

CREATE TABLE Category_Points 
(Category VARCHAR (20) NOT NULL PRIMARY KEY, 
Points INT NOT NULL);

ALTER table Product_Information ADD FOREIGN KEY (Category) REFERENCES Category_Points(Category); 

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

CREATE TABLE Members_Information
(Member_ID INT NOT NULL PRIMARY KEY,
First_Name VARCHAR(20) NOT NULL,
Last_Name VARCHAR(20) NOT NULL,
Email VARCHAR(50) NOT NULL,
Total_Points INT);

INSERT INTO Members_Information (Member_ID, First_Name, Last_Name, Email, Total_Points)
VALUES('1','Sam','Jones','samjones@mail.com',20),
('2','Jenny','Hill','jennyhill@mail.com',16),
('3','Sarah','Smith','sarahsmith@mail.com',43),
('4','Max','Green','maxgreen@mail.com',5),
('5','Jessica','Jackson','jessicajackson@mail.com',10),
('6','Abbie','Mitchell','abbiemitchell@mail.com', null),
('7','Nia','Bonadie','niabonadie@mail.com',15),
('8','Scott','Cooper','scottcooper@mail.com',48),
('9','Reece','Walsh','reecewalsh@mail.com',18),
('10','Connie','Spencer','conniespencer@mail.com',25);

CREATE TABLE Sales_Record 
(Sale_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
Purchase_Date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
Member_ID INT NOT NULL,
Product_ID INT NOT NULL,
FOREIGN KEY (Member_ID) REFERENCES Members_Information (Member_ID)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Product_ID) REFERENCES Product_Information(Product_ID)
ON UPDATE CASCADE ON DELETE CASCADE);

INSERT INTO Sales_Record (Member_ID, Product_ID)
VALUES (2,4), (1,5), (5,3), (5,4), (8,10), (4,15), (4,20), (10,1), (10,14), (10,13),(6,22); 

#View created to show product information and points, using left join from Product_information to Category_Points table
CREATE VIEW Product_Points AS  
(SELECT P.Product_ID, P.Product_Name, P.Price, C.Category, C.Points 
FROM Product_Information AS P 
LEFT JOIN Category_Points AS C 
ON P.Category = C.Category);

#View created to show sale record and points
CREATE VIEW Sales_Points AS 
(SELECT S.Sale_ID, S.Purchase_Date, S.Member_ID, S.Product_ID, P.Price, C.Points
FROM Sales_Record AS S
LEFT JOIN Product_Information AS P ON S.Product_ID = P.Product_ID
JOIN Category_points AS C ON P.Category = C.Category);
Select * from Sales_Points;
#Create 1 stored procedures and functions
#Find total points for each member on specific date and add to total points in members info table
DELIMITER $$
CREATE FUNCTION shopping_trip(Member_ID varchar,Shopping_date VARCHAR, Sales_points INTEGER) RETURNS INTEGER
BEGIN
  DECLARE profit DECIMAL(9,2);
  SET profit = price-cost;
  RETURN profit;
END$$
DELIMITER ;
#Create 1 transaction
#create example query with sub query for data base analysis
