CREATE PROCEDURE [SelfService].[uspGetStudentOnAccDuePaymentDetails](@DueID INT)
AS
BEGIN TRY

BEGIN TRANSACTION


	select DISTINCT A.*,B.S_Status_Desc,C.S_Receipt_No,D.S_Invoice_Number 
	from SelfService.T_OnAccount_Due A
	inner join T_Status_Master B on B.I_Status_Value=A.OnAccReceiptTypeID
	left join T_Receipt_Header C on A.ReceiptHeaderID=C.I_Receipt_Header_ID and C.I_Status=1
	left join T_Invoice_OnAccount_Details D on C.I_Receipt_Header_ID=D.I_Receipt_Header_ID
	where
	A.StatusID=1 and A.ID=@DueID

	COMMIT TRANSACTION

END TRY
BEGIN CATCH

 --Error occurred:      
        ROLLBACK TRANSACTION    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1) 

    END CATCH




--exec SelfService.uspInsertOnAccPaymentDetailsFromAPI @BrandID=107,@CenterID=1,@StudentID=N'10-0005',@DueID=1,@TransactionNo=N'9b11860ca6dbc9f6b1ba',@TransactionDate='2021-09-07 10:56:58',@TransactionSource=N'Online-SelfService',@TransactionStatus=N'Success',@TransactionMode=N'CC',@Amount=500,@Tax=0,@OnAccReceiptTypeID=62,@RawData=N'{"DueID":1,"StudentID":"10-0005","BrandID":107,"CenterID":1,"TransactionNo":"9b11860ca6dbc9f6b1ba","TransactionDate":"2021-09-07T10:56:58",
--"TransactionStatus":"Success","TransactionSource":"Online-SelfService","TransactionMode":"CC","Amount":500.0,"Tax":0.0,"OnAccReceiptTypeID":62}'
