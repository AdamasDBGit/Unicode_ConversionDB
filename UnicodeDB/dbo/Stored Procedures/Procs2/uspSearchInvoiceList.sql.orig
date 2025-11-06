CREATE PROCEDURE [dbo].[uspSearchInvoiceList]
(
	@iCenterId INT =NULL,
	@sInvoiceId VARCHAR(50)=NULL,
	@sStudentId VARCHAR(500)=NULL,
	@sStudentFirstName VARCHAR(50)=NULL,
	@sStudentSecondName VARCHAR(50)=NULL,
	@sStudentLastName VARCHAR(50)=NULL
)


AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @sStudentName VARCHAR(150)
	DECLARE @sStudentDetailId INT

	SELECT TIP.I_Student_Detail_ID, TIP.I_Invoice_Header_ID, ISNULL(TSD.S_First_Name,''), ISNULL(TSD.S_Middle_Name,'') , ISNULL(TSD.S_Last_Name,''),
	TSD.S_STUDENT_ID, TIP.S_Invoice_No, TIP.Dt_Invoice_Date
	FROM T_INVOICE_PARENT TIP,T_STUDENT_DETAIL TSD, T_STUDENT_CENTER_DETAIL TSCD
	WHERE TSCD.I_Centre_Id = @iCenterId AND
	TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND
	TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND
	TIP.S_Invoice_No LIKE ISNULL(@sInvoiceId,TIP.S_Invoice_No) + '%' AND
	TSD.S_Student_ID LIKE ISNULL(@sStudentId,TSD.S_Student_ID) + '%'  AND
	TSD.S_First_Name LIKE ISNULL(@sStudentFirstName,TSD.S_First_Name) + '%' AND
	TSD.S_Middle_Name LIKE ISNULL(@sStudentSecondName,TSD.S_Middle_Name) + '%' AND
	TSD.S_Last_Name LIKE ISNULL(@sStudentLastName,TSD.S_Last_Name) + '%' AND
	TIP.I_STATUS = 1
	ORDER BY TSD.S_Student_ID

END
