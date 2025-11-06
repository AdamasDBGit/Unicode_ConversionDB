CREATE PROCEDURE [DOCUMENT].[uspModifyUserDocuments]
(
	-- Add the parameters for the stored procedure here
	@iDocumentID INT,
	@sFileName VARCHAR(250),
	@sFilePath VARCHAR(250),
	@iFileSize INT,
	@iStatus INT,
	@dtExpDate DATETIME,
	@sUpdateBy VARCHAR(50),
	@dtUpdateOn DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Update statements for procedure here
	
		UPDATE DOCUMENT.T_User_Documents
		SET S_File_Name = @sFileName,
		S_File_Path = @sFilePath,
		I_File_Size = @iFileSize,
		Dt_Expiry_Date = @dtExpDate,
		I_Status = @iStatus,
		S_UpdatedBy = @sUpdateBy,
		Dt_UpadtedOn = @dtUpdateOn
		where I_Document_ID = @iDocumentID
	
END
