SELECT * FROM FreeTables('2021-01-27', '2021-02-01')

SELECT * FROM CustomerDiscounts(4)

SELECT dbo.CustomerOrdersNumberForValue(4, 20.0) AS OrdersNumber

SELECT dbo.CustomerOrdersNumber(4)

SELECT dbo.CustomerOrderWorth(4) AS OrdersWorth

SELECT dbo.CustomerMonthOrdersNumber(4, 1, 2021)

SELECT dbo.CustomerQuarterWorth(4, 1)

SELECT dbo.CustomerHasNOrdersOfGivenValue(4, 1, 10)

SELECT dbo.CustomerMonthOrdersNumberOfGivenValue(4, 10, '2021-01-20')

SELECT * FROM ReservationReport('2021-01-17', '2021-03-15')

SELECT * FROM MenuReport('2021-01-15', '2021-02-01')

SELECT * FROM DiscountReport('2021-01-15', '2021-02-01')

SELECT * FROM CustomerOrders(4)

SELECT * FROM MonthDishes(1, 11, 2020)

SELECT dbo.CanMakeReservation(4, 25, 15, 2, 26)
SELECT dbo.CanMakeReservation(4, 25, 15, 1, 26)

SELECT * FROM GenerateInvoice(1, 'Restaurant', 'Address')

SELECT * FROM GenerateCollectiveInvoice(4, 'Restaurant', 'Address', 1, 2021)