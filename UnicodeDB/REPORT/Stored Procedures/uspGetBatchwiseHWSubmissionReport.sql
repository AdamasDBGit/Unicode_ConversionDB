CREATE PROCEDURE [REPORT].[uspGetBatchwiseHWSubmissionReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @sBatchID VARCHAR(MAX)=NULL
    )
AS 
    BEGIN
    
		IF (@sBatchID IS NOT NULL)
		BEGIN

        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TSD.I_RollNo ,
                TESM.S_Skill_Desc ,
                COUNT(DISTINCT THM.I_Homework_ID) AS AssignedHW ,
                COUNT(THS.I_Student_Detail_ID) AS SubmittedHW
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN ( SELECT T1.I_Student_ID ,
                                    T2.I_Batch_ID
                             FROM   ( SELECT    TSBD2.I_Student_ID ,
                                                MAX(TSBD2.I_Student_Batch_ID) AS ID
                                      FROM      dbo.T_Student_Batch_Details TSBD2
                                      WHERE     TSBD2.I_Status IN ( 1 )
                                      GROUP BY  TSBD2.I_Student_ID
                                    ) T1
                                    INNER JOIN ( SELECT TSBD3.I_Student_ID ,
                                                        TSBD3.I_Student_Batch_ID AS ID ,
                                                        TSBD3.I_Batch_ID
                                                 FROM   dbo.T_Student_Batch_Details TSBD3
                                                 WHERE  TSBD3.I_Status IN ( 1,
                                                              3 )
                                               ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                       AND T1.ID = T2.ID
                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                LEFT JOIN EXAMINATION.T_Homework_Master THM ON TSBD.I_Batch_ID = THM.I_Batch_ID
                LEFT JOIN dbo.T_Session_Master TSM ON THM.I_session_ID = TSM.I_Session_ID
                LEFT JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
                LEFT JOIN EXAMINATION.T_Homework_Submission THS ON THM.I_Homework_ID = THS.I_Homework_ID
                                                              AND TSD.I_Student_Detail_ID = THS.I_Student_Detail_ID
        WHERE   TCBD.I_Centre_Id IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSBM.I_Batch_ID IN (
                SELECT  CAST(FSR.Val AS INT)
                FROM    dbo.fnString2Rows(@sBatchID, ',') FSR )
                AND THM.I_Status = 1
                AND ( THM.Dt_Submission_Date >= @dtStartDate
                      AND THM.Dt_Submission_Date < DATEADD(d, 1, @dtEndDate)
                    )
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name ,
                TSD.I_RollNo ,
                TESM.S_Skill_Desc
                
                END
                
                ELSE
                
                BEGIN
                SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TSD.I_RollNo ,
                TESM.S_Skill_Desc ,
                COUNT(DISTINCT THM.I_Homework_ID) AS AssignedHW ,
                COUNT(DISTINCT THS.I_Homework_Submission_ID) AS SubmittedHW
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN ( SELECT T1.I_Student_ID ,
                                    T2.I_Batch_ID
                             FROM   ( SELECT    TSBD2.I_Student_ID ,
                                                MAX(TSBD2.I_Student_Batch_ID) AS ID
                                      FROM      dbo.T_Student_Batch_Details TSBD2
                                      WHERE     TSBD2.I_Status IN ( 1 )
                                      GROUP BY  TSBD2.I_Student_ID
                                    ) T1
                                    INNER JOIN ( SELECT TSBD3.I_Student_ID ,
                                                        TSBD3.I_Student_Batch_ID AS ID ,
                                                        TSBD3.I_Batch_ID
                                                 FROM   dbo.T_Student_Batch_Details TSBD3
                                                 WHERE  TSBD3.I_Status IN ( 1,
                                                              3 )
                                               ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                       AND T1.ID = T2.ID
                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                LEFT JOIN EXAMINATION.T_Homework_Master THM ON TSBD.I_Batch_ID = THM.I_Batch_ID
                LEFT JOIN dbo.T_Session_Master TSM ON THM.I_session_ID = TSM.I_Session_ID
                LEFT JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
                LEFT JOIN EXAMINATION.T_Homework_Submission THS ON THM.I_Homework_ID = THS.I_Homework_ID
                                                              AND TSD.I_Student_Detail_ID = THS.I_Student_Detail_ID
        WHERE   TCBD.I_Centre_Id IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND THM.I_Status = 1
                AND ( THM.Dt_Submission_Date >= @dtStartDate
                      AND THM.Dt_Submission_Date < DATEADD(d, 1, @dtEndDate)
                    )
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name ,
                TSD.I_RollNo ,
                TESM.S_Skill_Desc
                END
        
        
    END
