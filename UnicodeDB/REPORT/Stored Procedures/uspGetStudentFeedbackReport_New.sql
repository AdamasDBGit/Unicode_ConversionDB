CREATE PROCEDURE [REPORT].[uspGetStudentFeedbackReport_New]  
  
  
--exec REPORT.uspGetStudentFeedbackReport '1',109,'2013-09-24','2013-09-26',3,11,null  
    (  
      @sHierarchyList VARCHAR(MAX) ,  
      @iBrandID INT ,  
      @dtStartDate DATE = NULL ,  
      @dtEndDate DATE = NULL,  
      @iFeedbackTypeID INT = NULL,  
      @iCourseID INT = NULL,  
      @iFacultyID INT = NULL  
    )  
AS   
    BEGIN  
        DECLARE @S_Instance_Chain VARCHAR(500)  
        
        SELECT TOP 1
        @S_Instance_Chain = FN2.instanceChain
FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
WHERE   FN2.HierarchyDetailID IN (
        SELECT  HierarchyDetailID
        FROM    [fnGetCentersForReports](@sHierarchyList, @iBrandID) )   
   
   
CREATE TABLE #StudentFeedBack
    (
		I_ID INT IDENTITY(1,1),
      FeedbackType VARCHAR(200) ,
      I_Student_Feedback_ID INT ,
      CourseorFaculty VARCHAR(500) ,
      QuestionGroup VARCHAR(500) ,
      QuestionID INT ,
      Question VARCHAR(900) ,
      Excellent INT ,
      VeryGood INT ,
      Good INT ,
      Fair INT
    )  
   ALTER TABLE #StudentFeedBack ADD PRIMARY KEY CLUSTERED (I_ID)     
   
INSERT  #StudentFeedBack
        SELECT  DISTINCT
                tftm.S_Description ,
                tsf.I_Student_Feedback_ID ,
                CASE WHEN TCM.I_Course_ID IS NULL
                     THEN ed.S_First_Name + ' ' + ISNULL(ed.S_Middle_Name, '')
                          + ed.S_Last_Name
                     ELSE tcm.S_Course_Name
                END CourseorFaculty ,
                tfg.S_Description ,
                tfm.I_Feedback_Master_ID ,
                tfm.S_Feedback_Question ,
                0 ,
                0 ,
                0 ,
                0
        FROM    ACADEMICS.T_Feedback_Master AS tfm WITH ( NOLOCK )
                INNER JOIN ACADEMICS.T_Feedback_Option_Master AS tfom WITH ( NOLOCK ) ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID
                INNER JOIN ACADEMICS.T_Feedback_Type_Master AS tftm WITH ( NOLOCK ) ON tftm.I_Feedback_Type_ID = tfm.I_Feedback_Type_ID
                INNER JOIN ACADEMICS.T_Feedback_Group AS tfg WITH ( NOLOCK ) ON tfm.I_Feedback_Group_ID = tfg.I_Feedback_Group_ID
                INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details TSFD
                WITH ( NOLOCK ) ON TSFD.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                   AND tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID
                INNER JOIN STUDENTFEATURES.T_Student_Feedback TSF WITH ( NOLOCK ) ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID
                LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TCM.I_Course_ID = tsf.I_Course_ID
                LEFT JOIN dbo.T_Employee_Dtls ED WITH ( NOLOCK ) ON ed.I_Employee_ID = tsf.I_Employee_ID
        WHERE   tfm.I_Feedback_Type_ID = ISNULL(@iFeedbackTypeID,
                                                tfm.I_Feedback_Type_ID)
                AND ( DATEDIFF(DD, @dtStartDate, tsf.Dt_Crtd_On) >= 0
                      AND DATEDIFF(DD, @dtEndDate, tsf.Dt_Crtd_On) <= 0
                    )
                AND ISNULL(tsf.I_Course_ID, 0) = ISNULL(@iCourseID,
                                                        ISNULL(tsf.I_Course_ID,
                                                              0))
                AND ISNULL(tsf.I_Employee_ID, 0) = ISNULL(@iFacultyID,
                                                          ISNULL(tsf.I_Employee_ID,
                                                              0))  
        
       
       
CREATE NONCLUSTERED INDEX [NC_#StudentFeedBack]
ON #StudentFeedBack([I_Student_Feedback_ID],[QuestionID])



       
UPDATE  #StudentFeedBack
SET     Fair = FeedbackCount
FROM    #StudentFeedBack S
        CROSS APPLY ( SELECT    tfm.I_Feedback_Master_ID ,
                                I_Value ,
                                COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount
                      FROM      STUDENTFEATURES.T_Student_Feedback AS tsf WITH ( NOLOCK )
                                INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details
                                AS tsfd WITH ( NOLOCK ) ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID
                                INNER JOIN ACADEMICS.T_Feedback_Master AS tfm
                                WITH ( NOLOCK ) ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                                   AND tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                INNER JOIN ACADEMICS.T_Feedback_Option_Master
                                AS tfom WITH ( NOLOCK ) ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID
                                                           AND tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID
                                INNER JOIN dbo.T_Student_Center_Detail AS tscd
                                WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsf.I_Student_ID
                      WHERE     tscd.I_Centre_Id IN (
                                SELECT  fnGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fnGCFR )
                                AND I_Value = 4
                                AND ( DATEDIFF(DD, @dtStartDate,
                                               tsf.Dt_Crtd_On) >= 0
                                      AND DATEDIFF(DD, @dtEndDate,
                                                   tsf.Dt_Crtd_On) <= 0
                                    )
                                AND ISNULL(I_Course_ID, 0) = ISNULL(@iCourseID,
                                                              ISNULL(I_Course_ID,
                                                              0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)
                                AND ISNULL(I_Employee_ID, 0) = ISNULL(@iFacultyID,
                                                              ISNULL(I_Employee_ID,
                                                              0))
                                AND S.QuestionID = tfm.I_Feedback_Master_ID
                                AND S.I_Student_Feedback_ID = tsf.I_Student_Feedback_ID
                      GROUP BY  tfm.I_Feedback_Master_ID ,
                                I_Value
                    ) AS Feedback 
        
UPDATE  #StudentFeedBack
SET     Good = FeedbackCount
FROM    #StudentFeedBack S
        CROSS APPLY ( SELECT    tfm.I_Feedback_Master_ID ,
                                I_Value ,
                                COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount
                      FROM      STUDENTFEATURES.T_Student_Feedback AS tsf WITH ( NOLOCK )
                                INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details
                                AS tsfd WITH ( NOLOCK ) ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID
                                INNER JOIN ACADEMICS.T_Feedback_Master AS tfm
                                WITH ( NOLOCK ) ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                                   AND tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                INNER JOIN ACADEMICS.T_Feedback_Option_Master
                                AS tfom WITH ( NOLOCK ) ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID
                                                           AND tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID
                                INNER JOIN dbo.T_Student_Center_Detail AS tscd
                                WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsf.I_Student_ID
                      WHERE     tscd.I_Centre_Id IN (
                                SELECT  fnGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fnGCFR )
                                AND I_Value = 3
                                AND ( DATEDIFF(DD, @dtStartDate,
                                               tsf.Dt_Crtd_On) >= 0
                                      AND DATEDIFF(DD, @dtEndDate,
                                                   tsf.Dt_Crtd_On) <= 0
                                    )
                                AND ISNULL(I_Course_ID, 0) = ISNULL(@iCourseID,
                                                              ISNULL(I_Course_ID,
                                                              0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)  
                                AND ISNULL(I_Employee_ID, 0) = ISNULL(@iFacultyID,
                                                              ISNULL(I_Employee_ID,
                                                              0))
                                AND S.QuestionID = tfm.I_Feedback_Master_ID
                                AND S.I_Student_Feedback_ID = tsf.I_Student_Feedback_ID
                      GROUP BY  tfm.I_Feedback_Master_ID ,
                                I_Value
                    ) AS Feedback  
    
UPDATE  #StudentFeedBack
SET     VeryGood = FeedbackCount
FROM    #StudentFeedBack S
        CROSS APPLY ( SELECT    tfm.I_Feedback_Master_ID ,
                                I_Value ,
                                COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount
                      FROM      STUDENTFEATURES.T_Student_Feedback AS tsf WITH ( NOLOCK )
                                INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details
                                AS tsfd WITH ( NOLOCK ) ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID
                                INNER JOIN ACADEMICS.T_Feedback_Master AS tfm
                                WITH ( NOLOCK ) ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                                   AND tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                INNER JOIN ACADEMICS.T_Feedback_Option_Master
                                AS tfom WITH ( NOLOCK ) ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID
                                                           AND tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID
                                INNER JOIN dbo.T_Student_Center_Detail AS tscd
                                WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsf.I_Student_ID
                      WHERE     tscd.I_Centre_Id IN (
                                SELECT  fnGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fnGCFR )
                                AND I_Value = 2
                                AND ( DATEDIFF(DD, @dtStartDate,
                                               tsf.Dt_Crtd_On) >= 0
                                      AND DATEDIFF(DD, @dtEndDate,
                                                   tsf.Dt_Crtd_On) <= 0
                                    )
                                AND ISNULL(I_Course_ID, 0) = ISNULL(@iCourseID,
                                                              ISNULL(I_Course_ID,
                                                              0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null) 
                                AND ISNULL(I_Employee_ID, 0) = ISNULL(@iFacultyID,
                                                              ISNULL(I_Employee_ID,
                                                              0))
                                AND S.QuestionID = tfm.I_Feedback_Master_ID
                                AND S.I_Student_Feedback_ID = tsf.I_Student_Feedback_ID
                      GROUP BY  tfm.I_Feedback_Master_ID ,
                                I_Value
                    ) AS Feedback 
    
UPDATE  #StudentFeedBack
SET     Excellent = FeedbackCount
FROM    #StudentFeedBack S
        CROSS APPLY ( SELECT    tfm.I_Feedback_Master_ID ,
                                I_Value ,
                                COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount
                      FROM      STUDENTFEATURES.T_Student_Feedback AS tsf WITH ( NOLOCK )
                                INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details
                                AS tsfd WITH ( NOLOCK ) ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID
                                INNER JOIN ACADEMICS.T_Feedback_Master AS tfm
                                WITH ( NOLOCK ) ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                                   AND tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID
                                INNER JOIN ACADEMICS.T_Feedback_Option_Master
                                AS tfom WITH ( NOLOCK ) ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID
                                                           AND tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID
                                INNER JOIN dbo.T_Student_Center_Detail AS tscd
                                WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsf.I_Student_ID
                      WHERE     tscd.I_Centre_Id IN (
                                SELECT  fnGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fnGCFR )
                                AND I_Value = 1
                                AND ( DATEDIFF(DD, @dtStartDate,
                                               tsf.Dt_Crtd_On) >= 0
                                      AND DATEDIFF(DD, @dtEndDate,
                                                   tsf.Dt_Crtd_On) <= 0
                                    )
                                AND ISNULL(I_Course_ID, 0) = ISNULL(@iCourseID,
                                                              ISNULL(I_Course_ID,
                                                              0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)  
                                AND ISNULL(I_Employee_ID, 0) = ISNULL(@iFacultyID,
                                                              ISNULL(I_Employee_ID,
                                                              0))
                                AND S.QuestionID = tfm.I_Feedback_Master_ID
                                AND S.I_Student_Feedback_ID = tsf.I_Student_Feedback_ID
                      GROUP BY  tfm.I_Feedback_Master_ID ,
                                I_Value
                    ) AS Feedback  
      
SELECT  @S_Instance_Chain AS S_Instance_Chain ,
        *
FROM    #StudentFeedBack  
        
DROP TABLE #StudentFeedBack       
  
    END
