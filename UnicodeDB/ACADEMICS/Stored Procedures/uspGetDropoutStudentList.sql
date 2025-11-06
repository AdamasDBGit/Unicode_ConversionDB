/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 07/05/2007
Description:Gets the list of dropout students
Parameters: CenterId,StudentId/Student Name
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspGetDropoutStudentList] --2, null, null, null, null, 2, 1
(
	@iCenterID int = null,
	@sStudentCode varchar(500) = null,
	@sFirstName varchar(50) = null,
	@sMiddleName varchar(50)= null,
	@sLastName varchar(50) = null,
	@iDropoutTypeID int = null,
	@iFlag int = null
)
AS
BEGIN TRY 

	SET NOCOUNT ON;
    
	BEGIN
		IF @iFlag IS NULL
		BEGIN
			SELECT DISTINCT D.I_Student_Detail_ID,
				   D.I_Dropout_Type_ID,
				   S.S_First_Name,
				   S.S_Middle_Name,
				   S.S_Last_Name, 
				   S.S_Student_ID
			FROM ACADEMICS.T_Dropout_Details D 
			INNER JOIN dbo.T_Student_Detail S  WITH (NOLOCK) 
			ON D.I_Student_Detail_ID = S.I_Student_Detail_ID
			AND D.I_Dropout_Type_ID = @iDropoutTypeID
			AND D.I_Dropout_Status <> 0
			WHERE S.S_First_Name LIKE ISNULL(@sFirstName,'') + '%' 
			AND	ISNULL(S.S_Middle_Name,'') LIKE ISNULL(@sMiddleName,'') + '%' 
			AND	S.S_Last_Name LIKE ISNULL(@sLastName,'') + '%' 
			AND S.S_Student_ID LIKE ISNULL(@sStudentCode,'') + '%'
		END
		ELSE
		--whether student is dropout
		BEGIN
			SELECT DISTINCT D.I_Student_Detail_ID,
				   D.I_Dropout_Type_ID,
				   S.S_First_Name,
				   S.S_Middle_Name,
				   S.S_Last_Name, 
				   S.S_Student_ID
			FROM ACADEMICS.T_Dropout_Details D 
			INNER JOIN dbo.T_Student_Detail S  WITH (NOLOCK) 
			ON D.I_Student_Detail_ID = S.I_Student_Detail_ID
			AND D.I_Dropout_Type_ID = ISNULL(@iDropoutTypeID,D.I_Dropout_Type_ID)
			AND D.I_Dropout_Status <> 0
			AND D.I_Center_Id = @iCenterID
			WHERE S.S_First_Name LIKE ISNULL(@sFirstName,'') + '%' 
			AND	ISNULL(S.S_Middle_Name,'') LIKE ISNULL(@sMiddleName,'') + '%' 
			AND	S.S_Last_Name LIKE ISNULL(@sLastName,'') + '%' 
			AND S.S_Student_ID LIKE ISNULL(@sStudentCode,'') + '%'
		END
	END
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
