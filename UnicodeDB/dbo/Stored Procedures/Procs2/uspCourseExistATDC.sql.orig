CREATE PROCEDURE [dbo].[uspCourseExistATDC]  
(           
  @iDestinationCenterId INT          
 ,@sCourseList VARCHAR(max)        
          
)          
AS          
BEGIN        
        
DECLARE @iDCCourseCount INT        
DECLARE @iOCCourseCount INT        
        
--set @sCourseList =         
--'         
--<COURSE>         
--  <COURSEIDTABLE>         
--    <I_Course_Id>1</I_Course_Id>          
-- <I_Course_Id>20</I_Course_Id>         
--  </COURSEIDTABLE>         
--</COURSE>         
--'        
declare @hDoc int         
exec sp_xml_preparedocument @hDoc OUTPUT,@sCourseList        
        
SELECT @iOCCourseCount = COUNT(I_Course_Id)        
FROM OPENXML (@hDoc,'/COURSE/COURSEIDTABLE',2)         
WITH ( I_Course_Id INT )        
        
SELECT @iDCCourseCount = COUNT(DISTINCT(tsbm.I_Course_Id))  
FROM [dbo].[T_Center_Batch_Details] AS tcbd  
INNER JOIN [dbo].[T_Student_Batch_Master] AS tsbm  
ON tcbd.[I_Batch_ID] = tsbm.[I_Batch_ID]  
LEFT OUTER JOIN [dbo].[T_Student_Batch_Details] AS tsbd  
ON tsbm.[I_Batch_ID] = tsbd.[I_Batch_ID]  
WHERE tcbd.I_Centre_Id = @iDestinationCenterId        
AND tsbm.I_Course_Id in        
(        
 SELECT I_Course_Id        
 FROM OPENXML (@hDoc,'/COURSE/COURSEIDTABLE',2)         
 WITH ( I_Course_Id INT )        
)      
AND GETDATE() >= ISNULL(tsbd.Dt_Valid_From, GETDATE())      
AND GETDATE() <= ISNULL(tsbd.Dt_Valid_To, GETDATE())      
AND (tsbd.I_Status <> 0 OR  tsbd.I_Status IS NULL)  
        
IF ( @iOCCourseCount = @iDCCourseCount )        
BEGIN        
 SELECT 'TRUE'        
END        
ELSE        
BEGIN        
 SELECT 'FALSE'        
END        
        
END
