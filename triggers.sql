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