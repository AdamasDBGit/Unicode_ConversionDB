/*******************************************************
Description : Gets the list of Group Details
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectGroupDetails] 
(
	@iEProjectGroupID int
)

AS
BEGIN TRY 

	-- getting records for Table [0]
	 SELECT EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc,
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date,
			EPG.Dt_Cancellation_Date,
			EPG.S_Cancellation_Reason,
			EPG.I_Status,
			EPG.I_E_Project_Spec_ID,
			EPG.I_Is_File_Submitted_Externally,
			EPG.S_Ext_E_Project_File_Name,
			EPG.S_Ext_Report_File_Name,
			EPG.S_Remarks,
			EPE.Dt_New_End_Date,
			EPE.S_Reason,
			EPS.S_Description,
			EPS.I_File_ID AS SpecFileID,
			UD1.S_Document_Name AS SpecFileName,
			UD1.S_Document_Path AS SpecFilePath,
			UD1.S_Document_Type AS SpecFileType,
			UD1.S_Document_URL AS SpecFileURL,
			UD1.I_Status AS SpecFileStatus,
			EPG.I_Report_File_ID  AS ReportFileID,
			UD2.S_Document_Name AS ReportFileName,
			UD2.S_Document_Path AS ReportFilePath,
			UD2.S_Document_Type AS ReportFileType,
			UD2.S_Document_URL AS ReportFileURL,
			UD2.I_Status AS ReportFileStatus,
			EPG.I_E_Project_File_ID AS ProjectFileID,
			UD3.S_Document_Name AS ProjectFileName,
			UD3.S_Document_Path AS ProjectFilePath,
			UD3.S_Document_Type AS ProjectFileType,
			UD3.S_Document_URL AS ProjectFileURL,
			UD3.I_Status AS ProjectFileStatus
	FROM ACADEMICS.T_E_Project_Group EPG
	INNER JOIN ACADEMICS.T_E_Project_Spec EPS WITH(NOLOCK)
	ON EPS.I_E_Project_Spec_ID = EPG.I_E_Project_Spec_ID
	LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE WITH(NOLOCK)
	ON EPE.I_E_Project_Group_ID = EPG.I_E_Project_Group_ID
	AND EPE.I_Status =1
	LEFT OUTER JOIN dbo.T_Upload_Document UD1 WITH(NOLOCK)
	ON EPS.I_File_ID = UD1.I_Document_ID
	AND UD1.I_Status = 1
	LEFT OUTER JOIN dbo.T_Upload_Document UD2 WITH(NOLOCK)
	ON EPG.I_Report_File_ID = UD2.I_Document_ID
	AND UD2.I_Status = 1 
	LEFT OUTER JOIN dbo.T_Upload_Document UD3 WITH(NOLOCK)
	ON EPG.I_E_Project_File_ID = UD3.I_Document_ID
	AND UD3.I_Status = 1
	WHERE EPG.I_E_Project_Group_ID = @iEProjectGroupID
	AND EPG.I_Status <> 3  
 
	-- getting records for Table[1]
	SELECT CEM.I_Center_E_Proj_ID,
		   CEM.I_Student_Detail_ID,
		   CEM.I_E_Proj_Manual_Number,
		   CEM.Dt_Cancellation_Date,
		   CEM.S_Cancellation_Reason,
		   CEM.N_Marks,
		   SD.S_Student_ID,
		   SD.S_Title,
		   SD.S_First_Name,
		   SD.S_Middle_Name,
		   SD.S_Last_Name,
		   SD.S_Email_ID,
		   EPE.Dt_New_End_Date,
		   EPE.S_Reason
	FROM ACADEMICS.T_Center_E_Project_Manual CEM
	INNER JOIN dbo.T_Student_Detail SD WITH(NOLOCK)
	ON SD.I_Student_Detail_ID = CEM.I_Student_Detail_ID
	AND SD.I_Status = 1
	LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE WITH(NOLOCK)
	ON EPE.I_E_Project_Group_ID = CEM.I_E_Project_Group_ID
	AND EPE.I_Status =1  
	WHERE CEM.I_E_Project_Group_ID = @iEProjectGroupID
	AND CEM.I_Status <> 3  

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
