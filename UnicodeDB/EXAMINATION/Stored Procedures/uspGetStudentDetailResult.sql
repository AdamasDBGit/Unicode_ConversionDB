-- =============================================  
-- Author:  <Susmita Paul>  
-- Create date: <2023 July 19>  
-- Description: <Get Student Marks Details>  
-- =============================================  
CREATE PROCEDURE [EXAMINATION].[uspGetStudentDetailResult]   
(  
@iStudentResultID INT=NULL  
)  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
   
 select * from   
 T_Student_Result as SR  
 inner join  
 T_Student_Result_Detail as SRD on SR.I_Student_Result_ID=SRD.I_Student_Result_ID  
 --inner join  
 --T_Exam_Component_Master as ECM on SRD.I_Exam_Component_ID=ECM.I_Exam_Component_ID  
 inner join  
 T_Student_Detail as SD on SR.I_Student_Detail_ID=SD.I_Student_Detail_ID  
 where SR.I_Student_Result_ID=@iStudentResultID  
  
  
  
END  
