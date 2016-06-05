/*
 * CSE.581.M004 SPRING 15.Intro D/Base Mngmt Syst.
 * Created by Chunli Yu [cyu22@syr.edu]
 * Last modification date: 2015-04-18 02:52:59.963
 * Views Application
 */

--Search the cheapest ticket when we want a trip from JFK after May,2015 
--IF EXISTS(SELECT * FROM SYS.VIEWS WHERE NAME = 'LowestPrice') DROP VIEW LowestPrice
CREATE VIEW LowestPrice AS
	SELECT r.DepartureAirpport,r.ArrivalAirport,p.Price
	FROM dbo.Prices p, dbo.FlightRoutes r,dbo.ScheduledFlights f
	WHERE p.Price=
		(SELECT MIN(p.Price) AS LowestPrice
		    FROM dbo.FlightRoutes r, dbo.ScheduledFlights f, dbo.ScheduledFlightTimes t, dbo.Prices p, dbo.Classes c
					WHERE EXISTS (SELECT t.ScheduledDepartureTime
								  FROM dbo.FlightRoutes r, dbo.ScheduledFlights f, dbo.ScheduledFlightTimes t
								  WHERE r.ArrivalAirport='JFK' 
									AND r.FlightRoutId=f.FlightRouteId
									AND f.ScheduledFlightId=t.ScheduledFlightId
									AND f.AvailableSeats<>0
									AND YEAR(t.ScheduledDepartureTime)=2015
									AND MONTH(t.ScheduledDepartureTime)>=05
						          )
			          AND c.ClassName='economy'
        )
     AND p.ScheduledFlightId = f.ScheduledFlightId
     AND f.FlightRouteId = r.FlightRoutId
--SELECT * FROM LowestPrice


