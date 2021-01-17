DROP FUNCTION IF EXISTS FreeTables
CREATE FUNCTION FreeTables
    (@startDate DATETIME, @endDate DATETIME)
RETURNS @freeTables TABLE
    (
        TableID INT,
        MaxCapacity INT,
        CurrentCapacity INT
    )
AS
BEGIN
    INSERT INTO @freeTables
    SELECT R.TableID, MaxCapacity, CurrentCapacity
    FROM Reservations R INNER JOIN Tables T ON R.TableID = T.TableID
    WHERE RealizationDate >= @startDate AND ReservationDate <= @endDate
    RETURN
END

SELECT * FROM FreeTables('2021-01-27', '2021-02-01')


DROP FUNCTION IF EXISTS CustomerOrdersNumber
GO
CREATE FUNCTION CustomerOrdersNumber
	(@customerID INT, @money FLOAT)
RETURNS INT
AS
BEGIN
	DECLARE @orderNumber INT 
	SELECT @orderNumber = COUNT(Orders.OrderID)
	FROM Orders
	INNER JOIN OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	WHERE Orders.CustomerID = @customerID AND OrderDetails.UnitPrice >= @money;
	IF (@orderNumber IS NULL)
		SET @orderNumber = 0;
	RETURN @orderNumber;
END

GO
SELECT dbo.CustomerOrdersNumber(4, 20.0) AS ordersNumber;

DROP FUNCTION IF EXISTS CustomerOrderWorth
GO
CREATE FUNCTION CustomerOrderWorth
	(@customerID int)
RETURNS FLOAT
AS
BEGIN
	DECLARE @worth INT
	SELECT @worth = SUM(OrderDetails.UnitPrice)
	FROM OrderDetails
	INNER JOIN Orders
	ON Orders.OrderID = OrderDetails.OrderID
	WHERE Orders.CustomerID = @customerID;
	IF (@worth IS NULL)
		set @worth = 0;
	RETURN @worth;
END