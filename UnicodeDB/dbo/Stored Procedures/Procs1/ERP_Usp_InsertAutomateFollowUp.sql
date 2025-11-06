CREATE Proc [dbo].[ERP_Usp_InsertAutomateFollowUp](    
    @EnquiryID bigint  
	,@FollowupTypeID int
)    
As     
begin    
Declare @FollowUpID int
IF NOT EXISTS(select * from T_Enquiry_Regn_Followup where I_Enquiry_Regn_ID=@EnquiryID)
 Begin
 INSERT INTO T_Enquiry_Regn_Followup
 (
 I_Enquiry_Regn_ID
 ,Dt_Followup_Date
 ,S_Followup_Remarks
 ,ERP_R_I_FollowupType_ID
 )
 Values
 (
 @EnquiryID
 ,GETDATE()
 ,'System generated follow up'
 ,@FollowupTypeID
 )
 End
 ELSE
 BEGIN 
 DECLARE @count int
 set @count = (select count(I_Enquiry_Regn_ID) from T_Enquiry_Regn_Followup  where I_Enquiry_Regn_ID=@EnquiryID)
 IF(@count=1)
 BEGIN
 update T_Enquiry_Regn_Followup set Dt_Followup_Date = GETDATE(),ERP_R_I_FollowupType_ID=@FollowupTypeID
 where I_Enquiry_Regn_ID=@EnquiryID and Dt_Next_Followup_Date is null
 END
 END
   End
