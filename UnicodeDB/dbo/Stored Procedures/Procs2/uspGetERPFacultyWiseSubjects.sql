-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 Nov 14>
-- Description:	<Get Subjects By Faculty>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetERPFacultyWiseSubjects] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@iFaculty INT
	,@iSchoolGroup INT=NULL
	,@iClass INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
	 TSM.I_Subject_ID SubjectID 
	,TC.S_Class_Name ClassName
	,TC.I_Class_ID ClassID
	,TSM.S_Subject_Code  SubjectCode
	,TSM.S_Subject_Name SubjectName 
	,TSM.I_Status Status
	,TSM.I_Brand_ID BrandID
	,TST.I_Subject_Type_ID SubjectTypeID
	,TST.S_Subject_Type SubjectType
	,TSM.I_School_Group_ID AS SchoolGroupID
	,TSG.S_School_Group_Name AS SchoolGroupName
	,TSM.I_TotalNoOfClasses AS TotalNumberOfLecturesRequired

  FROM T_Subject_Master TSM  
  inner join 
  T_Class TC ON TC.I_Class_ID = TSM.I_Class_ID
  inner join 
  T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type
  inner join 
  T_School_Group TSG ON TSG.I_School_Group_ID = TSM.I_School_Group_ID
  inner join
  T_ERP_Faculty_Subject as TEFS on TEFS.I_Subject_ID=TSM.I_Subject_ID
  inner join
  T_Faculty_Master as FM on FM.I_Faculty_Master_ID=TEFS.I_Faculty_Master_ID
  where TSM.I_Brand_ID=@iBrandID and FM.I_Faculty_Master_ID=@iFaculty
  and TSG.I_School_Group_ID=ISNULL(@iSchoolGroup,TSG.I_School_Group_ID)
  and TC.I_Class_ID=ISNULL(@iClass,TC.I_Class_ID) and TSM.I_Status=1


END
