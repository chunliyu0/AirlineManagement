-- SP2 RefundTicket:Refund a ticket based on the date
CREATE PROCEDURE dbo.RefundTicket(@TicketId AS INT) AS
	DECLARE @ErrorOccured AS BIT
	SET @ErrorOccured = 0

	BEGIN TRAN
	
	DECLARE @CheckInTime AS DATETIME
	DECLARE @TicketPaid AS DECIMAL(10,2)
	DECLARE @FeeTypeId AS INT
	DECLARE @TicketRefund AS DECIMAL(10,2)
	DECLARE @TicketRefundRatio AS DECIMAL(10,2)

	SELECT @CheckInTime = CheckInTime
		FROM Tickets
		WHERE TicketId = @TicketId
	SELECT @TicketPaid = SUM(Costs.CostDollars)
		FROM Costs
		WHERE TicketId = @TicketId
	SELECT @FeeTypeId = FeeTypeId
		FROM FeeTypes
		WHERE FeeTypeName = 'Refund'

	IF @CheckInTime < GETEDATE()
		BEGIN
			PRINT 'Sorry, You cannot be refunded.'
			SET @ErrorOccured = 1
		END
	ELSE IF DATEDIFF(MINUTE, GETEDATE(), @CheckInTime)/60.0>24
		BEGIN
			PRINT '10% Service Charge Required!'
			SELECT @TicketRefundRatio=0.9		
		END
	ELSE IF DATEDIFF(MINUTE, GETEDATE(), @CheckInTime)/60.0>2
		BEGIN
			PRINT '30% Service Charge Required!'
			SELECT @TicketRefundRatio=0.7	
		END
	ELSE
		BEGIN
		    PRINT '50% Service Charge Required!'
		    SELECT @TicketRefundRatio=0.7
		END

	IF @TicketPaid > 0	
	    BEGIN
            SELECT @TicketRefund= -@TicketRefundRatio*@TicketPaid
	        INSERT INTO Costs (FeeTypeId,TicketId,CostDollars)
				   VALUES (@FeeTypeId,@TicketId,@TicketRefund)
            INSERT INTO Reservations (ReservationDescription)
				   VALUES ('Ticket Refunded.')
    
	        DECLARE @ScheduledFlightId AS INT
	        SELECT @ScheduledFlightId = ScheduledFlightId
		           FROM Tickets
		           WHERE TicketId = @TicketId

	        PRINT 'Update Available Seats'
            UPDATE ScheduledFlights
				   SET AvailableSeats = @AvailableSeats + 1
				   WHERE ScheduledFlightId = @ScheduledFlightId

	        PRINT 'Congratuation! Ticket Refunded Successfully. '

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
