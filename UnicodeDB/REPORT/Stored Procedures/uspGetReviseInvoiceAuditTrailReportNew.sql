CREATE PROCEDURE [REPORT].[uspGetReviseInvoiceAuditTrailReportNew]
    (
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @TransferType VARCHAR(MAX)=NULL ,
      @iBrandID INT ,
      @SHierarchyList VARCHAR(MAX)
    )
AS 
    BEGIN
		IF (@TransferType='BranchTransfer')
		BEGIN
		
		SELECT  *
        FROM    ( SELECT    AA.DestStud ,
                            AA.DestStdName ,
                            XX.SrcCenterID ,
                            XX.SrcCenterName ,
                            XX.SrcCourseName,
                            XX.SrcBatch ,
                            AA.DestCenterID ,
                            AA.DestCenter ,
                            AA.DestCourseName,
                            AA.DestBatch ,
                            AA.DestCrtdOn ,
                            AA.DestInvNo ,
                            AA.DestCrtdBy ,
                            YY.InvReceiptAmount,
                            BB.OnAccReceiptAmount,
                            CC.TermName,
                            CASE WHEN AA.DestCenterID <> XX.SrcCenterID
                                 THEN 'BranchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID <> XX.SrcCourseID
                                 THEN 'CourseTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID <> XX.SrcBatchID
                                 THEN 'BatchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID = XX.SrcBatchID
                                 THEN 'ReviseInvoice'
                            END AS TransferType,
							'' AS S_Narration
                  FROM      ( SELECT    TSD.I_Student_Detail_ID AS DestStdID ,
                                        TSD.S_Student_ID AS DestStud ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS DestStdName ,
                                        TIP.I_Invoice_Header_ID AS DestInvID ,
                                        TIP.S_Invoice_No AS DestInvNo ,
                                        TSBM.I_Batch_ID AS DestBatchID ,
                                        TSBM.S_Batch_Name AS DestBatch ,
                                        TCHND.I_Center_ID AS DestCenterID ,
                                        TCHND.S_Center_Name AS DestCenter ,
                                        TSD.I_RollNo AS DestRoll ,
                                        TIP.Dt_Crtd_On AS DestCrtdOn ,
                                        TIP.Dt_Upd_On AS DestUpdOn ,
                                        TIP.I_Parent_Invoice_ID AS DestPrntID ,
                                        TUM.S_First_Name + ' '
                                        + ISNULL(TUM.S_Middle_Name, '') + ' '
                                        + TUM.S_Last_Name AS DestCrtdBy ,
                                        TSBM.I_Course_ID AS DestCourseID,
                                        TCM.S_Course_Name AS DestCourseName,
                                        TIP.I_Status AS DestStatus
                              FROM      dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                        INNER JOIN dbo.T_User_Master TUM ON TIP.S_Crtd_By = TUM.S_Login_ID
                                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID=TCM.I_Course_ID
                              WHERE     TCHND.I_Brand_ID = 109 AND TIP.I_Status=3 --AND TSD.S_Student_ID='1920/RICE/5019'
                            ) AA
                            INNER JOIN ( SELECT TSD2.I_Student_Detail_ID AS SrcStdID ,
                                                TSD2.S_Student_ID AS SrcStud ,
                                                TSBM2.I_Batch_ID AS SrcBatchID ,
                                                TSBM2.S_Batch_Name AS SrcBatch ,
                                                TCHND2.I_Center_ID AS SrcCenterID ,
                                                TCHND2.S_Center_Name AS SrcCenterName ,
                                                TIP2.I_Invoice_Header_ID AS SrcInvID ,
                                                TIP2.S_Invoice_No AS SrcInvNo ,
                                                TSD2.I_RollNo AS SrcRollNo ,
                                                TIP2.Dt_Crtd_On AS SrcCrtdOn ,
                                                TIP2.Dt_Upd_On AS SrcUpdOn ,
                                                TUM2.S_First_Name + ' '
                                                + ISNULL(TUM2.S_Middle_Name,
                                                         '') + ' '
                                                + TUM2.S_Last_Name AS SrcCrtdBy ,
                                                TSBM2.I_Course_ID AS SrcCourseID,
                                                TCM2.S_Course_Name AS SrcCourseName,
                                                TIP2.I_Status AS SrcStatus
                                         FROM   dbo.T_Invoice_Parent TIP2
                                                INNER JOIN dbo.T_Invoice_Child_Header TICH2 ON TIP2.I_Invoice_Header_ID = TICH2.I_Invoice_Header_ID
                                                LEFT JOIN dbo.T_Invoice_Batch_Map TIBM2 ON TICH2.I_Invoice_Child_Header_ID = TIBM2.I_Invoice_Child_Header_ID
                                                LEFT JOIN dbo.T_Student_Batch_Master TSBM2 ON TIBM2.I_Batch_ID = TSBM2.I_Batch_ID
                                                --INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBM2.I_Batch_ID = TCBD2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 ON TIP2.I_Centre_Id = TCHND2.I_Center_ID
                                                INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                INNER JOIN dbo.T_User_Master TUM2 ON TIP2.S_Crtd_By = TUM2.S_Login_ID
                                                LEFT JOIN dbo.T_Course_Master TCM2 ON TSBM2.I_Course_ID=TCM2.I_Course_ID
                                         WHERE  TCHND2.I_Brand_ID = 109 AND TIP2.I_Status=2 --AND TSD2.S_Student_ID='1920/RICE/5019'
                                       ) XX ON CONVERT(DATE,AA.DestCrtdOn)=CONVERT(DATE,XX.SrcCrtdOn) 
                                               AND AA.DestStdID = SrcStdID
                
                LEFT JOIN
                (
                SELECT TSD.S_Student_ID AS StdID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS InvReceiptAmount FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Student_Detail_ID=TIP.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TIP.I_Status IN (1,3)
                GROUP BY TSD.S_Student_ID
                ) YY ON AA.DestStud=YY.StdID
                
                
                LEFT JOIN
                (
                SELECT TSD.S_Student_ID AS StudentID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS OnAccReceiptAmount,CONVERT(DATE,TRH.Dt_Crtd_On) AS ReceiptDate FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NULL AND TRH.I_Receipt_Type IN (33,40,41)
                GROUP BY TSD.S_Student_ID,CONVERT(DATE,TRH.Dt_Crtd_On)
                ) BB ON AA.DestStud=BB.StudentID AND CONVERT(DATE,AA.DestCrtdOn)=BB.ReceiptDate
                
                
                
                LEFT JOIN
                (
                
                SELECT EE.S_Student_ID AS StudID,TTM2.S_Term_Name AS TermName FROM
                (
                SELECT TSD.S_Student_ID,MAX(TSA.I_TimeTable_ID) AS TimeTableID FROM dbo.T_Student_Attendance TSA
                INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TSA.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE TTTM.I_Session_ID IS NOT NULL AND TTTM.I_Status=1
                GROUP BY TSD.S_Student_ID
                ) EE
                INNER JOIN
                (
                SELECT TTTM.I_TimeTable_ID,TTM.I_Term_ID FROM
                dbo.T_TimeTable_Master TTTM
                INNER JOIN dbo.T_Term_Master TTM ON TTTM.I_Term_ID = TTM.I_Term_ID
                WHERE
                TTTM.I_Status=1 AND TTTM.I_Session_ID IS NOT NULL
                ) FF ON EE.TimeTableID=FF.I_TimeTable_ID
                LEFT JOIN dbo.T_Term_Master TTM2 ON FF.I_Term_ID = TTM2.I_Term_ID
                ) CC ON AA.DestStud=CC.StudID 
                ) ZZ
 
            WHERE   ZZ.TransferType LIKE @TransferType
                AND ( ZZ.SrcCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                      OR ZZ.DestCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                    )
                AND ( ZZ.DestCrtdOn >= @dtStartDate
                      AND ZZ.DestCrtdOn < DATEADD(d,1,@dtEndDate)
                    )
         ORDER BY ZZ.DestCrtdOn            
		
		END
		ELSE IF (@TransferType!='ALL' AND @TransferType!='BranchTransfer')
		BEGIN
        SELECT  *
        FROM    ( SELECT    AA.DestStud ,
                            AA.DestStdName ,
                            XX.SrcCenterID ,
                            XX.SrcCenterName ,
                            XX.SrcCourseName,
                            XX.SrcBatch ,
                            AA.DestCenterID ,
                            AA.DestCenter ,
                            AA.DestCourseName,
                            AA.DestBatch ,
                            AA.DestCrtdOn ,
                            AA.DestInvNo ,
                            AA.DestCrtdBy ,
                            YY.InvReceiptAmount,
                            BB.OnAccReceiptAmount,
                            CC.TermName,
                            CASE WHEN AA.DestCenterID <> XX.SrcCenterID
                                 THEN 'BranchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID <> XX.SrcCourseID
                                 THEN 'CourseTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID <> XX.SrcBatchID
                                 THEN 'BatchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID = XX.SrcBatchID
                                 THEN 'ReviseInvoice'
                            END AS TransferType,
							XX.S_Narration
                  FROM      ( SELECT    TSD.I_Student_Detail_ID AS DestStdID ,
                                        TSD.S_Student_ID AS DestStud ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS DestStdName ,
                                        TIP.I_Invoice_Header_ID AS DestInvID ,
                                        TIP.S_Invoice_No AS DestInvNo ,
                                        TSBM.I_Batch_ID AS DestBatchID ,
                                        TSBM.S_Batch_Name AS DestBatch ,
                                        TCHND.I_Center_ID AS DestCenterID ,
                                        TCHND.S_Center_Name AS DestCenter ,
                                        TSD.I_RollNo AS DestRoll ,
                                        TIP.Dt_Crtd_On AS DestCrtdOn ,
                                        TIP.Dt_Upd_On AS DestUpdOn ,
                                        TIP.I_Parent_Invoice_ID AS DestPrntID ,
                                        TUM.S_First_Name + ' '
                                        + ISNULL(TUM.S_Middle_Name, '') + ' '
                                        + TUM.S_Last_Name AS DestCrtdBy ,
                                        TSBM.I_Course_ID AS DestCourseID,
                                        TCM.S_Course_Name AS DestCourseName,
                                        TIP.I_Status AS DestStatus
                              FROM      dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                        INNER JOIN dbo.T_User_Master TUM ON TIP.S_Crtd_By = TUM.S_Login_ID
                                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID=TCM.I_Course_ID
                              WHERE     TCHND.I_Brand_ID = @iBrandID
                            ) AA
                            INNER JOIN ( SELECT TSD2.I_Student_Detail_ID AS SrcStdID ,
                                                TSD2.S_Student_ID AS SrcStud ,
                                                TSBM2.I_Batch_ID AS SrcBatchID ,
                                                TSBM2.S_Batch_Name AS SrcBatch ,
                                                TCHND2.I_Center_ID AS SrcCenterID ,
                                                TCHND2.S_Center_Name AS SrcCenterName ,
                                                TIP2.I_Invoice_Header_ID AS SrcInvID ,
                                                TIP2.S_Invoice_No AS SrcInvNo ,
                                                TSD2.I_RollNo AS SrcRollNo ,
                                                TIP2.Dt_Crtd_On AS SrcCrtdOn ,
                                                TIP2.Dt_Upd_On AS SrcUpdOn ,
                                                TUM2.S_First_Name + ' '
                                                + ISNULL(TUM2.S_Middle_Name,
                                                         '') + ' '
                                                + TUM2.S_Last_Name AS SrcCrtdBy ,
                                                TSBM2.I_Course_ID AS SrcCourseID,
                                                TCM2.S_Course_Name AS SrcCourseName,
                                                TIP2.I_Status AS SrcStatus,
												TIP2.S_Narration
                                         FROM   dbo.T_Invoice_Parent TIP2
                                                INNER JOIN dbo.T_Invoice_Child_Header TICH2 ON TIP2.I_Invoice_Header_ID = TICH2.I_Invoice_Header_ID
                                                INNER JOIN dbo.T_Invoice_Batch_Map TIBM2 ON TICH2.I_Invoice_Child_Header_ID = TIBM2.I_Invoice_Child_Header_ID
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TIBM2.I_Batch_ID = TSBM2.I_Batch_ID
                                                --INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBM2.I_Batch_ID = TCBD2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 ON TIP2.I_Centre_Id = TCHND2.I_Center_ID
                                                INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                INNER JOIN dbo.T_User_Master TUM2 ON TIP2.S_Crtd_By = TUM2.S_Login_ID
                                                INNER JOIN dbo.T_Course_Master TCM2 ON TSBM2.I_Course_ID=TCM2.I_Course_ID
                                         WHERE  TCHND2.I_Brand_ID = @iBrandID
                                       ) XX ON AA.DestPrntID = XX.SrcInvID --OR (CONVERT(DATE,AA.DestCrtdOn)=CONVERT(DATE,XX.SrcCrtdOn)) 
                                               AND AA.DestStdID = SrcStdID
                
                LEFT JOIN
                (
                SELECT TSD.S_Student_ID AS StdID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS InvReceiptAmount FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Student_Detail_ID=TIP.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TIP.I_Status IN (1,3)
                GROUP BY TSD.S_Student_ID
                ) YY ON AA.DestStud=YY.StdID
                LEFT JOIN
                (
                SELECT TSD.S_Student_ID AS StudentID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS OnAccReceiptAmount,CONVERT(DATE,TRH.Dt_Crtd_On) AS ReceiptDate FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NULL AND TRH.I_Receipt_Type IN (33,40,41)
                GROUP BY TSD.S_Student_ID,CONVERT(DATE,TRH.Dt_Crtd_On)
                ) BB ON AA.DestStud=BB.StudentID AND CONVERT(DATE,AA.DestCrtdOn)=BB.ReceiptDate
                LEFT JOIN
                (
                
                SELECT EE.S_Student_ID AS StudID,TTM2.S_Term_Name AS TermName FROM
                (
                SELECT TSD.S_Student_ID,MAX(TSA.I_TimeTable_ID) AS TimeTableID FROM dbo.T_Student_Attendance TSA
                INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TSA.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE TTTM.I_Session_ID IS NOT NULL AND TTTM.I_Status=1
                GROUP BY TSD.S_Student_ID
                ) EE
                INNER JOIN
                (
                SELECT TTTM.I_TimeTable_ID,TTM.I_Term_ID FROM
                dbo.T_TimeTable_Master TTTM
                INNER JOIN dbo.T_Term_Master TTM ON TTTM.I_Term_ID = TTM.I_Term_ID
                WHERE
                TTTM.I_Status=1 AND TTTM.I_Session_ID IS NOT NULL
                ) FF ON EE.TimeTableID=FF.I_TimeTable_ID
                INNER JOIN dbo.T_Term_Master TTM2 ON FF.I_Term_ID = TTM2.I_Term_ID
                ) CC ON AA.DestStud=CC.StudID 
                ) ZZ
 
            WHERE   ZZ.TransferType LIKE @TransferType
                AND ( ZZ.SrcCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                      OR ZZ.DestCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                    )
                AND ( ZZ.DestCrtdOn >= @dtStartDate
                      AND ZZ.DestCrtdOn < DATEADD(d,1,@dtEndDate)
                    )
        ORDER BY ZZ.DestCrtdOn 
        END
        ELSE IF (@TransferType='ALL')
        BEGIN
                SELECT  *
        FROM    ( SELECT    AA.DestStud ,
                            AA.DestStdName ,
                            XX.SrcCenterID ,
                            XX.SrcCenterName ,
                            XX.SrcCourseName,
                            XX.SrcBatch ,
                            AA.DestCenterID ,
                            AA.DestCenter ,
                            AA.DestCourseName,
                            AA.DestBatch ,
                            AA.DestCrtdOn ,
                            AA.DestInvNo ,
                            AA.DestCrtdBy ,
                            YY.InvReceiptAmount,
                            BB.OnAccReceiptAmount,
                            CC.TermName,
                            CASE WHEN AA.DestCenterID <> XX.SrcCenterID
                                 THEN 'BranchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID <> XX.SrcCourseID
                                 THEN 'CourseTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID <> XX.SrcBatchID
                                 THEN 'BatchTransfer'
                                 WHEN AA.DestCenterID = XX.SrcCenterID
                                      AND AA.DestCourseID = XX.SrcCourseID
                                      AND AA.DestBatchID = XX.SrcBatchID
                                 THEN 'ReviseInvoice'
                            END AS TransferType,
							XX.S_Narration
                  FROM      ( SELECT    TSD.I_Student_Detail_ID AS DestStdID ,
                                        TSD.S_Student_ID AS DestStud ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS DestStdName ,
                                        TIP.I_Invoice_Header_ID AS DestInvID ,
                                        TIP.S_Invoice_No AS DestInvNo ,
                                        TSBM.I_Batch_ID AS DestBatchID ,
                                        TSBM.S_Batch_Name AS DestBatch ,
                                        TCHND.I_Center_ID AS DestCenterID ,
                                        TCHND.S_Center_Name AS DestCenter ,
                                        TSD.I_RollNo AS DestRoll ,
                                        TIP.Dt_Crtd_On AS DestCrtdOn ,
                                        TIP.Dt_Upd_On AS DestUpdOn ,
                                        TIP.I_Parent_Invoice_ID AS DestPrntID ,
                                        TUM.S_First_Name + ' '
                                        + ISNULL(TUM.S_Middle_Name, '') + ' '
                                        + TUM.S_Last_Name AS DestCrtdBy ,
                                        TSBM.I_Course_ID AS DestCourseID,
                                        TCM.S_Course_Name AS DestCourseName
                              FROM      dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                        INNER JOIN dbo.T_User_Master TUM ON TIP.S_Crtd_By = TUM.S_Login_ID
                                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID=TCM.I_Course_ID
                              WHERE     TCHND.I_Brand_ID = @iBrandID
                            ) AA
                            INNER JOIN ( SELECT TSD2.I_Student_Detail_ID AS SrcStdID ,
                                                TSD2.S_Student_ID AS SrcStud ,
                                                TSBM2.I_Batch_ID AS SrcBatchID ,
                                                TSBM2.S_Batch_Name AS SrcBatch ,
                                                TCHND2.I_Center_ID AS SrcCenterID ,
                                                TCHND2.S_Center_Name AS SrcCenterName ,
                                                TIP2.I_Invoice_Header_ID AS SrcInvID ,
                                                TIP2.S_Invoice_No AS SrcInvNo ,
                                                TSD2.I_RollNo AS SrcRollNo ,
                                                TIP2.Dt_Crtd_On AS SrcCrtdOn ,
                                                TIP2.Dt_Upd_On AS SrcUpdOn ,
                                                TUM2.S_First_Name + ' '
                                                + ISNULL(TUM2.S_Middle_Name,
                                                         '') + ' '
                                                + TUM2.S_Last_Name AS SrcCrtdBy ,
                                                TSBM2.I_Course_ID AS SrcCourseID,
                                                TCM2.S_Course_Name AS SrcCourseName,
												TIP2.S_Narration
                                         FROM   dbo.T_Invoice_Parent TIP2
                                                INNER JOIN dbo.T_Invoice_Child_Header TICH2 ON TIP2.I_Invoice_Header_ID = TICH2.I_Invoice_Header_ID
                                                INNER JOIN dbo.T_Invoice_Batch_Map TIBM2 ON TICH2.I_Invoice_Child_Header_ID = TIBM2.I_Invoice_Child_Header_ID
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TIBM2.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBM2.I_Batch_ID = TCBD2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 ON TCBD2.I_Centre_Id = TCHND2.I_Center_ID
                                                INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                INNER JOIN dbo.T_User_Master TUM2 ON TIP2.S_Crtd_By = TUM2.S_Login_ID
                                                INNER JOIN dbo.T_Course_Master TCM2 ON TSBM2.I_Course_ID=TCM2.I_Course_ID
                                         WHERE  TCHND2.I_Brand_ID = @iBrandID
                                       ) XX ON AA.DestPrntID = XX.SrcInvID
                                               AND AA.DestStdID = SrcStdID
                
                INNER JOIN
                (
                SELECT TSD.S_Student_ID AS StdID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS InvReceiptAmount FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Parent TIP ON TRH.I_Student_Detail_ID=TIP.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TIP.I_Status IN (1,3)
                GROUP BY TSD.S_Student_ID
                ) YY ON AA.DestStud=YY.StdID
                LEFT JOIN
                (
                SELECT TSD.S_Student_ID AS StudentID,SUM(ISNULL(TRH.N_Receipt_Amount,0.0)+ISNULL(TRH.N_Tax_Amount,0.0)) AS OnAccReceiptAmount,CONVERT(DATE,TRH.Dt_Crtd_On) AS ReceiptDate FROM dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE
                TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NULL AND TRH.I_Receipt_Type IN (33,40,41)
                GROUP BY TSD.S_Student_ID,CONVERT(DATE,TRH.Dt_Crtd_On)
                ) BB ON AA.DestStud=BB.StudentID AND CONVERT(DATE,AA.DestCrtdOn)=BB.ReceiptDate
                LEFT JOIN
                (
                
                SELECT EE.S_Student_ID AS StudID,TTM2.S_Term_Name AS TermName FROM
                (
                SELECT TSD.S_Student_ID,MAX(TSA.I_TimeTable_ID) AS TimeTableID FROM dbo.T_Student_Attendance TSA
                INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TSA.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE TTTM.I_Session_ID IS NOT NULL AND TTTM.I_Status=1
                GROUP BY TSD.S_Student_ID
                ) EE
                INNER JOIN
                (
                SELECT TTTM.I_TimeTable_ID,TTM.I_Term_ID FROM
                dbo.T_TimeTable_Master TTTM
                INNER JOIN dbo.T_Term_Master TTM ON TTTM.I_Term_ID = TTM.I_Term_ID
                WHERE
                TTTM.I_Status=1 AND TTTM.I_Session_ID IS NOT NULL
                ) FF ON EE.TimeTableID=FF.I_TimeTable_ID
                INNER JOIN dbo.T_Term_Master TTM2 ON FF.I_Term_ID = TTM2.I_Term_ID
                ) CC ON AA.DestStud=CC.StudID 
                ) ZZ
 
            WHERE   
            --ZZ.TransferType LIKE @TransferType
                ( ZZ.SrcCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                      OR ZZ.DestCenterID IN (
                      SELECT    FGCFR.centerID
                      FROM      dbo.fnGetCentersForReports(@SHierarchyList,
                                                           @iBrandID) FGCFR )
                    )
                AND ( ZZ.DestCrtdOn >= @dtStartDate
                      AND ZZ.DestCrtdOn < DATEADD(d,1,@dtEndDate)
                    )
        ORDER BY ZZ.DestCrtdOn 
        END           
                   
    END
