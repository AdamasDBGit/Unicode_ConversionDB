CREATE PROCEDURE [dbo].[usp_ERP_FormSaleDetail]  
    (  
      @dtStart DATETIME ,  
      @dtEnd DATETIME ,  
      @iBrandId INT ,  
      @sHierarchyList NVARCHAR(max) =NULL 
    )  
AS   
    BEGIN  
      
  IF (@iBrandId=107)  
  BEGIN  
        SELECT  TCHND.S_Brand_Name,TCHND.S_Center_Name,D.Dt_Receipt_Date ,  
                A.I_Enquiry_Regn_ID ,  
                A.S_First_Name ,  
                A.S_Middle_Name ,  
                A.S_Last_Name ,  
                S_Form_No ,  
                S_Course_Name ,  
                A.S_Mobile_No ,  
                S_Father_Name ,  
                D.N_Receipt_Amount + D.N_Tax_Amount AS Amount ,  
                D.N_Receipt_Amount AS BaseAmount,  
                D.N_Tax_Amount AS TaxAmount,  
                TIOAD.S_Invoice_Number,  
                'DB' Scholar  
        FROM    T_Enquiry_Regn_Detail A  
                INNER JOIN T_Enquiry_Course B ON A.I_Enquiry_Regn_ID = B.I_Enquiry_Regn_ID  
                INNER JOIN T_Course_Master C ON C.I_Course_ID = B.I_Course_ID  
                INNER JOIN T_Receipt_Header D ON D.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID  
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON A.I_Centre_Id=TCHND.I_Center_ID  
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON D.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID  
        WHERE   D.I_Receipt_Type = 31  
                AND DATEDIFF(dd, @dtStart, D.Dt_Receipt_Date) >= 0  
                AND DATEDIFF(dd, @dtEnd, D.Dt_Receipt_Date) <= 0  
                AND S_Form_No LIKE '2020-0%'  
--AND  
--A.I_Enquiry_Status_Code=3  
                AND A.I_Centre_Id IN (  
                SELECT  CenterList.centerID  
                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList )  
                AND D.I_Status = 1  
        UNION ALL  
        SELECT  TCHND.S_Brand_Name,TCHND.S_Center_Name,D.Dt_Receipt_Date ,  
                A.I_Enquiry_Regn_ID ,  
                A.S_First_Name ,  
                A.S_Middle_Name ,  
                A.S_Last_Name ,  
                S_Form_No ,  
                S_Course_Name ,  
                A.S_Mobile_No ,  
                S_Father_Name ,  
                D.N_Receipt_Amount + D.N_Tax_Amount AS Amount ,  
                D.N_Receipt_Amount AS BaseAmount,  
                D.N_Tax_Amount AS TaxAmount,  
                TIOAD.S_Invoice_Number,  
                'DS' Scholar  
        FROM    T_Enquiry_Regn_Detail A  
                INNER JOIN T_Enquiry_Course B ON A.I_Enquiry_Regn_ID = B.I_Enquiry_Regn_ID  
                INNER JOIN T_Course_Master C ON C.I_Course_ID = B.I_Course_ID  
                INNER JOIN T_Receipt_Header D ON D.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID  
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON A.I_Centre_Id=TCHND.I_Center_ID  
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON D.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID  
        WHERE   D.I_Receipt_Type = 31  
                AND DATEDIFF(dd, @dtStart, D.Dt_Receipt_Date) >= 0  
                AND DATEDIFF(dd, @dtEnd, D.Dt_Receipt_Date) <= 0  
                AND S_Form_No LIKE '2020-1%'  
--AND  
--A.I_Enquiry_Status_Code=3  
                AND A.I_Centre_Id IN (  
                SELECT  CenterList.centerID  
                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList )  
                AND D.I_Status = 1  
        ORDER BY Dt_Receipt_Date ,  
                S_Course_Name ,  
                Scholar  
                  
        END  
          
        ELSE  
          
        BEGIN  
         SELECT  TCHND.S_Brand_Name,TCHND.S_Center_Name,D.Dt_Receipt_Date ,  
                A.I_Enquiry_Regn_ID ,  
                A.S_First_Name ,  
                A.S_Middle_Name ,  
                A.S_Last_Name ,  
                S_Form_No ,  
                S_Course_Name ,  
A.S_Mobile_No ,  
                S_Father_Name ,  
                D.N_Receipt_Amount + D.N_Tax_Amount AS Amount ,  
                D.N_Receipt_Amount AS BaseAmount,  
                D.N_Tax_Amount AS TaxAmount,  
                TIOAD.S_Invoice_Number,  
                CASE WHEN A.I_Enquiry_Status_Code=3 THEN 'Admitted'  
                WHEN A.I_Enquiry_Status_Code IS NULL OR A.I_Enquiry_Status_Code=1 THEN 'Enquiry' END AS Scholar  
        FROM    T_Enquiry_Regn_Detail A  
                INNER JOIN T_Enquiry_Course B ON A.I_Enquiry_Regn_ID = B.I_Enquiry_Regn_ID  
                INNER JOIN T_Course_Master C ON C.I_Course_ID = B.I_Course_ID  
                INNER JOIN T_Receipt_Header D ON D.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID  
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON A.I_Centre_Id=TCHND.I_Center_ID  
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON D.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID  
        WHERE   D.I_Receipt_Type IN (32,51,57)  
                AND DATEDIFF(dd, @dtStart, D.Dt_Receipt_Date) >= 0  
                AND DATEDIFF(dd, @dtEnd, D.Dt_Receipt_Date) <= 0  
                --AND S_Form_No LIKE '2017-0%'  
--AND  
--A.I_Enquiry_Status_Code=3  
                AND A.I_Centre_Id IN (  
                SELECT  CenterList.centerID  
                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList )  
                AND D.I_Status = 1  
        END          
    END  
  


