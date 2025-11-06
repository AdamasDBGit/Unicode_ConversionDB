  
   CREATE Proc ERP_REPORTS.USP_ERP_GetReceiptAndStudentDetails  
   (  
   @iSelectedBrandId INT,  
   @SessionID int,  
   @SchoolGroupID int=NULL,  
   @ClassID int =NULL,  
   @dtDateFrom DATE,   
      @dtDateTo DATE     
   )  
   As Begin  
   --   Declare @iSelectedBrandId INT=107,  
   --@SessionID int=35,  
   --@SchoolGroupID int=1,  
   --@ClassID int =15,  
   --@dtDateFrom DATETIME='2024-04-01',   
   --   @dtDateTo DATETIME='2024-06-30'            
                              
                     
        IF ( @dtDateTo IS NOT NULL )           
            SET @dtDateTo = DATEADD(dd, -1, @dtDateTo)                    
                    
       Declare @CentreID int   
        
  ----New changes for Fetching CenterID from BrandID      
    
  SET @CentreID=(Select  top 1 I_Centre_Id from T_Brand_Center_Details   
  where I_Brand_ID=@iSelectedBrandId)  
                    
                    
        DECLARE @tempTable TABLE          
            (          
              N_Receipt_Amount NUMERIC(18, 2) ,          
              I_Receipt_Header_ID INT ,          
              S_First_Name VARCHAR(50) ,          
              S_Middle_Name VARCHAR(50) ,          
              S_Last_Name VARCHAR(50) ,          
              I_Enquiry_Regn_ID INT ,          
              I_Student_Detail_ID INT ,          
              S_Receipt_No VARCHAR(20) ,          
              Dt_Receipt_Date DATETIME ,          
              I_Invoice_Header_ID INT ,          
              I_Receipt_Type INT ,          
              I_Status INT ,          
              I_Centre_Id INT ,        
              OnAccountInvoiceNo VARCHAR(100) ,  
     ChequeDD_No Varchar(100)  
            )                    
               
        INSERT  INTO @tempTable          
                SELECT  RH.N_Receipt_Amount ,          
                        RH.I_Receipt_Header_ID ,          
                        SD.S_First_Name ,          
                        SD.S_Middle_Name ,          
                        SD.S_Last_Name ,          
                        RH.I_Enquiry_Regn_ID ,          
                        RH.I_Student_Detail_ID ,          
                        RH.S_Receipt_No ,          
                        RH.Dt_Receipt_Date ,          
                        RH.I_Invoice_Header_ID ,          
                        RH.I_Receipt_Type ,          
                        RH.I_Status ,          
                        RH.I_Centre_Id,        
                        IOAD.S_Invoice_Number   
      ,RH.S_ChequeDD_No  
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )          
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID          
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON ISNULL(IP.I_Invoice_Header_ID,  '') = ISNULL(RH.I_Invoice_Header_ID,'')          
                        LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID= RH.I_Receipt_Header_ID AND IOAD.I_Status=1                                                                                                           
  
                        Where RH.I_Centre_Id=@CentreID  
      and RH.I_Student_Detail_ID IS NOT NULL       
      
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Receipt_Date), CONVERT(DATE,@dtDateFrom)) <= 0          
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Receipt_Date), CONVERT(DATE,@dtDateTo)) >= 0          
                                
                UNION ALL          
                SELECT  RH.N_Receipt_Amount ,          
                        RH.I_Receipt_Header_ID ,          
                        SD.S_First_Name ,          
                        SD.S_Middle_Name ,          
                        SD.S_Last_Name ,          
                        RH.I_Enquiry_Regn_ID ,          
                        RH.I_Student_Detail_ID ,          
                        RH.S_Receipt_No ,          
                RH.Dt_Upd_On AS Dt_Receipt_Date ,          
                        RH.I_Invoice_Header_ID ,          
                        RH.I_Receipt_Type ,          
                        0 ,          
                        RH.I_Centre_Id,        
                        IOAD.S_Invoice_Number   
      ,RH.S_ChequeDD_No  
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )          
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID          
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON ISNULL(IP.I_Invoice_Header_ID,          
                                                              '') = ISNULL(RH.I_Invoice_Header_ID,          
                                                              '')         
                        LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID= RH.I_Receipt_Header_ID AND IOAD.I_Status=0                                                                                                
                WHERE   RH.I_Student_Detail_ID IS NOT NULL          
                        AND RH.I_Status = 0                     
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Upd_On), CONVERT(DATE,@dtDateFrom)) <= 0          
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Upd_On), CONVERT(DATE,@dtDateTo)) >= 0          
                        AND RH.I_Centre_Id=@CentreID      
                      
        INSERT  INTO @tempTable          
                SELECT  RH.N_Receipt_Amount ,          
                        RH.I_Receipt_Header_ID ,          
                        EQ.S_First_Name ,          
                        EQ.S_Middle_Name ,          
                        EQ.S_Last_Name ,          
                        RH.I_Enquiry_Regn_ID ,          
                        RH.I_Student_Detail_ID ,          
                        RH.S_Receipt_No ,          
                        RH.Dt_Receipt_Date ,          
                        RH.I_Invoice_Header_ID ,          
                        RH.I_Receipt_Type ,          
                        1 ,          
                        RH.I_Centre_Id,        
                        IOAD.S_Invoice_Number  
      ,RH.S_ChequeDD_No  
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )          
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail EQ WITH ( NOLOCK ) ON EQ.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID          
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON ISNULL(IP.I_Invoice_Header_ID,          
                                                              '') = ISNULL(RH.I_Invoice_Header_ID,          
                                                              '')           
      LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID= RH.I_Receipt_Header_ID AND IOAD.I_Status=1                                                                                                              
      LEFT OUTER JOIN    T_Student_Detail sd ON RH.I_Student_Detail_ID = sd.I_Student_Detail_ID                 
      Left Join T_Student_Detail SDR on SDR.I_Enquiry_Regn_ID=EQ.I_Enquiry_Regn_ID            
      WHERE   RH.I_Receipt_Header_ID NOT IN (          
                        SELECT  I_Receipt_Header_ID          
                        FROM    @tempTable )          
                        AND RH.I_Student_Detail_ID IS NULL                                
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Receipt_Date), CONVERT(DATE,@dtDateFrom)) <= 0                                AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Receipt_Date), CONVERT(DATE,@dtDateTo)) >= 0          
                        AND RH.I_Centre_Id=@CentreID            
                UNION ALL          
                SELECT  RH.N_Receipt_Amount ,          
                        RH.I_Receipt_Header_ID ,          
   EQ.S_First_Name ,          
                        EQ.S_Middle_Name ,          
                        EQ.S_Last_Name ,          
                        RH.I_Enquiry_Regn_ID ,          
                        RH.I_Student_Detail_ID ,          
                        RH.S_Receipt_No ,          
                        RH.Dt_Upd_On AS Dt_Receipt_Date ,          
                        RH.I_Invoice_Header_ID ,          
                        RH.I_Receipt_Type ,          
                        0 ,          
                        RH.I_Centre_Id,        
                        IOAD.S_Invoice_Number    
      ,RH.S_ChequeDD_No  
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )          
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail EQ WITH ( NOLOCK ) ON EQ.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID          
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON ISNULL(IP.I_Invoice_Header_ID,          
                                                              '') = ISNULL(RH.I_Invoice_Header_ID,          
                                                              '')         
                        LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID= RH.I_Receipt_Header_ID AND IOAD.I_Status=0                                                   
      LEFT OUTER JOIN T_Student_Detail sd ON RH.I_Student_Detail_ID = sd.I_Student_Detail_ID                 
      Left Join T_Student_Detail SDR on SDR.I_Enquiry_Regn_ID=EQ.I_Enquiry_Regn_ID            
     WHERE   RH.I_Receipt_Header_ID NOT IN (          
                        SELECT  I_Receipt_Header_ID          
                        FROM    @tempTable )          
                        AND RH.I_Student_Detail_ID IS NULL          
                        AND RH.I_Status = 0                              
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Upd_On), CONVERT(DATE,@dtDateFrom)) <= 0          
                        AND DATEDIFF(dd, CONVERT(DATE,RH.Dt_Upd_On), CONVERT(DATE,@dtDateTo)) >= 0          
                        AND RH.I_Centre_Id=@CentreID               
                
        
     
        
---------------------------------------------------------------------------                   
        SELECT distinct T.N_Receipt_Amount ReceiptAmount,          
                RH.N_Tax_Amount TaxAmount,     
    (T.N_Receipt_Amount+RH.N_Tax_Amount) AS AmountWithTax,    
                T.I_Receipt_Header_ID ReceiptHeaderID,          
                T.S_First_Name FirstName,          
                T.S_Middle_Name MiddleName,          
                T.S_Last_Name LastName,          
                T.I_Enquiry_Regn_ID EnquiryRegnID,          
                T.I_Student_Detail_ID StudentDetailID,      
    SD.S_Student_ID AS StudentID ,    
                T.S_Receipt_No ReceiptNo,          
                T.Dt_Receipt_Date ReceiptDate,          
                T.I_Invoice_Header_ID InvoiceHeaderID,          
                case When  T.I_Receipt_Type=2  
    Then 'Admission'  
    ELSE 'Adhoc' end as  
    ReceiptType,         
    SM.S_Status_Desc as ReceiptTypeDesc,        
                T.I_Status IStatus,          
                T.I_Centre_Id CentreId,          
                CM.S_Center_Code CenterCode,          
                CM.S_Center_Short_Name CenterShortName,          
                    
                T.OnAccountInvoiceNo   
    ,ChequeDD_No  
    ,PMM.S_PaymentMode_Name as Payment_Mode  
    ,Concat(RH.S_Bank_Name,'-',RH.S_Branch_Name) as bankDetails  
    ,RH.S_AdjustmentRemarks as Remarks  
    Into #FinalReport  
        FROM    @tempTable T          
                INNER JOIN dbo.T_Centre_Master CM ON T.I_Centre_Id = CM.I_Centre_Id          
                --INNER JOIN dbo.T_Country_Master COU ON CM.I_Country_ID = COU.I_Country_ID          
                INNER JOIN dbo.T_Receipt_Header RH ON T.I_Receipt_Header_ID = RH.I_Receipt_Header_ID        
    left join        
    T_Currency_Master as CM2 on CM2.I_Currency_ID=ISNULL(RH.I_Currency_ID,0)        
    inner join        
    T_Brand_Center_Details as BCD on BCD.I_Centre_Id=CM.I_Centre_Id        
    left join T_Status_Master as SM on SM.I_Status_Value=T.I_Receipt_Type and (BCD.I_Brand_ID=SM.I_Brand_ID OR SM.I_Brand_ID IS NULL) and SM.S_Status_Type='ReceiptType'        
     left Join T_Student_Detail SD on SD.I_Student_Detail_ID=T.I_Student_Detail_ID       
      Left Join T_PaymentMode_Master  PMM ON PMM.I_PaymentMode_ID=RH.I_PaymentMode_ID  
        ORDER BY T.I_Receipt_Header_ID DESC     
    
  select tt.*  from #FinalReport tt  
  Inner Join T_Student_Class_Section SCS  
  ON SCS.I_Student_Detail_ID=tt.StudentDetailID  
     and tt.StudentDetailID is Not NULL  
  Inner Join T_School_Group_Class SGC  
  ON SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID  
  Where SGC.I_School_Group_ID=@SchoolGroupID  
  and SGC.I_Class_ID=@ClassID and SCS.I_School_Session_ID=@SessionID  
  and SCS.I_Status=1  
  
    
  Union ALL  
  select tt.*  from #FinalReport tt  
  Inner Join T_Enquiry_Regn_Detail reg  
  ON reg.I_Enquiry_Regn_ID=tt.EnquiryRegnID  
  and tt.EnquiryRegnID is Not NULL  
  where reg.I_School_Group_ID=@SchoolGroupID  
  and reg.I_Class_ID=@ClassID and reg.R_I_School_Session_ID=@SessionID  
  Order by tt.StudentID  
  Drop table #FinalReport  
End  
    
  
  --Select top 100 * from T_Enquiry_Regn_Detail where I_ERP_Entry=1  