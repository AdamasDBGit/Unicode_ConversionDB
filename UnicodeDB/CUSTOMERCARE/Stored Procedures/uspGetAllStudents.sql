-- =============================================  
  
-- Author:Sanjoy Mitra   
-- Create date: 29/09/2007  
-- Description: Search a Student Details from dbo.T_Student_Detail  
-- =============================================  
CREATE PROCEDURE [CUSTOMERCARE].[uspGetAllStudents]   --[CUSTOMERCARE].[uspGetAllStudents] 'deb' ,null,null,19,109
(  
 @sFirstName VARCHAR(50) = NULL   
,@sMiddleName VARCHAR(50 ) = NULL   
,@sLastName VARCHAR(50 ) = NULL   
,@iCenterID INT = NULL  
,@iBrandID INT = NULL  
)  
AS  
BEGIN  
DECLARE @sStudentFName VARCHAR(50 )   
DECLARE @sStudentMName VARCHAR(50 )   
DECLARE @sStudentLName VARCHAR(50 )   
  
IF(@sFirstName is null)   
SET @sStudentFName= ''   
IF(@sMiddleName is null)   
SET @sStudentMName = ''   
IF(@sLastName is null)   
SET @sStudentLName = ''   
  
SET @sStudentFName = @sFirstName + '%'   
SET @sStudentMName = @sMiddleName + '%'   
SET @sStudentLName = @sLastName + '%'   
  
SELECT   
 SD.I_Student_Detail_ID AS I_Student_Detail_ID  
,S_Student_ID AS S_Student_ID  
,S_Title AS S_Title  
,S_First_Name AS S_First_Name  
,S_Middle_Name AS S_Middle_Name  
,S_Last_Name AS S_Last_Name  
,S_Email_ID as Email   
,S_Phone_No as PhoneNumber   
,S_Mobile_No as MobileNumber   
,SCD.I_Centre_Id as CentreId  
 ,ISNULL(S_Curr_Address1, '') +' '+ ISNULL(S_Curr_Address2, '') +' '+ char (53) + ISNULL(S_Curr_Area, '') + ' '+ISNULL(S_Curr_Pincode, '') as Address 
--,(S_Curr_Address1 +' '+ S_Curr_Address2 +' '+ char (53) + S_Curr_Area + ' '+S_Curr_Pincode) as Address   
  
FROM dbo.T_Student_Detail SD   
INNER JOIN dbo.T_Student_Center_Detail SCD  
ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID  
INNER JOIN dbo.T_Brand_Center_Details BCD  
ON BCD.I_Centre_Id  = SCD.I_Centre_ID   
  
WHERE SD.S_First_Name LIKE COALESCE (@sStudentFName,SD.S_First_Name)   
AND SD.S_Middle_Name LIKE COALESCE(@sStudentMName,SD. S_Middle_Name)   
AND SD.S_Last_Name LIKE COALESCE(@sStudentLName,SD.S_Last_Name )   
AND SCD.I_Centre_Id LIKE COALESCE(@iCenterID,SCD.I_Centre_Id )   
AND BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)   
--AND SCD.I_Centre_Id=@iCenterID  
ORDER BY S_First_Name  
END
