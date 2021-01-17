DROP PROCEDURE IF EXISTS AddNewCustomer;
CREATE PROCEDURE AddNewCustomer
    @phone VARCHAR(20),
    @email VARCHAR(30),
    @isCompany BIT,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    INSERT INTO Customers(Address, City, PostalCode, Country, Phone, Email, IsCompany)
    VALUES (@address, @city, @postalCode, @country, @phone, @email, @isCompany)
END


DROP PROCEDURE IF EXISTS AddNewCompanyCustomer;
CREATE PROCEDURE AddNewCompanyCustomer
    @companyName VARCHAR(50),
    @phone VARCHAR(20),
    @email VARCHAR(30),
    @contactPersonName VARCHAR(50) = NULL,
    @contactPersonTitle VARCHAR(50) = NULL,
    @fax VARCHAR(20) = NULL,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    EXEC AddNewCustomer @phone, @email, 1, @address, @city, @postalCode, @country
    DECLARE @customerID INT
    SET @customerID = (SELECT CustomerID FROM Customers WHERE Email = @email AND Phone = @phone)
    INSERT INTO CompanyCustomers(CustomerID, CompanyName, ContactPersonName, ContactPersonTitle, Fax)
    VALUES (@customerID, @companyName, @contactPersonName, @contactPersonTitle, @fax)
END

EXEC AddNewCompanyCustomer 'Good Company', '123456789', 'email@gmail.com'
EXEC AddNewCompanyCustomer 'Good Company 2', '123456799', 'email2@gmail.com', @country = 'Poland'


DROP PROCEDURE IF EXISTS AddNewIndividualCustomer;
CREATE PROCEDURE AddNewIndividualCustomer
    @firstName VARCHAR(30),
    @lastName VARCHAR(30),
    @phone VARCHAR(20),
    @email VARCHAR(30),
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    EXEC AddNewCustomer @phone, @email, 0, @address, @city, @postalCode, @country
    DECLARE @customerID INT
    SET @customerID = (SELECT CustomerID FROM Customers WHERE Email = @email AND Phone = @phone)
    INSERT INTO IndividualCustomers(CustomerID, FirstName, LastName)
    VALUES (@customerID, @firstName, @lastName)
END

EXEC AddNewIndividualCustomer 'John', 'Doe', '123456123', 'john@gmail.com'
EXEC AddNewIndividualCustomer 'John', 'Doe', '123456124', 'john2@gmail.com', @city = 'Warsaw'


DROP PROCEDURE IF EXISTS AddNewEmployee;
GO
CREATE PROCEDURE AddNewEmployee
	@FirstName varchar(30),
	@LastName varchar(30),
	@Title varchar(30),
	@Phone varchar(20),
	@Email varchar(30),
	@HireDate datetime = null,
	@Address varchar(50) = null,
	@PostalCode nvarchar(30) = null,
	@City nvarchar(30) = null,
	@Country nvarchar(30) = null
AS
BEGIN
	INSERT INTO Employees (FirstName, LastName, Title, Phone, Email, HireDate, Address, PostalCode, City, Country)
	VALUES (@FirstName, @LastName, @Title, @Phone, @Email, @HireDate, @Address, @PostalCode, @City, @Country)
END

EXEC AddNewEmployee 'Anne', 'Smith', 'head of procurement', '165935616', 'asmith@gmail.com'
EXEC AddNewEmployee 'James', 'Cameron', 'Warehouse manager', '789243666', 'jamesCameron@restaurant.com', @Address = 'NorthStreet 31/16', @PostalCode = '30-200', @City = 'Naples', @Country = 'Italy'


DROP PROCEDURE IF EXISTS AddNewOrder;
GO
CREATE PROCEDURE AddNewOrder
	@EmployeeID int,
	@CustomerID int,
	@OrderDate datetime,
	@RequiredRealisationDate datetime,
	@PickUpDate datetime = null,
	@IsTakeAway bit = 1
AS
BEGIN
	INSERT INTO Orders (EmployeeID, CustomerID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway)
	VALUES (@EmployeeID, @CustomerID, @OrderDate, @RequiredRealisationDate, @PickUpDate, @IsTakeAway)
END

EXEC AddNewOrder 5, 4, '2021/01/17', '2021/01/27' 


DROP PROCEDURE IF EXISTS AddNewOrderDetails
GO
CREATE PROCEDURE AddNewOrderDetails
	@OrderID int,
	@DishID int,
	@UnitPrice float,
	@Quantity int = 1
AS
BEGIN
	INSERT INTO OrderDetails (OrderID, DishID, UnitPrice, Quantity)
	VALUES (@OrderID, @DishID, @UnitPrice, @Quantity)
END

EXEC AddNewOrderDetails 1, 1, 25.5


DROP PROCEDURE IF EXISTS AddNewProductCategory;
GO
CREATE PROCEDURE AddNewProductCategory
	@Name varchar(30),
	@Description varchar(50) = null
AS
BEGIN
	INSERT INTO ProductCategories (ProductCategoryName, Description)
	VALUES (@Name, @Description)
END

EXEC AddNewProductCategory 'Seafood', 'Seaweed, sushi and fish'
EXEC AddNewProductCategory 'Pasta'


DROP PROCEDURE IF EXISTS AddNewProduct
GO
CREATE PROCEDURE AddNewProduct
	@Name varchar(50),
	@ProductCategoryID int,
	@UnitsInStock int = 0
AS
BEGIN
	INSERT INTO Products (ProductName, ProductCategoryID, UnitsInStock)
	VALUES (@Name, @ProductCategoryID, @UnitsInStock)
END

EXEC AddNewProduct 'Penne' , 2


DROP PROCEDURE IF EXISTS AddNewDish
GO
CREATE PROCEDURE AddNewDish
	@Name varchar(50),
	@UnitPrice float,
AS
BEGIN
	INSERT INTO Dishes(DishName, UnitPrice)
	VALUES (@Name, @UnitPrice)
END

exec AddNewDish 'Penne al forno', 25.50


DROP PROCEDURE IF EXISTS AddProductToDish
GO
CREATE PROCEDURE AddProductToDish
	@ProductID int,
	@DishID int
AS
BEGIN
	INSERT INTO DishDetails (ProductID, DishID)
	VALUES (@ProductID, @DishID)
END

EXEC AddProductToDish 2, 1


DROP PROCEDURE IF EXISTS AddNewDiscount;
CREATE PROCEDURE AddNewDiscount
    @customerID INT,
    @value FLOAT,
    @issueDate DATETIME,
    @dueDate DATETIME = NULL,
    @isOneTime BIT = 1,
    @isAvailable BIT = 1
AS
BEGIN
    INSERT INTO Discounts(CustomerID, Value, DueDate, IssueDate, IsOneTime, IsAvailable)
    VALUES (@customerID, @value, @dueDate, @issueDate, @isOneTime, @isAvailable)
END

EXEC AddNewDiscount 4, 0.25, '2021-01-16'
EXEC AddNewDiscount 4, 0.30, '2021-01-16', @isOneTime = 0, @dueDate = '2021-02-16'


DROP PROCEDURE IF EXISTS AddNewReservation;
CREATE PROCEDURE AddNewReservation
    @customerID INT,
    @employeeID INT,
    @numberOfPeople INT,
    @realizationDate DATETIME,
    @reservationDate DATETIME,
    @tableID INT,
    @isCancelled BIT = 0,
    @isByPerson BIT = 1
AS
BEGIN
    INSERT INTO Reservations(EmployeeID, CustomerID, ReservationDate, RealizationDate, NumberOfPeople, TableID, IsByPerson, IsCancelled)
    VALUES (@employeeID, @customerID, @reservationDate, @realizationDate, @numberOfPeople, @tableID, @isByPerson, @isCancelled)
END

EXEC AddNewReservation 5, 1, 4, '2021-01-29', '2021-01-16', 2


DROP PROCEDURE IF EXISTS AddDishToMenu;
CREATE PROCEDURE AddDishToMenu
    @menuID INT,
    @dishID INT,
    @isAvailable BIT = 1
AS
BEGIN
    INSERT INTO MenuDishes(MenuID, DishID, IsAvailable)
    VALUES (@menuID, @dishID, @isAvailable)
END

EXEC AddDishToMenu 1, 10
EXEC AddDishToMenu 1, 10, 0


DROP PROCEDURE IF EXISTS AddNewMenu;
CREATE PROCEDURE AddNewMenu
    @arrangementDate DATETIME,
    @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN
    INSERT INTO Menu(ArrangementDate, StartDate, EndDate)
    VALUES (@arrangementDate, @startDate, @endDate)
END

EXEC AddNewMenu '2021-01-16', '2021-01-18', '2021-01-22'


DROP PROCEDURE IF EXISTS CancelReservation;
CREATE PROCEDURE CancelReservation
    @reservationID INT
AS
BEGIN
    UPDATE Reservations
    SET IsCancelled = 1
    WHERE ReservationID = @reservationID
END

EXEC CancelReservation 1


DROP PROCEDURE IF EXISTS ChangeTableParticipants;
CREATE PROCEDURE ChangeTableParticipants
    @reservationID INT,
    @newNumberOfPeople INT
AS
BEGIN
    UPDATE Reservations
    SET NumberOfPeople = @newNumberOfPeople
    WHERE ReservationID = @reservationID
END

EXEC ChangeTableParticipants 1, 6


DROP PROCEDURE IF EXISTS RemoveEmployee;
CREATE PROCEDURE RemoveEmployee
    @employeeID INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = @employeeID
END

EXEC RemoveEmployee 1


DROP PROCEDURE IF EXISTS ChangeCustomerData;
CREATE PROCEDURE ChangeCustomerData
    @customerID INT,
    @phone VARCHAR(20) = NULL,
    @email VARCHAR(30) = NULL,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    IF @phone IS NOT NULL
        UPDATE Customers
        SET Phone = @phone
        WHERE CustomerID = @customerID
    IF @email IS NOT NULL
        UPDATE Customers
        SET Email = @email
        WHERE CustomerID = @customerID
    IF @address IS NOT NULL
        UPDATE Customers
        SET Address = @address
        WHERE CustomerID = @customerID
    IF @city IS NOT NULL
        UPDATE Customers
        SET City = @city
        WHERE CustomerID = @customerID
    IF @postalCode IS NOT NULL
        UPDATE Customers
        SET PostalCode = @postalCode
        WHERE CustomerID = @customerID
    IF @country IS NOT NULL
        UPDATE Customers
        SET Country = @country
        WHERE CustomerID = @customerID
END

EXEC ChangeCustomerData 4, @email = 'good_email@gmail.com'
EXEC ChangeCustomerData 5, @email = 'john@gmail.com', @city = 'Gdansk'


DROP PROCEDURE IF EXISTS ChangeCompanyCustomerData;
CREATE PROCEDURE ChangeCompanyCustomerData
    @customerID INT,
    @companyName VARCHAR(50) = NULL,
    @contactPersonName VARCHAR(50) = NULL,
    @contactPersonTitle VARCHAR(50) = NULL,
    @fax VARCHAR(20) = NULL,
    @phone VARCHAR(20) = NULL,
    @email VARCHAR(30) = NULL,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    EXEC ChangeCustomerData @customerID, @phone, @email, @address, @city, @postalCode, @country
    IF @companyName IS NOT NULL
        UPDATE CompanyCustomers
        SET CompanyName = @companyName
        WHERE CustomerID = @customerID
    IF @contactPersonName IS NOT NULL
        UPDATE CompanyCustomers
        SET ContactPersonName = @contactPersonName
        WHERE CustomerID = @customerID
    IF @contactPersonName IS NOT NULL
        UPDATE CompanyCustomers
        SET ContactPersonTitle = @contactPersonTitle
        WHERE CustomerID = @customerID
    IF @fax IS NOT NULL
        UPDATE CompanyCustomers
        SET Fax = @fax
        WHERE CustomerID = @customerID
END

EXEC ChangeCompanyCustomerData 4, @companyName = 'Very Good Company', @contactPersonName = 'John Doe', @city = 'Krakow'


DROP PROCEDURE IF EXISTS ChangeIndividualCustomerData;
CREATE PROCEDURE ChangeIndividualCustomerData
    @customerID INT,
    @firstName VARCHAR(30) = NULL,
    @lastName VARCHAR(30) = NULL,
    @phone VARCHAR(20) = NULL,
    @email VARCHAR(30) = NULL,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    EXEC ChangeCustomerData @customerID, @phone, @email, @address, @city, @postalCode, @country
    IF @firstName IS NOT NULL
        UPDATE IndividualCustomers
        SET FirstName = @firstName
        WHERE CustomerID = @customerID
    IF @lastName IS NOT NULL
        UPDATE IndividualCustomers
        SET LastName = @lastName
        WHERE CustomerID = @customerID
END

EXEC ChangeIndividualCustomerData 6, @lastName = 'Smith', @country = 'Poland'


DROP PROCEDURE IF EXISTS ChangeEmployeeData;
CREATE PROCEDURE ChangeEmployeeData
    @employeeID INT,
    @firstName VARCHAR(30) = NULL,
    @lastName VARCHAR(30) = NULL,
    @title VARCHAR(30) = NULL,
    @hireDate DATETIME = NULL,
    @phone VARCHAR(20) = NULL,
    @email VARCHAR(30) = NULL,
    @address VARCHAR(50) = NULL,
    @city VARCHAR(30) = NULL,
    @postalCode VARCHAR(30) = NULL,
    @country VARCHAR(30) = NULL
AS
BEGIN
    IF @firstName IS NOT NULL
        UPDATE Employees
        SET FirstName = @firstName
        WHERE EmployeeID = @employeeID
    IF @lastName IS NOT NULL
        UPDATE Employees
        SET LastName = @lastName
        WHERE EmployeeID = @employeeID
    IF @title IS NOT NULL
        UPDATE Employees
        SET Title = @title
        WHERE EmployeeID = @employeeID
    IF @hireDate IS NOT NULL
        UPDATE Employees
        SET HireDate = @hireDate
        WHERE EmployeeID = @employeeID
    IF @phone IS NOT NULL
        UPDATE Employees
        SET Phone = @phone
        WHERE EmployeeID = @employeeID
    IF @email IS NOT NULL
        UPDATE Employees
        SET Email = @email
        WHERE EmployeeID = @employeeID
    IF @address IS NOT NULL
        UPDATE Employees
        SET Address = @address
        WHERE EmployeeID = @employeeID
    IF @city IS NOT NULL
        UPDATE Employees
        SET City = @city
        WHERE EmployeeID = @employeeID
    IF @postalCode IS NOT NULL
        UPDATE Employees
        SET PostalCode = @postalCode
        WHERE EmployeeID = @employeeID
    IF @country IS NOT NULL
        UPDATE Employees
        SET Country = @country
        WHERE EmployeeID = @employeeID
END

EXEC ChangeEmployeeData 1, @city = 'Warsaw', @country = 'Poland'