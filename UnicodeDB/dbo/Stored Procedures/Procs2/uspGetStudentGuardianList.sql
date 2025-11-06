-- =============================================  
-- Author:  Parichoy Nandi  
-- Create date: 08-08-2023  
-- Description: to get the student list  
--exec [uspGetStudentGuardianList] 1  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetStudentGuardianList]  
 (-- Add the parameters for the stored procedure here  
 @BrandId int = null  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT   
 distinct( SD.S_Student_ID),SD.S_Student_ID As StudentID,  
    Concat(SD.S_First_Name , ' ' , SD.S_Middle_Name , ' ' + SD.S_Last_Name) AS StudentName,  
    TSCS.I_Brand_ID AS BrandID  
 FROM T_Student_Detail AS SD 
 LEFT JOIN   
    T_Student_Parent_Maps AS SPM  
    ON SPM.S_Student_ID = SD.S_Student_ID  
 INNER JOIN T_Student_Class_Section TSCS ON TSCS.S_Student_ID = SD.S_Student_ID and TSCS.I_Status=1  
 where  TSCS.I_Brand_ID = ISNULL(@BrandId,TSCS.I_Brand_ID) --and SD.S_First_Name IS NOT NULL;  
END
