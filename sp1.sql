-- SP1 ReserveTicket:Reserve a ticket of a desired scheduled flight
CREATE PROCEDURE dbo.ReserveTicket(@ScheduledFlightId AS INT,@SetId INT,@TripId AS INT) AS
	DECLARE @ErrorOccured AS BIT
	SET @ErrorOccured = 0

	BEGIN TRAN
	DECLARE @AvailableSeats AS INT
	DECLARE @TicketReserved AS VARCHAR(11)
	DECLARE @TicketId AS VARCHAR(11)

	SELECT @AvailableSeats = AvailableSeats
		FROM ScheduledFlights
		WHERE ScheduledFlightId = @ScheduledFlightId
	SELECT @TicketReserved = TicketId
		FROM Reservations
		WHERE SeatId = @SeatId
		  AND SeatId IS NOT NULL

	IF @AvailableSeats = 0
		BEGIN
			PRINT 'Sorry, the tickets have sold out.'
			SET @ErrorOccured = 1
		END
	ELSE IF @TicketReserved IS NOT NULL
		BEGIN
			PRINT 'The seat has been reserved!'
			SET @errorOccured = 1
		END
	ELSE
		BEGIN
		    SELECT @TicketId = 
			 (SELECT TOP 1 TicketId FROM Tickets
			    WHERE ScheduledFlightId = @ScheduledFlightId
				  AND TicketId NOT IN (
				      SELECT TicketId FROM Reservations
					      WHERE ScheduledFlightId = @ScheduledFlightId
	                                  )
              )
			INSERT INTO Reservations (TicketId, SetId, TripId)
				VALUES (@TicketId, @SetId, @TripId)
			PRINT 'Congratuation! Ticket Reserved Successfully. '

			BEGIN
				PRINT 'Update Available Seats'
                UPDATE ScheduledFlights
					SET AvailableSeats = @AvailableSeats - 1
					WHERE ScheduledFlightId = @ScheduledFlightId
				END
		END

	IF @errorOccured = 1
		BEGIN
			PRINT 'Rollback'
			ROLLBACK TRAN
		END
	ELSE
		BEGIN
			PRINT 'Commit'
			COMMIT TRAN
		END;
