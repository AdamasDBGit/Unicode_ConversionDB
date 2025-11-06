CREATE FUNCTION [MBP].[fnGetProductIDFromCourseID]  
(  
 @iCourseID INT     
)  
RETURNS  @rtnTable TABLE  
(  
 iProductID INT,  
 iCourseID INT  
)  

AS   
  
BEGIN  
DECLARE @temProduct TABLE  
 (  
 ID INT IDENTITY(1,1),  
 iProductID INT  
 )  
      
           INSERT INTO @temProduct(iProductID)  
        SELECT DISTINCT(PC.I_Product_ID) FROM MBP.T_Product_Component PC  
        INNER JOIN dbo.T_Course_Master CM  
--        ON PC.I_Course_ID= CM.I_Course_ID  
--        INNER JOIN dbo.T_CourseFamily_Master CFM  
        ON CM.I_Course_ID= PC.I_Course_ID  
        WHERE PC.I_Course_ID = @iCourseID  
  
        INSERT INTO @temProduct(iProductID)  
        SELECT DISTINCT(PC.I_Product_ID) FROM MBP.T_Product_Component PC  
--        INNER JOIN dbo.T_Course_Master CM  
--        ON PC.I_Course_ID= CM.I_Course_ID  
        INNER JOIN dbo.T_CourseFamily_Master CFM  
        ON PC.I_Course_Family_ID= CFM.I_CourseFamily_ID  
        WHERE CFM.I_CourseFamily_ID = (SELECT I_CourseFamily_ID FROM dbo.T_Course_Master  
        WHERE I_Course_ID = @iCourseID)          
          
        INSERT INTO @rtnTable (iProductID,iCourseID)  
        SELECT  DISTINCT(iProductID),@iCourseID  FROM @temProduct  
        DELETE FROM @temProduct 
 
 RETURN;  
  
END