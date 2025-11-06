CREATE PROCEDURE [dbo].[Student_Subject_Selection] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 14-09-2023
-- Description:	To get Subject Status for Student
-- =============================================
-- Add the parameters for the stored procedure here
@StudentDetailID int,
@SessionID int,
@GroupID int,
@ClassID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	   SET NOCOUNT ON;

---*** Calling the below procedure to show the list of the student***-----
exec dbo.Usp_ERP_Student_Subject_Allocation_List
@SessionID,null,@StudentDetailID,null,null,null,null


select  

TSCS.I_Student_Detail_ID StudentDetailID,  
TSASM.I_School_Session_ID SchoolSessionID,  
isnull (TSG.I_School_Group_ID,'0') As SchoolGroupID,  
TSGC.I_Class_ID AS ClassID,  
TSM.I_Subject_ID as SubjectID,TSM.S_Subject_Code as SubjectCode,TSM.S_Subject_Name as SubjectName, -- susmita : change the name of display name
TST.S_Subject_Type as SubjectType,
(Case when TESB.I_Student_Subject_ID is null then 0 else 1 end) As Allocation


from 
T_Student_Class_Section TSCS  

left join T_School_Academic_Session_Master TSASM on
TSCS.I_School_Session_ID=TSASM.I_School_Session_ID  

left join T_School_Group_Class TSGC on 
TSGC.I_School_Group_Class_ID=TSCS.I_School_Group_Class_ID  

left join T_School_Group TSG on TSG.I_School_Group_ID=TSGC.I_School_Group_ID  
and TSG.I_Brand_Id=TSASM.I_Brand_ID  

left Join  T_Subject_Master TSM on 
TSM.I_Class_ID=TSGC.I_Class_ID 
and 
TSM.I_School_Group_ID=TSGC.I_School_Group_ID
and 
TSM.I_Brand_ID=TSG.I_Brand_Id 

LEFT join  T_Subject_Type TST on 
TST.I_Subject_Type_ID=TSM.I_Subject_Type

left join T_ERP_Student_Subject TESB on 
TESB.I_Student_Detail_ID=TSCS.I_Student_Detail_ID
and 
TESB.I_Class_ID=TSGC.I_Class_ID
and 
TESB.I_School_Session_ID=TSCS.I_School_Session_ID
and 
TESB.I_School_Group_ID=TSG.I_School_Group_ID
and 
TESB.I_Subject_ID=TSM.I_Subject_ID


where 

TSASM.I_School_Session_ID=@SessionID 
and 
TSM.I_Status=1  
and 
TSCS.I_Student_Detail_ID=@StudentDetailID
and 
TSGC.I_Class_ID=@ClassID
and 
TSG.I_School_Group_ID=@GroupID

ORDER BY 
TSCS.I_Student_Detail_ID, 
SubjectID;

END
