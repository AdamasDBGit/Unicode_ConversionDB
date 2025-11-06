
-------------------------------------------------------------------------------------------
--Issue No 246
-------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[uspInsertReleaseProductNote]
(
@iBrandID int = null ,
@iCourseFamilyID int = null ,
@sCourseCode varchar(20)= null ,
@sCourseName varchar(250) = null ,
@sCourseFamilyName varchar(50) = null,
@sCourseDescription varchar(500) = null,
@sCreatedBy varchar(20)= null ,
@dCreatedOn datetime = null ,
@iIsNewCourse int = null ,
@sDocumentName varchar(1000),
@sDocumentType varchar(50),
@sDocumentPath varchar(5000),
@sDocumentURL varchar(5000),
@sLanguageID INT=NULL, --added by susmita on 30-07-2022 for language
@sLanguageName varchar(200)=NULL --added by susmita on 30-07-2022 for language 
)

AS
BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
DECLARE @iUploadDocID int
DECLARE @iCourseID int
SET @iUploadDocID = 0


IF @iBrandID = 109
BEGIN
Set @sLanguageID=2
set @sLanguageName='Bengali & English'
END

BEGIN TRAN T1
INSERT INTO dbo.T_Upload_Document(S_Document_Name, S_Document_Type, S_Document_Path, S_Document_URL,I_Status, S_Crtd_By, Dt_Crtd_On)
VALUES(@sDocumentName, @sDocumentType, @sDocumentPath, @sDocumentURL,1, @sCreatedBy, @dCreatedOn)

SELECT @iUploadDocID = @@IDENTITY

COMMIT TRAN T1


IF @iIsNewCourse = 1
BEGIN
DECLARE @CourseFamilyID int
BEGIN TRAN T2
INSERT INTO T_CourseFamily_Master (I_Brand_ID,
S_CourseFamily_Name,S_Crtd_By,Dt_Crtd_On,I_Status)
VALUES(@iBrandID,@sCourseFamilyName,@sCreatedBy,@dCreatedOn,1)

SELECT @CourseFamilyID=@@IDENTITY

COMMIT TRAN T2

BEGIN TRAN T3

INSERT INTO T_Course_Master
( I_CourseFamily_ID,
I_Brand_ID,
S_Course_Code,
S_Course_Name,
S_Course_Desc,
S_Crtd_By,
Dt_Crtd_On,
I_Is_Editable,
I_Status,
I_Document_ID,
I_Language_ID, --added by susmita on 30-07-2022 for language
I_Language_Name) --added by susmita on 30-07-2022 for language
VALUES
( @CourseFamilyID,
@iBrandID,
@sCourseCode,
@sCourseName,
@sCourseDescription,
@sCreatedBy,
@dCreatedOn,
1,
1,
@iUploadDocID,
@sLanguageID, --added by susmita on 30-07-2022 for language
@sLanguageName ) --added by susmita on 30-07-2022 for language

SELECT @iCourseID = @@IDENTITY

COMMIT TRAN T3
END
ELSE
BEGIN

BEGIN TRAN T4

INSERT INTO T_Course_Master
( I_CourseFamily_ID,
I_Brand_ID,
S_Course_Code,
S_Course_Name,
S_Course_Desc,
S_Crtd_By,
Dt_Crtd_On,
I_Is_Editable,
I_Status,
I_Document_ID,
I_Language_ID, --added by susmita on 30-07-2022 for language
I_Language_Name) --added by susmita on 30-07-2022 for language
VALUES
( @iCourseFamilyID,
@iBrandID,
@sCourseCode,
@sCourseName,
@sCourseDescription,
@sCreatedBy,
@dCreatedOn,
1,
1,
@iUploadDocID ,
@sLanguageID, --added by susmita on 30-07-2022 for language
@sLanguageName ) --added by susmita on 30-07-2022 for language

SELECT @iCourseID = @@IDENTITY

COMMIT TRAN T4

SELECT @iCourseID CourseID
END
END TRY
BEGIN CATCH
--Error occurred:

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT @ErrMsg = ERROR_MESSAGE(),
@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
