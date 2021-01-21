# Gastronomy-Business-Database
Database designed and implemented within lab classes.

## Description 
Database created for gastronomy business serving eatables and alcohol-free beverages, selling dishes in place or take-away. Take-away order can be commissioned in place or ordered ahead using www-form. The restaurant has a limited number of tables as well as a limited number of seats. There is a possibility of early reservation for at least 2 people.

In view of COVID-19 in several days there can be a limited number of seats (concerning the local area), which can be changing over time.

The firm serves dishes for individual customers and companies. The restaurant can prepare invoices for companies.

More detailed description in Polish can be found [here](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/requirements.pdf).

## Tech used
- Microsoft SQL Server

## Diagram
The code of tables can be found in [creating_tables.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/creating_tables.sql) script.
<a href="https://imgur.com/3GXqJeh"><img src="https://i.imgur.com/3GXqJeh.png" title="source: imgur.com" /></a>

## Procedures
The code of scripts creating procedures can be found in [procedures.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/procedures.sql) script. There are also examples of using the procedures in [procedures_examples.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/procedures_examples.sql) script.  
  
There were implemented the following procedures:
- AddNewCustomer
- AddNewCompanyCustomer
- AddNewIndividualCustomer
- AddNewEmployee
- AddNewOrder
- AddNewOrderDetails
- AddNewDish
- AddProductToDish
- AddNewProduct
- AddNewProductCategory
- AddNewDiscount
- AddNewReservation
- AddDishToMenu
- AddNewMenu
- AddNewTable
- ChangeTableCurrentCapacity
- ChangeTablesLimit
- RemoveTablesLimits
- ChangeTableParticipants
- ChangeCustomerData
- ChangeCompanyCustomerData
- ChangeIndividualCustomerData
- ChangeEmployeeData
- RemoveEmployee
- CancelReservation
- CancelOrder
- ChangeDishAvailability
- ChangeProductUnitsInStock
- ChangeMenuDishAvailability
- ChangeDishPrice
- UseOneTimeDiscount
- ChangeDiscountValue
- DeactivateDiscount
- TryAssignNewDiscountToCompanyCustomer
- TryAssignNewDiscountToIndividualCustomer

## Functions
The code of scripts creating functions can be found in [functions.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/functions.sql) script. There are also examples of using the procedures in [functions_examples.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/functions_examples.sql) script.  
  
There were implemented the following functions:
- FreeTables
- CustomerDiscounts
- CustomerOrdersNumberForValue
- CustomerOrdersNumber
- CustomerOrderWorth
- CustomerMonthOrdersNumber
- CustomerQuarterWorth
- CustomerHasNOrdersOfGivenValue
- CustomerMonthOrdersNumberOfGivenValue
- ReservationReport
- MenuReport
- DiscountReport
- CustomerOrders
- MonthDishes
- CanMakeReservation
- GenerateInvoice
- GenerateCollectiveInvoice

## Views
The code of scripts creating views can be found in [views.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/views.sql) script. 
  
There were implemented the following views:
- ToDoOrders
- CurrentMenu
- UpcomingReservations
- WeekReservationsReport
- MonthReservationsReport
- WeekDiscountsReport
- MonthDiscountsReport
- WeekMenuReport
- MonthMenuReport
- WeekOrderReport
- MonthOrderReport
- OccupiedTablesNow
- FreeTablesNow
- UnavailableProducts
- ExhaustingProducts

## Triggers
The code of scripts creating triggers can be found in [triggers.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/triggers.sql) script.  
  
There were implemented the following triggers:
- ChangeMenuDishAvailabilityTrigger
- MakeUnavailableDish
- ChangeMenuEndDate
- CanOrderSeafood
- IndividualCustomerTrigger
- CompanyCustomerTrigger

## Indexes
The code of scripts creating indexes can be found in [indexes.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/indexes.sql) script.  
  
There were implemented the following indexes:
- `LastName` in the `IndividualCustomers` table
- `CompanyName` in the `CompanyCustomers` table
- `Email` in the `Customers` table
- `Phone` in the `Customers` table
- `CustomerID` in the `Discounts` table
- `CustomerID` in the `Reservations` table
- `EmployeeID` in the `Reservations` table
- `CustomerID` in the `Orders` table
- `EmployeeID` in the `Orders` table
- `ProductName` in the `Products` table
- `DishName` in the `Dishes` table
- `ProductCategoryName` in the `ProductCategories` table

## Roles
The code of scripts creating indexes can be found in [roles.sql](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/roles.sql) script.  

### Orders Manager
Has privileges to the following procedures: 
- AddNewCompanyCustomer
- AddNewIndividualCustomer
- AddNewOrder
- AddNewOrderDetails
- AddNewDiscount
- AddNewReservation
- AddNewTable
- ChangeTableCurrentCapacity
- ChangeTablesLimit
- RemoveTablesLimits
- ChangeTableParticipants
- CancelReservation
- CancelOrder
- UseOneTimeDiscount
- DeactivateDiscount
- ChangeDiscountValue
- TryAssignNewDiscountToCompanyCustomer
- TryAssignNewDiscountToIndividualCustomer
  
Has privileges to the following functions:
- FreeTables
- CustomerDiscounts
- CustomerOrdersNumber​ForValue
- CustomerOrdersNumber
- CustomerOrderWorth
- CustomerMonthOrdersNumber
- CustomerQuarterWorth
- CustomerHasNOrdersOfGivenValue
- CustomerMonthOrdersNumberOfGivenValue
- ReservationReport
- DiscountReport
- CustomerOrders
- CanMakeReservation
  
Has privileges to the following views:
- ToDoOrders
- CurrentMenu
- UpcomingReservations
- WeekReservationsReport
- MonthReservationsReport
- WeekDiscountsReport
- MonthDiscountsReport
- WeekOrderReport
- MonthOrderReport
- OccupiedTablesNow
- FreeTablesNow

### Menu Manager
Has privileges to the following procedures: 
- AddNewDish
- AddProductToDish
- AddNewProduct
- AddNewProductCategory
- AddDishToMenu
- AddNewMenu
- ChangeDishAvailability
- ChangeProductUnitsInStock
- ChangeMenuDishAvailability
- ChangeDishPrice
  
Has privileges to the following functions:
- MenuReport
- MonthDishes
  
Has privileges to the following views:
- CurrentMenu
- WeekMenuReport
- MonthMenuReport
- UnavailableProducts
- ExhaustingProducts

### Accountant
Has privileges to the following procedures: 
- AddNewDiscount
- UseOneTimeDiscount
- DeactivateDiscount
- ChangeDiscountValue
- TryAssignNewDiscountToCompanyCustomer
- TryAssignNewDiscountToIndividualCustomer
  
Has privileges to the following functions:
- CustomerDiscounts
- CustomerOrdersNumberForValue
- CustomerOrdersNumber
- CustomerOrderWorth
- CustomerMonthOrdersNumber
- CustomerQuarterWorth
- CustomerHasNOrdersOfGivenValue
- CustomerMonthOrdersNumberOfGivenValue
- ReservationReport
- DiscountReports
- MonthMenuReport
- WeekOrderReport
- MonthOrderReport
- CustomerOrders
- GenerateInvoice
- GenerateCollectiveInvoice
  
Has privileges to the following views:
- WeekReservationsReport
- MonthReservationsReport
- WeekDiscountsReport
- MonthDiscountsReport
- WeekOrdersReport
- MonthOrdersReport

### Database administrator
Database administrator has privileges to all of the defined [procedures](https://github.com/xenoteo/Gastronomy-Business-Database/#procedures), [functions](https://github.com/xenoteo/Gastronomy-Business-Database/#functions) and [views](https://github.com/xenoteo/Gastronomy-Business-Database/#views).

### Customer
Has privileges to the following procedures: 
- CancelReservation
- CancelOrder
  
Has privileges to the following views:
-  CurrentMenu

## Additional service
For the purpose of efficient code format edition created [Formatter](https://github.com/xenoteo/Gastronomy-Business-Database/blob/main/formatting/formatting.py) class responsible for formatting of the SQL scripts.
  
Provided functions:
- Capitalizing of the SQL variables
- Setting the SQL keywords uppercase
