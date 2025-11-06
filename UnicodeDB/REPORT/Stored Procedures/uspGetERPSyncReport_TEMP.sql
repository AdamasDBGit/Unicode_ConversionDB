CREATE PROCEDURE [REPORT].[uspGetERPSyncReport_TEMP]
    (
      -- Add the parameters for the stored procedure here
      -- EXEC REPORT.uspGetERPSyncReport 1,109,'01/03/2013','03/31/2013'
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS 
    BEGIN
        
        
        SELECT  'Student' AS [Type] ,
                S_Brand_Name ,
                S_Center_Name ,
                I_Transaction_Nature_ID ,
                tttm.I_Fee_Component_ID,
                tttm.I_Status_ID, 
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
               -- LEFT JOIN dbo.T_Fee_Component_Master TFCM ON TFCM.I_Fee_Component_ID=tttm.I_Fee_Component_ID
                --LEFT JOIN dbo.T_Status_Master TSM ON TSM.I_Status_Value=tttm.I_Status_ID
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
                S_Transaction_Code,
                I_Fee_Component_ID,
                I_Status_ID
                --S_Component_Name
                
        UNION ALL

        SELECT  'Enquiry' AS [Type],
                S_Brand_Name ,
                S_Center_Name ,
                I_Transaction_Nature_ID ,
               tttm.I_Status_ID AS FC,
                tttm.I_Fee_Component_ID,
                CAST(tstd.I_Enquiry_Regn_ID AS VARCHAR(50)) AS S_Student_ID ,
                --S_Status_Desc AS S,
                S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                + S_Last_Name AS S_Student_Name ,
                S_Transaction_Code ,
                SUM(ISNULL(N_Amount,0)) AS Amount
        FROM    ERP.T_Student_Transaction_Details AS tstd
                INNER JOIN dbo.T_Centre_Master AS tcm ON tstd.S_Cost_Center = tcm.S_Cost_Center
                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID
                INNER JOIN dbo.T_Brand_Master AS tbm ON tttm.I_Brand_ID = tbm.I_Brand_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID
                --LEFT JOIN dbo.T_Fee_Component_Master TFCM ON TFCM.I_Fee_Component_ID=tttm.I_Fee_Component_ID
                --LEFT JOIN dbo.T_Status_Master TSM ON TSM.I_Status_Value=tttm.I_Status_ID
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
                S_Transaction_Code,
                I_Status_ID,
                I_Fee_Component_ID
                --S_Status_Desc
        
        ORDER BY I_Status_ID,I_Fee_Component_ID,I_Transaction_Nature_ID
        

    END
