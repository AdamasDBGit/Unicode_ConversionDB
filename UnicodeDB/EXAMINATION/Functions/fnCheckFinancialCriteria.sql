/************************************************************************************/

CREATE FUNCTION [EXAMINATION].[fnCheckFinancialCriteria]
(
	@iStudentID INT,
	@iCenterID INT,
	@iCourseID INT,
	@iTermID INT = NULL,
	@iModuleID INT = NULL,
	@TotalSession INT,
	@iSessionsUptoCurrentTerm INT
)
RETURNS  CHAR(1)

AS 
BEGIN
	DECLARE @cReturn CHAR(1), @nTotalAmount NUMERIC(18,2), @nTotalPayment NUMERIC(18,2)
	SET @cReturn = 'N'
	SET @nTotalAmount = 0.0
	SET @nTotalPayment = 0.0
	
	SELECT @nTotalAmount = @nTotalAmount + TICD.N_Amount_Due FROM dbo.T_Invoice_Child_Detail TICD WITH(NOLOCK)	
	WHERE I_Invoice_Child_Header_ID IN (
											SELECT DISTINCT	TICH.I_Invoice_Child_Header_ID 
											FROM	dbo.T_Invoice_Child_Header TICH WITH(NOLOCK)
											INNER JOIN dbo.T_Invoice_Parent TIP WITH(NOLOCK)
												ON	TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
											WHERE	TICH.I_Course_ID = @iCourseID
													AND TIP.I_Student_Detail_ID = @iStudentID
										)
		
	SELECT @nTotalPayment = @nTotalPayment + TRCD.N_Amount_Paid
	FROM	dbo.T_Receipt_Header TRH WITH(NOLOCK)
		INNER JOIN	dbo.T_Receipt_Component_Detail TRCD WITH(NOLOCK)
				ON	TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
	WHERE I_Invoice_Header_ID IN (
											SELECT DISTINCT	TICH.I_Invoice_Header_ID 
											FROM	dbo.T_Invoice_Child_Header TICH WITH(NOLOCK)
											INNER JOIN dbo.T_Invoice_Parent TIP WITH(NOLOCK)
												ON	TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
											WHERE	TICH.I_Course_ID = @iCourseID
													AND TIP.I_Student_Detail_ID = @iStudentID
										)
			
	IF (@TotalSession > 0 AND @nTotalPayment - (@nTotalAmount * (CAST(@iSessionsUptoCurrentTerm AS NUMERIC(18,2)) / CAST(@TotalSession AS NUMERIC(18,2)))) > -10)
	BEGIN
		SET @cReturn = 'Y'
	END
	ELSE IF (@TotalSession = 0 AND ABS(@nTotalPayment - @nTotalAmount) < 10)
	BEGIN
		SET @cReturn = 'Y'
	END
		
	RETURN @cReturn
END