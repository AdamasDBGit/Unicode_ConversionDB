CREATE FUNCTION [dbo].[fnGetWaitingStatus]
    (
      @iStudentID INT 
    )
RETURNS INT
AS 
    BEGIN

		DECLARE @stat INT=1
		
		
        IF EXISTS ( SELECT  *
                            FROM    dbo.T_Student_Attendance TSA
                            WHERE   I_Student_Detail_ID = @iStudentID )
                            
                            BEGIN
                            	SET @stat=0
                            END


        RETURN @stat

    END