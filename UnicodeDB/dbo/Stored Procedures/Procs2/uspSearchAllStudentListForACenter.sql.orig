CREATE PROCEDURE [dbo].[uspSearchAllStudentListForACenter] 
(     
      @sStudentCode VARCHAR(500) =Null,
      @sStudentFName VARCHAR (100)=NULL,
      @sStudentMName VARCHAR (100)=NULL,
      @sStudentLName VARCHAR (100)=NULL,
      @sInvoiceNo VARCHAR(100)=NULL,
      @iCentreId INT
)

AS

BEGIN
      SET NOCOUNT ON;   
      
      SELECT 
      ISNULL(S_First_Name,'') AS S_First_Name, ISNULL(S_Middle_Name,'') AS S_Middle_Name, ISNULL(S_Last_Name,'') AS S_Last_Name,
      S_Student_ID,I_Student_Detail_ID
      FROM T_STUDENT_DETAIL 
      WHERE 
      S_First_Name LIKE ISNULL(@sStudentFName,S_First_Name) + '%' 
--    AND   S_Middle_Name LIKE ISNULL(@sStudentMName,S_Middle_Name) + '%' 
-- by KP on 26-Aug-2006 
-- ID middlename is having NULL Then no data is getting fetched. So, included IsNull function 
      AND   IsNull(S_Middle_Name, '') LIKE ISNULL(@sStudentMName, '') + '%' 
      AND   S_Last_Name LIKE ISNULL(@sStudentLName,S_Last_Name) + '%' 
      AND S_Student_ID LIKE ISNULL(@sStudentCode,S_Student_ID) + '%' 
      AND   I_Student_Detail_ID IN 
      (SELECT I_Student_Detail_ID FROM T_Student_Center_Detail WHERE I_Centre_Id = @iCentreId AND I_Status <> 0)
      ORDER BY ISNULL(S_First_Name,'')
      
END
