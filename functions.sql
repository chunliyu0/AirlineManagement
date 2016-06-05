--Get the trip information including ticketId, DepartureAirpport ArrivalAirport,CheckInTime returned as a table
CREATE FUNCTION FnGetTripInformation(@CustomerId INT) 
	RETURNS @TripInformationTable TABLE 
		(
		  CustomerId  VARCHAR(10), 
		  TicketId VARCHAR(11),
		  DepartureAirpport VARCHAR(5),
		  ArrivalAirport VARCHAR(5),
		  CheckInTime DATETIME,
		  TripId INT
		 )
AS 
		
BEGIN 
    DECLARE @TripId VARCHAR(10)

    DECLARE GetTripIdCursor CURSOR FOR
			SELECT TripId
				FROM Trips
					WHERE CustomerId=@CustomerId
	    
	OPEN GetTripIdCursor	    
		
	FETCH NEXT FROM GetTripIdCursor INTO @TripId
	    
	WHILE @@FETCH_STATUS = 0
			BEGIN	
				 INSERT INTO @TripInformationTable (
				                TicketId,
				                CustomerId,								
				                DepartureAirpport,
								ArrivalAirport,
								CheckInTime,
								TripId
								)
			     SELECT DISTINCT Reservations.TicketId,
				        Trips.CustomerId, 
				        FlightRoutes.DepartureAirpport,
						FlightRoutes.ArrivalAirport,
						Tickets.CheckInTime,
						Reservations.TripId			
			     FROM Trips, Reservations,Tickets,Personals,ScheduledFlights,FlightRoutes,Seats
			     WHERE Trips.TripId=@TripId
				   AND Reservations.TripId=@TripId
				   AND Personals.PersonId=@CustomerId
				   AND Tickets.TicketId=Reservations.TicketId
				   AND Tickets.ScheduledFlightId=ScheduledFlights.ScheduledFlightId
				   AND ScheduledFlights.FlightRouteId=FlightRoutes.FlightRoutId

				 FETCH NEXT FROM GetTripIdCursor INTO @TripId
			END
	    
	CLOSE GetTripIdCursor
	DEALLOCATE GetTripIdCursor
	  
	RETURN
END;

drop function FnGetTripInformation

SELECT * FROM FnGetTripInformation('100126789')


