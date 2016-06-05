
--list the information of employees who have experiences in maintenance
CREATE VIEW EmployeeInformation AS
		SELECT p1.FirstName+','+p1.LastName AS Employee, 
		       p2.FirstName+','+p2.LastName AS Supervisor,
			   j.JobTitle
			FROM dbo.Employees e, dbo.Jobs j, dbo.Personals p1,dbo.Personals p2
				WHERE p1.PersonId=e.EmployeeId
				  AND p2.PersonId=e.DirectSupervisor
				  AND j.JobId=e.JobId
				  AND e.EmployeeId IN 
				    ( SELECT DISTINCT MantenanceMan 
					    FROM MaintenanceRecords
					)