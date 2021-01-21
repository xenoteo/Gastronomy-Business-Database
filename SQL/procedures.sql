DROP PROCEDURE IF EXISTS AddNewCustomer
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewCompanyCustomer
GO
CREATE PROCEDURE AddNewCompanyCustomer
    @CompanyName VARCHAR(50),
    @Phone VARCHAR(20),
    @Email VARCHAR(30),
	@NIP VARCHAR(10),
    @ContactPersonName VARCHAR(50) = NULL,
    @ContactPersonTitle VARCHAR(50) = NULL,
    @Address VARCHAR(50) = NULL,
    @City VARCHAR(30) = NULL,
    @PostalCode VARCHAR(30) = NULL,
    @Country VARCHAR(30) = NULL
AS
BEGIN
    EXEC AddNewCustomer @Phone, @Email, 1, @Address, @City, @PostalCode, @Country
    DECLARE @CustomerID INT
    SET @CustomerID = (SELECT CustomerID FROM Customers WHERE Email = @Email AND Phone = @Phone)
    INSERT INTO CompanyCustomers(CustomerID, CompanyName, ContactPersonName, ContactPersonTitle, NIP)
    VALUES (@CustomerID, @CompanyName, @ContactPersonName, @ContactPersonTitle, @NIP)
END
GO

DROP PROCEDURE IF EXISTS AddNewIndividualCustomer
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewEmployee
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewOrder
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewOrderDetails
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewDish
GO
CREATE PROCEDURE AddNewDish
	@Name VARCHAR(50),
	@UnitPrice FLOAT
AS
BEGIN
	INSERT INTO Dishes(DishName, UnitPrice)
	VALUES (@Name, @UnitPrice)
END
GO

DROP PROCEDURE IF EXISTS AddProductToDish
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewProduct
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewProductCategory
GO
CREATE PROCEDURE AddNewProductCategory
	@Name VARCHAR(30),
	@Description VARCHAR(50) = NULL
AS
BEGIN
	INSERT INTO ProductCategories (ProductCategoryName, Description)
	VALUES (@Name, @Description)
END
GO

DROP PROCEDURE IF EXISTS AddNewDiscount
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewReservation
GO
CREATE PROCEDURE AddNewReservation
    @CustomerID INT,
    @EmployeeID INT,
	@OrderID INT,
    @NumberOfPeople INT,
    @RealizationDateStart DATETIME,
    @RealizationDateEnd DATETIME,
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
	IF (SELECT COUNT(OrderID) FROM Orders WHERE OrderID = @OrderID) < 1
        THROW 50001, 'No such order.', 1
    INSERT INTO Reservations(EmployeeID, CustomerID, ReservationDate, RealizationDateStart, RealizationDateEnd, NumberOfPeople, TableID, IsByPerson, IsCancelled, OrderID)
    VALUES (@EmployeeID, @CustomerID, @ReservationDate, @RealizationDateStart, @RealizationDateEnd, @NumberOfPeople, @TableID, @IsByPerson, @IsCancelled, @OrderID)
END
GO

DROP PROCEDURE IF EXISTS AddDishToMenu
GO
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
GO

DROP PROCEDURE IF EXISTS AddNewMenu
GO
CREATE PROCEDURE AddNewMenu
    @ArrangementDate DATETIME,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    INSERT INTO Menu(ArrangementDate, StartDate, EndDate)
    VALUES (@ArrangementDate, @StartDate, @EndDate)
END
GO

DROP PROCEDURE IF EXISTS AddNewTable
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeTableCurrentCapacity
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeTablesLimit
GO
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
GO

DROP PROCEDURE IF EXISTS RemoveTablesLimits
GO
CREATE PROCEDURE RemoveTablesLimits
AS
BEGIN
    UPDATE Tables
    SET CurrentCapacity = MaxCapacity
END
GO

DROP PROCEDURE IF EXISTS ChangeTableParticipants
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeCustomerData
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeCompanyCustomerData
GO
CREATE PROCEDURE ChangeCompanyCustomerData
    @CustomerID INT,
    @CompanyName VARCHAR(50) = NULL,
    @ContactPersonName VARCHAR(50) = NULL,
    @ContactPersonTitle VARCHAR(50) = NULL,
    @NIP VARCHAR(10) = NULL,
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
    IF @NIP IS NOT NULL
        UPDATE CompanyCustomers
        SET NIP = @NIP
        WHERE CustomerID = @CustomerID
END
GO

DROP PROCEDURE IF EXISTS ChangeIndividualCustomerData
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeEmployeeData
GO
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
GO

DROP PROCEDURE IF EXISTS RemoveEmployee
GO
CREATE PROCEDURE RemoveEmployee
    @EmployeeID INT
AS
BEGIN
    IF (SELECT COUNT(EmployeeID) FROM Employees WHERE EmployeeID = @EmployeeID) < 1
        THROW 50001, 'No such employee.', 1
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID
END
GO

DROP PROCEDURE IF EXISTS CancelReservation
GO
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
GO

DROP PROCEDURE IF EXISTS CancelOrder
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeDishAvailability
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeProductUnitsInStock
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeMenuDishAvailability
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeDishPrice
GO
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
GO

DROP PROCEDURE IF EXISTS UseOneTimeDiscount
GO
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
GO

DROP PROCEDURE IF EXISTS ChangeDiscountValue
GO
CREATE PROCEDURE ChangeDiscountValue
	@DiscountID INT,
    @NewValue FLOAT
AS
BEGIN
	IF (SELECT COUNT(DiscountID) FROM Discounts WHERE DiscountID = @DiscountID) < 1
		THROW 50001, 'No such discount.', 1
	UPDATE Discounts
	SET Value = @NewValue
	WHERE DiscountID = @DiscountID
END
GO

DROP PROCEDURE IF EXISTS DeactivateDiscount
GO
CREATE PROCEDURE DeactivateDiscount
	@DiscountID INT
AS
BEGIN
	IF (SELECT COUNT(DiscountID) FROM Discounts WHERE DiscountID = @DiscountID) < 1
		THROW 50001, 'No such discount.', 1
	UPDATE Discounts
	SET IsAvailable = 0
	WHERE DiscountID = @DiscountID
END
GO

DROP PROCEDURE IF EXISTS TryAssignNewDiscountToIndividualCustomer
GO
CREATE PROCEDURE TryAssignNewDiscountToIndividualCustomer
    @CustomerID INT,
    @Z1 INT,
    @K1 INT,
    @R1 FLOAT,
    @K2 INT,
    @R2 FLOAT,
    @D1 INT,
    @K3 INT,
    @R3 FLOAT,
    @D2 INT
AS
BEGIN
    DECLARE @Date DATETIME
    SET @Date = GETDATE()
    IF dbo.CustomerHasNOrdersOfGivenValue(@CustomerID, @Z1, @K1) = 1
        EXEC AddNewDiscount @CustomerID, @R1, @Date

    IF dbo.CustomerOrderWorth(@CustomerID) >= @K2
        BEGIN
            DECLARE @DueDate DATETIME
            SET @DueDate = DATEADD(DAY, @D1, @Date)
            EXEC AddNewDiscount @CustomerID, @R2, @Date, @DueDate = @DueDate
        END
    IF dbo.CustomerOrderWorth(@CustomerID) >= @K3
        BEGIN
            DECLARE @NewDueDate DATETIME
            SET @NewDueDate = DATEADD(DAY, @D2, @Date)
            EXEC AddNewDiscount @CustomerID, @R3, @Date, @DueDate = @NewDueDate
        END
END
GO

DROP PROCEDURE IF EXISTS TryAssignNewDiscountToCompanyCustomer
GO
CREATE PROCEDURE TryAssignNewDiscountToCompanyCustomer
    @CustomerID INT,
    @FZ INT,
    @FK1 INT,
    @FR1 FLOAT,
    @FM FLOAT,
    @FK2 INT,
    @FR2 FLOAT
AS
BEGIN
    DECLARE @Date DATETIME
    SET @Date = GETDATE()
    DECLARE @DiscountID INT
    SET @DiscountID = (SELECT DiscountID FROM Discounts
        WHERE CustomerID = @CustomerID AND IsAvailable = 1 AND IsOneTime = 0)
    DECLARE @MonthOrdersNumber INT
    SET @MonthOrdersNumber = dbo.CustomerMonthOrdersNumberOfGivenValue(@CustomerID, @FK1, @Date)
    IF @MonthOrdersNumber >= @FZ
        BEGIN
            IF @DiscountID IS NULL
                    EXEC AddNewDiscount @CustomerID, @FR1, @Date, @IsOneTime = 0
            ELSE
                BEGIN
                    DECLARE @OldDiscount FLOAT
                    SET @OldDiscount = (SELECT Value FROM Discounts
                        WHERE CustomerID = @CustomerID AND IsAvailable = 1 AND IsOneTime = 0)
                    DECLARE @NewDiscount FLOAT
                    SET @NewDiscount = @OldDiscount + @FR1
                    SET @NewDiscount = IIF((@NewDiscount > @FM), @FM, @NewDiscount)
                    EXEC ChangeDiscountValue @DiscountID, @NewDiscount
                END
        END
    ELSE IF @MonthOrdersNumber = 0 AND @DiscountID IS NOT NULL
        BEGIN
            EXEC ChangeDiscountValue @DiscountID, 0
        END

    DECLARE @Quarter INT
    SET @Quarter = DATEPART(quarter, @Date)
    DECLARE @QuarterWorth INT
    SET @QuarterWorth = dbo.CustomerQuarterWorth(@CustomerID, @Quarter)
    IF @QuarterWorth >= @FK2
        EXEC AddNewDiscount @CustomerID, @FR2, @Date
END
GO