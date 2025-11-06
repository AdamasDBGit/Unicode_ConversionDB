/*
-- ======================================================================================================================
-- Author:Ujjwal Sinha
-- Create date:22/05/2007 
-- Description:Select combined List from T_Shortlisted_Student,T_Vacanct_Detail,T_Business_Master,T_Employer_detail table 
-- ======================================================================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspValidateStudentEligiblity]
(
	@iStudentdetailid		INT
	
)
AS
	
BEGIN
    DECLARE @DtCourseexpectedenddate	DATETIME
	DECLARE @DtCurrdate			DATETIME
    DECLARE @nWeek                INT
	DECLARE @sReply VARCHAR(1)
	SET @DtCourseexpectedenddate = (SELECT Dt_Course_Expected_End_Date FROM [dbo].T_Student_Course_Detail WHERE I_Student_Detail_ID = @iStudentdetailid )

        SET @DtCurrdate = (SELECT getdate()) 

        SET @nWeek = (SELECT DATEDIFF(week,@DtCurrdate,@DtCourseexpectedenddate)) 

        IF @nWeek <= 6 
          BEGIN
              SET @sReply = 'T'
          END
        ELSE 
          BEGIN
            SET @sReply = 'F'
          END
   
SELECT @sReply   
END
