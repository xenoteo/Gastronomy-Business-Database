DROP TRIGGER IF EXISTS ChangeMenuDishAvailabilityTrigger
GO
CREATE TRIGGER ChangeMenuDishAvailabilityTrigger
ON Dishes 
FOR UPDATE AS
BEGIN
	IF UPDATE(isAvailable)
	BEGIN
		DECLARE @DishID AS INT
        SET @DishID = (SELECT DishID FROM INSERTED)

        UPDATE MenuDishes
        SET isAvailable = (SELECT isAvailable FROM INSERTED)
        WHERE DishID = @DishID
	END
END
GO

DROP TRIGGER IF EXISTS MakeUnavailableDish
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
			DECLARE @ProductID AS INT
			SET @ProductID = (SELECT i.ProductID FROM INSERTED AS i) 
			DECLARE @DishID AS INT
			SET @DishID = (SELECT DishID FROM DishDetails WHERE ProductID = @ProductID)

			UPDATE Dishes
			SET isAvailable = 0
			WHERE DishID = @DishID
		END
	END
END
GO

DROP TRIGGER IF EXISTS ChangeMenuEndDate
GO
CREATE TRIGGER ChangeMenuEndDate
ON Menu
FOR INSERT, UPDATE AS
BEGIN
	UPDATE Menu
	SET EndDate = DATEADD(WEEK, 2, StartDate)
	WHERE EndDate > DATEADD(WEEK, 2, StartDate)
END
GO

DROP TRIGGER IF EXISTS CanMakeReservationTrigger
GO
CREATE TRIGGER CanMakeReservationTrigger
ON Reservations
FOR INSERT 
AS
BEGIN
	DECLARE @CustomerID AS INT
	SET @CustomerID = (SELECT i.CustomerID FROM INSERTED AS i)
	DECLARE @OrderID AS INT
	SET @OrderID = (SELECT i.OrderID FROM INSERTED AS i)
	IF (SELECT dbo.CanMakeReservation(@CustomerID, @OrderID, 50.0, 5, 200.0)) = 0
	BEGIN
		RAISERROR ('This customer does not have the right to make reservation', -1, -1)
		ROLLBACK TRANSACTION
	END
END
GO

DROP TRIGGER IF EXISTS CanOrderSeafood
GO
CREATE TRIGGER CanOrderSeafood
ON Orders
FOR INSERT
AS
BEGIN
	DECLARE @DishID AS INT
	SET @DishID = (SELECT DishID FROM OrderDetails
					INNER JOIN INSERTED i ON i.OrderID = OrderDetails.OrderID)
	DECLARE @ProductID AS INT
	SET @ProductID = (SELECT DishDetails.ProductID FROM DishDetails
						INNER JOIN Products ON DishDetails.ProductID = Products.ProductID
						INNER JOIN ProductCategories ON ProductCategories.ProductCategoryID = Products.ProductCategoryID
						WHERE DishID = @DishID AND ProductCategoryName = 'Seafood'
	                )
	IF @ProductID IS NOT NULL
	BEGIN
		IF DATEPART(WEEKDAY, (SELECT OrderDate FROM INSERTED)) NOT IN (5, 6, 7)
		BEGIN
			RAISERROR ('Seafood were ordered in a wrong time', -1, -1)
			ROLLBACK TRANSACTION
		END
	END
END


DROP TRIGGER IF EXISTS IndividualCustomerTrigger
GO
CREATE TRIGGER IndividualCustomerTrigger
ON IndividualCustomers
FOR INSERT 
AS
BEGIN
	UPDATE dbo.Customers
	SET IsCompany = 0
	WHERE CustomerID = (SELECT CustomerID FROM Inserted)
END

DROP TRIGGER IF EXISTS CompanyCustomerTrigger
GO
CREATE TRIGGER CompanyCustomerTrigger
ON CompanyCustomers
FOR INSERT 
AS
BEGIN
	UPDATE dbo.Customers
	SET IsCompany = 1
	WHERE CustomerID = (SELECT CustomerID FROM Inserted)
END