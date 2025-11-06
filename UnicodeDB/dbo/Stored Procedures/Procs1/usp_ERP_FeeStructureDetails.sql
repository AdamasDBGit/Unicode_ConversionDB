--EXEC usp_ERP_FeeStructureDetails  null,251104,7,null    
  
CREATE PROCEDURE [dbo].[usp_ERP_FeeStructureDetails]                    
(                    
@schoolGroupID int = null,                    
@enquiryID int = null,  
@iSchoolSession int = null,  
@ReadmissionRequestID int=null  
)                    
 -- Add the parameters for the stored procedure here                    
AS                    
BEGIN                    
 -- SET NOCOUNT ON added to prevent extra result sets from                    
 -- interfering with SELECT statements.                    
 SET NOCOUNT ON;                    
                    
    -- Insert statements for procedure here                    
                 
   Declare @ClassID int,@streamID int ,@EnqSessionID Int  = null  
     
   IF @iSchoolSession IS NULL   
   BEGIN  
  Set   @EnqSessionID=(      
  Select top 1 R_I_School_Session_ID from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@enquiryID      
  )      
   END  
   ELSE  
   BEGIN  
  
  set @EnqSessionID=@iSchoolSession  
  
   END  
  
   --print '@ReadmissionRequestID'  
   --print @ReadmissionRequestID  
   --print @EnqSessionID  
  
   IF @ReadmissionRequestID IS NULL  
   BEGIN  
  
   SET  @ClassID=(Select I_Class_ID  from T_Enquiry_Regn_Detail               
   where I_Enquiry_Regn_ID=@enquiryID and R_I_School_Session_ID=@EnqSessionID  )            
     --select   @ClassID          
   SET  @streamID=(Select I_Stream_ID  from T_Enquiry_Regn_Detail               
   where I_Enquiry_Regn_ID=@enquiryID and R_I_School_Session_ID=@EnqSessionID  )    
     
   END  
   ELSE  
   BEGIN  
  
    SET  @ClassID=(Select I_Destination_Class_ID  from T_ERP_Student_Promotion_History_Header               
   where I_Student_Promotion_History_Header_ID=@ReadmissionRequestID   
   and I_Student_DetailID in (select top 1 I_Student_Detail_ID from T_Student_Detail where I_Enquiry_Regn_ID=@enquiryID))            
     --select   @ClassID          
   SET  @streamID=(Select I_Destination_Stream_ID  from T_ERP_Student_Promotion_History_Header               
   where I_Student_Promotion_History_Header_ID=@ReadmissionRequestID   
   and I_Student_DetailID in (select top 1 I_Student_Detail_ID from T_Student_Detail where I_Enquiry_Regn_ID=@enquiryID))   
  
   END  
  
  
   -- select @streamID          
print @ClassID  
print @streamID   
print @EnqSessionID   
  
  
IF @ReadmissionRequestID IS NULL  
 begin  
  
  If @streamID is  null            
  Begin            
   SELECT                     
   TEFS.S_Fee_Structure_Name+ISNULL(' (' + TEFS.S_Fee_Code + ')', '') FeeStructureName                     
  ,TEFS.S_Fee_Code FeeCode                    
  ,TEFS.I_Fee_Structure_ID FeeStructureID                    
  ,TEFS.N_Total_OneTime_Amount TotalAmount                    
  ,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable                    
                  
   FROM T_ERP_Fee_Structure TEFS        
   Inner Join T_Class tc on tc.I_Class_ID=TEFS.I_Class_ID  
   Inner Join T_Enquiry_Regn_Detail Rd ON rd.I_Class_ID=tc.I_Class_ID  
      
   Inner Join T_ERP_Fee_Structure_AcademicSession_Map SAM         
   ON SAM.I_Fee_Structure_ID=TEFS.I_Fee_Structure_ID and SAM.Is_Active=1         
   and SAM.I_School_Session_ID=ISNULL(@EnqSessionID,SAM.I_School_Session_ID) and SAM.I_School_Session_ID=ISNULL(@iSchoolSession,SAM.I_School_Session_ID) -- added school Session         
   where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID  and rd.I_Enquiry_Regn_ID=  @enquiryID    
   print 'Stream is Null'  
   End            
   Else            
   Begin            
    SELECT                     
   TEFS.S_Fee_Structure_Name+ISNULL(' (' + TEFS.S_Fee_Code + ')', '') FeeStructureName                     
  ,TEFS.S_Fee_Code FeeCode                    
  ,TEFS.I_Fee_Structure_ID FeeStructureID                    
  ,TEFS.N_Total_OneTime_Amount TotalAmount                    
  ,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable                    
                  
   FROM T_ERP_Fee_Structure TEFS        
   Inner Join T_Class tc on tc.I_Class_ID=TEFS.I_Class_ID  
   Inner Join T_Enquiry_Regn_Detail Rd ON rd.I_Class_ID=tc.I_Class_ID  
      
   Inner Join T_ERP_Fee_Structure_AcademicSession_Map SAM         
   ON SAM.I_Fee_Structure_ID=TEFS.I_Fee_Structure_ID and SAM.Is_Active=1        
   --and SAM.I_School_Session_ID=@EnqSessionID   
   and SAM.I_School_Session_ID=ISNULL(@EnqSessionID,SAM.I_School_Session_ID) and SAM.I_School_Session_ID=ISNULL(@iSchoolSession,SAM.I_School_Session_ID) -- added school Session  
   where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID   and rd.I_Enquiry_Regn_ID=  @enquiryID       
   and TEFS.I_Stream_ID=@streamID           
   or @streamID is null          
   End             
               
 end   
 else  
   
 begin  
  
  If @streamID is  null            
  Begin            
   SELECT                     
   TEFS.S_Fee_Structure_Name+ISNULL(' (' + TEFS.S_Fee_Code + ')', '') FeeStructureName                     
  ,TEFS.S_Fee_Code FeeCode                    
  ,TEFS.I_Fee_Structure_ID FeeStructureID                    
  ,TEFS.N_Total_OneTime_Amount TotalAmount                    
  ,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable                    
                  
   FROM T_ERP_Fee_Structure TEFS        
   Inner Join T_Class tc on tc.I_Class_ID=TEFS.I_Class_ID  
  -- Inner Join T_Enquiry_Regn_Detail Rd ON rd.I_Class_ID=tc.I_Class_ID  
      
   Inner Join T_ERP_Fee_Structure_AcademicSession_Map SAM         
   ON SAM.I_Fee_Structure_ID=TEFS.I_Fee_Structure_ID and SAM.Is_Active=1         
   and SAM.I_School_Session_ID=ISNULL(@EnqSessionID,SAM.I_School_Session_ID) and SAM.I_School_Session_ID=ISNULL(@iSchoolSession,SAM.I_School_Session_ID) -- added school Session         
   where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID  --and rd.I_Enquiry_Regn_ID=  @enquiryID    
   print 'Stream is Null'  
   End            
   Else            
   Begin            
    SELECT                     
   TEFS.S_Fee_Structure_Name+ISNULL(' (' + TEFS.S_Fee_Code + ')', '') FeeStructureName                     
  ,TEFS.S_Fee_Code FeeCode                    
  ,TEFS.I_Fee_Structure_ID FeeStructureID                    
  ,TEFS.N_Total_OneTime_Amount TotalAmount                    
  ,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable                    
                  
   FROM T_ERP_Fee_Structure TEFS        
   Inner Join T_Class tc on tc.I_Class_ID=TEFS.I_Class_ID  
   Inner Join T_ERP_Fee_Structure_AcademicSession_Map SAM         
   ON SAM.I_Fee_Structure_ID=TEFS.I_Fee_Structure_ID and SAM.Is_Active=1        
   --and SAM.I_School_Session_ID=@EnqSessionID   
   and SAM.I_School_Session_ID=ISNULL(@EnqSessionID,SAM.I_School_Session_ID) and SAM.I_School_Session_ID=ISNULL(@iSchoolSession,SAM.I_School_Session_ID) -- added school Session  
   where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID        
   and TEFS.I_Stream_ID=@streamID           
   or @streamID is null          
   End             
               
 end       
  
  
                    
END 