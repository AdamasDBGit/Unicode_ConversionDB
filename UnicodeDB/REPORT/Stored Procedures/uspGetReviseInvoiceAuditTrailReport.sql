CREATE PROCEDURE [REPORT].[uspGetReviseInvoiceAuditTrailReport]
    (
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @TransferType VARCHAR(MAX) ,
      @iBrandID INT ,
      @SHierarchyList VARCHAR(MAX)
    )
AS 
    BEGIN
        SELECT  *
        FROM    ( SELECT    AA.DestStud ,
                            AA.DestStdName ,
                            XX.SrcCenterID ,
                            XX.SrcCenterName ,
                            XX.SrcBatch ,
                            AA.DestCenterID ,
                            AA.DestCenter ,
                            AA.DestBatch ,
                            AA.DestCrtdOn ,
                            AA.DestInvNo ,
                            AA.DestCrtdBy ,
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
                            END AS TransferType
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
                                        TSBM.I_Course_ID AS DestCourseID
                              FROM      dbo.T_Invoice_Parent TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                        INNER JOIN dbo.T_User_Master TUM ON TIP.S_Crtd_By = TUM.S_Login_ID
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
                                                TSBM2.I_Course_ID AS SrcCourseID
                                         FROM   dbo.T_Invoice_Parent TIP2
                                                INNER JOIN dbo.T_Invoice_Child_Header TICH2 ON TIP2.I_Invoice_Header_ID = TICH2.I_Invoice_Header_ID
                                                INNER JOIN dbo.T_Invoice_Batch_Map TIBM2 ON TICH2.I_Invoice_Child_Header_ID = TIBM2.I_Invoice_Child_Header_ID
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TIBM2.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBM2.I_Batch_ID = TCBD2.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 ON TCBD2.I_Centre_Id = TCHND2.I_Center_ID
                                                INNER JOIN dbo.T_Student_Detail TSD2 ON TIP2.I_Student_Detail_ID = TSD2.I_Student_Detail_ID
                                                INNER JOIN dbo.T_User_Master TUM2 ON TIP2.S_Crtd_By = TUM2.S_Login_ID
                                         WHERE  TCHND2.I_Brand_ID = @iBrandID
                                       ) XX ON AA.DestPrntID = XX.SrcInvID
                                               AND AA.DestStdID = SrcStdID
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
                      AND ZZ.DestCrtdOn < @dtEndDate
                    )
        ORDER BY ZZ.DestCrtdOn 
                   
                   
    END
