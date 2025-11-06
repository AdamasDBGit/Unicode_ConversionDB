CREATE PROCEDURE [REPORT].[uspGetERPSyncReport]  
    (  
      -- Add the parameters for the stored procedure here  
      -- EXEC REPORT.uspGetERPSyncReport 53,107,'11/01/2013','11/30/2013'  
      @sHierarchyList VARCHAR(MAX) ,  
      @iBrandID INT ,  
      @dtStartDate DATETIME ,  
      @dtEndDate DATETIME  
    )  
AS   
    BEGIN  

/*
    --- For ALL Details
    --INSERT INTO dbo.T_NewTable_Akash
     
        SELECT  'Student' AS [Type] ,  
                S_Brand_Name ,  
                S_Center_Name ,  
                I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                S_Transaction_Code ,  
                SUM(ISNULL(N_Amount,0)) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
    INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NULL  
                AND tstd.I_Student_ID IS NOT NULL  
                AND tbm.I_Brand_ID = @iBrandID                  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
    I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                S_Transaction_Code  
                  
        UNION ALL  
  
        SELECT  'Enquiry' AS [Type],  
                S_Brand_Name ,  
                S_Center_Name ,  
                I_Transaction_Nature_ID ,  
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                S_Transaction_Code ,  
                SUM(ISNULL(N_Amount,0)) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NOT NULL  
                AND tstd.I_Student_ID IS NULL  
                AND tbm.I_Brand_ID = @iBrandID  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
                I_Transaction_Nature_ID ,  
                tstd.I_Enquiry_Regn_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                S_Transaction_Code  
          
         UNION ALL  
          SELECT  'Student' AS [Type] ,  
                S_Brand_Name ,  
                S_Center_Name ,  
                50 AS I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                FCM.S_Component_Name + '(Accrual - Adjustment)'AS S_Transaction_Code ,  
                SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
    INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Fee_Component_Master  FCM ON tttm.I_Fee_Component_ID = FCM.I_Fee_Component_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NULL  
                AND tstd.I_Student_ID IS NOT NULL  
                AND tbm.I_Brand_ID = @iBrandID                  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
    --tttm.I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                FCM.S_Component_Name   
                  
        UNION ALL  
  
        SELECT  'Enquiry' AS [Type],  
                S_Brand_Name ,  
                S_Center_Name ,  
                51 AS I_Transaction_Nature_ID ,  
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                FCM.S_Component_Name+ '(Accrual - Adjustment)'  AS S_Transaction_Code ,  
                    SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Fee_Component_Master  FCM ON tttm.I_Fee_Component_ID = FCM.I_Fee_Component_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NOT NULL  
                AND tstd.I_Student_ID IS NULL  
                AND tbm.I_Brand_ID = @iBrandID  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
                --I_Transaction_Nature_ID ,  
                tstd.I_Enquiry_Regn_ID ,  
         S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                FCM.S_Component_Name   
          
        ORDER BY S_Student_ID  


*/
--- For Acrual only  
  
 --- FEE COMPONENT  
 SELECT  'Student' AS [Type] ,  
                S_Brand_Name ,  
                S_Center_Name ,  
                50 AS I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                FCM.S_Component_Name AS S_Transaction_Code ,  
                SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
    INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Fee_Component_Master  FCM ON tttm.I_Fee_Component_ID = FCM.I_Fee_Component_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NULL  
                AND tstd.I_Student_ID IS NOT NULL  
                AND tbm.I_Brand_ID = @iBrandID                  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
    --tttm.I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                FCM.S_Component_Name   
                  
        UNION ALL  
  
        SELECT  'Enquiry' AS [Type],  
                S_Brand_Name ,  
                S_Center_Name ,  
                50 AS I_Transaction_Nature_ID ,  
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                FCM.S_Component_Name  AS S_Transaction_Code ,  
                    SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Fee_Component_Master  FCM ON tttm.I_Fee_Component_ID = FCM.I_Fee_Component_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NOT NULL  
                AND tstd.I_Student_ID IS NULL  
                AND tbm.I_Brand_ID = @iBrandID  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
                --I_Transaction_Nature_ID ,  
                tstd.I_Enquiry_Regn_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                FCM.S_Component_Name   
              
            --- TAX      
                UNION ALL  
                  
                  
                SELECT  'Student' AS [Type] ,  
                S_Brand_Name ,  
                S_Center_Name ,  
                51 AS I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                TM.S_Tax_Desc+' ' +ISNULL(FCM.S_Component_Name,'')+ ' ' + ISNULL(SM.S_Status_Desc,'') AS S_Transaction_Code ,  
                SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
    INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Tax_Master  TM ON TM.I_Tax_ID=tttm.I_Tax_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID  
                LEFT JOIN dbo.T_Fee_Component_Master FCM ON tttm.I_Fee_Component_ID=fcm.I_Fee_Component_ID  
                LEFT JOIN (SELECT I_Status_Value,S_Status_Desc FROM dbo.T_Status_Master WHERE S_Status_Type='ReceiptType') SM  
                ON sm.I_Status_Value=tttm.I_Status_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NULL  
                AND tstd.I_Student_ID IS NOT NULL  
                AND tbm.I_Brand_ID = @iBrandID                  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS NOT NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
    --tttm.I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                TM.S_Tax_Desc+' ' +ISNULL(FCM.S_Component_Name,'')+ ' ' + ISNULL(SM.S_Status_Desc,'')  
                  
        UNION ALL  
  
        SELECT  'Enquiry' AS [Type],  
                S_Brand_Name ,  
                S_Center_Name ,  
                51 AS I_Transaction_Nature_ID ,  
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
               TM.S_Tax_Desc+' ' +ISNULL(FCM.S_Component_Name,'')+ ' ' + ISNULL(SM.S_Status_Desc,'') AS S_Transaction_Code ,  
                    SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Tax_Master  TM ON TM.I_Tax_ID=tttm.I_Tax_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID  
                 LEFT JOIN dbo.T_Fee_Component_Master FCM ON tttm.I_Fee_Component_ID=fcm.I_Fee_Component_ID  
                LEFT JOIN (SELECT I_Status_Value,S_Status_Desc FROM dbo.T_Status_Master WHERE S_Status_Type='ReceiptType') SM  
                ON sm.I_Status_Value=tttm.I_Status_ID  
                WHERE   tstd.I_Enquiry_Regn_ID IS NOT NULL  
                AND tstd.I_Student_ID IS NULL  
                AND tbm.I_Brand_ID = @iBrandID  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS NOT NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
                --I_Transaction_Nature_ID ,  
                tstd.I_Enquiry_Regn_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
               TM.S_Tax_Desc+' ' +ISNULL(FCM.S_Component_Name,'')+ ' ' + ISNULL(SM.S_Status_Desc,'')   
                 
                 
               ----WITHOUT TAX AND FEE COM  
                 
               UNION ALL  
                  
                  
                SELECT  'Student' AS [Type] ,  
                S_Brand_Name ,  
                S_Center_Name ,  
                52 AS I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                ISNULL(SM.S_Status_Desc,'')  AS S_Transaction_Code ,  
                SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
    INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID  
                INNER JOIN (SELECT I_Status_Value,S_Status_Desc FROM dbo.T_Status_Master WHERE S_Status_Type='ReceiptType') SM  
                ON sm.I_Status_Value=tttm.I_Status_ID  
        WHERE   tstd.I_Enquiry_Regn_ID IS NULL  
                AND tstd.I_Student_ID IS NOT NULL  
                AND tbm.I_Brand_ID = @iBrandID                  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS  NULL AND tttm.I_Fee_Component_ID IS  NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
    --tttm.I_Transaction_Nature_ID ,  
                S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
                ISNULL(SM.S_Status_Desc,'')   
                  
        UNION ALL  
  
        SELECT  'Enquiry' AS [Type],  
                S_Brand_Name ,  
                S_Center_Name ,  
                52 AS I_Transaction_Nature_ID ,  
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name AS S_Student_Name ,  
                ISNULL(SM.S_Status_Desc,'')  AS S_Transaction_Code ,  
                    SUM( CASE WHEN tttm.I_Transaction_Nature_ID =1 THEN ISNULL(N_Amount,0)  
                WHEN tttm.I_Transaction_Nature_ID =2 THEN -ISNULL(N_Amount,0)  
                 WHEN tttm.I_Transaction_Nature_ID =6 THEN -ISNULL(N_Amount,0)  
                  WHEN tttm.I_Transaction_Nature_ID =9 THEN ISNULL(N_Amount,0)  
                  END                  
                ) AS Amount  
        FROM    ERP.T_Student_Transaction_Details AS tstd  
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center  
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID  
                INNER JOIN ERP.T_Transaction_Nature_Master TNM ON tttm.I_Transaction_Nature_ID = TNM.I_Transaction_Nature_ID  
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID  
                INNER JOIN (SELECT I_Status_Value,S_Status_Desc FROM dbo.T_Status_Master WHERE S_Status_Type='ReceiptType') SM  
                ON sm.I_Status_Value=tttm.I_Status_ID  
                WHERE   tstd.I_Enquiry_Regn_ID IS NOT NULL  
                AND tstd.I_Student_ID IS NULL  
                AND tbm.I_Brand_ID = @iBrandID  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtStartDate) <= 0  
                AND DATEDIFF(dd,tstd.Transaction_Date, @dtEndDate) >= 0  
                AND tcm.I_Centre_Id IN (SELECT fgcfr.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr)  
                AND tttm.I_Transaction_Nature_ID IN (1,2) AND tttm.I_Tax_ID IS  NULL AND tttm.I_Fee_Component_ID IS  NULL  
        GROUP BY S_Brand_Name ,  
    S_Center_Name ,  
                --I_Transaction_Nature_ID ,  
                tstd.I_Enquiry_Regn_ID ,  
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '  
                + S_Last_Name ,  
               ISNULL(SM.S_Status_Desc,'')
               
             
               
               ------SEPERATE-------   
          
             --select * from dbo.T_NewTable_Akash
           
    
            
    END
    
