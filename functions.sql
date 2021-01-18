DROP FUNCTION IF EXISTS FreeTables
GO
CREATE FUNCTION FreeTables
    (@StartDate DATETIME, @EndDate DATETIME)
RETURNS @FreeTables TABLE
    (
        TableID INT,
        MaxCapacity INT,
        CurrentCapacity INT
    )
AS
BEGIN
    INSERT INTO @FreeTables
    SELECT T.TableID, T.MaxCapacity, T.CurrentCapacity FROM Tables T
    LEFT JOIN Reservations R on T.TableID = R.TableID
    WHERE RealizationDateStart > @EndDate OR RealizationDateEnd < @StartDate OR RealizationDateStart IS NULL
    RETURN
END

SELECT * FROM FreeTables('2021-01-27', '2021-02-01')


DROP FUNCTION IF EXISTS CustomerDiscounts
GO
CREATE FUNCTION CustomerDiscounts
	(@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Discounts
	WHERE CustomerID = @CustomerID
)

SELECT * FROM CustomerDiscounts(4)


DROP FUNCTION IF EXISTS CustomerOrdersNumberForValue
GO
CREATE FUNCTION CustomerOrdersNumberForValue
	(@CustomerID INT, @Money FLOAT)
RETURNS INT
AS
BEGIN
	DECLARE @OrderNumber INT
	SELECT @OrderNumber = COUNT(Orders.OrderID) FROM Orders
	INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	LEFT JOIN OrderDiscounts ON Orders.OrderID = OrderDiscounts.OrderID
    LEFT JOIN Discounts ON OrderDiscounts.DiscountID = Discounts.DiscountID
	WHERE Orders.CustomerID = @CustomerID
	GROUP BY Orders.OrderID
	HAVING SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - ISNULL(Discounts.Value, 0))) >= @Money;
	IF (@OrderNumber IS NULL)
		SET @OrderNumber = 0;
	RETURN @OrderNumber;
END
GO

SELECT dbo.CustomerOrdersNumberForValue(4, 20.0) AS OrdersNumber


DROP FUNCTION IF EXISTS CustomerOrdersNumber
GO
CREATE FUNCTION CustomerOrdersNumber
	(@CustomerID INT)
RETURNS INT
AS
BEGIN
	DECLARE @OrderNumber INT
	SELECT @OrderNumber = COUNT(Orders.OrderID) FROM Orders
	WHERE Orders.CustomerID = @CustomerID
	GROUP BY Orders.OrderID;
	IF (@OrderNumber IS NULL)
		SET @OrderNumber = 0;
	RETURN @OrderNumber;
END
GO

SELECT dbo.CustomerOrdersNumber(4)

DROP FUNCTION IF EXISTS CustomerOrderWorth
GO
CREATE FUNCTION CustomerOrderWorth
	(@CustomerID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @Worth INT
	SELECT @Worth = SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - ISNULL(Discounts.Value, 0)))
	FROM Orders
	INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	LEFT JOIN OrderDiscounts ON Orders.OrderID = OrderDiscounts.OrderID
    LEFT JOIN Discounts ON OrderDiscounts.DiscountID = Discounts.DiscountID
	WHERE Orders.CustomerID = @CustomerID
	GROUP BY Orders.OrderID;

	IF (@Worth IS NULL)
		SET @Worth = 0;
	RETURN @Worth;
END

SELECT dbo.CustomerOrderWorth(4) AS OrdersWorth


DROP FUNCTION IF EXISTS CustomerMonthOrdersNumber
GO
CREATE FUNCTION CustomerMonthOrdersNumber
	(@CustomerID INT, @Month INT, @Year INT)
RETURNS INT
AS
BEGIN
	DECLARE @OrdersNumber INT
	SELECT @OrdersNumber = COUNT(Orders.OrderID) FROM Orders
	WHERE MONTH(OrderDate) = @Month AND YEAR(OrderDate) = @Year AND CustomerID = @CustomerID
	IF (@OrdersNumber IS NULL)
		SET @OrdersNumber = 0
	RETURN @OrdersNumber
END

SELECT dbo.CustomerMonthOrdersNumber(4, 1, 2021)


DROP FUNCTION IF EXISTS CustomerQuarterWorth
GO
CREATE FUNCTION CustomerQuarterWorth
	(@CustomerID INT, @Quarter INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @Worth INT
	SELECT @Worth = SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - ISNULL(Discounts.Value, 0)))
	FROM Orders
	INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
	LEFT JOIN OrderDiscounts ON Orders.OrderID = OrderDiscounts.OrderID
    LEFT JOIN Discounts ON OrderDiscounts.DiscountID = Discounts.DiscountID
	WHERE Orders.CustomerID = @CustomerID AND DATEPART(QUARTER, Orders.OrderDate) = @Quarter
	GROUP BY Orders.OrderID;
	IF (@Worth IS NULL)
		SET @Worth = 0;
	RETURN @Worth;
END

SELECT dbo.CustomerQuarterWorth(4, 1)


DROP FUNCTION IF EXISTS ReservationReport
GO
CREATE FUNCTION ReservationReport
	(@StartDate DATETIME, @EndDate DATETIME)
RETURNS TABLE
AS
RETURN
(
	SELECT ReservationID, EmployeeID, CustomerID, ReservationDate, RealizationDateStart, RealizationDateEnd, NumberOfPeople, IsCancelled, IsByPerson, Tables.TableID
	FROM Reservations
	INNER JOIN Tables ON Tables.TableID = Reservations.TableID
	WHERE RealizationDateStart >= @StartDate AND RealizationDateEnd <= @EndDate
)

SELECT * FROM ReservationReport('2021-01-17', '2021-03-15')


DROP FUNCTION IF EXISTS MenuReport
GO
CREATE FUNCTION MenuReport
    (@StartDate DATETIME, @EndDate DATETIME)
RETURNS @Report TABLE
    (
        MenuID INT,
        ArrangementDate DATETIME,
        StartDate DATETIME,
        EndDate DATETIME,
        DishName VARCHAR(50),
        UnitPrice FLOAT
    )
AS
BEGIN
    INSERT INTO @Report
    SELECT M.MenuID, ArrangementDate, StartDate, EndDate, DishName, UnitPrice
    FROM Menu M
    INNER JOIN MenuDishes MD ON M.MenuID = MD.MenuID
    INNER JOIN Dishes D ON D.DishID = MD.DishID
    WHERE StartDate >= @StartDate AND EndDate <= @EndDate
    RETURN
END

SELECT * FROM MenuReport('2021-01-15', '2021-02-01')


DROP FUNCTION IF EXISTS DiscountReport
GO
CREATE FUNCTION DiscountReport
    (@StartDate DATETIME, @EndDate DATETIME)
RETURNS @Report TABLE
    (
        DiscountID INT,
        CustomerID INT,
        Value FLOAT,
        DueDate DATETIME,
        IssueDate DATETIME,
        IsOneTime BIT,
        IsAvailable BIT
    )
AS
BEGIN
    INSERT INTO @Report
    SELECT * FROM Discounts
    WHERE IssueDate >= @StartDate AND IssueDate <= @EndDate
    RETURN
END

SELECT * FROM DiscountReport('2021-01-15', '2021-02-01')


DROP FUNCTION IF EXISTS CustomerOrders
GO
CREATE FUNCTION CustomerOrders
    (@CustomerID INT)
RETURNS @Stats TABLE
    (
        Date DATETIME,
        Worth FLOAT
    )
AS
BEGIN
    INSERT INTO @Stats
    SELECT OrderDate, SUM(UnitPrice * Quantity * (1 - ISNULL(Value, 0)))
    FROM Customers C
    INNER JOIN Orders O ON C.CustomerID = O.CustomerID
    INNER JOIN OrderDetails ODet ON O.OrderID = ODet.OrderID
    LEFT JOIN OrderDiscounts ODisc ON O.OrderID = ODisc.OrderID
    LEFT JOIN Discounts D ON ODisc.DiscountID = D.DiscountID
    WHERE C.CustomerID = @CustomerID
    GROUP BY O.OrderID, OrderDate
    RETURN
END

SELECT * FROM CustomerOrders(4)

DROP FUNCTION IF EXISTS LastMonthDishes
GO
CREATE FUNCTION LastMonthDishes
	(@MenuID INT, @month INT, @year INT)
RETURNS TABLE
AS
RETURN
(
	SELECT MenuDishes.DishID FROM MenuDishes
	INNER JOIN Dishes ON MenuDishes.DishID = Dishes.DishID
	INNER JOIN Menu ON MenuDishes.MenuID = Menu.MenuID
	WHERE MenuDishes.MenuID = @MenuID AND MONTH(Menu.StartDate) <= @month AND YEAR(Menu.StartDate) = @year
)


DROP FUNCTION IF EXISTS CanMakeReservation
GO
CREATE FUNCTION CanMakeReservation
	(@customerID INT, @orderValue FLOAT, @lowerLimitValue FLOAT, @previousOrders INT, @elseValue FLOAT)
RETURNS BIT
AS
BEGIN
	DECLARE @res BIT
	SELECT @res = (CASE WHEN ((@lowerLimitValue <= @orderValue AND dbo.CustomerOrdersNumber(@customerID) >= @previousOrders) OR (@lowerLimitValue >= @orderValue AND dbo.CustomerOrdersNumberForValue(@customerID, @elseValue) <= @previousOrders)) THEN 1 ELSE 0 END);
	RETURN @res;
END
GO
select dbo.CanMakeReservation(4, 25, 15, 2, 26)
select dbo.CanMakeReservation(4, 25, 15, 1, 26)
