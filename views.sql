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
SELECT ReservationID, CustomerID, RealizationDateStart, RealizationDateEnd, NumberOfPeople, TableID, IsByPerson FROM Reservations
WHERE IsCancelled = 0 AND RealizationDateStart >= GETDATE()


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