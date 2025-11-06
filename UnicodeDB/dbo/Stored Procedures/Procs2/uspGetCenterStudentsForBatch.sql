CREATE PROCEDURE [dbo].[uspGetCenterStudentsForBatch]  -- [uspGetCenterStudentsForBatch] 1,1             
    (        
      @iBatchID INT ,        
      @iCenterID INT                      
    )        
AS         
    BEGIN                        
        SELECT  '' AS S_Student_ID ,        
                '' AS I_RollNo ,        
                A.I_Enquiry_Regn_ID AS Student_ID ,        
                B.S_First_Name + ' ' + ISNULL(B.S_Middle_Name, '') + ' '        
                + B.S_Last_Name AS [StudentName] ,        
                A.Crtd_On AS [Date] ,        
                'Registered' AS Status ,
                'Active' AS NewStatus,        
                SUM(C.N_Receipt_Amount + C.N_Tax_Amount) AS Total_Payment        
        FROM    dbo.T_Student_Registration_Details A        
                INNER JOIN dbo.T_Enquiry_Regn_Detail B ON A.I_Enquiry_Regn_ID = B.I_Enquiry_Regn_ID        
                INNER JOIN dbo.T_Receipt_Header C ON B.I_Enquiry_Regn_ID = C.I_Enquiry_Regn_ID        
                                                     AND A.I_Receipt_Header_ID = C.I_Receipt_Header_ID        
                                                     AND C.I_Status = 1        
        WHERE   A.I_Status = 1        
                AND A.I_Batch_ID = @iBatchID        
                AND A.I_Destination_Center_ID = @iCenterID        
        GROUP BY A.I_Enquiry_Regn_ID ,        
                B.S_First_Name + ' ' + ISNULL(B.S_Middle_Name, '') + ' '        
                + B.S_Last_Name ,        
                A.Crtd_On        
        UNION        
        SELECT  b.S_Student_ID ,        
                ISNULL(TSBD.I_RollNo,b.I_RollNo) AS I_RollNo ,        
                TSBD.I_Student_ID AS Student_ID ,        
                B.S_First_Name + ' ' + ISNULL(B.S_Middle_Name, '') + ' '        
                + B.S_Last_Name AS [StudentName] ,        
                E.Dt_Invoice_Date AS [Date] ,        
                'Enrolled' AS Status ,
                CASE WHEN TSBM.Dt_BatchStartDate>GETDATE() THEN 'Waiting'
                WHEN TSBM.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NULL THEN 'Waiting'
                WHEN TSBM.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NOT NULL THEN 'Active'
                END AS NewStatus,    
                ISNULL(SUM(H.N_Amount_Paid + H.[Tax]), 0) AS Total_Payment        
        FROM    dbo.T_Student_Batch_Master AS TSBM        
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBM.I_Batch_ID = TSBD.I_Batch_ID        
                INNER JOIN dbo.T_Student_Detail B ON TSBD.I_Student_ID = b.I_Student_Detail_ID        
                INNER JOIN dbo.T_Center_Batch_Details D ON TSBM.I_Batch_ID = D.I_Batch_ID        
                                                           AND D.I_Centre_Id = @iCenterID        
                INNER JOIN T_Student_Center_Detail I ON TSBD.I_Student_ID = I.I_Student_Detail_ID        
                INNER JOIN dbo.T_Invoice_Parent E ON B.I_Student_Detail_ID = E.I_Student_Detail_ID        
                                                     AND E.I_Status IN (1,3)                        
                LEFT OUTER JOIN dbo.T_Invoice_Child_Header F ON E.I_Invoice_Header_ID = F.I_Invoice_Header_ID        
                LEFT OUTER JOIN T_Invoice_Batch_Map TIBM ON TIBM.I_Invoice_Child_Header_ID = F.I_Invoice_Child_Header_ID  
                LEFT OUTER JOIN dbo.T_Invoice_Child_Detail G ON F.I_Invoice_Child_Header_ID = G.I_Invoice_Child_Header_ID        
                LEFT OUTER JOIN ( SELECT    X.I_Receipt_Comp_Detail_ID ,        
                                            X.I_Invoice_Detail_ID ,        
                                            X.N_Amount_Paid ,        
                                            SUM(ISNULL(Y.N_Tax_Paid,0)) AS [Tax]        
                                  FROM      dbo.T_Receipt_Component_Detail X        
                                            LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail Y ON X.I_Receipt_Comp_Detail_ID = Y.I_Receipt_Comp_Detail_ID        
                                                              AND X.I_Invoice_Detail_ID = Y.I_Invoice_Detail_ID        
                                            INNER JOIN T_Receipt_Header Z ON X.I_Receipt_Detail_ID = Z.I_Receipt_Header_ID        
                                  WHERE     Z.I_Status = 1        
                     GROUP BY  X.I_Receipt_Comp_Detail_ID ,        
                                            X.I_Invoice_Detail_ID ,        
           X.N_Amount_Paid        
                                ) H ON G.I_Invoice_Detail_ID = H.I_Invoice_Detail_ID 
                                LEFT OUTER JOIN 
                                (
                                SELECT TSA.I_Student_Detail_ID,ISNULL(COUNT(DISTINCT TSA.I_Attendance_Detail_ID),0) AS AttnCount FROM dbo.T_Student_Attendance TSA
                                GROUP BY TSA.I_Student_Detail_ID
                                ) T1 ON B.I_Student_Detail_ID=T1.I_Student_Detail_ID      
        WHERE   TSBD.I_Status = 1        
                AND TSBD.I_Batch_ID = @iBatchID  
                AND (F.I_Invoice_Child_Header_ID IS NULL OR TIBM.I_Batch_ID = @iBatchID)   
                -- First part will return the students for whom there are records in   
                --Invoice but not in Child Header, second part will return for the batch only  
                AND I.I_Centre_Id = @iCenterID 
                AND B.I_Status=1       
        GROUP BY TSBD.I_Student_ID ,        
                B.S_First_Name + ' ' + ISNULL(B.S_Middle_Name, '') + ' '        
                + B.S_Last_Name ,        
                E.Dt_Invoice_Date ,        
                b.S_Student_ID ,        
                ISNULL(TSBD.I_RollNo,b.I_RollNo),
                CASE WHEN TSBM.Dt_BatchStartDate>GETDATE() THEN 'Waiting'
                WHEN TSBM.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NULL THEN 'Waiting'
                WHEN TSBM.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NOT NULL THEN 'Active'
                END        
       ORDER BY I_RollNo                 
    END
