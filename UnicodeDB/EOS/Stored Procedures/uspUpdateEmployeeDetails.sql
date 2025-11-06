CREATE PROCEDURE [EOS].[uspUpdateEmployeeDetails]

(
@iEmployeeID int,
@sTitle varchar(10),
@sFirstName varchar(50) ,
@sMiddleName varchar(50),
@sLastName varchar(50),
@dtDOB datetime,
@sPhoneNumber varchar(20),
@sEmail varchar(100),
@iStatus int,
@sUpdatedBy varchar(20),
@DtUpdatedOn datetime,
@iDocumentID int = NULL,
@iIsInterviewCleared INT = NULL
)
AS
BEGIN

SET NOCOUNT ON;

UPDATE dbo.T_Employee_Dtls

SET S_Title =@sTitle ,
S_First_Name = @sFirstName,
S_Middle_Name = @sMiddleName,
S_Last_Name = @sLastName,
Dt_DOB = @dtDOB,
S_Phone_No = @sPhoneNumber,
S_Email_ID =@sEmail ,
I_Document_ID = ISNULL(@iDocumentID, I_Document_ID),
Is_Interview_Cleared = ISNULL(@iIsInterviewCleared,0),
S_Upd_By =@sUpdatedBy ,
Dt_Crtd_On = @DtUpdatedOn
WHERE I_Employee_ID = @iEmployeeID

UPDATE dbo.T_User_Master
SET S_Title = @sTitle ,
S_First_Name = @sFirstName,
S_Middle_Name = @sMiddleName,
S_Last_Name = @sLastName
WHERE I_Reference_ID = @iEmployeeID
AND S_User_Type NOT IN ('ST','EM')

END
