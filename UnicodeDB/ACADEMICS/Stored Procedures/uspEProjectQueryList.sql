/*******************************************************
Description : Get E-Project Query List
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectQueryList] 
(
	@iCourseID int =null,
	@iTermID int=null,
	@iModuleID int=null,
	@iEProjectSpecID int = null,
	@iStudentDetailID int = null,
	@iQueryPostingID int = null
)

AS

BEGIN TRY 	

	IF @iEProjectSpecID IS NOT NULL
	BEGIN
		 SELECT QP.I_Query_Posting_ID,
				QP.I_Student_Detail_ID,
				QP.I_E_Project_Spec_ID,
				QP.S_Query_Dtls,
				QP.Dt_Query_Posting_Date,
				QP.S_Resolution,
				QP.I_Status,
				QP.S_Crtd_By,
				QP.S_Upd_By,
				QP.Dt_Upd_On,
				CNM.I_Centre_ID,
				CNM.S_Center_Code,
				CNM.S_Center_Name,
				EPS.I_Course_ID,
				CM.S_Course_Code,
				CM.S_Course_Name
		   FROM ACADEMICS.T_Query_Posting QP
		   INNER JOIN ACADEMICS.T_E_Project_Spec EPS
		   ON QP.I_E_Project_Spec_ID = EPS.I_E_Project_Spec_ID
		   INNER JOIN dbo.T_Course_Master CM
		   ON EPS.I_Course_ID = CM.I_Course_ID
		   AND CM.I_Status = 1
	       INNER JOIN dbo.T_Student_Center_Detail SCD
		   ON QP.I_Student_Detail_ID = SCD.I_Student_Detail_ID
		   AND SCD.I_Status = 1
		   INNER JOIN dbo.T_Centre_Master CNM
		   ON SCD.I_Centre_ID = CNM.I_Centre_Id
		   AND CNM.I_Status = 1
		   WHERE QP.I_E_Project_Spec_ID=@iEProjectSpecID
		   AND QP.I_Student_Detail_ID = ISNULL(@iStudentDetailID,QP.I_Student_Detail_ID)
		   AND QP.I_Query_Posting_ID = ISNULL(@iQueryPostingID,QP.I_Query_Posting_ID)
		   AND QP.I_Status = 1
	END
	ELSE
	BEGIN
		 SELECT A.I_Query_Posting_ID,
				A.I_Student_Detail_ID,
				A.I_E_Project_Spec_ID,
				A.S_Query_Dtls,
				A.Dt_Query_Posting_Date,
				A.S_Resolution,
				A.I_Status,
				A.S_Crtd_By,
				A.S_Upd_By,
				A.Dt_Upd_On,
				CNM.I_Centre_ID,
				CNM.S_Center_Code,
				CNM.S_Center_Name,
				B.I_Course_ID,
				CM.S_Course_Code,
				CM.S_Course_Name
		   FROM ACADEMICS.T_Query_Posting A
		   INNER JOIN ACADEMICS.T_E_Project_Spec B
		   ON A.I_E_Project_Spec_ID = B.I_E_Project_Spec_ID
		   INNER JOIN dbo.T_Course_Master CM
		   ON B.I_Course_ID = CM.I_Course_ID
		   AND CM.I_Status = 1
	       INNER JOIN ACADEMICS.T_Center_E_Project_Manual CEM
		   ON A.I_Student_Detail_ID = CEM.I_Student_Detail_ID
		   INNER JOIN dbo.T_Centre_Master CNM
		   ON CEM.I_Center_ID = CNM.I_Centre_Id
		   AND CNM.I_Status = 1
		   WHERE B.I_Course_ID=@iCourseID
		   AND B.I_Term_ID=@iTermID
	       AND B.I_Module_ID=@iModuleID
		   AND A.I_Status = 1
		   AND A.I_Student_Detail_ID = ISNULL(@iStudentDetailID,A.I_Student_Detail_ID)
		   AND A.I_Query_Posting_ID = ISNULL(@iQueryPostingID,A.I_Query_Posting_ID)
	END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
