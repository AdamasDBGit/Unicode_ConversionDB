/*******************************************************
Description : Get E-Project Student Query List
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectStudentQueryList] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iStudentDetailID int
)
AS

BEGIN TRY 

	 SELECT A.I_Query_Posting_ID,
		A.S_Query_Dtls,
		A.Dt_Query_Posting_Date,
		A.S_Resolution,
		A.I_Status,
		A.Dt_Upd_On
   FROM ACADEMICS.T_Query_Posting A,
		ACADEMICS.T_E_Project_Group B,
		ACADEMICS.T_Center_E_Project_Manual C
  WHERE A.I_E_Project_Spec_ID=B.I_E_Project_Spec_ID
	AND B.I_E_Project_Group_ID=C.I_E_Project_Group_ID
	AND C.I_Student_Detail_ID=@iStudentDetailID
	AND C.I_Course_ID=@iCourseID
	AND C.I_Term_ID=@iTermID
	AND C.I_Module_ID=@iModuleID
	AND C.I_STATUS <> 2
	AND B.I_Status <> 2
	AND GETDATE() >= ISNULL(B.Dt_Project_Start_Date,GETDATE())
	AND GETDATE() <= ISNULL(B.Dt_Project_End_Date,GETDATE())
	AND (A.I_Status = 0 OR A.I_Status=1)

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
