-- =============================================  
-- Author:  Parichoy Nandi  
-- Create date: 4th Jan 2024  
-- Description: to get the details of student info list  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_getStudentInfoList]  
 -- Add the parameters for the stored procedure here  
 @brandid int,  
 @Session int,  
 @SchoolGroup int,  
 @class int,  
 @section int,  
 @stream int  
 --@studentid int  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   select   
    
  SD.S_Student_ID as StudentID,  
  SD.I_Student_Detail_ID as StudentDetailID,  
  CONCAT(ISNULL(SD.S_First_Name, ''), ' ',ISNULL(SD.S_Middle_Name, ''), ' ', ISNULL(SD.S_Last_Name, '')) AS FullName,  
  TC.S_Class_Name as Class,  
  SCS.S_Class_Roll_No as RollNo,  
  CONCAT(ISNULL(ERGM.S_First_Name, ''), ' ', ISNULL(ERGM.S_Middile_Name, ''), ' ', ISNULL(ERGM.S_Last_Name, '')) AS GuardianName,  
  SD.Student_Status as StudentStatus  
  from [dbo].[T_ERP_Student_Detail] as SD  
  join [dbo].[T_Student_Class_Section] as SCS on SD.I_Student_Detail_ID = scs.I_Student_Detail_ID and SD.S_Student_ID= scs.S_Student_ID  
  inner join [dbo].[T_School_Group_Class]as SGC on SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID  
  inner join [dbo].[T_Class] as TC on TC.I_Class_ID = SGC.I_Class_ID   
  inner join [dbo].[T_ERP_Enquiry_Regn_Guardian_Master] as ERGM on ERGM.I_Enquiry_Regn_ID =sd.R_I_Enquiry_Regn_ID  
  inner join [dbo].[T_ERP_Enquiry_Regn_Detail] as ERD on ERD.I_Enquiry_Regn_ID = SD.R_I_Enquiry_Regn_ID  
  where SCS.I_Brand_ID = @brandid and  
  SGC.I_School_Group_ID= @SchoolGroup OR @SchoolGroup IS NULL and  
  SGC.I_Class_ID= @class OR @class IS NULL and  
  SCS.I_Section_ID = @section OR @section IS NULL and  
  SCS.I_Stream_ID = @stream OR @stream IS NULL and   
  SCS.I_School_Session_ID =@Session OR @Session IS NULL and   
  SD.Is_Active=1  
END
