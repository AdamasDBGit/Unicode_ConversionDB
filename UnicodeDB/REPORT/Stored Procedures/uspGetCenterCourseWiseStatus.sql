CREATE PROCEDURE [REPORT].[uspGetCenterCourseWiseStatus]  
    (  
      @sHierarchyList varchar(max),  
      @iBrandID int,  
      @dtStartDate datetime,  
      @dtEndDate datetime    
    )  
AS   
    BEGIN    
  Declare @rCount INT=1  
  Declare @rTCount INT  
  DECLARE @CourseID INT  
  DECLARE @CenterID INT  
  DECLARE @UpSales INT=0  
  DECLARE @CrossSales INT=0  
  DECLARE @ActualSessionCnt DECIMAL(8,3)  
  DECLARE @PlannedSessionCnt DECIMAL(8,3)  
        DECLARE @TMPTBL TABLE  
            (  
     Id INT IDENTITY(1, 1),   
              I_Centre_Id INT,  
              S_Center_Code VARCHAR(50),  
              S_Center_Name VARCHAR(250),  
              I_Course_ID INT,  
              S_Course_Code VARCHAR(50),  
              S_Course_Name VARCHAR(250),  
              NO_OF_BATCHES INT,  
              ActiveStudent INT,  
              FinishedBatchStudCnt INT,  
              NoOfBatchStarted INT,  
              OnHold INT,  
              NoOfBatchNotStarted INT,  
              AtnBatchCnt DECIMAL(8,3),  
              SchdlBatchCnt INT,  
              AccademicDropOut INT,  
              FinancialDropOut INT,  
              OtherDropOut INT,  
              CertificateELleg INT,  
              Interviewed INT,  
              NoOfSelection INT,  
              ConversionEA INT,  
              ConversionRA INT,  
              UpSalse INT,  
              CrossSalse INT  
            )    
      
        INSERT  INTO @TMPTBL  
                (  
                  I_Centre_Id,  
                  S_Center_Code,  
                  S_Center_Name,  
                  I_Course_ID,  
                  S_Course_Code,  
                  S_Course_Name,  
                  NO_OF_BATCHES     
                )  
                SELECT DISTINCT  
                        CNM.I_Centre_Id,  
                        CNM.S_Center_Code,  
                        CNM.S_Center_Name,  
                        CRM.I_Course_ID,  
                        CRM.S_Course_Code,  
                        CRM.S_Course_Name,  
                        ISNULL(BATCH.NO_OF_BATCHES, 0) NO_OF_BATCHES  
                FROM    DBO.T_Centre_Master CNM  
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1 ON CNM.I_Centre_Id = FN1.centerID  
                        INNER JOIN DBO.T_Course_Center_Detail CCD ON CNM.I_Centre_Id = CCD.I_Centre_Id  
                        INNER JOIN DBO.T_Course_Master CRM ON CCD.I_Course_ID = CRM.I_Course_ID  
                        INNER JOIN ( SELECT CBD.I_Centre_Id,  
                                            SBM.I_Course_ID,  
                                            COUNT(DISTINCT CBD.I_Batch_ID) AS NO_OF_BATCHES  
                                     FROM   DBO.T_Center_Batch_Details CBD  
                                            INNER JOIN DBO.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID  
                                     WHERE  DATEDIFF(DD, @dtStartDate,  
                                                     SBM.Dt_BatchStartDate) >= 0  
                                            AND DATEDIFF(DD, @dtEndDate,  
                                                         SBM.Dt_BatchStartDate) <= 0  
                                     GROUP BY CBD.I_Centre_Id,  
                                            SBM.I_Course_ID  
                                   ) AS BATCH ON CNM.I_Centre_Id = BATCH.I_Centre_Id  
                                                 AND CRM.I_Course_ID = BATCH.I_Course_ID  
                ORDER BY CNM.S_Center_Name,  
                        CRM.S_Course_Name    
                          
                          
  
       
        UPDATE  @TMPTBL  
        SET     ActiveStudent = ISNULL(STUDENT.ActiveStudent, 0) - ISNULL(FBATCH.NO_OF_FStudent,0),  
                NoOfBatchStarted = ISNULL(BATCHSTARTED.NoOfBatchStarted, 0),  
                OnHold = ISNULL(HOLD.OnHold, 0),  
                NoOfBatchNotStarted = ISNULL(BATCHNOTSTARTED.NoOfBatchNotStarted,  
                                             0),  
  --AtnBatchCnt = ISNULL(ATTN.AtnBatchCnt, 0),  
                SchdlBatchCnt = ISNULL(SCHEDULED.SchdlBatchCnt, 0),  
                AccademicDropOut = ISNULL(ADROPOUT.AccademicDropOut, 0),  
                FinancialDropOut = ISNULL(FDROPOUT.FinancialDropOut, 0),  
                OtherDropOut = ISNULL(ODROPOUT.OtherDropOut, 0),  
                CertificateELleg = ISNULL(Certf.CertificateELleg, 0),  
                Interviewed = ISNULL(Interview.Interviewed, 0),  
                NoOfSelection = ISNULL(Selected.NoOfSelection, 0),  
                ConversionEA = ISNULL(CNV_EA.ConvertEA, 0),  
                ConversionRA = ISNULL(TST.ConvertRA, 0),  
                FinishedBatchStudCnt=ISNULL(FBATCH.NO_OF_FStudent,0)  
        FROM    @TMPTBL A  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SD.I_Student_Detail_ID) AS ActiveStudent  
                            FROM    DBO.T_Center_Batch_Details CBD  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID  
                                    INNER JOIN DBO.T_Student_Batch_Details SBD ON SBM.I_Batch_ID = SBD.I_Batch_ID  
                                    INNER JOIN DBO.T_Student_Detail SD ON SBD.I_Student_ID = SD.I_Student_Detail_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON CBD.I_Centre_Id = TSCD.I_Centre_Id  
                                                                                      AND SBD.I_Student_ID = TSCD.I_Student_Detail_ID  
                            WHERE   SBD.I_Status = 1  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS STUDENT ON A.I_Centre_Id = STUDENT.I_Centre_Id  
                                          AND A.I_Course_ID = STUDENT.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBM.I_Batch_ID) AS NoOfBatchStarted  
                            FROM    DBO.T_Center_Batch_Details CBD  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID  
                                    LEFT JOIN dbo.T_Student_Batch_Schedule SBS ON CBD.I_Batch_ID = SBS.I_Batch_ID  
                            WHERE   DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                                    AND SBS.Dt_Actual_Date IS NOT NULL  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS BATCHSTARTED ON A.I_Centre_Id = BATCHSTARTED.I_Centre_Id  
                                               AND A.I_Course_ID = BATCHSTARTED.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBM.I_Batch_ID) AS NoOfBatchNotStarted  
                            FROM    DBO.T_Center_Batch_Details CBD  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID  
                                    LEFT JOIN dbo.T_Student_Batch_Schedule SBS ON CBD.I_Batch_ID = SBS.I_Batch_ID  
                            WHERE   DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                                    AND SBS.Dt_Actual_Date IS NULL  
                                    AND SBM.I_Batch_ID NOT IN (  
                                    SELECT DISTINCT  
                                            I_Batch_ID  
                                    FROM    T_Batch_Deferment_Details BDD  
                                    WHERE   DATEDIFF(DD, @dtStartDate,  
                                                     BDD.Dt_Batch_Hold_Start_Date) >= 0  
                                            AND DATEDIFF(DD, @dtEndDate,  
                                                         BDD.Dt_Batch_Hold_End_Date) <= 0 )  
                                    AND SBM.I_Batch_ID NOT IN (  
                                    SELECT DISTINCT  
                                            I_Batch_ID  
                                    FROM    T_Student_Batch_Schedule SBS  
                                    WHERE   DATEDIFF(DD, @dtStartDate,  
                                                     SBM.Dt_BatchStartDate) >= 0  
                                            AND DATEDIFF(DD, @dtEndDate,  
                                                         SBM.Dt_BatchStartDate) <= 0  
                                            AND SBS.Dt_Actual_Date IS NOT NULL )  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS BATCHNOTSTARTED ON A.I_Centre_Id = BATCHNOTSTARTED.I_Centre_Id  
                                                  AND A.I_Course_ID = BATCHNOTSTARTED.I_Course_ID  
                LEFT JOIN ( SELECT  DD.I_Center_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBD.I_Student_ID) AccademicDropOut  
                            FROM    ACADEMICS.T_Dropout_Details DD  
                                    INNER JOIN DBO.T_Student_Batch_Details SBD ON DD.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                            WHERE   DD.I_Dropout_Status = 1  
                                    AND DD.I_Dropout_Type_ID = 1  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY DD.I_Center_Id,  
                                    SBM.I_Course_ID  
                          ) AS ADROPOUT ON A.I_Centre_Id = ADROPOUT.I_Center_Id  
                                           AND A.I_Course_ID = ADROPOUT.I_Course_ID  
                LEFT JOIN ( SELECT  DD.I_Center_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBD.I_Student_ID) FinancialDropOut  
                            FROM    ACADEMICS.T_Dropout_Details DD  
                                    INNER JOIN DBO.T_Student_Batch_Details SBD ON DD.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                            WHERE   DD.I_Dropout_Status = 1  
                                    AND DD.I_Dropout_Type_ID = 2  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY DD.I_Center_Id,  
                                    SBM.I_Course_ID  
                          ) AS FDROPOUT ON A.I_Centre_Id = FDROPOUT.I_Center_Id  
                                           AND A.I_Course_ID = FDROPOUT.I_Course_ID  
                LEFT JOIN ( SELECT  DD.I_Center_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBD.I_Student_ID) OtherDropOut  
                            FROM    ACADEMICS.T_Dropout_Details DD  
                                    INNER JOIN DBO.T_Student_Batch_Details SBD ON DD.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                            WHERE   DD.I_Dropout_Status = 1  
                                    AND DD.I_Dropout_Type_ID = 3  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY DD.I_Center_Id,  
                                    SBM.I_Course_ID  
                          ) AS ODROPOUT ON A.I_Centre_Id = ODROPOUT.I_Center_Id  
                                           AND A.I_Course_ID = ODROPOUT.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SPC.I_Course_ID,  
                                    COUNT(DISTINCT SPC.I_Student_Detail_ID) CertificateELleg  
                            FROM    PSCERTIFICATE.T_Student_PS_Certificate SPC  
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON SPC.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                                    INNER JOIN DBO.T_Center_Batch_Details CBD ON SBD.I_Batch_ID = CBD.I_Batch_ID  
                            WHERE   DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY CBD.I_Centre_Id,  
                                    SPC.I_Course_ID  
                          ) AS Certf ON A.I_Centre_Id = Certf.I_Centre_Id  
                                        AND A.I_Course_ID = Certf.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SPC.I_Student_Detail_ID) Interviewed  
                            FROM    PLACEMENT.T_Shortlisted_Students SPC  
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON SPC.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = sbm.I_Batch_ID  
                                    INNER JOIN DBO.T_Center_Batch_Details CBD ON SBD.I_Batch_ID = CBD.I_Batch_ID  
                            WHERE   DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS Interview ON A.I_Centre_Id = Interview.I_Centre_Id  
                                            AND A.I_Course_ID = Interview.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SPC.I_Student_Detail_ID) NoOfSelection  
                            FROM    PLACEMENT.T_Shortlisted_Students SPC  
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON SPC.I_Student_Detail_ID = SBD.I_Student_ID  
                                    INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = sbm.I_Batch_ID  
                                    INNER JOIN DBO.T_Center_Batch_Details CBD ON SBD.I_Batch_ID = CBD.I_Batch_ID  
                            WHERE   SPC.C_Interview_Status = 'S'  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS Selected ON A.I_Centre_Id = Selected.I_Centre_Id  
                                           AND A.I_Course_ID = Selected.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SMB.I_Course_ID,  
                                    COUNT(DISTINCT BDD.I_Batch_ID) OnHold  
                            FROM    dbo.T_Batch_Deferment_Details BDD  
                                    INNER JOIN T_Center_Batch_Details CBD ON BDD.I_Batch_ID = CBD.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Batch_Master SMB ON CBD.I_Batch_ID = SMB.I_Batch_ID  
                            WHERE   ( DATEDIFF(DD, @dtStartDate,  
                                               BDD.Dt_Batch_Hold_Start_Date) >= 0  
                                      AND DATEDIFF(DD, @dtEndDate,  
                                                   BDD.Dt_Batch_Hold_End_Date) <= 0  
                                    )  
                                    AND ( DATEDIFF(DD, @dtStartDate,  
                                                   SMB.Dt_BatchStartDate) >= 0  
                                          AND DATEDIFF(DD, @dtEndDate,  
                                                       SMB.Dt_BatchStartDate) <= 0  
                                        )  
                            GROUP BY CBD.I_Centre_Id,  
                                    SMB.I_Course_ID  
                          ) AS HOLD ON A.I_Centre_Id = HOLD.I_Centre_Id  
                                       AND A.I_Course_ID = HOLD.I_Course_ID  
                --LEFT JOIN ( SELECT  CBD.I_Centre_ID,  
                --                    SBM.I_Course_ID,  
                --                    COUNT(DISTINCT SBS.I_Batch_ID) AtnBatchCnt  
                --            FROM    T_Student_Batch_Master SBM  
                --                    INNER JOIN DBO.T_Student_Batch_Schedule SBS ON SBM.I_Batch_ID = SBS.I_Batch_ID  
                --                    INNER JOIN T_Center_Batch_Details CBD ON SBM.I_Batch_ID = CBD.I_Batch_ID  
                --            WHERE   SBS.Dt_Actual_Date IS NOT NULL  
                --                    AND DATEDIFF(DD, @dtStartDate,  
                --                                 SBM.Dt_BatchStartDate) >= 0  
                --                    AND DATEDIFF(DD, @dtEndDate,  
                --                                 SBM.Dt_BatchStartDate) <= 0  
                --            GROUP BY CBD.I_Centre_ID,  
                --                    SBM.I_Course_ID  
                --          ) AS ATTN ON A.I_Centre_Id = ATTN.I_Centre_Id  
                --                       AND A.I_Course_ID = ATTN.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_ID,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBS.I_Batch_ID) SchdlBatchCnt  
                            FROM    T_Student_Batch_Master SBM  
                                    INNER JOIN DBO.T_Student_Batch_Schedule SBS ON SBM.I_Batch_ID = SBS.I_Batch_ID  
                                    INNER JOIN T_Center_Batch_Details CBD ON SBM.I_Batch_ID = CBD.I_Batch_ID  
                            WHERE SBS.Dt_Actual_Date IS NULL  
                                    AND SBS.Dt_Schedule_Date IS NOT NULL  
                                    AND DATEDIFF(DD, @dtStartDate,  
                                                 SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                            GROUP BY CBD.I_Centre_ID,  
                                    SBM.I_Course_ID  
                          ) AS SCHEDULED ON A.I_Centre_Id = SCHEDULED.I_Centre_Id  
                                            AND A.I_Course_ID = SCHEDULED.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SD.I_Student_Detail_ID) ConvertEA  
                            FROM    dbo.T_Student_Batch_Details SBD  
                                    INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Detail SD ON SBD.I_Student_ID = SD.I_Student_Detail_ID  
                                    INNER JOIN DBO.T_Enquiry_Course EC ON SD.I_Enquiry_Regn_ID = EC.I_Enquiry_Regn_ID  
                                    INNER JOIN dbo.T_Center_Batch_Details CBD ON SBM.I_Batch_ID = CBD.I_Batch_ID  
                                                                                 AND SBM.I_Course_ID = EC.I_Course_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON CBD.I_Centre_Id = TSCD.I_Centre_Id  
                                                                                      AND SBD.I_Student_ID = TSCD.I_Student_Detail_ID  
                                    LEFT OUTER JOIN dbo.T_Student_Registration_Details  
                                    AS TSRD ON SD.I_Enquiry_Regn_ID = TSRD.I_Enquiry_Regn_ID  
                            WHERE   DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                                    AND ( TSRD.I_Enquiry_Regn_ID IS  NULL  
                                          OR TSRD.I_Status = 1  
                                        )  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) CNV_EA ON A.I_Centre_Id = CNV_EA.I_Centre_Id  
                                      AND A.I_Course_ID = CNV_EA.I_Course_ID  
                LEFT JOIN ( SELECT  CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SD.I_Student_Detail_ID) ConvertRA  
                            FROM    dbo.T_Student_Registration_Details SRD  
                                    INNER JOIN dbo.T_Student_Detail SD ON SRD.I_Enquiry_Regn_ID = sd.I_Enquiry_Regn_ID  
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID  
                                                                                  AND SRD.I_Batch_ID = SBD.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID = SBM.I_Batch_ID  
                                    INNER JOIN dbo.T_Center_Batch_Details CBD ON SBM.I_Batch_ID = CBD.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON CBD.I_Centre_Id = TSCD.I_Centre_Id  
                                                                                      AND SBD.I_Student_ID = TSCD.I_Student_Detail_ID  
                            WHERE   SRD.I_Status = 0  
                            GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                          ) AS TST ON A.I_Centre_Id = TST.I_Centre_Id  
                                      AND A.I_Course_ID = TST.I_Course_ID    
                LEFT JOIN ( SELECT CBD.I_Centre_Id,  
                                    SBM.I_Course_ID,  
                                    COUNT(DISTINCT SBD.I_Student_ID) AS NO_OF_FStudent  
                             FROM   DBO.T_Center_Batch_Details CBD  
                                    INNER JOIN DBO.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Batch_Details SBD ON SBM.I_Batch_ID = SBD.I_Batch_ID  
                                    INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON CBD.I_Centre_Id = TSCD.I_Centre_Id  
                                                                                      AND SBD.I_Student_ID = TSCD.I_Student_Detail_ID  
                             WHERE  DATEDIFF(DD, @dtStartDate,  
                                             SBM.Dt_BatchStartDate) >= 0  
                                    AND DATEDIFF(DD, @dtEndDate,  
                                                 SBM.Dt_BatchStartDate) <= 0  
                                    AND CBD.I_Status=6  
                             GROUP BY CBD.I_Centre_Id,  
                                    SBM.I_Course_ID  
                           ) AS FBATCH ON A.I_Centre_Id = FBATCH.I_Centre_Id  
                                         AND A.I_Course_ID = FBATCH.I_Course_ID  
                                           
    SELECT  @rTCount=COUNT(*) FROM  @TMPTBL  
    IF @rTCount>0  
     BEGIN  
      WHILE @rCount<=@rTCount  
       BEGIN  
        SELECT @CourseID=A.I_Course_ID,  
            @CenterID=A.I_Centre_Id   
           FROM @TMPTBL A WHERE id=@rCount  
        SELECT @UpSales=UpSales,@CrossSales=CressSales FROM [REPORT].[fnGetUpSalesCrossSales](@CenterID,@CourseID,@dtStartDate,@dtEndDate)  
        UPDATE  @TMPTBL SET UpSalse=@UpSales,CrossSalse=@CrossSales WHERE I_Centre_Id=@CenterID AND I_Course_Id=@CourseID  
          
         SELECT @PlannedSessionCnt=ISNULL(COUNT(I_Batch_Schedule_ID),0)   
         FROM [dbo].[T_Student_Batch_Schedule] SBS  
         INNER JOIN DBO.T_Student_Batch_Master SBM ON SBS.I_Batch_ID = SBM.I_Batch_ID  
         WHERE SBS.I_Centre_ID=@CenterID AND SBM.I_Course_ID=@CourseID  
          
         SELECT @ActualSessionCnt=ISNULL(COUNT(I_Batch_Schedule_ID),0)  
         FROM [dbo].[T_Student_Batch_Schedule] SBS     
         INNER JOIN DBO.T_Student_Batch_Master SBM ON SBS.I_Batch_ID = SBM.I_Batch_ID  
         Where SBS.Dt_Actual_Date IS NOT NULL     
         AND SBS.Dt_Schedule_Date<=GETDATE()  
         AND SBS.I_Centre_ID=@CenterID AND SBM.I_Course_ID=@CourseID    
           
         IF @PlannedSessionCnt>0 AND @ActualSessionCnt>0  
         BEGIN  
          UPDATE  @TMPTBL SET AtnBatchCnt=(@ActualSessionCnt/@PlannedSessionCnt) WHERE I_Centre_Id=@CenterID AND I_Course_Id=@CourseID  
         END  
  
        Set @rCount=@rCount+1  
       END  
     end    
    SELECT  * FROM  @TMPTBL               
    END   
      
 --EXEC [REPORT].[uspGetCenterCourseWiseStatus] @dtEndDate='2011-12-31',@dtStartDate='2011-06-01',@iBrandID=2,@sHierarchyList=1
