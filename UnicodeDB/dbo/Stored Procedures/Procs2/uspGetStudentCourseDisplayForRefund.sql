CREATE PROCEDURE [dbo].[uspGetStudentCourseDisplayForRefund] --3166,20428        
    @iStudentID INT ,        
    @iInvoiceID INT = NULL        
AS         
    BEGIN                                      
              
        SELECT  T1.I_Course_ID ,        
                T1.S_Course_Name ,        
                T1.I_Batch_ID ,        
                T1.S_Batch_Code ,        
                T1.S_Batch_Name ,        
                T1.I_Fee_Component_ID ,        
                S_Component_Name ,        
                0 AS I_Total_Sessions ,        
                0 AS I_Completed_Sessions ,        
                0.0 AS PercentageComplete ,        
                TotalAmount ,        
                ISNULL(AmountPaid, 0) AS AmountPaid ,        
                ISNULL(TaxPaid, 0) AS TaxPaid        
        INTO    #temp        
        FROM    ( SELECT    T.I_Course_ID ,        
                            T.S_Course_Name ,        
                            T.I_Batch_ID ,        
                            T.S_Batch_Code ,        
                            T.S_Batch_Name ,        
                            T.I_Fee_Component_ID ,        
                            T.S_Component_Name ,        
                            SUM(N_Amount_Due) + SUM(N_Tax_Value) AS TotalAmount        
                  FROM      ( SELECT    TICH.I_Course_ID ,        
                                        TCM.S_Course_Name ,        
                                        TIBM.I_Batch_ID ,        
                                        TSBM.S_Batch_Code ,        
                                        TSBM.S_Batch_Name ,        
                                        TICD.I_Fee_Component_ID ,        
                                        TFCM.S_Component_Name ,        
                                        N_Amount_Due ,        
                                        TICD.I_Invoice_Detail_ID ,        
                                        ISNULL(SUM(N_Tax_Value), 0) AS N_Tax_Value        
                              FROM      dbo.T_Invoice_Child_Detail TICD        
                                        INNER JOIN dbo.T_Invoice_Child_Header        
                                        AS TICH ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID        
                                        LEFT outer join dbo.T_Course_Master AS TCM ON TICH.I_Course_ID = TCM.I_Course_ID        
                                        LEFT outer JOIN dbo.T_Invoice_Batch_Map AS TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID  AND TIBM.I_Status = 1           
                                        LEFT outer JOIN dbo.T_Student_Batch_Master        
                                        AS TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID        
                                        INNER JOIN dbo.T_Invoice_Parent AS TIP ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID        
                                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID        
                                        LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax        
                                        AS TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID        
                              WHERE     TICH.I_Invoice_Header_ID = @iInvoiceID        
                                          
                              GROUP BY  TICH.I_Course_ID ,        
                                        TCM.S_Course_Name ,        
                                        TIBM.I_Batch_ID ,        
                                        TSBM.S_Batch_Code ,        
                                        TSBM.S_Batch_Name ,        
                                        TICD.I_Fee_Component_ID ,        
                                        TFCM.S_Component_Name ,        
                                        N_Amount_Due ,        
                                        TICD.I_Invoice_Detail_ID                                    ) T        
                  GROUP BY  T.I_Course_ID ,        
                            T.S_Course_Name ,        
                            T.I_Batch_ID ,        
                            T.S_Batch_Code ,        
                            T.S_Batch_Name ,        
                            T.I_Fee_Component_ID ,        
                            T.S_Component_Name        
   ) T1        
                LEFT OUTER JOIN ( SELECT    T.I_Fee_Component_ID ,        
                                            SUM(N_Amount_Paid)        
                                            + SUM(N_Tax_Paid) AS AmountPaid ,        
                                            SUM(N_Tax_Paid) AS TaxPaid        
                                  FROM      ( SELECT    I_Fee_Component_ID ,        
                                                        TRCD.I_Invoice_Detail_ID ,        
                                                        N_Amount_Paid ,        
                                                        ISNULL(SUM(N_Tax_Paid),        
                                                              0) N_Tax_Paid        
                                              FROM      dbo.T_Receipt_Component_Detail        
                                                        AS TRCD        
                                                        LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail        
                                                        AS TRTD ON TRCD.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID        
                                                        INNER JOIN dbo.T_Receipt_Header        
                                                        AS TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID        
                                                        INNER JOIN dbo.T_Invoice_Child_Detail        
                                                        AS TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID        
                                                        INNER JOIN dbo.T_Invoice_Child_Header        
                                                        AS TICH ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID        
                                                        INNER JOIN dbo.T_Invoice_Parent        
                                                        AS TIP2 ON TICH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID        
                                              WHERE     TICH.I_Invoice_Header_ID = @iInvoiceID        
                                                        AND TRH.I_Status = 1        
                                              GROUP BY  I_Fee_Component_ID ,        
                                                        TRCD.I_Invoice_Detail_ID ,        
                                                        N_Amount_Paid        
                                            ) T        
                                  GROUP BY  T.I_Fee_Component_ID        
                                ) T2 ON T1.I_Fee_Component_ID = T2.I_Fee_Component_ID              
              
              
        DELETE  FROM #temp        
        WHERE   TotalAmount = 0.0                                      
                                      
        UPDATE  T2        
        SET     T2.I_Completed_Sessions = T1.[SessionCompleted]        
        FROM    #temp AS T2        
                INNER JOIN ( SELECT TSBM.I_Course_ID ,        
                                    SCD.I_Batch_ID ,        
                                    COUNT(SBS.I_TimeTable_ID) AS [SessionCompleted]        
                             FROM   dbo.T_TimeTable_Master SBS        
                                    INNER JOIN dbo.T_Student_Batch_Details AS SCD ON SBS.I_Batch_ID = SCD.I_Batch_ID                                        
--AND SBS.I_Centre_ID = SCD.I_Centre_Id                  
                                    INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON SCD.I_Batch_ID = TSBM.I_Batch_ID        
                             WHERE  SCD.I_Student_ID = @iStudentID        
                                    AND SCD.I_Status = 1        
                                    AND SBS.I_Is_Complete = 1        
                                    AND SBS.I_Status = 1        
                             GROUP BY TSBM.I_Course_ID ,        
                                    SCD.I_Batch_ID        
                           ) T1 ON T2.I_Batch_ID = T1.I_Batch_ID        
                                   AND T2.I_Course_ID = T1.I_Course_ID                                        
                                        
        UPDATE  T3        
        SET     T3.I_Total_Sessions = T1.[SessionCompleted]        
        FROM    #temp AS T3        
                INNER JOIN ( SELECT TSBM.I_Course_ID ,        
                                    TSBM.I_Batch_ID ,        
                                    COUNT(*) AS [SessionCompleted]        
                             FROM   dbo.T_Student_Batch_Details AS TSBD        
                                    INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID        
                                    INNER JOIN dbo.T_Course_Master AS TCM ON TSBM.I_Course_ID = TCM.I_Course_ID        
                                    INNER JOIN dbo.T_Term_Course_Map AS TTCM ON TCM.I_Course_ID = TTCM.I_Course_ID        
                                    INNER JOIN dbo.T_Module_Term_Map AS TMTM ON TTCM.I_Term_ID = TMTM.I_Term_ID        
                                    INNER JOIN dbo.T_Session_Module_Map AS TSMM ON TMTM.I_Module_ID = TSMM.I_Module_ID        
                             WHERE  I_Student_ID = @iStudentID        
                             GROUP BY TSBM.I_Course_ID ,        
                                    TSBM.I_Batch_ID        
                           ) T1 ON T3.I_Batch_ID = T1.I_Batch_ID        
                                   AND T3.I_Course_ID = T1.I_Course_ID                                                                
                                                 
        SELECT  ISNULL(I_Course_ID,'') AS I_Course_ID,        
                ISNULL(S_Course_Name,'') AS S_Course_Name ,        
                ISNULL(I_Batch_ID,'')AS I_Batch_ID ,        
                ISNULL(S_Batch_Code,'') AS S_Batch_Code,        
                ISNULL(S_Batch_Name,'') AS S_Batch_Name ,        
                I_Fee_Component_ID ,        
                S_Component_Name ,        
                I_Total_Sessions ,        
                I_Completed_Sessions ,        
                (CASE WHEN I_Total_Sessions >0 then CAST(( CAST(I_Completed_Sessions AS DECIMAL(10, 2))        
                       / I_Total_Sessions ) * 100 AS DECIMAL(10, 2))    
                       ELSE 0 END) AS PercentageComplete ,        
                TotalAmount ,        
                AmountPaid ,        
                TaxPaid        
        FROM    #temp AS T              
              
        DROP TABLE #temp                                                 
    END
