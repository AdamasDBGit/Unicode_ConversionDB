
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspEditClassTest]
    (
      @iClassTestId INT ,
      @sClassTestName VARCHAR(200) ,
      @sClassTestDesc VARCHAR(2000) ,
      @dSubmissionDate DATETIME = NULL ,
      @sUpdatedBy VARCHAR(50) = NULL ,
      @dUpdatedOn DATETIME = NULL,
      @nTotalMarks DECIMAL(14,1)
    )
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON ;


   
   
        UPDATE  EXAMINATION.T_ClassTest_Master
        SET     S_ClassTest_Name = @sClassTestName ,
                S_ClassTest_Desc = @sClassTestDesc ,
                Dt_Submission_Date = @dSubmissionDate ,
                S_Updt_On = @sUpdatedBy ,
                Dt_Updt_On = @dUpdatedOn,
                N_Total_Marks=@nTotalMarks
        WHERE   I_ClassTest_ID = @iClassTestId
  
		
    END
