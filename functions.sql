DROP FUNCTION IF EXISTS FreeTables
CREATE FUNCTION FreeTables
    (@startDate DATETIME, @endDate DATETIME)
RETURNS @freeTables TABLE
    (
        TableID INT,
        MaxCapacity INT,
        CurrentCapacity INT
    )
AS
BEGIN
    INSERT INTO @freeTables
    SELECT R.TableID, MaxCapacity, CurrentCapacity
    FROM Reservations R INNER JOIN Tables T ON R.TableID = T.TableID
    WHERE RealizationDate >= @startDate AND ReservationDate <= @endDate
    RETURN
END

SELECT * FROM FreeTables('2021-01-27', '2021-02-01')