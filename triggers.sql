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

CREATE TRIGGER ChangeMenuEndDateTrigger
ON Menu
FOR INSERT, UPDATE AS
BEGIN
	UPDATE Menu
	SET EndDate = DATEADD(WEEK, 2, StartDate)
	WHERE EndDate > DATEADD(WEEK, 2, StartDate)
END