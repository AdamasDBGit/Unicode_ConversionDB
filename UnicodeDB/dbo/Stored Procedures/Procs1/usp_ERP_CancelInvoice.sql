

CREATE PROCEDURE [dbo].[usp_ERP_CancelInvoice]
    (
      @iInvoiceId INT ,
	  @iUpdatedBy NVARCHAR(max) ,
      @sUpdatedBy NVARCHAR(max)=null ,
      @iCancellationReasonId INT = NULL ,
	  @sCancellationRemarks NVARCHAR(max)=NULL
    )
AS
    BEGIN TRY      
        SET NOCOUNT ON;      
        DECLARE @iStudentDetailID INT  
		DECLARE @iBatchID INT
       
        BEGIN TRANSACTION      
 --exec [dbo].[uspInsertReceiptArchive] @iInvoiceId


 select @sUpdatedBy=S_Username from T_ERP_User where I_User_ID=@iUpdatedBy
 
 --SET THE STATUS IN THE TABLE T_INVOICE_PARENT      
        UPDATE  T_Invoice_Parent
        SET     I_Status = 0 ,
                S_Upd_By = @sUpdatedBy ,
				I_Updated_By=@iUpdatedBy,
                Dt_Upd_On = GETDATE() ,
                S_Cancel_Type = 1,
				S_Narration=@sCancellationRemarks
        WHERE   I_Invoice_Header_ID = @iInvoiceId 
 
        EXEC usp_ERP_InsertCreditNoteForInvoice @iInvoiceId
       
 -- delete the courses for the invoice      
        SELECT  @iStudentDetailID = I_Student_Detail_ID
        FROM    T_Invoice_Parent
        WHERE   I_Invoice_Header_ID = @iInvoiceId 


		SELECT  @iBatchID=TIBM.I_Batch_ID
                        FROM    dbo.T_Invoice_Batch_Map AS TIBM
                                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        WHERE   TICH.I_Invoice_Header_ID = @iInvoiceId and TIBM.I_Status=1


	
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
       
	    Declare @ClassID int,@streamID int,@academicSession int, @CurrentERPFeeSchedule int,@ClassGroupID int



select
@ClassID=SGC.I_Class_ID,@streamID=SCS.I_Stream_ID,@academicSession=SASM.I_School_Session_ID
,@CurrentERPFeeSchedule=CFP.I_New_I_Fee_Structure_ID,@ClassGroupID=SGC.I_School_Group_Class_ID
from T_Student_Class_Section as SCS
inner join
T_School_Group_Class as SGC on SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID
inner join
T_School_Academic_Session_Master as SASM on SCS.I_School_Session_ID=SASM.I_School_Session_ID  --and SASM.I_Status=1
inner join
T_Invoice_Parent as TIP on  
--CONVERT(DATE,TIP.Dt_Crtd_On) between CONVERT(DATE,SASM.Dt_Session_Start_Date) AND CONVERT(DATE,SASM.Dt_Session_End_Date)
--and
TIP.I_Invoice_Header_ID=@iInvoiceId and SCS.I_Student_Detail_ID=@iStudentDetailID
and TIP.I_School_Session_ID=SCS.I_School_Session_ID
inner join
T_Invoice_Child_Header as ICP on ICP.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
inner join
T_Course_Fee_Plan as CFP on CFP.I_Course_Fee_Plan_ID=ICP.I_Course_FeePlan_ID
	  
	   
	   update T_Student_Class_Section set I_Status = 0 where I_Student_Detail_ID=@iStudentDetailID and I_School_Group_Class_ID= @ClassGroupID
		and I_Status=1 and I_School_Session_ID=@academicSession


		select 1 StatusFlag,'Invoice successfully canceled and credit note has been generated' Message
		
		COMMIT TRANSACTION      
    END TRY      
      
    BEGIN CATCH      
 --Error occurred:        
        ROLLBACK TRANSACTION      
        DECLARE @ErrMsg NVARCHAR(max) ,
            @ErrSeverity INT      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()      
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)      
    END CATCH  


