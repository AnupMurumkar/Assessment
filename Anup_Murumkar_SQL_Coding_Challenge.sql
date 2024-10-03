create database CarRental2
go
use CarRental2
go 

--Creating Tables 

--Vehichle Table
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY,
    make NVARCHAR(50) NOT NULL,
    model NVARCHAR(50) NOT NULL,
    year INT NOT NULL,
    dailyRate DECIMAL(10, 2) NOT NULL,
    status BIT NOT NULL,  -- Use BIT for status
    passengerCapacity INT NOT NULL,
    engineCapacity INT NOT NULL
);



--Customer Table 
CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName NVARCHAR(50) NOT NULL,
    lastName NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    phoneNumber NVARCHAR(15) NOT NULL
);

--Lease Table 
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT FOREIGN KEY REFERENCES Vehicle(vehicleID),
    customerID INT FOREIGN KEY REFERENCES Customer(customerID),
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    type NVARCHAR(10) CHECK (type IN ('Daily', 'Monthly'))
);


--Payment table 
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT FOREIGN KEY REFERENCES Lease(leaseID),
    paymentDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

--Insert values 
INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);


INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, type)
VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');


INSERT INTO Payment (paymentID, leaseID, paymentDate, amount)
VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);


--Q1 :  Update the daily rate for a Mercedes car to 68.
UPDATE Vehicle
SET dailyRate = 68
WHERE make = 'Mercedes' AND model = 'C-Class';

select * from Vehicle

--Q2 : Delete a specific customer and all associated leases and payments.

--to delete all the data from payment and lease we need to alter the table such that if we  delete the customer entries all related entries of that customer 
--form payement and lease table would be delete that can be done with the help of On Delete Cascade 
ALTER TABLE Lease
DROP CONSTRAINT [CK__Lease__type__3D5E1FD2]; 

ALTER TABLE Lease
ADD CONSTRAINT FK_Lease_Vehicle
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID)
    ON DELETE CASCADE;

ALTER TABLE Lease
ADD CONSTRAINT FK_Lease_Customer
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
    ON DELETE CASCADE;

ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_Lease
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
    ON DELETE CASCADE;


DELETE FROM Customer
WHERE customerID = 2; 

--Q3:  Rename the "paymentDate" column in the Payment table to "transactionDate".
EXEC sp_rename 'dbo.Payment.paymentDate', 'transactionDate', 'COLUMN';


--Q4:  Find a specific customer by email.
SELECT * 
FROM Customer
WHERE email = 'johndoe@example.com';


--Q5. Get active leases for a specific customer
SELECT * 
FROM Lease
WHERE customerID = 1 AND endDate > GETDATE();


--Q6  Find all payments made by a customer with a specific phone number.

SELECT p.* , c.phoneNumber
FROM Payment p
JOIN Lease l ON p.leaseID = l.leaseID
JOIN Customer c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-789-1234';  


--Q7  Calculate the average daily rate of all available cars.
SELECT AVG(dailyRate) AS averageDailyRate
FROM Vehicle
WHERE status = 1;  

--Q8 Find the car with the highest daily rate.

SELECT TOP 1 *
FROM Vehicle
ORDER BY dailyRate DESC;

--Q9 Retrieve all cars leased by a specific customer.

SELECT v.*
FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID
WHERE l.customerID = 1;  

--Q10  Find the details of the most recent lease.

SELECT TOP 1 *
FROM Lease
ORDER BY startDate DESC;  

--Q11 List all payments made in the year 2023.
SELECT * 
FROM Payment
WHERE YEAR(transactionDate) = 2023;

--Q12 Retrieve customers who have not made any payments. 
SELECT c.*
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
WHERE p.paymentID IS NULL;

--Q13 Retrieve Car Details and Their Total Payments
SELECT v.*, SUM(p.amount) AS totalPayments
FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.year, v.dailyRate, v.status, v.passengerCapacity, v.engineCapacity;



--Q14 Calculate Total Payments for Each Customer.

SELECT c.*, SUM(p.amount) AS totalPayments
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName, c.email, c.phoneNumber;


--Q15 List Car Details for Each Lease.
SELECT l.*, v.*
FROM Lease l
JOIN Vehicle v ON l.vehicleID = v.vehicleID;


--Q16 Retrieve Details of Active Leases with Customer and Car Information
SELECT l.*, c.*, v.*
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN Vehicle v ON l.vehicleID = v.vehicleID
WHERE l.endDate > GETDATE();  

--Q17: Find the Customer Who Has Spent the Most on Leases

SELECT c.*, SUM(p.amount) AS totalSpent
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName, c.email, c.phoneNumber
ORDER BY totalSpent DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;  

--Q18 List All Cars with Their Current Lease Information
SELECT v.*, l.*
FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
WHERE l.endDate > GETDATE() OR l.endDate IS NULL; 

SELECT V.*, L.leaseID, C.firstName, C.lastName, L.startDate, L.endDate
FROM Vehicle V
LEFT JOIN Lease L ON V.vehicleID = L.vehicleID
LEFT JOIN Customer C ON L.customerID = C.customerID
WHERE L.endDate >= GETDATE() OR L.leaseID IS NULL