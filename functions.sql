DROP FUNCTION IF EXISTS FreeTables
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
    SELECT R.TableID, MaxCapacity, CurrentCapacity
    FROM Reservations R INNER JOIN Tables T ON R.TableID = T.TableID
    WHERE RealizationDate >= @StartDate AND ReservationDate <= @EndDate
    RETURN
END

SELECT * FROM FreeTables('2021-01-27', '2021-02-01')


DROP FUNCTION IF EXISTS CustomerOrdersNumber
CREATE FUNCTION CustomerOrdersNumber
	(@CustomerID INT, @Money FLOAT)
RETURNS INT
AS
BEGIN
	DECLARE @OrderNumber INT
	SELECT @OrderNumber = COUNT(Orders.OrderID)
	FROM Orders
	INNER JOIN OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	WHERE Orders.CustomerID = @CustomerID AND OrderDetails.UnitPrice >= @Money;
	IF (@OrderNumber IS NULL)
		SET @OrderNumber = 0;
	RETURN @OrderNumber;
END

SELECT dbo.CustomerOrdersNumber(4, 20.0) AS OrdersNumber


DROP FUNCTION IF EXISTS CustomerOrderWorth
CREATE FUNCTION CustomerOrderWorth
	(@CustomerID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @Worth INT
	SELECT @Worth = SUM(OrderDetails.UnitPrice)
	FROM OrderDetails
	INNER JOIN Orders
	ON Orders.OrderID = OrderDetails.OrderID
	WHERE Orders.CustomerID = @CustomerID;
	IF (@Worth IS NULL)
		SET @Worth = 0;
	RETURN @Worth;
END

SELECT dbo.CustomerOrderWorth(4) AS OrdersWorth


DROP FUNCTION IF EXISTS CustomerOrders
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


DROP FUNCTION IF EXISTS MenuReport
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
