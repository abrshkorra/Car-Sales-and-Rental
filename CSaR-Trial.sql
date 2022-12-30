create DATABASE CSaR
use CSaR

CREATE TABLE Cars
(
    CarID int IDENTITY (1, 1) NOT NULL,
    Manufacturer varchar(50) NOT NULL,
    Model varchar(50) NOT NULL,
    Year int NOT NULL,
    Color varchar(50) NOT NULL,
    SalesPrice money DEFAULT 0.00 NOT NULL,
    RentalPrice money DEFAULT 0.00 NOT NULL,
    Status tinyint DEFAULT 0 NOT NULL
    -- 1 Sold/Rented , 0 Available for sale/rental                        
);

CREATE TABLE Customers
(
    CustomerID int IDENTITY (1, 1) NOT NULL,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    Address varchar(50) NOT NULL,
    City varchar(50) NOT NULL,
    State varchar(50) NOT NULL,
    ZipCode varchar(50) NOT NULL,
    Phone varchar(50) NOT NULL,
    Email varchar(50) NOT NULL,
    PayStatus tinyint DEFAULT 0 NOT NULL
);

CREATE TABLE Sales
(
    SaleID int IDENTITY (1, 1) NOT NULL,
    CarID int NOT NULL,
    CustomerID int NOT NULL,
    SaleDate datetime NOT NULL,
    SalePrice money NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Rentals
(
    RentalID int IDENTITY (1, 1) NOT NULL,
    CarID int NOT NULL,
    CustomerID int NOT NULL,
    RentalDate datetime NOT NULL,
    ReturnDate datetime NOT NULL,
    RentalPrice money NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees
(
    EmployeeID int IDENTITY (1, 1) NOT NULL,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    Address varchar(50) NOT NULL,
    City varchar(50) NOT NULL,
    State varchar(50) NOT NULL,
    ZipCode varchar(50) NOT NULL,
    Phone varchar(50) NOT NULL,
    Email varchar(50) NOT NULL,
    HireDate datetime NOT NULL,
    TerminationDate datetime NOT NULL,
    Salary money NOT NULL,
    JobTitle varchar(50) NOT NULL,
    JobDescription varchar(50) NOT NULL,
    Department varchar(50) NOT NULL
);

/* Trigger to update the status of the car when it is sold */
CREATE TRIGGER tr_CarSold
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE Cars
    SET Status = 1
    FROM Cars
        INNER JOIN inserted
        ON Cars.CarID = inserted.CarID
END

/* Trigger to update the status of the car when it is rented */
CREATE TRIGGER tr_CarRented
ON Rentals
AFTER INSERT
AS
BEGIN
    UPDATE Cars
    SET Status = 1
    FROM Cars
        INNER JOIN inserted
        ON Cars.CarID = inserted.CarID
END

/* Trigger to update the status of the car when it is returned */
CREATE TRIGGER tr_CarReturned
ON Rentals
AFTER UPDATE
AS
BEGIN
    UPDATE Cars
    SET Status = 0
    FROM Cars
        INNER JOIN inserted
        ON Cars.CarID = inserted.CarID
END

/* Trigger to update the status of the customer when they pay their bill */
CREATE TRIGGER tr_CustomerPaid
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE Customers
    SET PayStatus = 1
    FROM Customers
        INNER JOIN inserted
        ON Customers.CustomerID = inserted.CustomerID
END

/* Transaction to insert a new car into the database */

BEGIN TRANSACTION
INSERT INTO Cars
    (Manufacturer, Model, Year, Color, SalesPrice, RentalPrice, Status)
VALUES
    ('Ford', 'Mustang', 2015, 'Red', 25000, 100, 0)
COMMIT

/* Transaction to insert a new customer into the database */

BEGIN TRANSACTION
INSERT INTO Customers
    (FirstName, LastName, Address, City, State, ZipCode, Phone, Email, PayStatus)
VALUES
    ('John', 'Smith', '123 Main St', 'New York', 'NY', '10001', '555-555-5555', '
', 0)
COMMIT

/* Transaction to insert a new sale into the database */

BEGIN TRANSACTION
INSERT INTO Sales
    (CarID, CustomerID, SaleDate, SalePrice)
VALUES
    (1, 1, GETDATE(), 25000)
COMMIT

/* Transaction to insert a new rental into the database */

BEGIN TRANSACTION
INSERT INTO Rentals
    (CarID, CustomerID, RentalDate, ReturnDate, RentalPrice)
VALUES
    (1, 1, GETDATE(), GETDATE(), 100)
COMMIT

/* Transaction to update a rental in the database */

BEGIN TRANSACTION
UPDATE Rentals
SET ReturnDate = GETDATE()
WHERE RentalID = 1
COMMIT

/* Transaction to update a car in the database */

BEGIN TRANSACTION
UPDATE Cars
SET SalesPrice = 20000
WHERE CarID = 1
COMMIT

/* Transaction to update a customer in the database */

BEGIN TRANSACTION
UPDATE Customers
SET PayStatus = 1
WHERE CustomerID = 1
COMMIT

/* Transaction to delete a car from the database */

BEGIN TRANSACTION
DELETE FROM Cars
WHERE CarID = 1

/* Transaction to delete a customer from the database */

BEGIN TRANSACTION
DELETE FROM Customers
WHERE CustomerID = 1

/* Transaction to delete a sale from the database */

BEGIN TRANSACTION
DELETE FROM Sales
WHERE SaleID = 1

/* Transaction to delete a rental from the database */

BEGIN TRANSACTION
DELETE FROM Rentals
WHERE RentalID = 1


/* function to calculate the total sales for a given month */

CREATE FUNCTION fn_TotalSales
(
    @Month int,
    @Year int
)
RETURNS money

AS
BEGIN
    DECLARE @TotalSales money
    SELECT @TotalSales = SUM(SalePrice)
    FROM Sales
    WHERE MONTH(SaleDate) = @Month
        AND YEAR(SaleDate) = @Year
    RETURN @TotalSales
END

/* function to calculate the total rentals for a given month */

CREATE FUNCTION fn_TotalRentals
(
    @Month int,
    @Year int
)

RETURNS money

AS
BEGIN
    DECLARE @TotalRentals money
    SELECT @TotalRentals = SUM(RentalPrice)
    FROM Rentals
    WHERE MONTH(RentalDate) = @Month
        AND YEAR(RentalDate) = @Year
    RETURN @TotalRentals
END

