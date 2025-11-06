CREATE PROCEDURE [dbo].[uspUpdateRegistrationDetail]
(
@iCourseId INT,
@iEnquiryId INT,
@iBatchID INT,
@iReceiptID INT,
@dtFirstFollowUpDate datetime,
@UpdatedBy varchar(20),
@DtUpdatedOn DATETIME,
@iDestCenterID INT,
@iApplicableFeePlanID INT,
@dReferralAmount DECIMAL,
@iEnquiryStatus INT = -1
)
AS

BEGIN TRY
SET NOCOUNT ON;
DECLARE @iEmployeeId INT
DECLARE @iCenterID INT
SELECT @iCenterID = I_Centre_Id FROM dbo.T_Enquiry_Regn_Detail WHERE I_enquiry_Regn_ID = @iEnquiryId

BEGIN TRANSACTION

INSERT INTO dbo.T_Student_Registration_Details (
I_Enquiry_Regn_ID,
I_Batch_ID,
I_Origin_Center_Id,
I_Destination_Center_ID,
I_Fee_Plan_ID,
N_Referral_Amount,
I_Receipt_Header_ID,
I_Status,
Crtd_By,
Crtd_On
) VALUES (
/* I_Enquiry_Regn_ID - int */ @iEnquiryId,
/* I_Batch_ID - int */ @iBatchID,
/* I_Origin_Center_Id - int */ @iCenterID,
/* I_Destination_Center_ID - int */ @iDestCenterID,
@iApplicableFeePlanID,
@dReferralAmount,
/* I_Receipt_Header_ID - int */ @iReceiptID,
/* I_Status - int */ 1,
/* Crtd_By - varchar(50) */ @UpdatedBy,
/* Crtd_On - datetime */ @DtUpdatedOn )

IF EXISTS(SELECT I_Enquiry_Course_ID FROM T_ENQUIRY_COURSE WHERE I_Enquiry_Regn_ID = @iEnquiryId AND I_Course_ID = @iCourseId)
BEGIN
UPDATE T_ENQUIRY_COURSE SET C_Is_Registered = 'Y' WHERE
I_Enquiry_Regn_ID = @iEnquiryId AND I_Course_ID = @iCourseId
END
ELSE
BEGIN
INSERT INTO T_ENQUIRY_COURSE(I_Course_ID,I_Enquiry_Regn_ID,C_Is_Registered)
VALUES
(@iCourseId,@iEnquiryId,'Y')
END

-- Status 2 indicates Registration Open
IF (@iEnquiryStatus = -1 OR @iEnquiryStatus = 0)
BEGIN
UPDATE T_Enquiry_Regn_Detail
SET
I_Enquiry_Status_Code = 2,
S_Upd_By = @UpdatedBy,
Dt_Upd_On = @DtUpdatedOn
where I_Enquiry_Regn_ID = @iEnquiryId
END
ELSE
BEGIN
UPDATE T_Enquiry_Regn_Detail
SET
I_Enquiry_Status_Code = @iEnquiryStatus,
S_Upd_By = @UpdatedBy,
Dt_Upd_On = @DtUpdatedOn
where I_Enquiry_Regn_ID = @iEnquiryId
END

-- Get the Employee Id of the Councellor
SELECT @iEmployeeId = I_Employee_ID FROM dbo.T_Employee_Dtls
WHERE I_Employee_ID = (SELECT I_Reference_ID FROM dbo.T_User_Master WHERE S_Login_ID = @UpdatedBy)

-- Update the first followup information for the registration
INSERT INTO dbo.T_Enquiry_Regn_FollowUp (
I_Enquiry_Regn_ID,
I_Employee_ID,
Dt_Followup_Date,
Dt_Next_Followup_Date,
S_Followup_Remarks)
VALUES
(
@iEnquiryID,
@iEmployeeId,
@DtUpdatedOn,
@dtFirstFollowUpDate,
'First FollowUp after Registration'
)
COMMIT TRANSACTION
END TRY


BEGIN CATCH
--Error occurred:
ROLLBACK TRANSACTION
DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT @ErrMsg = ERROR_MESSAGE(),
@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
