CREATE PROCEDURE [dbo].[usp_ERP_GetFacultySubjectMapping] 
-- =============================================
     -- Author:	Arijit Manna
-- Create date: 21-09-2023
-- Description:	Faculty subject map listing
-- =============================================
-- Add the parameters for the stored procedure here
	-- exec usp_ERP_GetFacultySubjectMapping 1
@FacultyID int =null,
@iBrandID int = null
AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
      SET NOCOUNT ON;
	  SELECT 
	  TSG.I_School_Group_ID AS schoolGroupValue,
	  TC.I_Class_ID AS classValue,
	  SM.I_Subject_ID AS subjectValue,
	  EFS.I_Is_Primary isPrimary,
	  TSG.S_School_Group_Name AS schoolGroupText,
	  TC.S_Class_Name AS classText,
	  SM.S_Subject_Name AS subjectText
	  FROM T_ERP_Faculty_Subject EFS 
	  inner join T_Subject_Master SM ON SM.I_Subject_ID = EFS.I_Subject_ID
	  inner join T_Class TC ON TC.I_Class_ID = SM.I_Class_ID 
	  inner join T_School_Group TSG ON TSG.I_School_Group_ID = SM.I_School_Group_ID
	  inner join
	  T_Faculty_Master as FM on EFS.I_Faculty_Master_ID=FM.I_Faculty_Master_ID
	  inner join
	  T_ERP_User_Brand as EUB on EUB.I_User_ID=FM.I_User_ID and EUB.I_Brand_ID=ISNULL(@iBrandID,EUB.I_Brand_ID) and EUB.Is_Teaching_Staff='true'
	  where EFS.I_Faculty_Master_ID = @FacultyID

END TRY
BEGIN CATCH  
    
 select 0 as statusFlag, ERROR_MESSAGE() as Message
          
END CATCH; 

END
