CREATE FUNCTION [dbo].[fnCheckReceiptValidity]
(
@iStudentDetailID INT = NULL,
@iCentreID INT = NULL,
@iEnqRegnDtlID INT = NULL,
@iAmount Numeric(15,2)
)
RETURNS BIT

AS
BEGIN

DECLARE @bResult BIT
DECLARE @iDiffInMinute INT
DECLARE @DtLastCreationTime DATETIME

IF @iStudentDetailID IS NOT NULL
BEGIN
SELECT @DtLastCreationTime=ISNULL(max(Dt_Receipt_Date),'1/1/2002') FROM T_Receipt_Header WITH (NOLOCK)
WHERE I_Student_Detail_ID=@iStudentDetailID and CAST(N_Receipt_Amount AS Numeric(18,0)) = CAST(@iAmount AS Numeric(18,0))

SELECT @iDiffInMinute=DATEDIFF(n,@DtLastCreationTime,GETDATE())
IF @iDiffInMinute > 5
BEGIN
SET @bResult=1
END
ELSE
BEGIN
SET @bResult=0
END

END
ELSE
BEGIN
SELECT @DtLastCreationTime=ISNULL(max(Dt_Receipt_Date),'1/1/2002') FROM T_Receipt_Header WITH (NOLOCK)
WHERE I_Enquiry_Regn_ID=@iEnqRegnDtlID and I_Centre_Id=@iCentreID  and CAST(N_Receipt_Amount AS NUMERIC(18,0)) = CAST(@iAmount AS Numeric(18,0))

SELECT @iDiffInMinute=DATEDIFF(n,@DtLastCreationTime,GETDATE())
IF @iDiffInMinute > 5
BEGIN
SET @bResult=1
END
ELSE
BEGIN
SET @bResult=0
END

END

--RETURN @bResult
--this function is commented as in case user is creating two seperate registrations in different courses which has same
--registration fees it stops the user from doing so.
RETURN 1

END