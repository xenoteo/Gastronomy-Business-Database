CREATE ROLE OrdersManager

GRANT EXECUTE ON AddNewCompanyCustomer TO OrdersManager
GRANT EXECUTE ON AddNewIndividualCustomer TO OrdersManager
GRANT EXECUTE ON AddNewOrder TO OrdersManager
GRANT EXECUTE ON AddNewOrderDetails TO OrdersManager
GRANT EXECUTE ON AddNewDiscount TO OrdersManager
GRANT EXECUTE ON AddNewReservation TO OrdersManager
GRANT EXECUTE ON AddNewTable TO OrdersManager
GRANT EXECUTE ON ChangeTableCurrentCapacity TO OrdersManager
GRANT EXECUTE ON ChangeTablesLimit TO OrdersManager
GRANT EXECUTE ON RemoveTablesLimits TO OrdersManager
GRANT EXECUTE ON ChangeTableParticipants TO OrdersManager
GRANT EXECUTE ON CancelReservation TO OrdersManager
GRANT EXECUTE ON CancelOrder TO OrdersManager
GRANT EXECUTE ON UseOneTimeDiscount TO OrdersManager
GRANT EXECUTE ON DeactivateDiscount TO OrdersManager
GRANT EXECUTE ON ChangeDiscountValue TO OrdersManager
GRANT EXECUTE ON TryAssignNewDiscountToCompanyCustomer TO OrdersManager
GRANT EXECUTE ON TryAssignNewDiscountToIndividualCustomer TO OrdersManager

GRANT SELECT ON FreeTables TO OrdersManager
GRANT SELECT ON CustomerDiscounts TO OrdersManager
GRANT EXECUTE ON CustomerOrdersNumberForValue TO OrdersManager
GRANT EXECUTE ON CustomerOrdersNumber TO OrdersManager
GRANT EXECUTE ON CustomerOrderWorth TO OrdersManager
GRANT EXECUTE ON CustomerMonthOrdersNumber TO OrdersManager
GRANT EXECUTE ON CustomerQuarterWorth TO OrdersManager
GRANT EXECUTE ON CustomerHasNOrdersOfGivenValue TO OrdersManager
GRANT EXECUTE ON CustomerMonthOrdersNumberOfGivenValue TO OrdersManager
GRANT SELECT ON ReservationReport TO OrdersManager
GRANT SELECT ON DiscountReport TO OrdersManager
GRANT SELECT ON CustomerOrders TO OrdersManager
GRANT EXECUTE ON CanMakeReservation TO OrdersManager

GRANT SELECT ON ToDoOrders TO OrdersManager
GRANT SELECT ON CurrentMenu TO OrdersManager
GRANT SELECT ON UpcomingReservations TO OrdersManager
GRANT SELECT ON WeekReservationsReport TO OrdersManager
GRANT SELECT ON MonthReservationsReport TO OrdersManager
GRANT SELECT ON WeekDiscountsReport TO OrdersManager
GRANT SELECT ON MonthDiscountsReport TO OrdersManager
GRANT SELECT ON WeekOrderReport TO OrdersManager
GRANT SELECT ON MonthOrderReport TO OrdersManager
GRANT SELECT ON OccupiedTablesNow TO OrdersManager
GRANT SELECT ON FreeTablesNow TO OrdersManager


CREATE ROLE MenuManager

GRANT EXECUTE ON AddNewDish TO MenuManager
GRANT EXECUTE ON AddProductToDish TO MenuManager
GRANT EXECUTE ON AddNewProduct TO MenuManager
GRANT EXECUTE ON AddNewProductCategory TO MenuManager
GRANT EXECUTE ON AddDishToMenu TO MenuManager
GRANT EXECUTE ON AddNewMenu TO MenuManager
GRANT EXECUTE ON ChangeDishAvailability TO MenuManager
GRANT EXECUTE ON ChangeProductUnitsInStock TO MenuManager
GRANT EXECUTE ON ChangeMenuDishAvailability TO MenuManager
GRANT EXECUTE ON ChangeDishPrice TO MenuManager

GRANT SELECT ON MenuReport TO MenuManager
GRANT SELECT ON MonthDishes TO MenuManager

GRANT SELECT ON CurrentMenu TO MenuManager
GRANT SELECT ON WeekMenuReport TO MenuManager
GRANT SELECT ON MonthMenuReport TO MenuManager
GRANT SELECT ON UnavailableProducts TO MenuManager
GRANT SELECT ON ExhaustingProducts TO MenuManager


CREATE ROLE Accountant

GRANT EXECUTE ON AddNewDiscount TO Accountant
GRANT EXECUTE ON UseOneTimeDiscount TO Accountant
GRANT EXECUTE ON DeactivateDiscount TO Accountant
GRANT EXECUTE ON ChangeDiscountValue TO Accountant
GRANT EXECUTE ON TryAssignNewDiscountToCompanyCustomer TO Accountant
GRANT EXECUTE ON TryAssignNewDiscountToIndividualCustomer TO Accountant

GRANT SELECT ON CustomerDiscounts TO Accountant
GRANT EXECUTE ON CustomerOrdersNumberForValue TO Accountant
GRANT EXECUTE ON CustomerOrdersNumber TO Accountant
GRANT EXECUTE ON CustomerOrderWorth TO Accountant
GRANT EXECUTE ON CustomerMonthOrdersNumber TO Accountant
GRANT EXECUTE ON CustomerQuarterWorth TO Accountant
GRANT EXECUTE ON CustomerHasNOrdersOfGivenValue TO Accountant
GRANT EXECUTE ON CustomerMonthOrdersNumberOfGivenValue TO Accountant
GRANT SELECT ON ReservationReport TO Accountant
GRANT SELECT ON DiscountReport TO Accountant
GRANT SELECT ON CustomerOrders TO Accountant
GRANT SELECT ON GenerateInvoice TO Accountant
GRANT SELECT ON GenerateCollectiveInvoice TO Accountant

GRANT SELECT ON WeekReservationsReport TO Accountant
GRANT SELECT ON MonthReservationsReport TO Accountant
GRANT SELECT ON WeekDiscountsReport TO Accountant
GRANT SELECT ON MonthDiscountsReport TO Accountant
GRANT SELECT ON WeekOrderReport TO Accountant
GRANT SELECT ON MonthOrderReport TO Accountant


CREATE ROLE DataBaseAdmin

GRANT EXECUTE, ALTER ON AddNewCustomer TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewCompanyCustomer TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewIndividualCustomer TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewEmployee TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewOrder TO ODataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewOrderDetails TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewDish TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddProductToDish TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewProduct TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewProductCategory TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewDiscount TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewReservation TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddDishToMenu TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewMenu TO DataBaseAdmin
GRANT EXECUTE, ALTER ON AddNewTable TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeTableCurrentCapacity TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeTablesLimit TO DataBaseAdmin
GRANT EXECUTE, ALTER ON RemoveTablesLimits TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeTableParticipants TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeCustomerData TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeCompanyCustomerData TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeIndividualCustomerData TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeEmployeeData TO DataBaseAdmin
GRANT EXECUTE, ALTER ON RemoveEmployee TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CancelReservation TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CancelOrder TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeDishAvailability TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeProductUnitsInStock TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeMenuDishAvailability TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeDishPrice TO DataBaseAdmin
GRANT EXECUTE, ALTER ON UseOneTimeDiscount TO DataBaseAdmin
GRANT EXECUTE, ALTER ON DeactivateDiscount TO DataBaseAdmin
GRANT EXECUTE, ALTER ON ChangeDiscountValue TO DataBaseAdmin
GRANT EXECUTE, ALTER ON TryAssignNewDiscountToCompanyCustomer TO DataBaseAdmin
GRANT EXECUTE, ALTER ON TryAssignNewDiscountToIndividualCustomer TO DataBaseAdmin

GRANT SELECT, ALTER ON FreeTables TO DataBaseAdmin
GRANT SELECT, ALTER ON CustomerDiscounts TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerOrdersNumberForValue TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerOrdersNumber TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerOrderWorth TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerMonthOrdersNumber TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerQuarterWorth TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerHasNOrdersOfGivenValue TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CustomerMonthOrdersNumberOfGivenValue TO DataBaseAdmin
GRANT SELECT, ALTER ON ReservationReport TO DataBaseAdmin
GRANT SELECT, ALTER ON MenuReport TO DataBaseAdmin
GRANT SELECT, ALTER ON DiscountReport TO DataBaseAdmin
GRANT SELECT, ALTER ON CustomerOrders TO DataBaseAdmin
GRANT SELECT, ALTER ON MonthDishes TO DataBaseAdmin
GRANT EXECUTE, ALTER ON CanMakeReservation TO DataBaseAdmin
GRANT SELECT, ALTER ON GenerateInvoice TO DataBaseAdmin
GRANT SELECT, ALTER ON GenerateCollectiveInvoice TO DataBaseAdmin

GRANT SELECT, ALTER ON ToDoOrders TO DataBaseAdmin
GRANT SELECT, ALTER ON CurrentMenu TO DataBaseAdmin
GRANT SELECT, ALTER ON UpcomingReservations TO DataBaseAdmin
GRANT SELECT, ALTER ON WeekReservationsReport TO DataBaseAdmin
GRANT SELECT, ALTER ON MonthReservationsReport TO DataBaseAdmin
GRANT SELECT, ALTER ON WeekDiscountsReport TO DataBaseAdmin
GRANT SELECT, ALTER ON MonthDiscountsReport TO DataBaseAdmin
GRANT SELECT, ALTER ON WeekMenuReport TO DataBaseAdmin
GRANT SELECT, ALTER ON MonthMenuReport TO DataBaseAdmin
GRANT SELECT, ALTER ON WeekOrderReport TO DataBaseAdmin
GRANT SELECT, ALTER ON MonthOrderReport TO DataBaseAdmin
GRANT SELECT, ALTER ON OccupiedTablesNow TO DataBaseAdmin
GRANT SELECT, ALTER ON FreeTablesNow TO DataBaseAdmin
GRANT SELECT, ALTER ON UnavailableProducts TO DataBaseAdmin
GRANT SELECT, ALTER ON ExhaustingProducts TO DataBaseAdmin


CREATE ROLE Customer

GRANT EXECUTE ON CancelReservation TO Customer
GRANT EXECUTE ON CancelOrder TO Customer

GRANT SELECT ON CurrentMenu TO Customer