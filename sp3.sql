
-- SP3 FireEmployee and update the coresponding information
CREATE PROCEDURE dbo.FireEmployee( @EmployeeId AS VARCHAR(10)) AS
	DECLARE @Temp AS VARCHAR(10)

	DECLARE SubordinateCursor CURSOR FOR
			SELECT EmployeeId
				FROM Employees
				WHERE DirectSupervisor = @EmployId

	OPEN SubordinateCursor
	FETCH NEXT FROM SubordinateCursor INTO @Temp

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Sorry, Your boss has to be changed.'
		UPDATE Employees
		   SET DirectSupervisor=
		          (SELECT TOP 1 EmployeeId FROM Employees
			             WHERE JobId = 
						        (SELECT JobId 
								   FROM Employees
								   WHERE EmployeeId=@EmployId
							    )
						   AND EmployeeId <> @EmployId
                  )
			FETCH NEXT FROM MyCursor INTO @temp
	END

	CLOSE MyCursor
	DEALLOCATE MyCursor

    UPDATE Employees 
	   SET EmployeeDescription='Already fired !!!'
	   WHERE EmployeeId = @EmployeeId

    DELETE FROM Crew
	   WEHRE EmployeeId = @EmployeeId

	DELETE FROM CanWork
	   WEHRE EmployeeId = @EmployeeId

    
	
		    

     





		    
		 