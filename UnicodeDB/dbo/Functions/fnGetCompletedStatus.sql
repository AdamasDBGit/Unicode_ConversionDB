CREATE FUNCTION [dbo].[fnGetCompletedStatus]
    (
      @iStudentID INT 
    )
RETURNS INT
AS 
    BEGIN

		DECLARE @stat INT=1
		DECLARE @BatchID INT
		
		
		
		SELECT  @BatchID = TSBD.I_Batch_ID
                FROM    dbo.T_Student_Batch_Details TSBD
                        INNER JOIN ( SELECT TSBD.I_Student_ID ,
                                            MIN(TSBD.I_Student_Batch_ID) AS MinBatchID
                                     FROM   dbo.T_Student_Batch_Details TSBD       
                                     WHERE  TSBD.I_Student_ID = @iStudentID
                                     GROUP BY TSBD.I_Student_ID
                                   ) TT ON TT.I_Student_ID = TSBD.I_Student_ID
                                           AND TT.MinBatchID = TSBD.I_Student_Batch_ID
                WHERE   TSBD.I_Student_ID = @iStudentID
                
                
                IF( DATEDIFF(d,
                                      ( SELECT  Dt_BatchStartDate
                                        FROM    dbo.T_Student_Batch_Master
                                        WHERE   I_Batch_ID = @BatchID
                                      ), GETDATE()) < 1095 )
                                      
                                      BEGIN
                                      	SET @stat=0
                                      END


        RETURN @stat

    END