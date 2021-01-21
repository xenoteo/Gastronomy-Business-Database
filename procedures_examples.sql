EXEC AddNewCompanyCustomer 'Good Company', '123456789', 'email@Gmail.com', '6462933516'
EXEC AddNewCompanyCustomer 'Good Company 2', '123456799', 'email2@Gmail.com', '1234056789', @Country = 'Poland'
EXEC AddNewCompanyCustomer 'Motorola', '126445689', 'iamtheboss@motorola.com', '5672345195'

EXEC AddNewIndividualCustomer 'John', 'Doe', '123456123', 'john@Gmail.com'
EXEC AddNewIndividualCustomer 'John', 'Doe', '123456124', 'john2@Gmail.com', @City = 'Warsaw'

EXEC AddNewEmployee 'Anne', 'Smith', 'head of procurement', '165935616', 'asmith@Gmail.com'
EXEC AddNewEmployee 'James', 'Cameron', 'Warehouse manager', '789243666', 'jamesCameron@Restaurant.com', @Address = 'NorthStreet 31/16', @PostalCode = '30-200', @City = 'Naples', @Country = 'Italy'

EXEC AddNewOrder 5, 4, '2021/01/17', '2021/01/27'

EXEC AddNewOrderDetails 1, 1, 25.5

EXEC AddNewDish 'Penne al forno', 25.50

EXEC AddProductToDish 2, 1

EXEC AddNewProduct 'Penne' , 2

EXEC AddNewProductCategory 'Seafood', 'Seaweed, sushi and fish'
EXEC AddNewProductCategory 'Pasta'

EXEC AddNewDiscount 4, 0.25, '2021-01-16'
EXEC AddNewDiscount 4, 0.30, '2021-01-16', @IsOneTime = 0, @DueDate = '2021-02-16'

EXEC AddNewReservation 5, 1, 1, 3, '2021-01-29 18:00', '2021-01-29 20:00','2021-01-16', 1

EXEC AddDishToMenu 1, 1
EXEC AddDishToMenu 1, 1, 0

EXEC AddNewMenu '2021-01-16', '2021-01-18', '2021-01-22'

EXEC AddNewTable 10
EXEC AddNewTable 10, 4

EXEC ChangeTableCurrentCapacity 1, 5

EXEC ChangeTablesLimit 10

EXEC RemoveTablesLimits

EXEC ChangeTableParticipants 3, 6

EXEC ChangeCustomerData 4, @Email = 'good_email@Gmail.com'
EXEC ChangeCustomerData 5, @Email = 'john@Gmail.com', @City = 'Gdansk'

EXEC ChangeCompanyCustomerData 4, @CompanyName = 'Very Good Company', @ContactPersonName = 'John Doe', @City = 'Krakow'

EXEC ChangeIndividualCustomerData 6, @LastName = 'Smith', @Country = 'Poland'

EXEC ChangeEmployeeData 1, @City = 'Warsaw', @Country = 'Poland'

EXEC RemoveEmployee 1

EXEC CancelReservation 3

EXEC CancelOrder 1

EXEC ChangeDishAvailability 1, 1

EXEC ChangeProductUnitsInStock 1, 10

EXEC ChangeMenuDishAvailability 1, 1, 0

EXEC ChangeDishPrice 1, 12.25

EXEC UseOneTimeDiscount 1

EXEC ChangeDiscountValue 1, 0.33

EXEC DeactivateDiscount 1

EXEC TryAssignNewDiscountToIndividualCustomer 1, 10, 30, 0.03, 1000, 0.05,7, 5000, 0.05, 7

EXEC TryAssignNewDiscountToCompanyCustomer 1, 5, 500, 0.001, 0.04, 10000, 0.05