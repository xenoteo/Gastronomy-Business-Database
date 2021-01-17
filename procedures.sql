DROP PROCEDURE IF EXISTS AddNewCustomer
CREATE PROCEDURE AddNewCustomer
    @Phone VARCHAR(20),
    @Email VARCHAR(30),
    @IsCompany BIT,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    INSERT INTO Customers(Address, City, PostalCode, Country, Phone, Email, IsCompany)
    VALUES (@Address, @City, @PostalCode, @Country, @Phone, @Email, @IsCompany)
END


DROP PROCEDURE IF EXISTS AddNewCompanyCustomer
CREATE PROCEDURE AddNewCompanyCustomer
    @CompanyName VARCHAR(50),
    @Phone VARCHAR(20),
    @Email VARCHAR(30),
    @ContactPersonName VARCHAR(50) = NULL,
    @ContactPersonTitle VARCHAR(50) = NULL,
    @Fax VARCHAR(20) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    EXEC AddNewCustomer @Phone, @Email, 1, @Address, @City, @PostalCode, @Country
    DECLARE @CustomerID INT
    SET @CustomerID = (SELECT CustomerID FROM Customers WHERE Email = @Email AND Phone = @Phone)
    INSERT INTO CompanyCustomers(CustomerID, CompanyName, ContactPersonName, ContactPersonTitle, Fax)
    VALUES (@CustomerID, @CompanyName, @ContactPersonName, @ContactPersonTitle, @Fax)
END

EXEC AddNewCompanyCustomer 'Good Company', '123456789', 'email@Gmail.com'
EXEC AddNewCompanyCustomer 'Good Company 2', '123456799', 'email2@Gmail.com', @Country = 'Poland'


DROP PROCEDURE IF EXISTS AddNewIndividualCustomer
CREATE PROCEDURE AddNewIndividualCustomer
    @FirstName VARCHAR(30),
    @LastName VARCHAR(30),
    @Phone VARCHAR(20),
    @Email VARCHAR(30),
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    EXEC AddNewCustomer @Phone, @Email, 0, @Address, @City, @PostalCode, @Country
    DECLARE @CustomerID INT
    SET @CustomerID = (SELECT CustomerID FROM Customers WHERE Email = @Email AND Phone = @Phone)
    INSERT INTO IndividualCustomers(CustomerID, FirstName, LastName)
    VALUES (@CustomerID, @FirstName, @LastName)
END

EXEC AddNewIndividualCustomer 'John', 'Doe', '123456123', 'john@Gmail.com'
EXEC AddNewIndividualCustomer 'John', 'Doe', '123456124', 'john2@Gmail.com', @City = 'Warsaw'


DROP PROCEDURE IF EXISTS AddNewEmployee
CREATE PROCEDURE AddNewEmployee
	@FirstName VARCHAR(30),
	@LastName VARCHAR(30),
	@Title VARCHAR(30),
	@Phone VARCHAR(20),
	@Email VARCHAR(30),
	@HireDate DATETIME = NULL,
	@Address VARCHAR(50) = NULL,
	@PostalCode NVARCHAR(30) = NULL,
	@City NVARCHAR(30) = NULL,
	@Country NVARCHAR(30) = NULL
AS
BEGIN
	INSERT INTO Employees (FirstName, LastName, Title, Phone, Email, HireDate, Address, PostalCode, City, Country)
	VALUES (@FirstName, @LastName, @Title, @Phone, @Email, @HireDate, @Address, @PostalCode, @City, @Country)
END

EXEC AddNewEmployee 'Anne', 'Smith', 'head of procurement', '165935616', 'asmith@Gmail.com'
EXEC AddNewEmployee 'James', 'Cameron', 'Warehouse manager', '789243666', 'jamesCameron@Restaurant.com', @Address = 'NorthStreet 31/16', @PostalCode = '30-200', @City = 'Naples', @Country = 'Italy'


DROP PROCEDURE IF EXISTS AddNewOrder
CREATE PROCEDURE AddNewOrder
	@EmployeeID INT,
	@CustomerID INT,
	@OrderDate DATETIME,
	@RequiredRealisationDate DATETIME,
	@PickUpDate DATETIME = NULL,
	@IsTakeAway BIT = 1
AS
BEGIN
	IF (SELECT COUNT(EmployeeID) FROM Employees WHERE EmployeeID = @EmployeeID) < 1
		THROW 50001, 'No such employee.', 1
	IF (SELECT COUNT(CustomerID) FROM Customers WHERE CustomerID = @CustomerID) < 1
		THROW 50002, 'No such customer.', 1
	INSERT INTO Orders (EmployeeID, CustomerID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway)
	VALUES (@EmployeeID, @CustomerID, @OrderDate, @RequiredRealisationDate, @PickUpDate, @IsTakeAway)
END

EXEC AddNewOrder 5, 4, '2021/01/17', '2021/01/27'


DROP PROCEDURE IF EXISTS AddNewOrderDetails
CREATE PROCEDURE AddNewOrderDetails
	@OrderID INT,
	@DishID INT,
	@UnitPrice FLOAT,
	@Quantity INT = 1
AS
BEGIN
	IF (SELECT COUNT(OrderID) FROM Orders WHERE OrderID = @OrderID) < 1
		THROW 50001, 'No such order.', 1
	IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
		THROW 50002, 'No such dish.', 1
	INSERT INTO OrderDetails (OrderID, DishID, UnitPrice, Quantity)
	VALUES (@OrderID, @DishID, @UnitPrice, @Quantity)
END

EXEC AddNewOrderDetails 1, 1, 25.5


DROP PROCEDURE IF EXISTS AddNewDish
CREATE PROCEDURE AddNewDish
	@Name VARCHAR(50),
	@UnitPrice FLOAT
AS
BEGIN
	INSERT INTO Dishes(DishName, UnitPrice)
	VALUES (@Name, @UnitPrice)
END

EXEC AddNewDish 'Penne al forno', 25.50


DROP PROCEDURE IF EXISTS AddProductToDish
CREATE PROCEDURE AddProductToDish
	@ProductID INT,
	@DishID INT
AS
BEGIN
	IF (SELECT COUNT(ProductID) FROM Products WHERE ProductID = @ProductID) < 1
		THROW 50001, 'No such product.', 1
	IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
		THROW 50002, 'No such dish.', 1
	INSERT INTO DishDetails (ProductID, DishID)
	VALUES (@ProductID, @DishID)
END

EXEC AddProductToDish 2, 1


DROP PROCEDURE IF EXISTS AddNewProduct
CREATE PROCEDURE AddNewProduct
	@Name VARCHAR(50),
	@ProductCategoryID INT,
	@UnitsInStock INT = 0
AS
BEGIN
	IF (SELECT COUNT(ProductCategoryID) FROM ProductCategories WHERE ProductCategoryID = @ProductCategoryID) < 1
		THROW 50001, 'No such product category', 1
	INSERT INTO Products (ProductName, ProductCategoryID, UnitsInStock)
	VALUES (@Name, @ProductCategoryID, @UnitsInStock)
END

EXEC AddNewProduct 'Penne' , 2


DROP PROCEDURE IF EXISTS AddNewProductCategory;
CREATE PROCEDURE AddNewProductCategory
	@Name VARCHAR(30),
	@Description VARCHAR(50) = NULL
AS
BEGIN
	INSERT INTO ProductCategories (ProductCategoryName, Description)
	VALUES (@Name, @Description)
END

EXEC AddNewProductCategory 'Seafood', 'Seaweed, sushi and fish'
EXEC AddNewProductCategory 'Pasta'


DROP PROCEDURE IF EXISTS AddNewDiscount
CREATE PROCEDURE AddNewDiscount
    @CustomerID INT,
    @Value FLOAT,
    @IssueDate DATETIME,
    @DueDate DATETIME = NULL,
    @IsOneTime BIT = 1,
    @IsAvailable BIT = 1
AS
BEGIN
    INSERT INTO Discounts(CustomerID, Value, DueDate, IssueDate, IsOneTime, IsAvailable)
    VALUES (@CustomerID, @Value, @DueDate, @IssueDate, @IsOneTime, @IsAvailable)
END

EXEC AddNewDiscount 4, 0.25, '2021-01-16'
EXEC AddNewDiscount 4, 0.30, '2021-01-16', @IsOneTime = 0, @DueDate = '2021-02-16'


DROP PROCEDURE IF EXISTS AddNewReservation
CREATE PROCEDURE AddNewReservation
    @CustomerID INT,
    @EmployeeID INT,
    @NumberOfPeople INT,
    @RealizationDate DATETIME,
    @ReservationDate DATETIME,
    @TableID INT,
    @IsCancelled BIT = 0,
    @IsByPerson BIT = 1
AS
BEGIN
    IF (SELECT COUNT(CustomerID) FROM Customers WHERE CustomerID = @CustomerID) < 1
        THROW 50001, 'No such customer.', 1
    IF (SELECT COUNT(EmployeeID) FROM Employees WHERE EmployeeID = @EmployeeID) < 1
        THROW 50001, 'No such employee.', 1
    IF (SELECT COUNT(TableID) FROM Tables WHERE TableID = @TableID) < 1
        THROW 50001, 'No such table.', 1
    IF @NumberOfPeople > (SELECT CurrentCapacity FROM Tables WHERE TableID = @TableID)
        THROW 50002, 'Number of people is too big.', 1
    INSERT INTO Reservations(EmployeeID, CustomerID, ReservationDate, RealizationDate, NumberOfPeople, TableID, IsByPerson, IsCancelled)
    VALUES (@EmployeeID, @CustomerID, @ReservationDate, @RealizationDate, @NumberOfPeople, @TableID, @IsByPerson, @IsCancelled)
END

EXEC AddNewReservation 5, 1, 3, '2021-01-29', '2021-01-16', 2


DROP PROCEDURE IF EXISTS AddDishToMenu
CREATE PROCEDURE AddDishToMenu
    @MenuID INT,
    @DishID INT,
    @IsAvailable BIT = 1
AS
BEGIN
    IF (SELECT COUNT(MenuID) FROM Menu WHERE MenuID = @MenuID) < 1
        THROW 50001, 'No such menu.', 1
    IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
        THROW 50001, 'No such dish.', 1
    INSERT INTO MenuDishes(MenuID, DishID, IsAvailable)
    VALUES (@MenuID, @DishID, @IsAvailable)
END

EXEC AddDishToMenu 1, 1
EXEC AddDishToMenu 1, 1, 0


DROP PROCEDURE IF EXISTS AddNewMenu
CREATE PROCEDURE AddNewMenu
    @ArrangementDate DATETIME,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    INSERT INTO Menu(ArrangementDate, StartDate, EndDate)
    VALUES (@ArrangementDate, @StartDate, @EndDate)
END

EXEC AddNewMenu '2021-01-16', '2021-01-18', '2021-01-22'


DROP PROCEDURE IF EXISTS AddNewTable
CREATE PROCEDURE AddNewTable
    @MaxCapacity INT,
    @CurrentCapacity INT = NULL
AS
BEGIN
    IF @CurrentCapacity IS NOT NULL
        INSERT INTO Tables(MaxCapacity, CurrentCapacity)
        VALUES (@MaxCapacity, @CurrentCapacity)
    ELSE
        INSERT INTO Tables(MaxCapacity, CurrentCapacity)
        VALUES (@MaxCapacity, @MaxCapacity)
END

EXEC AddNewTable 10
EXEC AddNewTable 10, 4


DROP PROCEDURE IF EXISTS ChangeTableCurrentCapacity
CREATE PROCEDURE ChangeTableCurrentCapacity
    @TableID INT,
    @NewCurrentCapacity INT
AS
BEGIN
    IF (SELECT COUNT(TableID) FROM Tables WHERE TableID = @TableID) < 1
        THROW 50001, 'No such tables.', 1
    UPDATE Tables
    SET CurrentCapacity = @NewCurrentCapacity
    WHERE TableID = @TableID
END

EXEC ChangeTableCurrentCapacity 1, 5


DROP PROCEDURE IF EXISTS ChangeTablesLimit
CREATE PROCEDURE ChangeTablesLimit
    @NewLimit INT
AS
BEGIN
    DECLARE @GeneralCapacity INT
    SET @GeneralCapacity = (SELECT SUM(MaxCapacity) FROM Tables)
    IF @NewLimit > @GeneralCapacity
        THROW 50002, 'New limit is too big.', 1
    DECLARE @Coef FLOAT
    SET @Coef =  CAST(@NewLimit AS FLOAT) / @GeneralCapacity
    UPDATE Tables
    SET CurrentCapacity = CAST(MaxCapacity * @Coef AS INT)
END

EXEC ChangeTablesLimit 10


DROP PROCEDURE IF EXISTS RemoveTablesLimits
CREATE PROCEDURE RemoveTablesLimits
AS
BEGIN
    UPDATE Tables
    SET CurrentCapacity = MaxCapacity
END

EXEC RemoveTablesLimits


DROP PROCEDURE IF EXISTS ChangeTableParticipants
CREATE PROCEDURE ChangeTableParticipants
    @ReservationID INT,
    @NewNumberOfPeople INT
AS
BEGIN
    IF (SELECT COUNT(ReservationID) FROM Reservations WHERE ReservationID = @ReservationID) < 1
        THROW 50001, 'No such reservation.', 1
    IF @NewNumberOfPeople > (
                                SELECT CurrentCapacity
                                FROM Reservations R
                                INNER JOIN Tables T ON T.TableID = R.TableID
                                WHERE ReservationID = @ReservationID
                            )
        THROW 50002, 'Number of people is too big.', 1
    UPDATE Reservations
    SET NumberOfPeople = @NewNumberOfPeople
    WHERE ReservationID = @ReservationID
END

EXEC ChangeTableParticipants 1, 6


DROP PROCEDURE IF EXISTS ChangeCustomerData
CREATE PROCEDURE ChangeCustomerData
    @CustomerID INT,
    @Phone VARCHAR(20) = NULL,
    @Email VARCHAR(30) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    IF (SELECT COUNT(CustomerID) FROM Customers WHERE CustomerID = @CustomerID) < 1
        THROW 50001, 'No such customer.', 1
    IF @Phone IS NOT NULL
        UPDATE Customers
        SET Phone = @Phone
        WHERE CustomerID = @CustomerID
    IF @Email IS NOT NULL
        UPDATE Customers
        SET Email = @Email
        WHERE CustomerID = @CustomerID
    IF @Address IS NOT NULL
        UPDATE Customers
        SET Address = @Address
        WHERE CustomerID = @CustomerID
    IF @City IS NOT NULL
        UPDATE Customers
        SET City = @City
        WHERE CustomerID = @CustomerID
    IF @PostalCode IS NOT NULL
        UPDATE Customers
        SET PostalCode = @PostalCode
        WHERE CustomerID = @CustomerID
    IF @Country IS NOT NULL
        UPDATE Customers
        SET Country = @Country
        WHERE CustomerID = @CustomerID
END

EXEC ChangeCustomerData 4, @Email = 'good_email@Gmail.com'
EXEC ChangeCustomerData 5, @Email = 'john@Gmail.com', @City = 'Gdansk'


DROP PROCEDURE IF EXISTS ChangeCompanyCustomerData
CREATE PROCEDURE ChangeCompanyCustomerData
    @CustomerID INT,
    @CompanyName VARCHAR(50) = NULL,
    @ContactPersonName VARCHAR(50) = NULL,
    @ContactPersonTitle VARCHAR(50) = NULL,
    @Fax VARCHAR(20) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Email VARCHAR(30) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    IF (SELECT COUNT(CustomerID) FROM CompanyCustomers WHERE CustomerID = @CustomerID) < 1
        THROW 50001, 'No such company customer.', 1
    EXEC ChangeCustomerData @CustomerID, @Phone, @Email, @Address, @City, @PostalCode, @Country
    IF @CompanyName IS NOT NULL
        UPDATE CompanyCustomers
        SET CompanyName = @CompanyName
        WHERE CustomerID = @CustomerID
    IF @ContactPersonName IS NOT NULL
        UPDATE CompanyCustomers
        SET ContactPersonName = @ContactPersonName
        WHERE CustomerID = @CustomerID
    IF @ContactPersonName IS NOT NULL
        UPDATE CompanyCustomers
        SET ContactPersonTitle = @ContactPersonTitle
        WHERE CustomerID = @CustomerID
    IF @Fax IS NOT NULL
        UPDATE CompanyCustomers
        SET Fax = @Fax
        WHERE CustomerID = @CustomerID
END

EXEC ChangeCompanyCustomerData 4, @CompanyName = 'Very Good Company', @ContactPersonName = 'John Doe', @City = 'Krakow'


DROP PROCEDURE IF EXISTS ChangeIndividualCustomerData
CREATE PROCEDURE ChangeIndividualCustomerData
    @CustomerID INT,
    @FirstName VARCHAR(30) = NULL,
    @LastName VARCHAR(30) = NULL,
    @Phone VARCHAR(20) = NULL,
    @Email VARCHAR(30) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    IF (SELECT COUNT(CustomerID) FROM IndividualCustomers WHERE CustomerID = @CustomerID) < 1
        THROW 50001, 'No such individual customer.', 1
    EXEC ChangeCustomerData @CustomerID, @Phone, @Email, @Address, @City, @PostalCode, @Country
    IF @FirstName IS NOT NULL
        UPDATE IndividualCustomers
        SET FirstName = @FirstName
        WHERE CustomerID = @CustomerID
    IF @LastName IS NOT NULL
        UPDATE IndividualCustomers
        SET LastName = @LastName
        WHERE CustomerID = @CustomerID
END

EXEC ChangeIndividualCustomerData 6, @LastName = 'Smith', @Country = 'Poland'


DROP PROCEDURE IF EXISTS ChangeEmployeeData
CREATE PROCEDURE ChangeEmployeeData
    @EmployeeID INT,
    @FirstName VARCHAR(30) = NULL,
    @LastName VARCHAR(30) = NULL,
    @Title VARCHAR(30) = NULL,
    @HireDate DATETIME = NULL,
    @Phone VARCHAR(20) = NULL,
    @Email VARCHAR(30) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    IF (SELECT COUNT(EmployeeID) FROM Employees WHERE EmployeeID = @EmployeeID) < 1
        THROW 50001, 'No such employee.', 1
    IF @FirstName IS NOT NULL
        UPDATE Employees
        SET FirstName = @FirstName
        WHERE EmployeeID = @EmployeeID
    IF @LastName IS NOT NULL
        UPDATE Employees
        SET LastName = @LastName
        WHERE EmployeeID = @EmployeeID
    IF @Title IS NOT NULL
        UPDATE Employees
        SET Title = @Title
        WHERE EmployeeID = @EmployeeID
    IF @HireDate IS NOT NULL
        UPDATE Employees
        SET HireDate = @HireDate
        WHERE EmployeeID = @EmployeeID
    IF @Phone IS NOT NULL
        UPDATE Employees
        SET Phone = @Phone
        WHERE EmployeeID = @EmployeeID
    IF @Email IS NOT NULL
        UPDATE Employees
        SET Email = @Email
        WHERE EmployeeID = @EmployeeID
    IF @Address IS NOT NULL
        UPDATE Employees
        SET Address = @Address
        WHERE EmployeeID = @EmployeeID
    IF @City IS NOT NULL
        UPDATE Employees
        SET City = @City
        WHERE EmployeeID = @EmployeeID
    IF @PostalCode IS NOT NULL
        UPDATE Employees
        SET PostalCode = @PostalCode
        WHERE EmployeeID = @EmployeeID
    IF @Country IS NOT NULL
        UPDATE Employees
        SET Country = @Country
        WHERE EmployeeID = @EmployeeID
END

EXEC ChangeEmployeeData 1, @City = 'Warsaw', @Country = 'Poland'


DROP PROCEDURE IF EXISTS RemoveEmployee
CREATE PROCEDURE RemoveEmployee
    @EmployeeID INT
AS
BEGIN
    IF (SELECT COUNT(EmployeeID) FROM Employees WHERE EmployeeID = @EmployeeID) < 1
        THROW 50001, 'No such employee.', 1
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID
END

EXEC RemoveEmployee 1


DROP PROCEDURE IF EXISTS CancelReservation
CREATE PROCEDURE CancelReservation
    @ReservationID INT
AS
BEGIN
    IF (SELECT COUNT(ReservationID) FROM Reservations WHERE ReservationID = @ReservationID) < 1
        THROW 50001, 'No such reservation.', 1
    UPDATE Reservations
    SET IsCancelled = 1
    WHERE ReservationID = @ReservationID
END

EXEC CancelReservation 1


DROP PROCEDURE IF EXISTS CancelOrder
CREATE PROCEDURE CancelOrder
	@OrderID INT
AS
BEGIN
	IF (SELECT COUNT(OrderID) FROM Orders WHERE OrderID = @OrderID) < 1
       THROW 50001, 'No such order.', 1
   DELETE FROM Orders
   WHERE OrderID = @OrderID
   DELETE FROM OrderDetails
   WHERE OrderID = @OrderID
END


DROP PROCEDURE IF EXISTS ChangeDishAvailability
CREATE PROCEDURE ChangeDishAvailability
	@DishID INT,
	@NewAvailability BIT
AS
BEGIN
	IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
       THROW 50001, 'No such dish.', 1
	UPDATE Dishes
	SET isAvailable = @NewAvailability
	WHERE DishID = @DishID
END

EXEC ChangeDishAvailability 1, 1


DROP PROCEDURE IF EXISTS ChangeProductUnitsInStock
CREATE PROCEDURE ChangeProductUnitsInStock
	@ProductID INT,
	@NewNumberOfUnits INT
AS
BEGIN
	IF (SELECT COUNT(ProductID) FROM Products WHERE ProductID = @ProductID) < 1
		THROW 50001, 'No such product.', 1
	UPDATE Products
	SET UnitsInStock = @NewNumberOfUnits
	WHERE ProductID = @ProductID
END

EXEC ChangeProductUnitsInStock 1, 10


DROP PROCEDURE IF EXISTS ChangeMenuDishAvailability
CREATE PROCEDURE ChangeMenuDishAvailability
	@MenuID INT,
	@DishID INT,
	@NewAvailability BIT
AS
BEGIN
	IF (SELECT COUNT(MenuID) FROM Menu WHERE MenuID = @MenuID) < 1
		THROW 50001, 'No such menu.', 1
	IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
		THROW 50002, 'No such dish.', 1
	UPDATE MenuDishes
	SET isAvailable = @NewAvailability
	WHERE DishID = @DishID AND MenuID = @MenuID
END

EXEC ChangeMenuDishAvailability 1, 1, 0


DROP PROCEDURE IF EXISTS ChangeDishPrice
CREATE PROCEDURE ChangeDishPrice
	@DishID INT,
	@Price FLOAT
AS
BEGIN
	IF (SELECT COUNT(DishID) FROM Dishes WHERE DishID = @DishID) < 1
		THROW 50002, 'No such dish.', 1
	UPDATE Dishes
	SET UnitPrice = @Price
	WHERE DishID = @DishID
END

EXEC ChangeDishPrice 1, 12.25


DROP PROCEDURE IF EXISTS UseOneTimeDiscount
CREATE PROCEDURE UseOneTimeDiscount
	@DiscountID INT
AS
BEGIN
	IF (SELECT COUNT(DiscountID) FROM Discounts WHERE DiscountID = @DiscountID) < 1
		THROW 50001, 'No such discount.', 1
	IF (SELECT COUNT(DiscountID) FROM Discounts WHERE DiscountID = @DiscountID AND IsOneTime = 0) > 0
		THROW 50002, 'This discount is not one time', 1
	UPDATE Discounts
	SET IsAvailable = 0
	WHERE DiscountID = @DiscountID
END

EXEC UseOneTimeDiscount 1