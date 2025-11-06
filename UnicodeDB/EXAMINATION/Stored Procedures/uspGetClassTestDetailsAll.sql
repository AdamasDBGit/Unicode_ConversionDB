
CREATE PROCEDURE [EXAMINATION].[uspGetClassTestDetailsAll] 
	-- Add the parameters for the stored procedure here
    (
      @iBatchId INT ,
      @iCenterId INT
    )
AS 
    BEGIN 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON ;

                
        SELECT  TCTM.I_ClassTest_ID AS I_Homework_ID ,
                TCTM.S_ClassTest_Name AS S_Homework_Name ,
                TCTM.S_ClassTest_Desc AS S_Homework_Desc ,
                TTM.I_Term_ID,
                TTTM.I_TimeTable_ID AS I_session_ID,
                TTTM.S_Session_Name,
                TCTM.Dt_Submission_Date,
                TCTM.N_Total_Marks
        FROM    EXAMINATION.T_ClassTest_Master TCTM
				INNER JOIN dbo.T_TimeTable_Master TTTM ON TCTM.I_TimeTable_ID = TTTM.I_TimeTable_ID
				INNER JOIN dbo.T_Term_Master TTM ON TTTM.I_Term_ID = TTM.I_Term_ID
        WHERE   TCTM.I_Batch_ID = @iBatchId
                AND TCTM.I_Center_ID = @iCenterId
                AND TCTM.I_Status = 1


    END
