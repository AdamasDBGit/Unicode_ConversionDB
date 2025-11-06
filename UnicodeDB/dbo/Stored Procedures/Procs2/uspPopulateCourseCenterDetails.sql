-- =============================================    
-- Author:  Debarshi Basu    
-- Create date: 26/03/2006    
-- Description: GETS the different Courses,course family,    
--    certificate,duration of course related to     
--    a particular center    
-- =============================================    
CREATE PROCEDURE [dbo].[uspPopulateCourseCenterDetails]     
 @iHierarchyID int,    
 @iBrandID int    
AS    
BEGIN    
    
 SET NOCOUNT OFF    
 DECLARE @iCenterID int    
     
 SELECT @iCenterID = I_Center_Id FROM     
 dbo.T_Center_Hierarchy_Details WHERE    
 I_Hierarchy_Detail_ID = @iHierarchyID    
     
 --table 1(for courses related to a center)    
 SELECT DISTINCT A.I_Course_ID,B.S_Course_Code,B.S_Course_Name    
 FROM dbo.T_Course_Center_Detail A     
 INNER JOIN  dbo.T_Course_Master B    
 ON A.I_Course_ID = B.I_Course_ID    
 WHERE A.I_Centre_Id = @iCenterID    
 AND B.I_Brand_Id = @iBrandID    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
 AND A.I_Course_ID IN    
 (    
  SELECT A1.I_Course_ID     
  FROM dbo.T_Course_Center_Detail A1    
  INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B    
  ON A1.I_Course_Center_ID = B.I_Course_Center_ID    
  AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())    
  AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())    
  AND B.I_Status = 1    
  AND A1.I_Course_ID = A.I_Course_ID     
  AND A1.I_Centre_Id = @iCenterID    
 )    
    
 --table 2(for course family related to a center)    
 SELECT DISTINCT B.I_CourseFamily_ID,C.S_CourseFamily_Name    
 FROM dbo.T_Course_Center_Detail A    
 INNER JOIN dbo.T_Course_Master B    
 ON A.I_Course_ID = B.I_Course_ID    
 INNER JOIN dbo.T_CourseFamily_Master C    
 ON B.I_CourseFamily_ID = C.I_CourseFamily_ID    
 WHERE A.I_Centre_Id = @iCenterID    
 AND B.I_Brand_Id = @iBrandID    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
 AND C.I_Status = 1    
 AND A.I_Course_ID IN    
 (    
  SELECT A1.I_Course_ID     
  FROM dbo.T_Course_Center_Detail A1    
  INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B    
  ON A1.I_Course_Center_ID = B.I_Course_Center_ID    
  AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())    
  AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())    
  AND B.I_Status = 1    
  AND A1.I_Course_ID = A.I_Course_ID     
  AND A1.I_Centre_Id = @iCenterID    
 )    
     
    
 --table 3(for Certificates related to the center)    
 SELECT DISTINCT C.I_Certificate_ID,C.S_Certificate_Name    
 FROM dbo.T_Course_Center_Detail A    
 INNER JOIN dbo.T_Course_Master B    
 ON A.I_Course_ID = B.I_Course_ID    
 INNER JOIN dbo.T_Certificate_Master C    
 ON B.I_Certificate_ID = C.I_Certificate_ID    
 WHERE A.I_Centre_Id = @iCenterID    
 AND B.I_Brand_Id = @iBrandID    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
 AND A.I_Course_ID IN    
 (    
  SELECT A1.I_Course_ID     
  FROM dbo.T_Course_Center_Detail A1    
  INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B    
  ON A1.I_Course_Center_ID = B.I_Course_Center_ID    
  AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())    
  AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())    
  AND B.I_Status = 1    
  AND A1.I_Course_ID = A.I_Course_ID     
  AND A1.I_Centre_Id = @iCenterID    
 )    
    
 --table 4(for different Course Durations related with the center)    
 --SELECT CEILING((B.N_Course_Duration*7)/(dbo.fnGetSessionInWeek(D.I_No_Of_Session,D.S_DaysOfWeek)*30)) AS MONTHS,
 --SUBSTRING(  
 SELECT * INTO #temp FROM
 (SELECT DISTINCT B.N_Course_Duration AS DURATION,CEILING((B.N_Course_Duration*7)/(dbo.fnGetSessionInWeek(D.I_No_Of_Session,D.S_DaysOfWeek)*30)) AS MONTHS    
 FROM dbo.T_Course_Center_Detail A    
 INNER JOIN dbo.T_Course_Center_Delivery_FeePlan Y      
 ON A.I_Course_Center_ID = Y.I_Course_Center_ID     
 INNER JOIN dbo.T_Course_Delivery_Map B    
 ON Y.I_Course_Delivery_ID = B.I_Course_Delivery_ID      
 INNER JOIN dbo.T_Course_Master C    
 ON A.I_Course_ID = C.I_Course_ID    
 INNER JOIN dbo.T_Delivery_Pattern_Master D
 ON B.I_Delivery_Pattern_ID = D.I_Delivery_Pattern_ID 
 WHERE A.I_Centre_Id = @iCenterID    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
 AND Y.I_Status = 1    
 AND A.I_Course_ID IN    
 (    
  SELECT A1.I_Course_ID     
  FROM dbo.T_Course_Center_Detail A1    
  INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B    
  ON A1.I_Course_Center_ID = B.I_Course_Center_ID    
  AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())    
  AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())    
  AND B.I_Status = 1    
  AND A1.I_Course_ID = A.I_Course_ID     
  AND A1.I_Centre_Id = @iCenterID    
 )) T1
 
 
 SELECT DISTINCT MONTHS,STUFF((
 SELECT ','+CAST(DURATION AS varchar(10))
 FROM #temp
 WHERE MONTHS = A.MONTHS
 FOR XML PATH('')
 ),1,1,'') AS DURATION_LIST
 FROM #temp AS A 
 

     
     
END
