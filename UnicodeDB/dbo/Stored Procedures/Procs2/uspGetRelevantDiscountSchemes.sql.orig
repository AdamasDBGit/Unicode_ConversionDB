CREATE PROCEDURE [dbo].[uspGetRelevantDiscountSchemes]    
(    
 @sCourseIdList VARCHAR(500),    
 @iCenterID int     
)    
    
AS    
    
BEGIN    
 SET @sCourseIdList = (SELECT LEFT(OriginalCourseIDList,LEN(OriginalCourseIDList)-1) FROM    
(SELECT(SELECT CAST(Val AS VARCHAR(10))+','     
FROM dbo.fnString2Rows(@sCourseIdList,',') #temp     
ORDER BY Val FOR XML PATH('')) AS OriginalCourseIDList) ABC)    
    
SELECT  Z.S_Discount_Scheme_Name AS SCHEME_NAME,XYZ.Scheme_ID AS SCHEME_ID FROM    
    (SELECT Scheme_ID,    
    LEFT(CourseID_List,LEN(CourseID_List)-1) AS CourseID_List    
     FROM (SELECT X.I_Discount_Scheme_ID AS Scheme_ID,(SELECT     
       DISTINCT CAST(I_Course_ID AS VARCHAR(50)) +','     
       FROM dbo.T_Discount_Center_Detail A    
       INNER JOIN dbo.T_Discount_Scheme_Master B    
       ON A.I_Discount_Scheme_ID = B.I_Discount_Scheme_ID    
       INNER JOIN dbo.T_Discount_Details C    
       ON B.I_Discount_Scheme_ID = C.I_Discount_Scheme_ID    
       INNER JOIN dbo.T_CourseList_Course_Map D    
       ON C.I_CourseList_ID = D.I_CourseList_ID    
       WHERE I_Centre_ID = @iCenterID    
       AND C.I_CourseList_ID = X.I_CourseList_ID  
       AND B.Dt_Valid_From <= GETDATE()  
       AND B.Dt_Valid_To >= GETDATE()
       ORDER BY CAST(I_Course_ID AS VARCHAR(50)) +','    
       FOR XML PATH ('')) AS CourseID_List    
  FROM dbo.T_Discount_Details X,dbo.T_Discount_Scheme_Master Y    
  GROUP BY X.I_CourseList_ID,X.I_Discount_Scheme_ID) TEMP) XYZ    
  INNER JOIN dbo.T_Discount_Scheme_Master Z    
  ON XYZ.Scheme_ID = Z.I_Discount_Scheme_ID  
  INNER JOIN dbo.T_Discount_Center_Detail DCD  
  ON Z.I_Discount_Scheme_ID = DCD.I_Discount_Scheme_ID    
  WHERE XYZ.CourseID_List = @sCourseIdList    
  AND DCD.I_Centre_ID = @iCenterID  
    
       
END
