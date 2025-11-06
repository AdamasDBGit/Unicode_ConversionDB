CREATE PROCEDURE [REPORT].[uspGetFeeAccrualReport]
    (
      -- Add the parameters for the stored procedure here
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtFromDate DATETIME ,
      @dtToDate DATETIME
    )
AS 
    BEGIN

        SET NOCOUNT ON ;

        SELECT  B.I_Invoice_Child_Header_ID ,
                S_Student_ID ,
                E.I_RollNo ,
                E.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                + S_Last_Name AS S_Student_Name ,
                A.S_Invoice_No ,
                A.Dt_Invoice_Date ,
                S_Component_Name ,
                tsbm.S_Batch_Name ,
                tcm.S_Course_Name ,
                tcm2.S_Center_Name ,
                S_Brand_Name ,
                S_Cost_Center ,
                C.N_Amount_Due ,
                Dt_Installment_Date ,
                I_Installment_No ,
                A.I_Parent_Invoice_ID ,
                C.I_Invoice_Detail_ID ,
                CASE WHEN I_Parent_Invoice_ID IS NULL THEN NULL
                     ELSE A.Dt_Crtd_On
                END AS Revised_Invoice_Date,
                FN2.instanceChain
        FROM    T_Invoice_Parent A
                INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                                                       AND A.I_Status IN (1,3)
                INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
                INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID = C.I_Fee_Component_ID
                                                       AND D.I_Status = 1
                INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID = A.I_Student_Detail_ID
                INNER JOIN dbo.T_Centre_Master AS tcm2 ON A.I_Centre_Id = tcm2.I_Centre_Id
                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm2.I_Centre_Id = tbcd.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
                INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Student_ID = a.I_Student_Detail_ID
                                                              AND tsbd.I_Status = 1
                INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID
                INNER JOIN dbo.T_Course_Master AS tcm ON tcm.I_Course_ID = tsbm.I_Course_ID
                INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON tcm2.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
        WHERE   A.I_Centre_Id IN (
                SELECT  fnCenter.centerID
                FROM    fnGetCentersForReports(@sHierarchyList, @iBrandID) fnCenter )
                AND DATEDIFF(dd, @dtFromDate, Dt_Installment_Date) >= 0
                AND DATEDIFF(dd, @dtToDate, Dt_Installment_Date) <= 0
               -- AND I_Installment_No<>1
        GROUP BY B.I_Invoice_Child_Header_ID ,
                S_Student_ID ,
                E.I_RollNo ,
                A.S_Invoice_No ,
                A.Dt_Invoice_Date ,
                S_Component_Name ,
                C.N_Amount_Due ,
                Dt_Installment_Date ,
                I_Installment_No ,
                A.I_Parent_Invoice_ID ,
                A.Dt_Crtd_On ,
                C.I_Invoice_Detail_ID ,
                tsbm.S_Batch_Name ,
                tcm.S_Course_Name ,
                tcm2.S_Center_Name ,
                S_Brand_Name ,
                S_Cost_Center ,
                E.S_First_Name ,
                E.S_Middle_Name ,
                E.S_Last_Name,
                FN2.instanceChain
        ORDER BY S_Center_Name, S_Batch_Name, S_Student_ID
		
    END
