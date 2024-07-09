create table amazon_sales(
UserID int primary key,
UserName varchar(1000) Unique,
Email varchar(1000) Unique,
password  varchar(500),
FirstName varchar(500),
LastName varchar(300),
Address varchar(1000),
state varchar(500),
city varchar(500),
Zipcode  int,
Country varchar(500),
phoneNum BIGint

)

create table amazon_sales_order(
OrderID int primary key,
UserID int,
productID int,
productname varchar(500),
Orderdate DATE,
Totalamount int,
status varchar(200)
foreign key(userid) references amazon_sales(userid)
on update cascade
on delete cascade
)


create table amazon_sales_payments(
PaymentID int primary key,
UserID int,
OrderID int,
Paymentmethod varchar(500),
Amount int,
paymentdate DATE,
foreign key(userid) references amazon_sales(userid)
on update cascade
on delete cascade
)

CREATE TABLE amazon_sales_reviews (
    ReviewID INT PRIMARY KEY,
    UserID INT,
    OrderID INT,
    Rating INT,
    ReviewText TEXT,
    ReviewDate DATE,
    FOREIGN KEY (UserID) REFERENCES amazon_sales(UserID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	
);


CREATE TABLE amazon_sales_returns (
    ReturnID INT PRIMARY KEY,
    UserID INT,
    ProductName NVARCHAR(100),
    ProductID INT,
    Description NVARCHAR(MAX)
	FOREIGN KEY (UserID) REFERENCES amazon_sales(UserID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



select * from amazon_sales
select * from amazon_sales_order
select * from amazon_sales_payments
select * from amazon_sales_reviews
select * from amazon_sales_returns



------------------Join Query------------------


SELECT 
    u.UserID,
    u.UserName,
    u.Email,
    u.FirstName,
    u.LastName,
    u.Address,
    u.state,
    u.city,
    u.Zipcode,
    u.Country,
    u.phoneNum,
    o.OrderID,
    o.productID,
    o.productname,
    o.Orderdate,
    o.Totalamount,
    o.status,
    p.PaymentID,
    p.Paymentmethod,
    p.Amount,
    p.paymentdate,
    r.ReviewID,
    r.Rating,
    r.ReviewText,
    r.ReviewDate,
    rr.returnID,
	rr.ProductName AS ReturnedProductName,
    rr.Description AS ReturnDescription
FROM amazon_sales u
LEFT JOIN amazon_sales_order o ON u.UserID = o.UserID
LEFT JOIN amazon_sales_payments p ON u.UserID = p.UserID
LEFT JOIN amazon_sales_reviews r ON u.UserID = r.UserID
LEFT JOIN amazon_sales_returns rr ON u.UserID = rr.returnID;



-------------------using Group By/Order By-----------

SELECT
    u.UserID,
    u.UserName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalAmountSpent,
    AVG(r.Rating) AS AverageRating
FROM
    amazon_sales u
LEFT JOIN
    amazon_sales_order o ON u.UserID = o.UserID
LEFT JOIN
    amazon_sales_reviews r ON u.UserID = r.UserID
GROUP BY
    u.UserID, u.UserName
ORDER BY
    TotalAmountSpent DESC;

---------------------Using Aggregate Function---------------
SELECT
    UserID,
    COUNT(OrderID) AS TotalOrders,
    SUM(Totalamount) AS TotalAmountSpent,
    AVG(CAST(Totalamount AS FLOAT)) AS AverageAmountSpent,
    MAX(Orderdate) AS LatestOrderDate,
    MIN(Orderdate) AS EarliestOrderDate
FROM
    amazon_sales_order
GROUP BY
    UserID
ORDER BY
    TotalAmountSpent DESC;


-- Retrieve the count of orders for each UserID
SELECT 
    UserID,
    COUNT(*) AS OrderCount
FROM 
    amazon_sales_order
GROUP BY 
    UserID;


-- Query using CTE in amazon_users

WITH active_users AS (
    SELECT 
        UserID,
        UserName,
		Country,
        Email,
        FirstName,
        LastName
    FROM 
        amazon_sales
    WHERE 
        Country='India'  -- Assuming there is a column IsActive to indicate active users
)
SELECT *
FROM active_users;

-------------------------------------

-- Query using CASE in amazon_users

SELECT 
    UserID,
    UserName,
    Email,
	Country,
    FirstName,
    LastName,
    CASE 
        WHEN Country = 'USA' THEN 'Domestic'
        ELSE 'International'
    END AS CustomerType
FROM 
    amazon_sales;




-----Calculate Total Amount Spent by Each User------

SELECT
    UserID,
    SUM(Totalamount) AS TotalAmountSpent
FROM
    amazon_sales_order
GROUP BY
    UserID
ORDER BY
    TotalAmountSpent DESC;


-------Calculate Average Rating for Each Product--------


SELECT
    ProductName,
    AVG(Rating) AS AverageRating
FROM
    amazon_sales_reviews r
JOIN
    amazon_sales_order o ON r.OrderID = o.OrderID
GROUP BY
    ProductName
ORDER BY
    AverageRating DESC;

-----Retrieve Users Who Have Not Placed Orders---------

SELECT
    u.UserID,
    u.UserName
FROM
    amazon_sales u
LEFT JOIN
    amazon_sales_order o ON u.UserID = o.UserID
WHERE
    o.OrderID IS NULL;

----------------Store Procedure-----------

-- Create a stored procedure to retrieve orders by UserID


CREATE PROCEDURE GetOrdersByUserids (@pUserID INT)
AS
BEGIN
    SELECT
        OrderID,
        ProductName,
        Orderdate,
        TotalAmount,
        Status
    FROM
        amazon_sales_order
    WHERE
        UserID = @pUserID;
END;
GO

GetOrdersByUserids 34


---Retrieve Orders Within a Specific Date Range----

SELECT
    OrderID,
    UserID,
    ProductName,
    Orderdate,
    TotalAmount
FROM
    amazon_sales_order
WHERE
    Orderdate BETWEEN '2024-07-01' AND '2024-07-30'
ORDER BY
    Orderdate DESC;







-------------------------Inserting Values-------------------------------


INSERT INTO amazon_sales_returns (ReturnID, UserID, ProductName, ProductID, Description)
SELECT 
    ROW_NUMBER() OVER (ORDER BY UserID) + 35 AS ReturnID,
    UserID,
    ProductName,
    ProductID,
    'Returned product' AS Description
FROM 
    amazon_sales_order
WHERE 
    UserID BETWEEN 36 AND 40;

---------------------------Date & Functions-----------------






















insert into amazon_sales values

(1,'MS Dhoni','msd@gmal.com','master123','MS','Dhoni','34 1st cross ranji','JK','Ranji',611067,'India',9865863698),
(2,'Suresh Raina','sr@gmail.com','master123','Suresh','Raina','33street Delhi','Haryana','Delhi',539575,'India',7936894567),
(3,'virat kohli','vk@gmail.com','master123','virat','kohli','18 street Delhi','MH','Mumbai',768943,'India',8723451976),
(4,'Rishab Pant','RP@gmail.com','master123','Rishab','pant','23 street lucknow','UP','lucknow',2345342,'India',6758943945),
(5,'shreyas iyer','si@gmail.com','master123','shreyas','iyer','45 street kolkata','WB','kolkata',563783,'India',7689054323),
(6,'sam curran','smcurran@gmail.com','master123','sam','curran','54 street England','UK','London',678342,'England',7835479265),
(7,'moen ali','moenali@gmail.com','master123','moen','ali','66 street england','UK','London',432678,'England',9834657823),
(8,'jos butler','josb@gmail.com','master123','jos','butler','22 street london','UK','london',456732,'England',8746528234),
(9,'Tom curran','tomcurran@gmail.com','master123','Tom','Curran','65 street england','UK','London',789747,'England',9345627365),
(10,'Ben stoke','benstoke@gmail.com','master123','Ben','stoke','77 street england','UK','London',765234,'England',8783477890),
(11,'David warner','Davidw@gmail.com','master123','David','Warner','32 street Aus','NSW','Sydney',453243,'Australia',6457292034),
(12,'Glen Maxwell','Gmaxwell@gmail.com','master123','Glen','maxwell','42 street Aus','Vic','Melbourne',678435,'Australia',9834567823),
(13,'steve smith','ssmith@gmail.com','master123','steve','smith','55 street Aus','WA','perth',879237,'Australia',7837845678),
(14,'Travis Head','THead@gmail.com','master123','Travis','Head','23 street Aus','Vic','Melbourne',546879,'Australia',9456784576),
(15,'Ricky pointing','rpointing@gmail.com','master123','Ricky','pointing','32 street Aus','NSW','Sydney',897654,'Australia',8967543278),
(16,'Devon Conway','Dconway@gmail.com','master123','Devon','Conway','12 street NZ','Ak','Auckland',876543,'New Zealand',8756749899),
(17,'Mitchell Satnar','Msatnar@gmail.com','master123','Mitchell','satnar','89 street NZ','WG','Wellington',678543,'New Zealand',8796546776),
(18,'Rachin Ravindra','Rravindra@gmail.com','master123','Rachin','Ravindra','55 street NZ','AK','Auckland',786980,'New Zealand',9456998734),
(19,'kane williamson','kwilliamson@gmail.com','master123','kane','williamson','22 street NZ','AK','Auckland',890347,'New Zealand',9768543678),
(20,'Darry Mitchell','Dmitchell@gmail.com','master123','Darry','Mitchell','54 street NZ','WG','Welligton',543782,'New Zealand',7688745654),
(21,'AB Develiers','ABD@gmail.com','master123','AB','Develiers','71 street Capetown','SA','capetown',974690,'South Africa',7708775342),
(22,'Faf Duplesis','faf@gmail.com','master123','faf','duplesis','13 street CT','SA','Capetown',784352,'south africe',7895643741),
(23,'Quinton Dcock','Qdcock@gmail.com','master123','Quinton','Dcock','23 street CT','SA','Capetown',569873,'South Africa',9843527876),
(24,'Heinrich Klaseen','Hklaseen@gmail.com','master123','Heinrich','klaseen','53 street CT','SA','Capetown',786590,'South Africa',9080705463),
(25,'Albie Morkal','Amorkal@gmail.com','master123','Albie','Morkal','76 street CT','SA','Capetown',456327,'South Africa',8097689012),
(26, 'John Doe', 'Jdoe@gmal.com', 'master123', 'John', 'Doe', '123 Main St', 'California', 'Los Angeles', 90001, 'USA', 1234567890),
(27, 'jane smith', 'jsmith@gmail.com', 'master123', 'Jane', 'Smith', '456 Elm St', 'New York', 'New York City', 10001, 'USA', 2345678901),
(28, 'mike johnson', 'mikej@gmail.com', 'master123', 'Mike', 'Johnson', '789 Oak St', 'Texas', 'Houston', 77001, 'USA', 3456789012),
(29, 'Emily Brown', 'EmilyB@gmail.com', 'master123', 'Emily', 'Brown', '101 Pine St', 'Florida', 'Miami', 33101, 'USA', 4567890123),
(30, 'Chris Wilson', 'ChrisW@gmail.com', 'master123', 'Chris', 'Wilson', '202 Maple St', 'Illinois', 'Chicago', 60601, 'USA', 5678901234),
(31, 'sarah martinez', 'Sarahm@gmail.com', 'master123', 'Sarah', 'Martinez', '303 Cedar St', 'Arizona', 'Phoenix', 85001, 'USA', 6789012345),
(32, 'David garcia', 'Davidg@gmail.com', 'master123', 'David', 'Garcia', '404 Birch St', 'California', 'San Francisco', 94101, 'USA', 7890123456),
(33, 'jessica lopez', 'jessicaL@gmail.com', 'master123', 'Jessica', 'Lopez', '505 Walnut St', 'Texas', 'Dallas', 75201, 'USA', 8901234567),
(34, 'michael hernandez', 'michaelH@gmail.com', 'master123', 'Michael', 'Hernandez', '606 Pineapple St', 'Florida', 'Orlando', 32801, 'USA', 9012345678),
(35, 'Amanda Gonzalez', 'AmandaG@gmail.com', 'master123', 'Amanda', 'Gonzalez', '707 Peach St', 'New York', 'Buffalo', 14201, 'USA', 1234567890),
(36, 'Daniel Rodriguez', 'DanielR@gmail.com', 'master123', 'Daniel', 'Rodriguez', '808 Cherry St', 'California', 'Sacramento', 95801, 'USA', 2345678901),
(37, 'Nicole Perez', 'NicoleP@gmail.com', 'master123', 'Nicole', 'Perez', '909 Banana St', 'Illinois', 'Springfield', 62701, 'USA', 3456789012),
(38, 'Matthew Sanchew', 'matthewS@gmail.com', 'master123', 'Matthew', 'Sanchez', '1010 Grape St', 'Texas', 'Austin', 73301, 'USA', 4567890123),
(39, 'Ashley Torres', 'AshleyT@gmail.com', 'master123', 'Ashley', 'Torres', '1111 Mango St', 'Florida', 'Tampa', 33601, 'USA', 5678901234),
(40, 'Andrew Rivera', 'AndrewR@gmail.com', 'master123', 'Andrew', 'Rivera', '1212 Kiwi St', 'California', 'San Diego', 92101, 'USA', 6789012345),
(41, 'Samantha Flores', 'SamanthaF@gmail.com', 'master123', 'Samantha', 'Flores', '1313 Lemon St', 'Texas', 'El Paso', 79901, 'USA', 7890123456),
(42, 'Christopher Gomez', 'ChristopherG@gmail.com', 'master123', 'Christopher', 'Gomez', '1414 Orange St', 'New York', 'Rochester', 14601, 'USA', 8901234567),
(43, 'Brittany Diaz', 'BrittanyD@gmail.com', 'master123', 'Brittany', 'Diaz', '1515 Blueberry St', 'Illinois', 'Peoria', 61601, 'USA', 9012345678),
(44, 'Justin Hernandez', 'JustinH@gmail.com', 'master123', 'Justin', 'Hernandez', '1616 Raspberry St', 'Florida', 'Jacksonville', 32201, 'USA', 1234567890),
(45, 'Stephanie Martinez', 'StephanieM@gmail.com', 'master123', 'Stephanie', 'Martinez', '1717 Blackberry St', 'California', 'Fresno', 93701, 'USA', 2345678901),
(46, 'Ryan Lopez', 'RyanL@gmail.com', 'master123', 'Ryan', 'Lopez', '1818 Strawberry St', 'Texas', 'San Antonio', 78201, 'USA', 3456789012),
(47, 'Heather Gonzale', 'HeatherG@example.com', 'master123', 'Heather', 'Gonzalez', '1919 Watermelon St', 'New York', 'Syracuse', 13201, 'USA', 4567890123),
(48, 'Nicolas Pooran', 'Npooran@gmail.com', 'master123', 'Nicolas', 'Pooran', '199 Water St', 'New York', 'NJ', 13281, 'USA', 4567878123),
(49, 'Dwayne Bravo', 'DBravo@gmail.com', 'master123', 'Dwayne', 'Bravo', '78 Blue St', 'New York', 'Edison', 13241, 'USA', 4567832123),
(50, 'Hardik Pandya', 'Hpandya@gmail.com', 'master123', 'Hardik', 'Pandya', '1917 third cross St', 'New York', 'NYC', 13271, 'USA', 4562690123)

INSERT INTO amazon_sales_order (OrderID, UserID, ProductID, ProductName, OrderDate, TotalAmount, Status)
VALUES
(1, 1, 1, 'Laptop', '2024-07-01', 1200, 'Shipped'),
(2, 2, 2, 'Smartphone', '2024-07-02', 800, 'Delivered'),
(3, 3, 3, 'Headphones', '2024-07-03', 100, 'Pending'),
(4, 4, 4, 'Camera', '2024-07-04', 600, 'Shipped'),
(5, 5, 5, 'Tablet', '2024-07-05', 500, 'Delivered'),
(6, 6, 6, 'Keyboard', '2024-07-06', 50, 'Pending'),
(7, 7, 1, 'Laptop', '2024-07-07', 1200, 'Shipped'),
(8, 8, 2, 'Smartphone', '2024-07-08', 800, 'Delivered'),
(9, 9, 3, 'Headphones', '2024-07-09', 100, 'Pending'),
(10, 10, 4, 'Camera', '2024-07-10', 600, 'Shipped'),
(11, 11, 5, 'Tablet', '2024-07-11', 500, 'Delivered'),
(12, 12, 6, 'Keyboard', '2024-07-12', 50, 'Pending'),
(13, 13, 1, 'Laptop', '2024-07-13', 1200, 'Shipped'),
(14, 14, 2, 'Smartphone', '2024-07-14', 800, 'Delivered'),
(15, 15, 3, 'Headphones', '2024-07-15', 100, 'Pending'),
(16, 16, 4, 'Camera', '2024-07-16', 600, 'Shipped'),
(17, 17, 5, 'Tablet', '2024-07-17', 500, 'Delivered'),
(18, 18, 6, 'Keyboard', '2024-07-18', 50, 'Pending'),
(19, 19, 1, 'Laptop', '2024-07-19', 1200, 'Shipped'),
(20, 20, 2, 'Smartphone', '2024-07-20', 800, 'Delivered'),
(21, 21, 3, 'Headphones', '2024-07-21', 100, 'Pending'),
(22, 22, 4, 'Camera', '2024-07-22', 600, 'Shipped'),
(23, 23, 5, 'Tablet', '2024-07-23', 500, 'Delivered'),
(24, 24, 6, 'Keyboard', '2024-07-24', 50, 'Pending'),
(25, 25, 1, 'Laptop', '2024-07-25', 1200, 'Shipped'),
(26, 26, 2, 'Smartphone', '2024-07-26', 800, 'Delivered'),
(27, 27, 3, 'Headphones', '2024-07-27', 100, 'Pending'),
(28, 28, 4, 'Camera', '2024-07-28', 600, 'Shipped'),
(29, 29, 5, 'Tablet', '2024-07-29', 500, 'Delivered'),
(30, 30, 6, 'Keyboard', '2024-07-30', 50, 'Pending'),
(31, 31, 1, 'Laptop', '2024-07-31', 1200, 'Shipped'),
(32, 32, 2, 'Smartphone', '2024-08-01', 800, 'Delivered'),
(33, 33, 3, 'Headphones', '2024-08-02', 100, 'Pending'),
(34, 34, 4, 'Camera', '2024-08-03', 600, 'Shipped'),
(35, 35, 5, 'Tablet', '2024-08-04', 500, 'Delivered'),
(36, 36, 1, 'Laptop', '2024-08-05', 1200, 'Returned'),
(37, 37, 2, 'Smartphone', '2024-08-06', 800, 'Returned'),
(38, 38, 3, 'Headphones', '2024-08-07', 100, 'Returned'),
(39, 39, 4, 'Camera', '2024-08-08', 600, 'Returned'),
(40, 40, 5, 'Tablet', '2024-08-09', 500, 'Returned');
(41, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(42, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(43, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(44, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(45, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(46, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(47, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(48, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(49, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet'),
(50, NULL, NULL, NULL, NULL, NULL, 'No orders placed yet');


INSERT INTO amazon_sales_payments (PaymentID, UserID, OrderID, PaymentMethod, Amount, PaymentDate)
VALUES
(1, 1, 1, 'Credit Card', 1200, '2024-07-01'),
(2, 2, 2, 'PayPal', 800, '2024-07-02'),
(3, 3, 3, 'Debit Card', 100, '2024-07-03'),
(4, 4, 4, 'Bank Transfer', 600, '2024-07-04'),
(5, 5, 5, 'Credit Card', 500, '2024-07-05'),
(6, 6, 6, 'PayPal', 50, '2024-07-06'),
(7, 7, 7, 'Debit Card', 1200, '2024-07-07'),
(8, 8, 8, 'Bank Transfer', 800, '2024-07-08'),
(9, 9, 9, 'Credit Card', 100, '2024-07-09'),
(10, 10, 10, 'PayPal', 600, '2024-07-10'),
(11, 11, 11, 'Debit Card', 500, '2024-07-11'),
(12, 12, 12, 'Credit Card', 50, '2024-07-12'),
(13, 13, 13, 'Bank Transfer', 1200, '2024-07-13'),
(14, 14, 14, 'PayPal', 800, '2024-07-14'),
(15, 15, 15, 'Debit Card', 100, '2024-07-15'),
(16, 16, 16, 'Credit Card', 600, '2024-07-16'),
(17, 17, 17, 'PayPal', 500, '2024-07-17'),
(18, 18, 18, 'Bank Transfer', 50, '2024-07-18'),
(19, 19, 19, 'Credit Card', 1200, '2024-07-19'),
(20, 20, 20, 'PayPal', 800, '2024-07-20'),
(21, 21, 21, 'Debit Card', 100, '2024-07-21'),
(22, 22, 22, 'Credit Card', 600, '2024-07-22'),
(23, 23, 23, 'PayPal', 500, '2024-07-23'),
(24, 24, 24, 'Bank Transfer', 50, '2024-07-24'),
(25, 25, 25, 'Credit Card', 1200, '2024-07-25'),
(26, 26, 26, 'PayPal', 800, '2024-07-26'),
(27, 27, 27, 'Debit Card', 100, '2024-07-27'),
(28, 28, 28, 'Credit Card', 600, '2024-07-28'),
(29, 29, 29, 'PayPal', 500, '2024-07-29'),
(30, 30, 30, 'Bank Transfer', 50, '2024-07-30'),
(31, 31, 31, 'Credit Card', 1200, '2024-07-31'),
(32, 32, 32, 'PayPal', 800, '2024-08-01'),
(33, 33, 33, 'Debit Card', 100, '2024-08-02'),
(34, 34, 34, 'Credit Card', 600, '2024-08-03'),
(35, 35, 35, 'PayPal', 500, '2024-08-04'),
(36, 36, 36, 'Bank Transfer', 1200, '2024-08-05'),
(37, 37, 37, 'Credit Card', 800, '2024-08-06'),
(38, 38, 38, 'PayPal', 100, '2024-08-07'),
(39, 39, 39, 'Debit Card', 600, '2024-08-08'),
(40, 40, 40, 'Credit Card', 500, '2024-08-09');


INSERT INTO amazon_sales_reviews (ReviewID, UserID, OrderID, Rating, ReviewText, ReviewDate)
VALUES
(1, 1, 1, 5, 'Great laptop, very fast!', '2024-07-01'),
(2, 2, 2, 4, 'Good smartphone, but battery life could be better.', '2024-07-02'),
(3, 3, 3, 3, 'Decent headphones, comfortable but sound quality could be improved.', '2024-07-03'),
(4, 4, 4, 5, 'Excellent camera, takes amazing photos!', '2024-07-04'),
(5, 5, 5, 4, 'Solid tablet, good for reading and browsing.', '2024-07-05'),
(6, 6, 6, 2, 'Keyboard keys are too stiff, not comfortable to type on.', '2024-07-06'),
(7, 7, 7, 5, 'The laptop is perfect for my needs, very satisfied!', '2024-07-07'),
(8, 8, 8, 4, 'The smartphone has a sleek design and works well.', '2024-07-08'),
(9, 9, 9, 3, 'The headphones are okay, but they hurt my ears after a while.', '2024-07-09'),
(10, 10, 10, 4, 'The camera is good, but the zoom could be better.', '2024-07-10'),
(11, 11, 11, 5, 'I love this tablet, it''s fast and reliable.', '2024-07-11'),
(12, 12, 12, 3, 'The keyboard feels cheap, keys are wobbly.', '2024-07-12'),
(13, 13, 13, 5, 'Amazing laptop, worth every penny!', '2024-07-13'),
(14, 14, 14, 4, 'The smartphone is great, fast and responsive.', '2024-07-14'),
(15, 15, 15, 3, 'Headphones are comfortable but sound quality is average.', '2024-07-15'),
(16, 16, 16, 5, 'The camera takes stunning photos, very pleased!', '2024-07-16'),
(17, 17, 17, 4, 'Tablet works well, good battery life.', '2024-07-17'),
(18, 18, 18, 2, 'Keyboard is disappointing, keys feel mushy.', '2024-07-18'),
(19, 19, 19, 5, 'Another great laptop from this brand, highly recommended!', '2024-07-19'),
(20, 20, 20, 4, 'Smartphone is good, no complaints so far.', '2024-07-20'),
(21, 21, 21, 3, 'Headphones are okay, nothing exceptional.', '2024-07-21'),
(22, 22, 22, 5, 'Camera quality is excellent, very happy with my purchase.', '2024-07-22'),
(23, 23, 23, 4, 'Tablet is reliable, good for daily use.', '2024-07-23'),
(24, 24, 24, 2, 'Keyboard feels cheap, not comfortable for typing.', '2024-07-24'),
(25, 25, 25, 5, 'Best laptop I''ve ever owned, superb performance!', '2024-07-25'),
(26, 26, 26, 4, 'Great smartphone, does everything I need it to.', '2024-07-26'),
(27, 27, 27, 3, 'Headphones are average, expected better sound.', '2024-07-27'),
(28, 28, 28, 5, 'Camera is fantastic, love the zoom capabilities.', '2024-07-28'),
(29, 29, 29, 4, 'Tablet works well, good value for money.', '2024-07-29'),
(30, 30, 30, 2, 'Keyboard is not comfortable to type on, keys are hard.', '2024-07-30'),
(31, 31, 31, 5, 'Superb laptop, fast and efficient!', '2024-07-31'),
(32, 32, 32, 4, 'The smartphone is great, sleek design.', '2024-08-01'),
(33, 33, 33, 3, 'Headphones are decent, could use better sound.', '2024-08-02'),
(34, 34, 34, 5, 'Excellent camera, very impressed with the quality.', '2024-08-03'),
(35, 35, 35, 4, 'Tablet meets expectations, good performance.', '2024-08-04'),
(36, 36, 36, 1, 'Keyboard is terrible, keys stick and feel cheap.', '2024-08-05'),
(37, 37, 37, 2, 'Smartphone is okay, not as fast as expected.', '2024-08-06'),
(38, 38, 38, 1, 'Headphones are uncomfortable, sound quality is poor.', '2024-08-07'),
(39, 39, 39, 1, 'Camera is disappointing, photos are grainy.', '2024-08-08'),
(40, 40, 40, 1, 'Tablet is slow, regret buying it.', '2024-08-09');


