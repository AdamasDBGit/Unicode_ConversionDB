CREATE PROCEDURE [PSCERTIFICATE].[uspAddStudentCertificateRequest] 
(
	@iStudentCertificateID	int,
	@iStudentID				INT,
	--@sStudentName			varchar(50),
	@iExamMarks			    int,
	@sReissReason			varchar(2000),
	@sFilePath			    varchar(2000)=null,
	@iStatus			    int,
	@sStudentFName		    VARCHAR(50),
	@sStudentMName		    VARCHAR(50),
	@sStudentLName		    VARCHAR(50),
    @SCrtdBy				varchar(20),
    @DtCrtdOn 				datetime
	
)
AS
BEGIN TRY
	SET NOCOUNT OFF;
DECLARE @iStudentCertRequestID		int

    
    INSERT INTO [PSCERTIFICATE].T_Student_Certificate_Request
      (
	--I_Student_Cert_Request_ID,
	I_Student_Certificate_ID,	
	S_Student_FName,
	S_Student_MName,
	S_Student_LName,
	I_Exam_Marks,
	S_Reiss_Reason,
	I_Status,	
	S_Crtd_By,
    Dt_Crtd_On
      )
	VALUES
      (
	--@iStudentCertRequestID,
	@iStudentCertificateID,
	@sStudentFName,
	@sStudentMName,
	@sStudentLName,
	@iExamMarks,
	@sReissReason,
    @iStatus,
   	@SCrtdBy,
    @DtCrtdOn
	)

SET @iStudentCertRequestID= SCOPE_IDENTITY()

--SELECT 	@iStudentCertRequestID


INSERT INTO [PSCERTIFICATE].T_File_Upload
      (
	I_Student_Cert_Request_ID,
	S_File_Path,
	S_Crtd_By,
	Dt_Crtd_On
      )
	VALUES
      (
	@iStudentCertRequestID,
	@sFilePath,
   	@SCrtdBy,
    @DtCrtdOn
	)

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
