DROP VIEW IF EXISTS ToDoOrders
GO
CREATE VIEW ToDoOrders
AS
SELECT * FROM Orders
WHERE GETDATE() < RequiredRealisationDate AND PickUpDate IS NULL


DROP VIEW IF EXISTS CurrentMenu
GO
CREATE VIEW CurrentMenu
AS
SELECT M.MenuID, ArrangementDate, StartDate, EndDate, DishName, UnitPrice, D.IsAvailable FROM Menu M
INNER JOIN MenuDishes MD on M.MenuID = MD.MenuID
INNER JOIN Dishes D on D.DishID = MD.DishID
WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate


DROP VIEW IF EXISTS UpcomingReservations
GO
CREATE VIEW UpcomingReservations
AS
SELECT ReservationID, Reservations.CustomerID, (CASE WHEN Customers.IsCompany = 1 THEN CompanyCustomers.ContactPersonName ELSE IndividualCustomers.FirstName + ' ' +IndividualCustomers.LastName END) AS ContactName, RealizationDateStart, RealizationDateEnd, NumberOfPeople, TableID, IsByPerson from Reservations
INNER JOIN Customers ON Customers.CustomerID = Reservations.CustomerID
INNER JOIN CompanyCustomers ON Customers.CustomerID = CompanyCustomers.CustomerID
INNER JOIN IndividualCustomers ON IndividualCustomers.CustomerID = Customers.CustomerID
WHERE IsCancelled = 0 AND RealizationDateStart >= GETDATE()

DROP VIEW IF EXISTS MonthReservationsReport
GO
CREATE VIEW MonthReservationsReport
AS
SELECT ReservationID, Reservations.CustomerID, (CASE WHEN Customers.IsCompany = 1 THEN CompanyCustomers.ContactPersonName ELSE IndividualCustomers.FirstName + ' ' +IndividualCustomers.LastName END) AS ContactName, RealizationDateStart, RealizationDateEnd, NumberOfPeople, TableID, IsByPerson from Reservations
INNER JOIN Customers ON Customers.CustomerID = Reservations.CustomerID
INNER JOIN CompanyCustomers ON Customers.CustomerID = CompanyCustomers.CustomerID
INNER JOIN IndividualCustomers ON IndividualCustomers.CustomerID = Customers.CustomerID
WHERE MONTH(RealizationDateStart) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(RealizationDateStart)
GO

DROP VIEW IF EXISTS WeekReservationsReport
GO
CREATE VIEW WeekReservationsReport
AS
SELECT ReservationID, Reservations.CustomerID, (CASE WHEN Customers.IsCompany = 1 THEN CompanyCustomers.ContactPersonName ELSE IndividualCustomers.FirstName + ' ' +IndividualCustomers.LastName END) AS ContactName, RealizationDateStart, RealizationDateEnd, NumberOfPeople, TableID, IsByPerson from Reservations
INNER JOIN Customers ON Customers.CustomerID = Reservations.CustomerID
INNER JOIN CompanyCustomers ON Customers.CustomerID = CompanyCustomers.CustomerID
INNER JOIN IndividualCustomers ON IndividualCustomers.CustomerID = Customers.CustomerID
WHERE DATEPART(WEEK,RealizationDateStart) = DATEPART(WEEK,GETDATE()) AND YEAR(GETDATE()) = YEAR(RealizationDateStart) AND MONTH(RealizationDateStart) = MONTH(GETDATE())
GO

DROP VIEW IF EXISTS MonthDiscountsReport
GO
CREATE VIEW MonthDiscountsReport
AS
SELECT DiscountID, Value, Customers.CustomerID, (CASE WHEN Customers.IsCompany = 1 THEN CompanyCustomers.CompanyName ELSE IndividualCustomers.FirstName + ' ' +IndividualCustomers.LastName END) AS CustomerName, IssueDate, DueDate, IsOneTime, IsAvailable FROM Discounts
INNER JOIN Customers ON Customers.CustomerID = Discounts.CustomerID
INNER JOIN CompanyCustomers ON Customers.CustomerID = CompanyCustomers.CustomerID
INNER JOIN IndividualCustomers ON IndividualCustomers.CustomerID = Customers.CustomerID
WHERE MONTH(IssueDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(IssueDate)
GO

DROP VIEW IF EXISTS WeekDiscountsReport
GO
CREATE VIEW WeekDiscountsReport
AS
SELECT DiscountID, Value, Customers.CustomerID, (CASE WHEN Customers.IsCompany = 1 THEN CompanyCustomers.CompanyName ELSE IndividualCustomers.FirstName + ' ' +IndividualCustomers.LastName END) AS CustomerName, IssueDate, DueDate, IsOneTime, IsAvailable FROM Discounts
INNER JOIN Customers ON Customers.CustomerID = Discounts.CustomerID
INNER JOIN CompanyCustomers ON Customers.CustomerID = CompanyCustomers.CustomerID
INNER JOIN IndividualCustomers ON IndividualCustomers.CustomerID = Customers.CustomerID
WHERE DATEPART(WEEK,IssueDate) = DATEPART(WEEK,GETDATE()) AND MONTH(IssueDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(IssueDate)
GO

DROP VIEW IF EXISTS MonthMenuReport
GO
CREATE VIEW MonthMenuReport
AS
SELECT M.MenuID, ArrangementDate, StartDate, EndDate, DishName, UnitPrice, MD.IsAvailable
    FROM Menu M
    INNER JOIN MenuDishes MD ON M.MenuID = MD.MenuID
    INNER JOIN Dishes D ON D.DishID = MD.DishID
    WHERE MONTH(StartDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(StartDate)
GO

DROP VIEW IF EXISTS WeekMenuReport
GO
CREATE VIEW WeekMenuReport
AS
SELECT M.MenuID, ArrangementDate, StartDate, EndDate, DishName, UnitPrice, MD.IsAvailable
    FROM Menu M
    INNER JOIN MenuDishes MD ON M.MenuID = MD.MenuID
    INNER JOIN Dishes D ON D.DishID = MD.DishID
    WHERE  DATEPART(WEEK,StartDate) = DATEPART(WEEK,GETDATE()) AND MONTH(StartDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(StartDate)
GO

DROP VIEW IF EXISTS MonthOrderReport
GO
CREATE VIEW MonthOrderReport
AS
SELECT Orders.OrderID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - ISNULL(Discounts.Value, 0))) AS TotalPrice FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
LEFT JOIN OrderDiscounts ON Orders.OrderID = OrderDiscounts.OrderID
LEFT JOIN Discounts ON OrderDiscounts.DiscountID = Discounts.DiscountID
WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(OrderDate)
GROUP BY Orders.OrderID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway;
GO

DROP VIEW IF EXISTS WeekOrderReport
GO
CREATE VIEW WeekOrderReport
AS
SELECT Orders.OrderID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - ISNULL(Discounts.Value, 0))) AS TotalPrice FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
LEFT JOIN OrderDiscounts ON Orders.OrderID = OrderDiscounts.OrderID
LEFT JOIN Discounts ON OrderDiscounts.DiscountID = Discounts.DiscountID
WHERE DATEPART(WEEK,OrderDate) = DATEPART(WEEK,GETDATE()) AND MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(GETDATE()) = YEAR(OrderDate)
GROUP BY Orders.OrderID, OrderDate, RequiredRealisationDate, PickUpDate, IsTakeAway;
GO

DROP VIEW IF EXISTS OccupiedTablesNow
GO
CREATE VIEW OccupiedTablesNow
AS
SELECT T.TableID, T.MaxCapacity, T.CurrentCapacity FROM Tables T
INNER JOIN Reservations R ON T.TableID = R.TableID
WHERE RealizationDateStart <= GETDATE() AND GETDATE() <= RealizationDateEnd


DROP VIEW IF EXISTS FreeTablesNow
GO
CREATE VIEW FreeTablesNow
AS
SELECT T.TableID, T.MaxCapacity, T.CurrentCapacity FROM Tables T
LEFT JOIN Reservations R ON T.TableID = R.TableID
WHERE RealizationDateStart > GETDATE() OR RealizationDateEnd < GETDATE() OR RealizationDateStart IS NULL


DROP VIEW IF EXISTS UnavailableProducts
GO
CREATE VIEW UnavailableProducts
AS
SELECT * FROM Products
WHERE UnitsInStock = 0


DROP VIEW IF EXISTS ExhaustingProducts
GO
CREATE VIEW ExhaustingProducts
AS
SELECT * FROM Products
WHERE UnitsInStock < 10
