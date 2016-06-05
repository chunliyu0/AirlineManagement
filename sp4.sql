/*
 * CSE.581.M004 SPRING 15.Intro D/Base Mngmt Syst.
 * Created by Chunli Yu [cyu22@syr.edu]
 * Last modification date: 2015-04-18 02:52:59.963
 * SP Application
 */

-- SP1 GetMaintenanceRecordsByPlane:find what maintenances have been done to a certain plane
--DROP PROCEDURE dbo.GetMaintenanceRecordsByPlane;
CREATE PROCEDURE dbo.GetMaintenanceRecordsByPlane (@PlaneId VARCHAR(6)) AS 
		SELECT m.PlaneId,m.MantenancedDate, s.ServiceName,s.ServiceDescription
			FROM  MaintenanceRecords m INNER JOIN Services s
			ON m.WorkBeingDone=s.ServiceId AND m.PlaneId=@PlaneId;
EXEC dbo.GetMaintenanceRecordsByPlane 'N323';

-- SP2 GetMaintenanceRecordsByPlane:
CREATE PROCEDURE dbo.EnrollStudent (@CourseID AS INT, @StudentID AS VARCHAR(20)) AS
	DECLARE @IsEnrolled VARCHAR(20)
	DECLARE @IsFaculty  VARCHAR(20)
	DECLARE @OpenSeats  INT
	DECLARE @ErrorCode  INT
	SELECT  @IsEnrolled=(SELECT StudentId FROM CourseEnrollment 
		                 WHERE CourseId=@CourseID AND StudentId=@StudentID)
	SELECT  @IsFaculty =(SELECT Faculty   FROM Courses2          
	                     WHERE CourseId=@CourseID)
	IF @IsEnrolled IS NOT NULL
		BEGIN 
			PRINT 'The student is already enrolled'
		END
	ELSE 
	    BEGIN
          IF @IsFaculty IS NULL
			PRINT'Cannot enroll until faculty is selected'
          ELSE
		    BEGIN 
			 SELECT @OpenSeats=(SELECT OpenSeats FROM Courses 
			                   WHERE CourseId=@CourseID)
			 IF @OpenSeats>0
				BEGIN
					BEGIN TRAN
						INSERT INTO CourseEnrollment(CourseId, StudentId) 
						     VALUES(@CourseID, @StudentID)
						SELECT @ErrorCode = @@ERROR
						IF(@ErrorCode<>0) GOTO PROBLEM
						UPDATE Courses SET OpenSeats = @OpenSeats-1 WHERE CourseId = @CourseID
						SELECT @ErrorCode = @@ERROR
						IF(@ErrorCode<>0) GOTO PROBLEM
					COMMIT TRAN

					PROBLEM:
						IF(@ErrorCode<>0)
						BEGIN
							PRINT 'Unexpected error occurred!'
							ROLLBACK TRAN
						END
				 END
			  ELSE
					PRINT 'Class is full !!!'			
		    END
		END

-- SP2 BuyTicket: Buy ticket in a specified trip
-- change ticket: 
-- http://stackoverflow.com/questions/22500454/complex-stored-procedure
https://www.youtube.com/watch?v=B9zKi8H_IUs
CREATE PROCEDURE dbo.BuyTicket ( @TicketId AS VARCHAR(11), 
								 @ScheduledFlightId AS VARCHAR(20),
								 @SeatId AS INT,
								 @CheckInTime AS DATETIME,
								 @TripId AS INT,
							 AS
	   
	    DECLARE @EnrolledStudent AS VARCHAR(20)
		DECLARE @AllowedUploadFileType AS VARCHAR(20)
		DECLARE @AllowedUploadFileSizeOfThisType AS INT
	        
		SELECT @EnrolledStudent = (SELECT NtId 
	                                FROM Enrollments
										WHERE NtId=@InputStudentId AND CourseCode = @InputCourseCode)

		SELECT @AllowedUploadFileType=(SELECT AllowedUploadFileType
										FROM Files
											WHERE AllowedUploadFileType=@InputFileType)
		IF @EnrolledStudent IS NULL   
		   BEGIN
				PRINT 'The student didnot enroll this course.'
		   END
		ELSE BEGIN
				IF @AllowedUploadFileType IS NULL
					BEGIN 
						PRINT 'Cannot be uploaded for wrong type.'
					END
				ELSE BEGIN						
						SELECT @AllowedUploadFileSizeOfThisType =(SELECT AllowedUploadFileSizeOfThisType
																	FROM Files
																		WHERE AllowedUploadFileType=@InputFileType)
							
							IF @InputFileSizeInKB > @AllowedUploadFileSizeOfThisType
								BEGIN
									PRINT 'Cannot be uploaded for wrong size.'
								END
							ELSE
								BEGIN
									UPDATE StudentAssignments
										SET  AssignmentGrade=@InputAssignmentGrade
										WHERE  StudentId=@InputStudentId AND AssignmentId=@InputAssignmentId
									PRINT 'Successed Update!'
								END
					END
		 END;			 	 
		    
SELECT * FROM StudentAssignments; 



EXEC dbo.UpdateStudentAssignments  1,'05-DBTimmy',95,3,'WORD',50;



-- End of file.




