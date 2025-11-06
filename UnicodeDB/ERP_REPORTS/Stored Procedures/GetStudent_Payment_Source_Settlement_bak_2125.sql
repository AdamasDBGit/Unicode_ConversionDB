CREATE PROCEDURE ERP_REPORTS.GetStudent_Payment_Source_Settlement_bak_2125  
    @brandID INT,  
    @SessionID INT,  
    @schoolGroupID INT,  
    @ClassID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
 Declare @CenterID int  
 SET @CenterID=  
 (Select top 1 I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@brandID )  
  
  
    SELECT DISTINCT   
        TT.S_Receipt_No AS ReceiptNO,  
        SD.S_First_Name +  
            CASE       
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''         
                THEN ' ' + SD.S_Middle_Name         
                ELSE ''         
            END +         
            ' ' + SD.S_Last_Name AS StudentName,  
        SD.S_Student_ID AS StudentID,  
        EQ.S_Enquiry_No AS EnquiryNO,  
        TT.S_ChequeDD_No AS Cheque_DD_No,  
        TT.N_Receipt_Amount AS R_Amount,  
  TPM.S_PaymentMode_Name,  
        CONVERT(DATE, TT.Dt_Deposit_Date) AS DepositDate,  
        TT.S_Bank_Name AS Bank_Name  
    FROM   
    (  
        SELECT   
            S_Receipt_No,   
            S_ChequeDD_No,  
            Dt_ChequeDD_Date,  
            S_Bank_Name,  
            S_Branch_Name,  
            I_Student_Detail_ID,  
            I_Enquiry_Regn_ID,  
            N_Receipt_Amount,  
            Dt_Deposit_Date,  
            I_Receipt_Type,  
   I_PaymentMode_ID  
  
        FROM   
            T_Receipt_Header   
        WHERE   
            (Dt_ChequeDD_Date IS NOT NULL OR S_ChequeDD_No IS NOT NULL)  
            AND I_Enquiry_Regn_ID IS NOT NULL   
            AND I_Centre_Id = @CenterID  
  
        UNION ALL  
  
        SELECT   
            S_Receipt_No,   
            S_ChequeDD_No,  
            Dt_ChequeDD_Date,  
            S_Bank_Name,  
            S_Branch_Name,  
            I_Student_Detail_ID,  
            I_Enquiry_Regn_ID,  
            N_Receipt_Amount,  
            Dt_Deposit_Date,  
            I_Receipt_Type,  
   I_PaymentMode_ID  
        FROM   
            T_Receipt_Header   
        WHERE   
            (Dt_ChequeDD_Date IS NOT NULL OR S_ChequeDD_No IS NOT NULL)  
            AND I_Student_Detail_ID IS NOT NULL   
            AND I_Centre_Id = @CenterID  
    ) AS TT  
    INNER JOIN T_Student_Class_Section SCS    
        ON SCS.I_Student_Detail_ID = TT.I_Student_Detail_ID   
    INNER JOIN T_Student_Detail SD   
        ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID    
        AND SCS.I_Brand_ID = @brandID     
        AND SCS.I_School_Session_ID = @SessionID     
        AND SCS.I_Status = 1    
    INNER JOIN T_School_Group_Class SGC   
        ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID    
    INNER JOIN T_School_Group SG   
        ON SG.I_School_Group_ID = SGC.I_School_Group_ID     
        AND SG.I_Brand_Id = @brandID    
    INNER JOIN T_Class TC   
        ON TC.I_Class_ID = SGC.I_Class_ID     
        AND TC.I_Brand_ID = @brandID    
    LEFT JOIN T_Section TS   
        ON TS.I_Section_ID = SCS.I_Section_ID   
    LEFT JOIN T_Enquiry_Regn_Detail EQ   
        ON EQ.I_Enquiry_Regn_ID =  
            CASE   
                WHEN TT.I_Enquiry_Regn_ID IS NULL THEN SD.I_Enquiry_Regn_ID  
                ELSE TT.I_Enquiry_Regn_ID   
            END   
 Left Join T_PaymentMode_Master TPM ON TPM.I_PaymentMode_ID=TT.I_PaymentMode_ID  
    WHERE     
        SG.I_School_Group_ID = @schoolGroupID     
        AND TC.I_Class_ID = @ClassID;  
END;  