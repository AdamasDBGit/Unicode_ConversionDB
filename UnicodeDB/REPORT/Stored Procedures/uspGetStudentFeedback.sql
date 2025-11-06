CREATE PROCEDURE [REPORT].[uspGetStudentFeedback]   
(    
 @sHierarchyList varchar(MAX),    
 @iBrandID int,    
 @dtStartDate datetime,    
 @dtEndDate datetime,    
 @sCenter VARCHAR(100)=Null    
)    
AS    
 BEGIN    
  DECLARE @centerList VARCHAR(max)    
  IF @sCenter IS NOT NULL AND @sCenter <> ''    
   BEGIN    
    SELECT @centerList=COALESCE(@centerList+',','') + S_Center_Name    
    FROM    
    (    
    SELECT c.S_Center_Name FROM dbo.T_Centre_Master C WHERE c.I_Centre_Id IN    
    (     
    SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCenter, ',') AS FSR    
    )    
    )tmp       
   END    
       
  declare @StudentFeedBack Table    
  (    
   QuestionGroup Varchar(200),    
   QusetionSubGroup Varchar(200),    
   QuestionID INT,    
   Question VARCHAR(900),    
   Poor INT,    
   SoSo INT,    
   Satisfactory INT,    
   Good INT,    
   Excellent INT,    
   NA INT    
  )    
      
  INSERT @StudentFeedBack    
      
  SELECT  DISTINCT SQG.S_GroupDesc,ISNULL(SQS.S_SubGroupDesc,''),SSR.I_Survey_Question_ID,SQ.S_Question,0,0,0,0,0,0    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  LEFT OUTER JOIN STUDENTFEATURES.T_Survey_Question_SubGroups SQS ON SQ.I_SQ_SubGroups_ID=SQS.I_SQ_SubGroups_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question_Groups SQG ON SQ.I_SQ_Groups_ID=SQG.I_SQ_Groups_ID    
  WHERE (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)    
  ORDER BY SSR.I_Survey_Question_ID    
    
  UPDATE @StudentFeedBack SET Poor=PoorCount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) PoorCount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=1    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS POOR ON S.QuestionID=POOR.I_Survey_Question_ID    
      
  UPDATE @StudentFeedBack SET SoSo=SoSoCount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) SoSoCount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=2    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS SOSO ON S.QuestionID=SOSO.I_Survey_Question_ID    
      
  UPDATE @StudentFeedBack SET Satisfactory=SatisfactoryCount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) SatisfactoryCount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=3    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS Satisfactory ON S.QuestionID=Satisfactory.I_Survey_Question_ID    
    
  UPDATE @StudentFeedBack SET Good=GoodCount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) GoodCount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=4    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS GOOD ON S.QuestionID=GOOD.I_Survey_Question_ID    
    
  UPDATE @StudentFeedBack SET Excellent=ExcellentCount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) ExcellentCount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=5    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS Excellent ON S.QuestionID=Excellent.I_Survey_Question_ID    
     
  UPDATE @StudentFeedBack SET NA=NACount    
  FROM @StudentFeedBack S    
  INNER JOIN    
  (    
  SELECT  SSR.I_Survey_Question_ID,SSR.I_Weightage,COUNT(distinct SSD.I_Student_Detail_ID) NACount    
  FROM STUDENTFEATURES.T_Student_Survey_Details SSD    
  INNER JOIN STUDENTFEATURES.T_Student_Survey_Ratings SSR ON SSD.I_Student_Survey_ID=SSR.I_Student_Survey_ID    
  INNER JOIN STUDENTFEATURES.T_Survey_Question SQ ON SSR.I_Survey_Question_ID=SQ.I_Survey_Question_ID    
  INNER JOIN dbo.T_Student_Detail SD ON SSD.I_Student_Detail_ID=SD.I_Student_Detail_ID    
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID    
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1    
  ON ERD.I_Centre_Id=FN1.CenterID    
  WHERE SSR.I_Weightage=6    
  AND (DATEDIFF(DD,@dtStartDate,SSD.Dt_Crtd_On) >= 0 AND DATEDIFF(DD,@dtEndDate,SSD.Dt_Crtd_On)<= 0)     
  GROUP BY SSR.I_Survey_Question_ID,SSR.I_Weightage     
  )    
  AS NA ON S.QuestionID=NA.I_Survey_Question_ID    
    
 Select @centerList as Center,* from @StudentFeedBack    
END    
    
--EXEC [REPORT].[uspGetStudentFeedback] 1,2,'2011-06-01','2011-08-30','750,751,752'
