-- Creating the Database after testing if it exists

IF DB_ID('SoyezJolieDB') IS NOT NULL
BEGIN
    DROP DATABASE SoyezJolieDB;
END;
GO

CREATE DATABASE SoyezJolieDB;
GO

USE SoyezJolieDB;
GO


-- Dropping tables if they exist

DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Promotions;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS ProductSales;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS AppointmentServices;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS EmployeeService;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS SalonServices;
DROP TABLE IF EXISTS EmployeeSchedule;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
GO


-- Creating tables


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL UNIQUE,
    EmailAdress VARCHAR(50) UNIQUE,
    POPIAcceptance BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Certification BIT DEFAULT 0
);
GO

CREATE TABLE EmployeeSchedule (
    ScheduleID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    WorkDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE SalonServices (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName VARCHAR(50) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Duration INT NOT NULL
);
GO

CREATE TABLE Treatment (
    TreatmentID INT PRIMARY KEY IDENTITY(1,1),
    TreatmentType VARCHAR(100),
    ServiceID INT FOREIGN KEY REFERENCES SalonServices(ServiceID),
    Price DECIMAL(10,2) NOT NULL,
    Duration TIME NOT NULL
);
GO

CREATE TABLE EmployeeService (
    EmployeeID INT,
    ServiceID INT,
    PRIMARY KEY (EmployeeID, ServiceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ServiceID) REFERENCES SalonServices(ServiceID)
);
GO

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    EmployeeID INT,
    AppointmentDateTime DATETIME NOT NULL,
    AppointmentStatus VARCHAR(50) NOT NULL CHECK (AppointmentStatus IN ('Scheduled', 'Completed', 'Cancelled')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE AppointmentServices (
    AppointmentID INT,
    TreatmentID INT,
    ServiceID INT,
    EmployeeID INT,
    Price DECIMAL(10,2) NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(10,2) DEFAULT 0,
    PaymentMethod VARCHAR(20) CHECK (PaymentMethod IN ('Cash', 'CardPayment', 'Voucher')),
    PRIMARY KEY (AppointmentID, ServiceID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatment(TreatmentID),
    FOREIGN KEY (ServiceID) REFERENCES SalonServices(ServiceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    PaymentMethod VARCHAR(20) NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    TipAmount DECIMAL(10,2) DEFAULT 0.00,
    AppointmentID INT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    Category VARCHAR(50) NOT NULL
);
GO

CREATE TABLE ProductSales (
    ProductSaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    CustomerID INT,
    EmployeeID INT,
    Quantity INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    SaleDate DATETIME NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL
);
GO

CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);
GO

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    CustomerComment VARCHAR(255) NOT NULL,
    CustomerRating INT CHECK (CustomerRating BETWEEN 1 AND 5),
    Date DATE DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO




-- Inserting sample data into the tables


-- Customers
INSERT INTO Customers (FullName, ContactNumber, EmailAdress, POPIAcceptance) VALUES
('Lebo Dlamini', '0711234567', 'lebo.d@example.com', 1);
INSERT INTO Customers (FullName, ContactNumber, EmailAdress, POPIAcceptance) VALUES
('Thabo Mokoena', '0729876543', 'thabo.m@example.com', 1);
INSERT INTO Customers (FullName, ContactNumber, EmailAdress, POPIAcceptance) VALUES
('Zanele Khumalo', '0734567890', 'zanele.k@example.com', 0);
INSERT INTO Customers (FullName, ContactNumber, EmailAdress, POPIAcceptance) VALUES
('Kea Radebe', '0742223333', 'kea.r@example.com', 1);
GO

-- Employees
INSERT INTO Employees (FullName, Role, Certification) VALUES
('Nomsa Mthembu', 'Stylist', 1);
INSERT INTO Employees (FullName, Role, Certification) VALUES
('Kabelo Mahlangu', 'Receptionist', 0);
INSERT INTO Employees (FullName, Role, Certification) VALUES
('Tshepo Nkosi', 'Hair Technician', 1);
INSERT INTO Employees (FullName, Role, Certification) VALUES
('Lerato Maseko', 'Massage Therapist', 1);
GO

-- EmployeeSchedule
INSERT INTO EmployeeSchedule (EmployeeID, WorkDate, StartTime, EndTime) VALUES
(1, '2025-04-22', '09:00', '17:00');
INSERT INTO EmployeeSchedule (EmployeeID, WorkDate, StartTime, EndTime) VALUES
(2, '2025-04-22', '08:00', '14:00');
INSERT INTO EmployeeSchedule (EmployeeID, WorkDate, StartTime, EndTime) VALUES
(3, '2025-04-23', '10:00', '18:00');
INSERT INTO EmployeeSchedule (EmployeeID, WorkDate, StartTime, EndTime) VALUES
(4, '2025-04-23', '09:30', '17:30');
GO

-- SalonServices
INSERT INTO SalonServices (ServiceName, Category, Price, Duration) VALUES
('Hair Cut', 'Hair', 120.00, 30);
INSERT INTO SalonServices (ServiceName, Category, Price, Duration) VALUES
('Full Body Massage', 'Massage', 300.00, 60);
INSERT INTO SalonServices (ServiceName, Category, Price, Duration) VALUES
('Facial Treatment', 'Skin', 200.00, 45);
INSERT INTO SalonServices (ServiceName, Category, Price, Duration) VALUES
('Hair Coloring', 'Hair', 250.00, 60);
GO

-- Treatment
INSERT INTO Treatment (TreatmentType, ServiceID, Price, Duration) VALUES
('Basic Hair Trim', 1, 100.00, '00:20:00');
INSERT INTO Treatment (TreatmentType, ServiceID, Price, Duration) VALUES
('Swedish Massage', 2, 280.00, '01:00:00');
INSERT INTO Treatment (TreatmentType, ServiceID, Price, Duration) VALUES
('Deep Cleansing Facial', 3, 210.00, '00:50:00');
INSERT INTO Treatment (TreatmentType, ServiceID, Price, Duration) VALUES
('Full Hair Colour', 4, 260.00, '01:10:00');
GO



-- EmployeeService
INSERT INTO EmployeeService (EmployeeID, ServiceID) VALUES (1, 1);
INSERT INTO EmployeeService (EmployeeID, ServiceID) VALUES (1, 4);
INSERT INTO EmployeeService (EmployeeID, ServiceID) VALUES (2, 3);
INSERT INTO EmployeeService (EmployeeID, ServiceID) VALUES (3, 1);
INSERT INTO EmployeeService (EmployeeID, ServiceID) VALUES (4, 2);
GO

-- Appointments
INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus) VALUES
(1, 1, '2025-04-22 10:00', 'Scheduled');
INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus) VALUES
(2, 4, '2025-04-23 13:30', 'Completed');
INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus) VALUES
(3, 3, '2025-04-24 11:00', 'Cancelled');
INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus) VALUES
(4, 1, '2025-04-25 15:00', 'Scheduled');
GO

-- AppointmentServices
INSERT INTO AppointmentServices (AppointmentID, TreatmentID, ServiceID, EmployeeID, Price, AmountPaid, Discount, PaymentMethod)
VALUES (1, 1, 1, 1, 100.00, 100.00, 0.00, 'Cash');
INSERT INTO AppointmentServices (AppointmentID, TreatmentID, ServiceID, EmployeeID, Price, AmountPaid, Discount, PaymentMethod)
VALUES (2, 2, 2, 4, 280.00, 280.00, 0.00, 'CardPayment');
INSERT INTO AppointmentServices (AppointmentID, TreatmentID, ServiceID, EmployeeID, Price, AmountPaid, Discount, PaymentMethod)
VALUES (3, 3, 3, 2, 210.00, 190.00, 20.00, 'Voucher');
INSERT INTO AppointmentServices (AppointmentID, TreatmentID, ServiceID, EmployeeID, Price, AmountPaid, Discount, PaymentMethod)
VALUES (4, 4, 4, 1, 260.00, 260.00, 0.00, 'Cash');
GO

-- Payments
INSERT INTO Payments (PaymentMethod, AmountPaid, TipAmount, AppointmentID)
VALUES ('Cash', 100.00, 10.00, 1);
INSERT INTO Payments (PaymentMethod, AmountPaid, TipAmount, AppointmentID)
VALUES ('CardPayment', 280.00, 0.00, 2);
INSERT INTO Payments (PaymentMethod, AmountPaid, TipAmount, AppointmentID)
VALUES ('Voucher', 190.00, 0.00, 3);
INSERT INTO Payments (PaymentMethod, AmountPaid, TipAmount, AppointmentID)
VALUES ('Cash', 260.00, 20.00, 4);
GO

-- Products
INSERT INTO Products (ProductName, Price, StockQuantity, Category)
VALUES ('Shampoo', 85.00, 25, 'Hair Care');
INSERT INTO Products (ProductName, Price, StockQuantity, Category)
VALUES ('Massage Oil', 150.00, 10, 'Wellness');
INSERT INTO Products (ProductName, Price, StockQuantity, Category)
VALUES ('Facial Cleanser', 120.00, 15, 'Skin Care');
INSERT INTO Products (ProductName, Price, StockQuantity, Category)
VALUES ('Hair Dye Kit', 200.00, 8, 'Hair Care');
GO

-- ProductSales
INSERT INTO ProductSales (ProductID, CustomerID, EmployeeID, Quantity, AmountPaid, SaleDate)
VALUES (1, 1, 1, 2, 170.00, '2025-04-22 11:00');
INSERT INTO ProductSales (ProductID, CustomerID, EmployeeID, Quantity, AmountPaid, SaleDate)
VALUES (2, 2, 4, 1, 150.00, '2025-04-23 13:45');
INSERT INTO ProductSales (ProductID, CustomerID, EmployeeID, Quantity, AmountPaid, SaleDate)
VALUES (3, 3, 2, 1, 120.00, '2025-04-24 12:00');
INSERT INTO ProductSales (ProductID, CustomerID, EmployeeID, Quantity, AmountPaid, SaleDate)
VALUES (4, 4, 3, 1, 200.00, '2025-04-25 10:00');
GO

-- Suppliers
INSERT INTO Suppliers (SupplierName, ContactNumber)
VALUES ('HairPro Supplies', '0112345678');
INSERT INTO Suppliers (SupplierName, ContactNumber)
VALUES ('Wellness Warehouse', '0123456789');
INSERT INTO Suppliers (SupplierName, ContactNumber)
VALUES ('BeautyLine Distributors', '0134567890');
GO

-- Promotions
INSERT INTO Promotions (Description, StartDate, EndDate)
VALUES ('Autumn Haircare Discount', '2025-04-01', '2025-04-30');
INSERT INTO Promotions (Description, StartDate, EndDate)
VALUES ('Massage Monday Deal', '2025-04-15', '2025-05-15');
GO

-- Feedback
INSERT INTO Feedback (CustomerID, CustomerComment, CustomerRating)
VALUES (1, 'Excellent service and very friendly staff!', 5);
INSERT INTO Feedback (CustomerID, CustomerComment, CustomerRating)
VALUES (2, 'The massage was relaxing and professional.', 4);
INSERT INTO Feedback (CustomerID, CustomerComment, CustomerRating)
VALUES (3, 'Service was good but had to wait a while.', 3);
GO




-- Dropping Views if they exist
IF OBJECT_ID('UpcomingAppointments', 'V') IS NOT NULL DROP VIEW UpcomingAppointments;
IF OBJECT_ID('ProductSalesSummary', 'V') IS NOT NULL DROP VIEW ProductSalesSummary;
IF OBJECT_ID('FeedbackRatings', 'V') IS NOT NULL DROP VIEW FeedbackRatings;
GO

-- Dropping Stored Procedures if they exist
IF OBJECT_ID('UpdateStock', 'P') IS NOT NULL DROP PROCEDURE UpdateStock;
IF OBJECT_ID('BookAppointment', 'P') IS NOT NULL DROP PROCEDURE BookAppointment;
IF OBJECT_ID('GetEmployeeSchedule', 'P') IS NOT NULL DROP PROCEDURE GetEmployeeSchedule;
GO

-- Dropping Triggers if they exist
IF OBJECT_ID('DecreaseStockAfterSale', 'TR') IS NOT NULL DROP TRIGGER DecreaseStockAfterSale;
IF OBJECT_ID('CheckEmployeeAvailability', 'TR') IS NOT NULL DROP TRIGGER CheckEmployeeAvailability;
GO


-- Creating Views And Calling Them

-- View: Upcoming Appointments
CREATE VIEW UpcomingAppointments AS
SELECT 
    Appointments.AppointmentID,
    Customers.FullName,
    Employees.FullName AS EmployeeName,
    Appointments.AppointmentDateTime,
    Appointments.AppointmentStatus
FROM Appointments
JOIN Customers ON Appointments.CustomerID = Customers.CustomerID
JOIN Employees ON Appointments.EmployeeID = Employees.EmployeeID
WHERE Appointments.AppointmentDateTime > GETDATE();
GO

SELECT *
FROM UpcomingAppointments;
GO

-- View: Product Sales Summary
CREATE VIEW ProductSalesSummary AS
SELECT 
    Products.ProductName,
    SUM(ProductSales.Quantity) AS TotalQuantitySold,
    SUM(ProductSales.AmountPaid) AS TotalRevenue
FROM ProductSales
JOIN Products ON ProductSales.ProductID = Products.ProductID
GROUP BY Products.ProductName;
GO

SELECT * 
FROM ProductSalesSummary;
GO

-- View: Feedback Ratings
CREATE VIEW FeedbackRatings AS
SELECT 
    Feedback.CustomerID,
    Customers.FullName,
    Feedback.CustomerComment,
    Feedback.CustomerRating,
    Feedback.Date
FROM Feedback
JOIN Customers ON Feedback.CustomerID = Customers.CustomerID;
GO

SELECT *
FROM FeedbackRatings;
GO


-- Creating Stored Procedures

-- Procedure: Update Stock
CREATE PROCEDURE UpdateStock
    @ProductID INT,
    @QuantitySold INT
AS
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - @QuantitySold
    WHERE ProductID = @ProductID;
END;
GO

EXECUTE UpdateStock;
GO

-- Procedure: Book Appointment
CREATE PROCEDURE BookAppointment
    @CustomerID INT,
    @EmployeeID INT,
    @AppointmentDateTime DATETIME,
    @Status VARCHAR(50)
AS
BEGIN
    INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus)
    VALUES (@CustomerID, @EmployeeID, @AppointmentDateTime, @Status);
END;
GO

EXECUTE BookAppointment;
GO

-- Procedure: Get Employee Schedule
CREATE PROCEDURE GetEmployeeSchedule
    @WorkDate DATE
AS
BEGIN
    SELECT 
        EmployeeSchedule.ScheduleID,
        Employees.FullName,
        EmployeeSchedule.WorkDate,
        EmployeeSchedule.StartTime,
        EmployeeSchedule.EndTime
    FROM EmployeeSchedule
    JOIN Employees ON EmployeeSchedule.EmployeeID = Employees.EmployeeID
    WHERE EmployeeSchedule.WorkDate = @WorkDate;
END;
GO

EXECUTE GetEmployeeSchedule;
GO


-- Creating the Triggers

-- Trigger: Decrease Stock After Sale
CREATE TRIGGER DecreaseStockAfterSale
ON ProductSales
AFTER INSERT
AS
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - inserted.Quantity
    FROM Products
    JOIN inserted ON Products.ProductID = inserted.ProductID;
END;
GO


-- Trigger: Check Employee Availability Before Appointment
CREATE TRIGGER CheckEmployeeAvailability
ON Appointments
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM Appointments A
        JOIN inserted I ON A.EmployeeID = I.EmployeeID
        AND A.AppointmentDateTime = I.AppointmentDateTime
    )
    BEGIN
        RAISERROR('Employee is already booked at this time.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Appointments (CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus)
        SELECT CustomerID, EmployeeID, AppointmentDateTime, AppointmentStatus
        FROM inserted;
    END
END;
GO

-- The Backup : Backup database
 
BACKUP DATABASE SoyezJolieDB
TO DISK = 'C:\SQLBackups\SoyezJolieDB.bak'
WITH FORMAT,
     MEDIANAME = 'SoyezJolieDBBackup' ,
     NAME = 'Full Backup of SoyezJolieDB Database'
GO
