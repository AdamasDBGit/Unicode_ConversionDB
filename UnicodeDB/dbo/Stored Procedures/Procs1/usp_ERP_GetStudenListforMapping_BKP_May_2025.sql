
-- =============================================      
-- Author:  <Parichoy Nandi>      
-- Create date: <20th Sept 2023>      
-- Description: <for the list of students >      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_ERP_GetStudenListforMapping_BKP_May_2025]      
 -- Add the parameters for the stored procedure here      
 @iStudentClassSectionID int = null,      
 @iStudentID int =null,      
 @iSchoolGroupID int = null,      
 @iSectionID int = null,      
 @iStreamID int = null,      
 @iSessionID int =null,      
 @iClassID int =null,      
 @iBrandid int      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
      
    -- Insert statements for procedure here      
 Select       
  SCS.I_Student_Class_Section_ID as ClassSectionID,       
  SCS.I_Student_Detail_ID as StudentID,       
  SCS.I_School_Session_ID as SessionID,       
  SGC.I_Class_ID as ClassID,       
  SGC.I_School_Group_ID as SchoolGroupID,       
  TSG.S_School_Group_Name,       
  SCS.I_Section_ID as SectionID,      
  TSG.I_Brand_Id as BrandID,      
  TSt.S_Stream as StreamName,       
  SCS.I_Stream_ID as StreamID,       
  TC.S_Class_Name as ClassName,       
  TS.S_Section_Name as SectionName,       
  ISNULL(sd.S_First_Name, '') + ' ' + ISNULL(sd.[S_Middle_Name], '') + ' ' + ISNULL(sd.[S_Last_Name], '')+ ' (' + sd.S_Student_ID + ')' AS StudentName,       
  SCS.I_Status as StudentStatus       
from       
  [dbo].[T_Student_Class_Section] as SCS       
  inner join [dbo].[T_School_Group_Class]as SGC on SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID       
  inner join T_Student_Detail as sd on sd.I_Student_Detail_ID = scs.I_Student_Detail_ID       
  left join [dbo].[T_Section] as TS on TS.I_Section_ID = SCS.I_Section_ID       
  inner join [dbo].[T_Class] as TC on TC.I_Class_ID = SGC.I_Class_ID and TC.I_Brand_ID=@iBrandid      
  inner join [dbo].[T_School_Group] as TSG on TSG.I_School_Group_ID = SGC.I_School_Group_ID  and TSG.I_Brand_Id= @iBrandid 
  and TSG.I_Status=1
  left join [dbo].[T_Stream] as TSt on TSt.I_Stream_ID = SCS.I_Stream_ID and TSt.I_brand_id=@iBrandid      
where SCS.I_Student_Class_Section_ID = ISNULL(@iStudentClassSectionID,SCS.I_Student_Class_Section_ID) and TSG.I_Brand_Id=@iBrandid      
and SCS.I_Student_Detail_ID=ISNULL(@iStudentID,SCS.I_Student_Detail_ID)      
and SCS.I_School_Session_ID = ISNULL(@iSessionID,SCS.I_School_Session_ID)      
and SGC.I_Class_ID = ISNULL(@iClassID,SGC.I_Class_ID )      
and (SCS.I_Section_ID=@iSectionID or @iSectionID is null)      
and (SCS.I_Stream_ID =@iStreamID or @iStreamID is null)      
and SGC.I_School_Group_ID= ISNULL(@iSchoolGroupID,SGC.I_School_Group_ID)       
END  
