CREATE PROCEDURE [REPORT].[uspGetStudentFeedbackReport]  
  
  
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
        FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,  
                                                         @iBrandID) FN2  
        WHERE   FN2.HierarchyDetailID IN (  
                SELECT  HierarchyDetailID  
                FROM    [fnGetCentersForReports](@sHierarchyList, @iBrandID) )   
   
   
        DECLARE @StudentFeedBack TABLE  
            (  
              FeedbackType VARCHAR(200) ,  
              QuestionGroup VARCHAR(500) ,  
              QuestionID INT ,  
              Question VARCHAR(900) ,  
              Excellent INT ,  
              VeryGood INT ,  
              Good INT ,  
              Fair INT  
            )  
        
        INSERT  @StudentFeedBack  
                SELECT  DISTINCT tftm.S_Description ,  
                        tfg.S_Description ,  
                        tfm.I_Feedback_Master_ID ,  
                        tfm.S_Feedback_Question ,  
                        0 ,  
                        0 ,  
                        0 ,  
                        0  
                FROM    ACADEMICS.T_Feedback_Master AS tfm  
                        INNER JOIN ACADEMICS.T_Feedback_Option_Master AS tfom ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID  
                        INNER JOIN ACADEMICS.T_Feedback_Type_Master AS tftm ON tftm.I_Feedback_Type_ID = tfm.I_Feedback_Type_ID  
                        INNER JOIN ACADEMICS.T_Feedback_Group AS tfg ON tfm.I_Feedback_Group_ID = tfg.I_Feedback_Group_ID  
      WHERE tfm.I_Feedback_Type_ID = ISNULL(@iFeedbackTypeID, tfm.I_Feedback_Type_ID)  
        
        UPDATE  @StudentFeedBack  
        SET     Fair = FeedbackCount  
        FROM    @StudentFeedBack S  
                INNER JOIN ( SELECT tfm.I_Feedback_Master_ID ,  
                                    I_Value ,  
                                    COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount  
                             FROM   STUDENTFEATURES.T_Student_Feedback AS tsf  
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details  
                                    AS tsfd ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Master AS tfm ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Option_Master  
                                    AS tfom ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tscd.I_Student_Detail_ID = tsf.I_Student_ID  
                             WHERE  tscd.I_Centre_Id IN (  
                                    SELECT  fnGCFR.centerID  
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
                                                              @iBrandID) fnGCFR )  
                                    AND I_Value = 4  
                                    AND ( DATEDIFF(DD, @dtStartDate,  
                                                   tsf.Dt_Crtd_On) >= 0  
                                          AND DATEDIFF(DD, @dtEndDate,  
                                                       tsf.Dt_Crtd_On) <= 0  
                                        )  
                                    AND ISNULL(I_Course_ID,0) = ISNULL(@iCourseID, ISNULL(I_Course_ID,0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)
                                    AND  ISNULL(I_Employee_ID,0) = ISNULL(@iFacultyID, ISNULL(I_Employee_ID,0))  
                           GROUP BY tfm.I_Feedback_Master_ID ,  
                                    I_Value  
                           ) AS Feedback ON S.QuestionID = Feedback.I_Feedback_Master_ID  
        
        UPDATE  @StudentFeedBack  
        SET     Good = FeedbackCount  
        FROM    @StudentFeedBack S  
                INNER JOIN ( SELECT tfm.I_Feedback_Master_ID ,  
                                    I_Value ,  
                                    COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount  
                             FROM   STUDENTFEATURES.T_Student_Feedback AS tsf  
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details  
                                    AS tsfd ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Master AS tfm ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Option_Master  
                                    AS tfom ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tscd.I_Student_Detail_ID = tsf.I_Student_ID  
                             WHERE  tscd.I_Centre_Id IN (  
                                    SELECT  fnGCFR.centerID  
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
                                                              @iBrandID) fnGCFR )  
                                    AND I_Value = 3  
                                    AND ( DATEDIFF(DD, @dtStartDate,  
                                                   tsf.Dt_Crtd_On) >= 0  
                                          AND DATEDIFF(DD, @dtEndDate,  
                                                       tsf.Dt_Crtd_On) <= 0  
                                        )  
                                    AND ISNULL(I_Course_ID,0) = ISNULL(@iCourseID, ISNULL(I_Course_ID,0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)  
                                    AND  ISNULL(I_Employee_ID,0) = ISNULL(@iFacultyID, ISNULL(I_Employee_ID,0))  
                             GROUP BY tfm.I_Feedback_Master_ID ,  
                                    I_Value  
                           ) AS Feedback ON S.QuestionID = Feedback.I_Feedback_Master_ID  
    
        UPDATE  @StudentFeedBack  
        SET     VeryGood = FeedbackCount  
        FROM    @StudentFeedBack S  
                INNER JOIN ( SELECT tfm.I_Feedback_Master_ID ,  
                                    I_Value ,  
                                    COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount  
                             FROM   STUDENTFEATURES.T_Student_Feedback AS tsf  
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details  
                                    AS tsfd ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Master AS tfm ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Option_Master  
                                    AS tfom ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tscd.I_Student_Detail_ID = tsf.I_Student_ID  
                             WHERE  tscd.I_Centre_Id IN (  
                                    SELECT  fnGCFR.centerID  
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
                                                              @iBrandID) fnGCFR )  
                                    AND I_Value = 2  
                                    AND ( DATEDIFF(DD, @dtStartDate,  
                                                   tsf.Dt_Crtd_On) >= 0  
                                          AND DATEDIFF(DD, @dtEndDate,  
                                                       tsf.Dt_Crtd_On) <= 0  
                                        )  
                                    AND ISNULL(I_Course_ID,0) = ISNULL(@iCourseID, ISNULL(I_Course_ID,0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null) 
                                    AND  ISNULL(I_Employee_ID,0) = ISNULL(@iFacultyID, ISNULL(I_Employee_ID,0))   
                             GROUP BY tfm.I_Feedback_Master_ID ,  
                                    I_Value  
                           ) AS Feedback ON S.QuestionID = Feedback.I_Feedback_Master_ID  
    
        UPDATE  @StudentFeedBack  
        SET     Excellent = FeedbackCount  
        FROM    @StudentFeedBack S  
                INNER JOIN ( SELECT tfm.I_Feedback_Master_ID ,  
                                    I_Value ,  
                                    COUNT(DISTINCT tsf.I_Student_ID) AS FeedbackCount  
                             FROM   STUDENTFEATURES.T_Student_Feedback AS tsf  
                                    INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details  
                                    AS tsfd ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Master AS tfm ON tsfd.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID  
                                    INNER JOIN ACADEMICS.T_Feedback_Option_Master  
                                    AS tfom ON tfm.I_Feedback_Master_ID = tfom.I_Feedback_Master_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tscd.I_Student_Detail_ID = tsf.I_Student_ID  
                             WHERE  tscd.I_Centre_Id IN (  
                                    SELECT  fnGCFR.centerID  
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
                                                              @iBrandID) fnGCFR )  
                                    AND I_Value = 1  
                                    AND ( DATEDIFF(DD, @dtStartDate,  
                                                   tsf.Dt_Crtd_On) >= 0  
                                          AND DATEDIFF(DD, @dtEndDate,  
                                                       tsf.Dt_Crtd_On) <= 0  
                                        )  
                                    AND ISNULL(I_Course_ID,0) = ISNULL(@iCourseID, ISNULL(I_Course_ID,0))  
                                    --AND ( I_Employee_ID = ISNULL(@iFacultyID, I_Employee_ID)  or I_Employee_ID is null)  
                                    AND  ISNULL(I_Employee_ID,0) = ISNULL(@iFacultyID, ISNULL(I_Employee_ID,0))  
                             GROUP BY tfm.I_Feedback_Master_ID ,  
                                    I_Value  
                           ) AS Feedback ON S.QuestionID = Feedback.I_Feedback_Master_ID  
      
        SELECT  @S_Instance_Chain AS S_Instance_Chain,  
                *  
        FROM    @StudentFeedBack      
  
    END
