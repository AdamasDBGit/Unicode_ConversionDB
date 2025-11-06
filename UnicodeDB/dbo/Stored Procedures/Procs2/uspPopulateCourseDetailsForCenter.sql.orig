CREATE PROCEDURE [dbo].[uspPopulateCourseDetailsForCenter]     
 @iHierarchyID int,    
 @sCourseIDs varchar(100),    
 @sCourseFamilyIDs varchar(100),    
 @sDurationIDs varchar(1000),    
 @sCertificateIDs varchar(100)    
AS    
BEGIN   
 SET NOCOUNT OFF    
 DECLARE @iCenterID int     
  
 IF LEN(@sCourseIDs) = 0    
 BEGIN    
  SET @sCourseIDs = null    
 END    
 IF LEN(@sCourseFamilyIDs) = 0    
 BEGIN    
  SET @sCourseFamilyIDs = null    
 END    
 IF LEN(@sDurationIDs) = 0    
 BEGIN    
  SET @sDurationIDs = null    
 END    
 IF LEN(@sCertificateIDs) = 0    
 BEGIN    
  SET @sCertificateIDs = null    
 END    
    
 SELECT @iCenterID = I_Center_Id FROM     
 dbo.T_Center_Hierarchy_Details WHERE    
 I_Hierarchy_Detail_ID = @iHierarchyID     
    
 SELECT DISTINCT X.I_Course_ID,A.S_Course_Code,A.S_Course_Name,C.I_Delivery_Pattern_ID,B.I_Course_Fee_Plan_ID ,  
 B.N_TotalLumpSum,B.N_TotalInstallment,Z.S_Pattern_Name,C.N_Course_Duration , dbo.GetDiscountSchemeforCenter(X.I_Course_ID, @iCenterID) AS DiscountSchemes   
 FROM dbo.T_Course_Center_Detail X     
 INNER JOIN dbo.T_Course_Center_Delivery_FeePlan Y   
 ON X.I_Course_Center_ID = Y.I_Course_Center_ID    
 INNER JOIN dbo.T_Course_Delivery_Map C    
 ON Y.I_Course_Delivery_ID = C.I_Course_Delivery_ID   
 INNER JOIN dbo.T_Delivery_Pattern_Master Z  
 ON Z.I_Delivery_Pattern_ID = C.I_Delivery_Pattern_ID  
 INNER JOIN dbo.T_Course_Fee_Plan B    
 ON Y.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID    
 INNER JOIN dbo.T_Course_Master A    
 ON X.I_Course_ID = A.I_Course_ID     
 WHERE X.I_Centre_Id = @iCenterID    
 AND CHARINDEX(','+ CONVERT(VARCHAR(20), X.I_Course_ID  ) + ',', ISNULL(@sCourseIDs, ','+CONVERT(VARCHAR(20), X.I_Course_ID  )+',')) > 0     
 AND CHARINDEX(','+ CONVERT(VARCHAR(20), ISNULL(A.I_Certificate_ID,'') ) + ',', ISNULL(@sCertificateIDs, ','+ CONVERT(VARCHAR(20), ISNULL(A.I_Certificate_ID,'') )+',')) > 0    
 AND CHARINDEX(','+ CONVERT(VARCHAR(20), A.I_CourseFamily_ID  ) + ',', ISNULL(@sCourseFamilyIDs, ','+CONVERT(VARCHAR(20), A.I_CourseFamily_ID)+',')) > 0     
 AND CHARINDEX(','+ CONVERT(VARCHAR(20), C.N_Course_Duration ) + ',', ISNULL(@sDurationIDs, ','+CONVERT(VARCHAR(20), C.N_Course_Duration)+',')) > 0    
 AND X.I_STATUS <> 0 AND Y.I_STATUS <> 0 AND C.I_STATUS <> 0 AND B.I_STATUS <> 0 AND A.I_STATUS <> 0  
 AND GETDATE() >= ISNULL(Y.Dt_Valid_From,GETDATE()) AND GETDATE() <= ISNULL(Y.Dt_Valid_To,GETDATE())
 AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE())
 ORDER BY A.S_Course_Code  
END
