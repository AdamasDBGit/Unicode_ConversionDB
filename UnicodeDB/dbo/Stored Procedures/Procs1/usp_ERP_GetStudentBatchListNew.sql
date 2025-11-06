CREATE PROCEDURE [dbo].[usp_ERP_GetStudentBatchListNew]  
    (  
      @iBrandId INT ,  
      @sHierarchyListID Nnvarchar(max)=NULL ,  
      @sBatchList Nnvarchar(max) = NULL  
    )  
AS   
    BEGIN  
	Declare @brandname nvarchar(max)
	SET @brandname=(Select S_Brand_Name from T_Brand_Master where I_Brand_ID=@iBrandId)
  
        IF ( @sBatchList IS NOT NULL  
             AND @sBatchList != ''  
             AND @sBatchList != '0'  
             AND @sBatchList != '--Select--'  
           )   
            BEGIN  
  
                SELECT  @brandname ,  
                        ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS I_RollNo ,  
                        TSD.S_Student_ID ,  
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')  
                        + ' ' + TSD.S_Last_Name AS StudentName ,  
                        TCHND.I_Centre_Id ,  
                        TCHND.S_Center_Name ,  
                        TSBM.I_Batch_ID ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '')  as S_Batch_Name,  
                        TSBM.Dt_BatchStartDate,  
                        TCM.I_Course_ID ,  
                        TCM.S_Course_Name ,  
                        CONVERT(DATE, TSD.Dt_Birth_Date) AS DOB ,  
                        TERD.S_Father_Name ,  
                        TERD.S_Mother_Name ,  
                        TERD.S_Father_Office_Phone,  
                        TERD.S_Mother_Office_Phone,  
                        '`'+TSD.S_Curr_Address1 AS S_Curr_Address1,  
      TCM2.S_City_Name as City,  
                        TSD.S_Curr_Pincode ,  
                        TSD.S_Mobile_No ,  
                        TSD.S_Phone_No ,  
                        TSD.S_Guardian_Name ,  
                        COALESCE(TSD.S_Guardian_Mobile_No,  
                                 TSD.S_Guardian_Phone_No, '') AS GuardianContactNo ,  
                        TSD.S_Email_ID,  
      TSD.S_OrgEmailID AS S_MS_Email_ID,  
                        TTM.S_PickupPoint_Name ,  
                        TBRM.S_Route_No ,  
                        TTM.N_Fees,  
                        THM.S_House_Name ,  
                        ISNULL(TERD.S_Second_Language_Opted,'') AS SecondLanguage,  
                        CASE WHEN TERD.I_Sex_ID = 1 THEN 'Male'  
                             WHEN TERD.I_Sex_ID = 2 THEN 'Female'  
                        END AS Sex ,  
                        CASE WHEN TSBM.Dt_BatchStartDate > GETDATE()  
                             THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NULL THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NOT NULL THEN 'Active'  
                        END AS StdStatus ,  
      TSD.Dt_Crtd_On AS AdmissionDate,  
      TC.S_Caste_Name as SocialCategory,  
                        ISNULL(SUM(H.N_Amount_Paid + H.[Tax]), 0) AS Total_Payment  
                FROM    dbo.T_Student_Detail TSD  
                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID  
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID  
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID  
                        --INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID  
                       Inner Join T_Centre_Master TCHND on TCHND.I_Centre_Id=TCBD.I_Centre_Id
					   INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID  
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID  
                        LEFT JOIN dbo.T_MSTeam_Student_Details AS TMTSD WITH (NOLOCK) ON TMTSD.S_Student_ID = TSD.S_Student_ID  
                        LEFT JOIN dbo.T_Transport_Master TTM ON TSD.I_Transport_ID = TTM.I_PickupPoint_ID  
                                                              AND TTM.I_Status = 1  
                        LEFT JOIN dbo.T_BusRoute_Master TBRM ON TSD.I_Route_ID = TBRM.I_Route_ID  
                                                              AND TBRM.I_Status = 1  
                        LEFT JOIN dbo.T_House_Master THM ON TSD.I_House_ID = THM.I_House_ID  
                                                            AND THM.I_Status = 1  
                        LEFT JOIN ( SELECT  TSA.I_Student_Detail_ID ,  
                                            COUNT(DISTINCT TSA.I_TimeTable_ID) AS AttnCount  
                                    FROM    dbo.T_Student_Attendance TSA  
                                    GROUP BY TSA.I_Student_Detail_ID  
                                  ) T1 ON TSD.I_Student_Detail_ID = T1.I_Student_Detail_ID  
      LEFT JOIN T_Caste_Master TC on TERD.I_Caste_ID=TC.I_Caste_ID  
      LEFT JOIN T_City_Master TCM2 on TCM2.I_City_ID=TSD.I_Curr_City_ID  
                        --Payment Data            
                        INNER JOIN dbo.T_Invoice_Parent E ON TSD.I_Student_Detail_ID = E.I_Student_Detail_ID  
                                                             AND E.I_Status IN (  
                                                             1, 3 )  
                        LEFT OUTER JOIN dbo.T_Invoice_Child_Header F ON E.I_Invoice_Header_ID = F.I_Invoice_Header_ID  
                        LEFT OUTER JOIN T_Invoice_Batch_Map TIBM ON TIBM.I_Invoice_Child_Header_ID = F.I_Invoice_Child_Header_ID AND TSBM.I_Batch_ID=TIBM.I_Batch_ID  
                        LEFT OUTER JOIN dbo.T_Invoice_Child_Detail G ON F.I_Invoice_Child_Header_ID = G.I_Invoice_Child_Header_ID  
                        LEFT OUTER JOIN ( SELECT    X.I_Receipt_Comp_Detail_ID ,  
                                                    X.I_Invoice_Detail_ID ,  
                                                    X.N_Amount_Paid ,  
                                                    SUM(ISNULL(Y.N_Tax_Paid, 0)) AS [Tax]  
                                          FROM      dbo.T_Receipt_Component_Detail X  
                                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail Y ON X.I_Receipt_Comp_Detail_ID = Y.I_Receipt_Comp_Detail_ID  
                                                              AND X.I_Invoice_Detail_ID = Y.I_Invoice_Detail_ID  
                                                    INNER JOIN T_Receipt_Header Z ON X.I_Receipt_Detail_ID = Z.I_Receipt_Header_ID  
                                          WHERE     Z.I_Status = 1  
                                          GROUP BY  X.I_Receipt_Comp_Detail_ID ,  
                                                    X.I_Invoice_Detail_ID ,  
                                                    X.N_Amount_Paid  
                                        ) H ON G.I_Invoice_Detail_ID = H.I_Invoice_Detail_ID  
                        --Payment Data                  
                WHERE   TCHND.I_Centre_Id IN (  
                        SELECT  FGCFR.centerID  
                        FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) FGCFR )  
                        AND TSBM.I_Batch_ID IN (  
                        SELECT  CAST(FSR.Val AS INT)  
                        FROM    dbo.fnString2Rows(@sBatchList, ',') FSR )  
                        AND TSBD.I_Status = 1  
      AND TSD.I_Status=1  
                GROUP BY  
                        TCHND.I_Centre_Id ,  
                        TCHND.S_Center_Name ,  
                        TCM.I_Course_ID ,  
                        TCM.S_Course_Name ,  
                        TSBM.I_Batch_ID ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') ,  
                        TSBM.Dt_BatchStartDate,  
                        TSD.S_Student_ID ,  
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')  
                        + ' ' + TSD.S_Last_Name ,  
                        ISNULL(TSBD.I_RollNo,TSD.I_RollNo) ,  
   CONVERT(DATE, TSD.Dt_Birth_Date) ,  
                        TERD.S_Father_Name ,  
                        TERD.S_Mother_Name ,  
                        TERD.S_Father_Office_Phone,  
                        TERD.S_Mother_Office_Phone,  
                        '`'+TSD.S_Curr_Address1 ,  
      TCM2.S_City_Name,  
                        TSD.S_Curr_Pincode ,  
                        TSD.S_Mobile_No ,  
                        TSD.S_Phone_No ,  
                        TSD.S_Guardian_Name ,  
                        COALESCE(TSD.S_Guardian_Mobile_No,  
                                 TSD.S_Guardian_Phone_No, '') ,  
                        TSD.S_Email_ID,  
      TSD.S_OrgEmailID,  
                        TTM.S_PickupPoint_Name ,  
                        TBRM.S_Route_No ,  
                        TTM.N_Fees,  
                        THM.S_House_Name ,  
                        ISNULL(TERD.S_Second_Language_Opted,''),  
                        CASE WHEN TERD.I_Sex_ID = 1 THEN 'Male'  
                             WHEN TERD.I_Sex_ID = 2 THEN 'Female'  
                        END ,  
                        CASE WHEN TSBM.Dt_BatchStartDate > GETDATE()  
                             THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NULL THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NOT NULL THEN 'Active'  
                        END,  
      TSD.Dt_Crtd_On,  
      TC.S_Caste_Name  
                ORDER BY TCHND.S_Center_Name ,  
                        TCM.S_Course_Name ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') ,  
                        ISNULL(TSBD.I_RollNo,TSD.I_RollNo)  
          
            END  
          
        ELSE   
            BEGIN  
                SELECT  ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS I_RollNo ,  
                        TSD.S_Student_ID ,  
                        TERD.I_Enquiry_Regn_ID,  
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')  
                        + ' ' + TSD.S_Last_Name AS StudentName ,  
                        TCHND.I_Center_ID ,  
                        TCHND.S_Center_Name ,  
                        TSBM.I_Batch_ID ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '')  as S_Batch_Name,  
                        TSBM.Dt_BatchStartDate,  
                        TCM.I_Course_ID ,  
                        TCM.S_Course_Name ,  
                        CONVERT(DATE, TSD.Dt_Birth_Date) AS DOB ,  
                        TERD.S_Father_Name ,  
                        TERD.S_Mother_Name ,  
                        TERD.S_Father_Office_Phone,  
                        TERD.S_Mother_Office_Phone,  
                        '`'+TSD.S_Curr_Address1 AS S_Curr_Address1,  
      TCM2.S_City_Name as City,  
                        TSD.S_Curr_Pincode ,  
      '`'+TSD.S_Perm_Address1 AS S_Perm_Address1,  
      TSD.S_Perm_Pincode,  
                        TSD.S_Mobile_No ,  
                        TSD.S_Phone_No ,  
                        TSD.S_Guardian_Name ,  
                        COALESCE(TSD.S_Guardian_Mobile_No,  
                                 TSD.S_Guardian_Phone_No, '') AS GuardianContactNo ,  
                        TSD.S_Email_ID,    
      TSD.S_OrgEmailID AS S_MS_Email_ID,  
                        TTM.S_PickupPoint_Name ,  
                        TBRM.S_Route_No ,  
                        TTM.N_Fees,  
                        THM.S_House_Name ,  
                        ISNULL(TERD.S_Second_Language_Opted,'') AS SecondLanguage,  
                        TNL.S_Native_Language_Name,  
                        CASE WHEN TERD.I_Sex_ID = 1 THEN 'Male'  
                             WHEN TERD.I_Sex_ID = 2 THEN 'Female'  
                        END AS Sex ,  
                        CASE WHEN TSBM.Dt_BatchStartDate > GETDATE()  
                             THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NULL THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NOT NULL THEN 'Active'  
                        END AS StdStatus ,  
                        TCHND.S_Brand_Name,  
      TSD.Dt_Crtd_On AS AdmissionDate,  
      TC.S_Caste_Name as SocialCategory,  
                        ISNULL(SUM(H.N_Amount_Paid + H.[Tax]), 0) AS Total_Payment  
                FROM    dbo.T_Student_Detail TSD  
                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID  
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID  
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID  
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID  
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID  
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID  
                        INNER JOIN T_Native_Language TNL ON TNL.I_Native_Language_ID=TERD.I_Native_Language_ID  
      LEFT JOIN dbo.T_MSTeam_Student_Details AS TMTSD WITH (NOLOCK) ON TMTSD.S_Student_ID = TSD.S_Student_ID  
                        LEFT JOIN dbo.T_Transport_Master TTM ON TSD.I_Transport_ID = TTM.I_PickupPoint_ID  
                                                              AND TTM.I_Status = 1  
                        LEFT JOIN dbo.T_BusRoute_Master TBRM ON TSD.I_Route_ID = TBRM.I_Route_ID  
                                                              AND TBRM.I_Status = 1  
                        LEFT JOIN dbo.T_House_Master THM ON TSD.I_House_ID = THM.I_House_ID  
                                                            AND THM.I_Status = 1  
                        LEFT JOIN ( SELECT  TSA.I_Student_Detail_ID ,  
                                            COUNT(DISTINCT TSA.I_TimeTable_ID) AS AttnCount  
                                    FROM    dbo.T_Student_Attendance TSA  
                                    GROUP BY TSA.I_Student_Detail_ID  
                                  ) T1 ON TSD.I_Student_Detail_ID = T1.I_Student_Detail_ID  
      LEFT JOIN T_Caste_Master TC on TERD.I_Caste_ID=TC.I_Caste_ID  
      LEFT JOIN T_City_Master TCM2 on TCM2.I_City_ID=TSD.I_Curr_City_ID  
                        --Payment Data            
                        INNER JOIN dbo.T_Invoice_Parent E ON TSD.I_Student_Detail_ID = E.I_Student_Detail_ID  
                                                             AND E.I_Status IN (  
                                                             1, 3 )  
                        LEFT OUTER JOIN dbo.T_Invoice_Child_Header F ON E.I_Invoice_Header_ID = F.I_Invoice_Header_ID  
                        LEFT OUTER JOIN T_Invoice_Batch_Map TIBM ON TIBM.I_Invoice_Child_Header_ID = F.I_Invoice_Child_Header_ID AND TSBM.I_Batch_ID=TIBM.I_Batch_ID  
                        LEFT OUTER JOIN dbo.T_Invoice_Child_Detail G ON F.I_Invoice_Child_Header_ID = G.I_Invoice_Child_Header_ID  
                        LEFT OUTER JOIN ( SELECT    X.I_Receipt_Comp_Detail_ID ,  
                                                    X.I_Invoice_Detail_ID ,  
                                                    X.N_Amount_Paid ,  
                                                    SUM(ISNULL(Y.N_Tax_Paid, 0)) AS [Tax]  
                                          FROM      dbo.T_Receipt_Component_Detail X  
                                                    LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail Y ON X.I_Receipt_Comp_Detail_ID = Y.I_Receipt_Comp_Detail_ID  
                                                              AND X.I_Invoice_Detail_ID = Y.I_Invoice_Detail_ID  
                                                    INNER JOIN T_Receipt_Header Z ON X.I_Receipt_Detail_ID = Z.I_Receipt_Header_ID  
                                          WHERE     Z.I_Status = 1  
                                          GROUP BY  X.I_Receipt_Comp_Detail_ID ,  
                                                    X.I_Invoice_Detail_ID ,  
                                                    X.N_Amount_Paid  
                                        ) H ON G.I_Invoice_Detail_ID = H.I_Invoice_Detail_ID  
                        --Payment Data  
                WHERE   TCHND.I_Center_ID IN (  
                        SELECT  FGCFR.centerID  
                        FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) FGCFR )  
        --AND TSBM.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR)  
                        AND TSBD.I_Status = 1  
      AND TSD.I_Status=1  
                        --and TSD.S_Student_ID='15-0226'  
                GROUP BY TCHND.S_Brand_Name ,  
                        TCHND.I_Center_ID ,  
                        TCHND.S_Center_Name ,  
                        TCM.I_Course_ID ,  
                        TCM.S_Course_Name ,  
                        TSBM.I_Batch_ID ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''),  
                        TSBM.Dt_BatchStartDate,  
                        TSD.S_Student_ID ,  
                        TERD.I_Enquiry_Regn_ID,  
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')  
                        + ' ' + TSD.S_Last_Name ,  
                        ISNULL(TSBD.I_RollNo,TSD.I_RollNo) ,  
                        CONVERT(DATE, TSD.Dt_Birth_Date) ,  
                        TERD.S_Father_Name ,  
                        TERD.S_Mother_Name ,  
                        TERD.S_Father_Office_Phone,  
                        TERD.S_Mother_Office_Phone,  
                        '`'+TSD.S_Curr_Address1 ,  
                        TSD.S_Curr_Pincode ,  
      '`'+TSD.S_Perm_Address1,  
      TCM2.S_City_Name,  
      TSD.S_Perm_Pincode,  
                        TSD.S_Mobile_No ,  
                        TSD.S_Phone_No ,  
                        TSD.S_Guardian_Name ,  
                        COALESCE(TSD.S_Guardian_Mobile_No,  
                                 TSD.S_Guardian_Phone_No, '') ,  
                        TSD.S_Email_ID,    
      TSD.S_OrgEmailID,  
                        TTM.S_PickupPoint_Name ,  
                        TBRM.S_Route_No ,  
                        TTM.N_Fees,  
                        THM.S_House_Name ,  
                        ISNULL(TERD.S_Second_Language_Opted,''),  
                        TNL.S_Native_Language_Name,  
                        CASE WHEN TERD.I_Sex_ID = 1 THEN 'Male'  
                             WHEN TERD.I_Sex_ID = 2 THEN 'Female'  
                        END ,  
                        CASE WHEN TSBM.Dt_BatchStartDate > GETDATE()  
                             THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NULL THEN 'Waiting'  
                             WHEN TSBM.Dt_BatchStartDate <= GETDATE()  
                                  AND T1.AttnCount IS NOT NULL THEN 'Active'  
                        END,  
      TSD.Dt_Crtd_On,  
      TC.S_Caste_Name  
                ORDER BY TCHND.S_Center_Name ,  
                        TCM.S_Course_Name ,  
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''),  
                        ISNULL(TSBD.I_RollNo,TSD.I_RollNo)  
            END  
          
    END  
          
          
          
          

