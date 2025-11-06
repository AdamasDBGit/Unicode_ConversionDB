
CREATE PROCEDURE [dbo].[uspCancelInvoice]
    (
      @iInvoiceId INT ,
      @sUpdatedBy Nnvarchar(max) ,
      @iCancellationReasonId INT = NULL ,
	  @sCancellationRemarks Nnvarchar(max)=NULL
    )
AS
    BEGIN TRY      
        SET NOCOUNT ON;      
        DECLARE @iStudentDetailID INT  
		DECLARE @iBatchID INT
       
        BEGIN TRANSACTION      
 --exec [dbo].[uspInsertReceiptArchive] @iInvoiceId
 
 --SET THE STATUS IN THE TABLE T_INVOICE_PARENT      
        UPDATE  T_Invoice_Parent
        SET     I_Status = 0 ,
                S_Upd_By = @sUpdatedBy ,
                Dt_Upd_On = GETDATE() ,
                S_Cancel_Type = 1,
				S_Narration=@sCancellationRemarks
        WHERE   I_Invoice_Header_ID = @iInvoiceId 
 
        EXEC uspInsertCreditNoteForInvoice @iInvoiceId
       
 -- delete the courses for the invoice      
        SELECT  @iStudentDetailID = I_Student_Detail_ID
        FROM    T_Invoice_Parent
        WHERE   I_Invoice_Header_ID = @iInvoiceId 


		SELECT  @iBatchID=TIBM.I_Batch_ID
                        FROM    dbo.T_Invoice_Batch_Map AS TIBM
                                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        WHERE   TICH.I_Invoice_Header_ID = @iInvoiceId and TIBM.I_Status=1


		EXEC [LMS].[uspInsertStudentBatchDetailsForInterface] @iStudentDetailID,@iBatchID,'DELETE',NULL
 
 --akash 2.8.2018
        IF ( @iCancellationReasonId <> 2)
            BEGIN
 
 --akash 2.8.2018


				
      
                UPDATE  dbo.T_Student_Batch_Details
                SET     I_Status = 0 ,
                        Dt_Valid_To = GETDATE()
                WHERE   I_Batch_ID IN (
                        SELECT  TIBM.I_Batch_ID
                        FROM    dbo.T_Invoice_Batch_Map AS TIBM
                                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        WHERE   TICH.I_Invoice_Header_ID = @iInvoiceId )
                        AND I_Student_ID = @iStudentDetailID 


				
 
 --akash 2.8.2018
 
            END 

			
 
 --akash 2.8.2018
   
  -- only the courses which are not completed (During migration old course gets completed)      
       
        DELETE  FROM T_Student_Term_Detail
        WHERE   I_Student_Detail_ID = @iStudentDetailID
                AND I_Course_ID IN (
                SELECT  I_Course_ID
                FROM    T_Student_Course_Detail
                WHERE   I_Student_Detail_ID = @iStudentDetailID
                        AND I_Status = 0 )      
       
        DELETE  FROM T_Student_Module_Detail
        WHERE   I_Student_Detail_ID = @iStudentDetailID
                AND I_Course_ID IN (
                SELECT  I_Course_ID
                FROM    T_Student_Course_Detail
                WHERE   I_Student_Detail_ID = @iStudentDetailID
                        AND I_Status = 0 )      
       
 --Commented by Soumya on 29-Aug-08 as no child will deleted for FT purpose      
 --DELETE ASOOCIATED RECORDS FROM T_RECEIPT_TAX_DETAIL      
 --DELETE FROM T_RECEIPT_TAX_DETAIL WHERE I_Receipt_Comp_Detail_ID IN       
 --(SELECT I_Receipt_Comp_Detail_ID FROM T_RECEIPT_COMPONENT_DETAIL WHERE I_Receipt_Detail_ID IN       
 --(SELECT I_Receipt_Header_ID FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId AND I_Status <> 0))      
       
 --DELETE ASOOCIATED RECORDS FROM T_RECEIPT_COMPONENT_DETAIL      
 --DELETE FROM T_RECEIPT_COMPONENT_DETAIL WHERE I_Receipt_Detail_ID IN       
 --(SELECT I_Receipt_Header_ID FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId AND I_Status <> 0)      
       
     
        UPDATE  dbo.T_Invoice_Batch_Map
        SET     I_Status = 0 ,
                S_Updt_By = @sUpdatedBy ,
                Dt_Updt_On = GETDATE()
        WHERE   I_Invoice_Child_Header_ID IN (
                SELECT  I_Invoice_Child_Header_ID
                FROM    dbo.T_Invoice_Child_Header AS tich
                WHERE   I_Invoice_Header_ID = @iInvoiceId
                        AND I_Status <> 0 ) 
                        
                        
        EXEC SMManagement.uspCancelStudentEligibilitySchedule @StudentDetailID = @iStudentDetailID, -- int
            @InvoiceID = @iInvoiceId, -- int
            @UpdatedBy = @sUpdatedBy -- nvarchar(max)
                           
      
        IF ( @iCancellationReasonId IS NOT NULL )
            BEGIN  
                INSERT  INTO T_Student_Invoice_History
                        ( I_Invoice_Header_ID ,
                          I_Student_Detail_ID ,
                          I_Cancellation_Reason_ID ,
                          I_Status ,
                          S_Crtd_By ,
                          Dt_Crtd_On   
                        )
                VALUES  ( @iInvoiceId ,
                          @iStudentDetailID ,
                          @iCancellationReasonId ,
                          1 ,
                          @sUpdatedBy ,
                          GETDATE()
                        )  
            END  
   
 --SELECT ALL RECEIPT HEADERS THAT CORRESPONDS TO THE PARTICULAR INVOICE      
 --SELECT I_Receipt_Header_ID, N_Receipt_Amount,DT_RECEIPT_DATE FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId and I_STATUS = 1      
        COMMIT TRANSACTION      
    END TRY      
      
    BEGIN CATCH      
 --Error occurred:        
        ROLLBACK TRANSACTION      
        DECLARE @ErrMsg Nnvarchar(max) ,
            @ErrSeverity INT      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()      
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)      
    END CATCH

