CREATE PROCEDURE [dbo].[uspInsertCorporateStudentInformation]
(
	@iStudentID INT,	
	@iCenterCorpPlanID INT
)
AS
BEGIN
	INSERT INTO dbo.T_Corp_Student_Invoice_Map (
		I_Student_Detail_ID,
		I_Center_Corp_Plan_ID,
		I_Status
	) VALUES ( 
		/* I_Student_Detail_ID - int */ @iStudentID,
		/* I_Center_Corp_Plan_ID - int */ @iCenterCorpPlanID,
		/* I_Status - int */ 1 ) 
END
