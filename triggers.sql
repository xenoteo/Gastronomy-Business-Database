CREATE TRIGGER MakeUnavailableMenuDishTrigger 
ON Dishes 
FOR UPDATE AS
BEGIN
	IF UPDATE(isAvailable)
	BEGIN
		IF (SELECT isAvailable FROM inserted) = 0
		BEGIN
			DECLARE @DishID AS INT
			SET @DishID = (SELECT DishID FROM inserted)

			UPDATE MenuDishes
			SET isAvailable = 0
			WHERE DishID = @DishID
		END
	END
END
GO

CREATE TRIGGER MakeUnavailableDish
ON Products
FOR UPDATE
AS
BEGIN
	IF UPDATE(UnitsInStock)
	BEGIN
		IF (SELECT UnitsInStock FROM INSERTED) = 0
		BEGIN 
			DECLARE @productID AS INT
			SET @productID = (SELECT i.ProductID FROM INSERTED AS i) 
			DECLARE @dishID AS INT
			SET @dishID = (SELECT DishID FROM DishDetails WHERE ProductID = @productID)

			UPDATE Dishes
			SET isAvailable = 0
			WHERE DishID = @dishID
		END
	END
END
go

CREATE TRIGGER MakeAvailableDish
ON Products
FOR UPDATE
AS
BEGIN
	IF UPDATE(UnitsInStock)
	BEGIN
		IF (SELECT UnitsInStock FROM INSERTED) > 0
		BEGIN 
			DECLARE @productID AS INT
			SET @productID = (SELECT i.ProductID FROM INSERTED AS i) 
			DECLARE @dishID AS INT
			SET @dishID = (SELECT DishID FROM DishDetails WHERE ProductID = @productID)

			UPDATE Dishes
			SET isAvailable = 1
			WHERE DishID = @dishID
		END
	END
END



CREATE TRIGGER ChangeMenuEndDateTrigger
ON Menu
FOR INSERT, UPDATE AS
BEGIN
	UPDATE Menu
	SET EndDate = DATEADD(WEEK, 2, StartDate)
	WHERE EndDate > DATEADD(WEEK, 2, StartDate)
END
GO

CREATE TRIGGER CanMakeReservationTrigger
ON Reservations
FOR INSERT 
AS
BEGIN
	DECLARE @customerid AS INT
	SET @customerid = (SELECT i.CustomerID FROM INSERTED AS i)
	DECLARE @orderid AS INT
	SET @orderid = (SELECT i.OrderID FROM INSERTED AS i)
	IF (SELECT dbo.CanMakeReservation(@customerid, @orderid, 50.0, 5, 200.0)) = 0
	BEGIN
		RAISERROR ('This customer does not have the right to make reservation', -1, -1)
		ROLLBACK TRANSACTION
	END
END

GO
-- nie uruchomilam tego triggera, bo sie boje xdd
CREATE TRIGGER CanOrderSeafood
ON Orders
FOR INSERT
AS
BEGIN
	DECLARE @dishID AS INT
	SET @dishID = (SELECT DishID FROM OrderDetails
					INNER JOIN INSERTED i ON i.OrderID = OrderDetails.OrderID)
	DECLARE @productID AS INT
	set @productID = (SELECT DishDetails.ProductID FROM DishDetails 
						INNER JOIN Products ON DishDetails.ProductID = Products.ProductID
						INNER JOIN ProductCategories ON ProductCategories.ProductCategoryID = Products.ProductCategoryID
						WHERE DishID = @dishID AND ProductCategoryName = 'Seafood'
						)
	IF @productID IS NOT NULL
	BEGIN
		IF DATEPART(WEEKDAY, (SELECT i.OrderDate FROM INSERTED AS i)) <> 4 AND DATEPART(WEEKDAY, (SELECT i.OrderDate FROM INSERTED AS i)) <> 5 AND DATEPART(WEEKDAY, (SELECT i.OrderDate FROM INSERTED AS i)) <> 6
		BEGIN
			RAISERROR ('Seafood were ordered in a wrong time', -1, -1)
			ROLLBACK TRANSACTION
		END
	END
END