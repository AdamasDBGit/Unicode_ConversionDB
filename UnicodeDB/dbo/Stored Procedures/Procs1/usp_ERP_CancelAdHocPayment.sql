CREATE   PROCEDURE [dbo].[usp_ERP_CancelAdHocPayment]   
(  
 @Id int,
 @Reason nvarchar(MAX)
)  
AS  
begin transaction  
BEGIN TRY   
  
update T_ERP_AdhocPaymentScheduleStudentDetail set inPaymentStatus=2,sRemarks=@Reason where  inAdhocPaymentScheduleStudentDetailID=@Id
  
select 1 StatusFlag,'Payment Cancelled Succesfully.' Message  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  
commit transaction  
