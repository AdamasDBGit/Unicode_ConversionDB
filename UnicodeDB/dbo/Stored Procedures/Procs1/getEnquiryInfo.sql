--exec [getEnquiryInfo] 237226
CREATE PROCEDURE [dbo].[getEnquiryInfo]    
 -- Add the parameters for the stored procedure here    
 (    
  @EnquiryNo int null    
 )    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    -- Insert statements for procedure here    
 select top 1    
 TERD.I_Enquiry_Regn_ID as EnquiryID,    
 Concat(isnull(TERD.S_First_Name, ''),' ', isnull(TERD.S_Middle_Name, ''),' ',  isnull(TERD.S_Last_Name, '')) as FullName,    
 TERD.S_Mobile_No as Phone    
 --TC.S_Class_Name as ClassName   
 ,sd.I_Student_Detail_ID as StudentID
 ,ISNULL((select S_Class_Name from T_Class where I_Class_ID= TSGC.I_Class_ID),TC.S_Class_Name) ClassName
 
 from T_Enquiry_Regn_Detail TERD    
 left join T_Class as TC on TC.I_Class_ID = TERD.I_Class_ID    
 Left Join T_student_detail sd on sd.I_Enquiry_Regn_ID=TERd.I_Enquiry_Regn_ID  
 left join T_Student_Class_Section TSCS ON TSCS.I_Student_Detail_ID=sd.I_Student_Detail_ID
 left join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID=TSCS.I_School_Group_Class_ID
 and sd.I_Status=1  
 where terd.I_Enquiry_Regn_ID = isnull(@EnquiryNo, Terd.I_Enquiry_Regn_ID)    
END

