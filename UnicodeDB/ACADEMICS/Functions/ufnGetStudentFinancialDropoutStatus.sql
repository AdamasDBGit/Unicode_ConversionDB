CREATE FUNCTION [ACADEMICS].[ufnGetStudentFinancialDropoutStatus] 
(
	@iStudentID int,
	@iCenterID int,
	@iAllowedNumberOfNonPaymentDays int,
	@dCurrenDate datetime
)
RETURNS  CHAR(1)

AS 
-- Returns the Student Status whether ACTIVE, ON LEAVE or DROPOUT.
BEGIN

DECLARE @cDropoutStatus CHAR(1)
DECLARE @dDateCompare DATETIME
DECLARE @dLastInstallmentDate DATETIME
DECLARE @dActualLastInstallmentDate DATETIME
DECLARE @iDayCount INT
DECLARE @iInvoiceHeaderID INT
DECLARE @iActualNumberofNonPaymentDays int

SET @cDropoutStatus = 'N'

		IF EXISTS(
			SELECT I_Student_Detail_ID
			FROM ACADEMICS.T_Dropout_Details
			WHERE I_Student_Detail_ID = @iStudentID
			AND I_Dropout_Status = 1
			AND I_Dropout_Type_ID = 2
		 )
		BEGIN
			SET @cDropoutStatus = 'Y'
		END

    RETURN @cDropoutStatus
END