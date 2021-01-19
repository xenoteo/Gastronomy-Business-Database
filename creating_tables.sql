IF OBJECT_ID('Customers', 'U') IS NOT NULL
    DROP TABLE Customers
CREATE TABLE Customers(
    CustomerID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Address VARCHAR(50),
    City VARCHAR(30),
    PostalCode VARCHAR(30),
    Country VARCHAR(30),
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(30) NOT NULL,
    IsCompany BIT
)

IF OBJECT_ID('CompanyCustomers', 'U') IS NOT NULL
    DROP TABLE CompanyCustomers
CREATE TABLE CompanyCustomers(
    CustomerID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Customers(CustomerID),
    CompanyName VARCHAR(50) NOT NULL UNIQUE,
    ContactPersonName VARCHAR(50),
    ContactPersonTitle VARCHAR(50),
    NIP VARCHAR(10) NOT NULL UNIQUE
)

IF OBJECT_ID('IndividualCustomers', 'U') IS NOT NULL
    DROP TABLE IndividualCustomers
CREATE TABLE IndividualCustomers(
    CustomerID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Customers(CustomerID),
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL
)

IF OBJECT_ID('Discounts', 'U') IS NOT NULL
    DROP TABLE Discounts
CREATE TABLE Discounts(
    DiscountID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    Value FLOAT NOT NULL CHECK (Value > 0 AND Value <= 1),
    DueDate DATETIME,
    IssueDate DATETIME NOT NULL,
    IsOneTime BIT NOT NULL DEFAULT 1,
    IsAvailable BIT NOT NULL DEFAULT 1
)

IF OBJECT_ID('OrderDiscounts', 'U') IS NOT NULL
    DROP TABLE OrderDiscounts
CREATE TABLE OrderDiscounts(
    DiscountID INT FOREIGN KEY REFERENCES Discounts(DiscountID),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID)
)

IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees
CREATE TABLE Employees(
    EmployeeID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
    Title VARCHAR(30) NOT NULL,
    HireDate DATETIME,
    Address VARCHAR(50),
    City VARCHAR(30),
    PostalCode VARCHAR(30),
    Country VARCHAR(30),
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(30) NOT NULL
)

IF OBJECT_ID('Tables', 'U') IS NOT NULL
    DROP TABLE Tables
CREATE TABLE Tables(
    TableID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    MaxCapacity INT NOT NULL CHECK (MaxCapacity >= 2 AND MaxCapacity <= 100),
    CurrentCapacity INT NOT NULL CHECK (CurrentCapacity >= 2 AND CurrentCapacity <= 100),
    CHECK (CurrentCapacity <= MaxCapacity)
)

IF OBJECT_ID('Reservations', 'U') IS NOT NULL
    DROP TABLE Reservations
CREATE TABLE Reservations(
    ReservationID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    ReservationDate DATETIME NOT NULL,
    RealizationDateStart DATETIME NOT NULL,
    RealizationDateEnd DATETIME NOT NULL,
    NumberOfPeople INT NOT NULL CHECK (NumberOfPeople > 0 AND NumberOfPeople <= 100),
    TableID INT NOT NULL FOREIGN KEY REFERENCES Tables(TableID),
    IsCancelled BIT DEFAULT 0,
    IsByPerson BIT DEFAULT 1,
    CHECK (ReservationDate <= RealizationDateStart),
    CHECK (RealizationDateStart < RealizationDateEnd)
)

ALTER TABLE Reservations 
ADD OrderID INT

ALTER TABLE Reservations 
ALTER COLUMN OrderID INT NOT NULL

ALTER TABLE Reservations
ADD CONSTRAINT FK_OrderID
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);


IF OBJECT_ID('Menu', 'U') IS NOT NULL
 DROP TABLE Menu
CREATE TABLE Menu(
    MenuID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    ArrangementDate DATETIME NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    CHECK(ArrangementDate < StartDate),
    CHECK(StartDate < EndDate),
    CHECK (DATEDIFF(day, ArrangementDate, StartDate) >= 1),
    CHECK (DATEDIFF(week, StartDate, EndDate) <= 2)
)

IF OBJECT_ID('ProductCategories', 'U') IS NOT NULL
 DROP TABLE ProductCategories
    CREATE TABLE ProductCategories(
    ProductCategoryID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    ProductCategoryName VARCHAR(30) NOT NULL UNIQUE,
    Description VARCHAR(50)
)

IF OBJECT_ID('Products', 'U') IS NOT NULL
 DROP TABLE Products
CREATE TABLE Products(
    ProductID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    ProductName VARCHAR(50) NOT NULL,
    ProductCategoryID INT NOT NULL FOREIGN KEY REFERENCES ProductCategories(ProductCategoryID),
    UnitsInStock INT NOT NULL CHECK(UnitsInStock >= 0 AND UnitsInStock <= 5000)
)

IF OBJECT_ID('Dishes', 'U') IS NOT NULL
 DROP TABLE Dishes
CREATE TABLE Dishes (
    DishID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    DishName VARCHAR(50) NOT NULL UNIQUE,
    UnitPrice FLOAT NOT NULL CHECK(UnitPrice >= 0 AND UnitPrice <= 5000),
    IsAvailable BIT NOT NULL DEFAULT 1
)

IF OBJECT_ID('DishDetails', 'U') IS NOT NULL
 DROP TABLE DishDetails
CREATE TABLE DishDetails (
    DishID INT NOT NULL FOREIGN KEY REFERENCES Dishes(DishID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID)
)

IF OBJECT_ID('MenuDishes', 'U') IS NOT NULL
 DROP TABLE MenuDishes
CREATE TABLE MenuDishes (
    MenuID INT NOT NULL FOREIGN KEY REFERENCES Menu(MenuID),
    DishID INT NOT NULL FOREIGN KEY REFERENCES Dishes(DishID),
    IsAvailable BIT NOT NULL DEFAULT 1
)

IF OBJECT_ID('Orders', 'U') IS NOT NULL
 DROP TABLE Orders
CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
    EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME NOT NULL,
    RequiredRealisationDate DATETIME NOT NULL,
    PickUpDate DATETIME,
    IsTakeAway BIT NOT NULL DEFAULT 1,
    CHECK(OrderDate < RequiredRealisationDate),
    CHECK(RequiredRealisationDate < PickUpDate)
)

IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
 DROP TABLE OrderDetails
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    DishID INT FOREIGN KEY REFERENCES Dishes(DishID),
    UnitPrice FLOAT NOT NULL CHECK(UnitPrice >= 0 and UnitPrice <= 5000),
    Quantity INT NOT NULL CHECK(Quantity >= 0 and Quantity <= 5000)
)
