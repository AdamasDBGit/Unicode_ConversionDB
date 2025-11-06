
CREATE PROCEDURE [dbo].[usp_ERP_GetCollectionRegister_BKP_May_2025]      
    (      
      @iSelectedHierarchyId INT=NULL ,      
      @iSelectedBrandId INT,    
      @dtDateTo DATETIME=null ,      
      @dtDateFrom DATETIME=null ,      
      @sFName Nnvarchar(max)=NULL,      
      @sMName Nnvarchar(max)=NULL,      
      @sLName Nnvarchar(max)=NULL,      
      @sStudentCode Nnvarchar(max) = NULL ,      
      @sEnquiryNo Nnvarchar(max) = NULL   ,
	  @iReceiptNo int=NULL
    )      
AS       
BEGIN                
    SET NOCOUNT ON;                

    DECLARE @TempCenter TABLE ( I_Center_ID INT );                
                 
    -- Fetching CenterID from BrandID  
    INSERT INTO @TempCenter(I_Center_ID)  
    SELECT I_Centre_Id FROM T_Brand_Center_Details WHERE I_Brand_ID=@iSelectedBrandId;  

	DECLARE @iStudentDetailID INT=NULL
	DECLARE @iEnquiryID INT=NULL


	IF @sStudentCode IS NOT NULL
	BEGIN

		select top 1 @iStudentDetailID=I_Student_Detail_ID,@iEnquiryID=I_Enquiry_Regn_ID from T_Student_Detail where S_Student_ID=@sStudentCode

	END
	ELSE
	BEGIN

		IF @sEnquiryNo IS NOT NULL
		BEGIN
		select top 1 @iEnquiryID=I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail where S_Enquiry_No=@sEnquiryNo
		END

	END





    DECLARE @tempTable TABLE      
    (      
        N_Receipt_Amount NUMERIC(18, 2),      
        I_Receipt_Header_ID INT,      
        S_First_Name nvarchar(max),      
        S_Middle_Name nvarchar(max),      
        S_Last_Name nvarchar(max),      
        I_Enquiry_Regn_ID INT,      
        I_Student_Detail_ID INT,      
        S_Receipt_No nvarchar(max),      
        Dt_Receipt_Date DATETIME,      
        I_Invoice_Header_ID INT,      
        I_Receipt_Type INT,      
        I_Status INT,      
        I_Centre_Id INT,    
        OnAccountInvoiceNo nvarchar(max)   ,
		S_Cancellation_Reason nnvarchar(max)
    );                

    -- Insert Active Receipts
    INSERT INTO @tempTable      
    SELECT  
        RH.N_Receipt_Amount,      
        RH.I_Receipt_Header_ID,      
        ISNULL(SD.S_First_Name,ED.S_First_Name),      
        ISNULL(SD.S_Middle_Name,ED.S_Middle_Name),      
        ISNULL(SD.S_Last_Name,ED.S_Last_Name),      
        RH.I_Enquiry_Regn_ID,      
        RH.I_Student_Detail_ID,      
        RH.S_Receipt_No,      
        RH.Dt_Receipt_Date,      
        RH.I_Invoice_Header_ID,      
        RH.I_Receipt_Type,      
        1,      
        RH.I_Centre_Id,    
        IOAD.S_Invoice_Number ,
		RH.S_Cancellation_Reason
    FROM dbo.T_Receipt_Header RH WITH (NOLOCK)      
    INNER JOIN @TempCenter TC ON RH.I_Centre_Id = TC.I_Center_ID      
    LEFT OUTER JOIN dbo.T_Student_Detail SD WITH (NOLOCK) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID      
    LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND IOAD.I_Status = 1                                                                                                           
    LEFT JOIN T_Enquiry_Regn_Detail as ED on ED.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID
   WHERE   
        --RH.I_Student_Detail_ID IS NOT NULL                
        --AND 
		     CONVERT(DATE, RH.Dt_Receipt_Date) 
          BETWEEN COALESCE(@dtDateFrom, '2000-01-01') 
              AND COALESCE(@dtDateTo, GETDATE())
        AND ISNULL(ISNULL(SD.S_First_Name,ED.S_First_Name), '') LIKE ISNULL(@sFName, '') + '%'      
        AND ISNULL(ISNULL(SD.S_Middle_Name,ED.S_Middle_Name), '') LIKE ISNULL(@sMName, '') + '%'      
        AND ISNULL(ISNULL(SD.S_Last_Name,ED.S_Last_Name), '') LIKE ISNULL(@sLName, '') + '%'      
        AND (RH.I_Student_Detail_ID = ISNULL(@iStudentDetailID, RH.I_Student_Detail_ID)      
        OR RH.I_Enquiry_Regn_ID = ISNULL(@iEnquiryID, RH.I_Enquiry_Regn_ID))  
		AND RH.S_Receipt_No = ISNULL(@iReceiptNo,RH.S_Receipt_No)
		--AND RH.I_Enquiry_Regn_ID = ISNULL(@sEnquiryNo,RH.I_Enquiry_Regn_ID)
		AND (
    @sEnquiryNo IS NULL 
    OR RH.I_Enquiry_Regn_ID = @sEnquiryNo
)
    -- Insert Cancelled Receipts
    INSERT INTO @tempTable      
    SELECT  
        RH.N_Receipt_Amount,      
        RH.I_Receipt_Header_ID,      
        ISNULL(SD.S_First_Name,ED.S_First_Name),      
        ISNULL(SD.S_Middle_Name,ED.S_Middle_Name),      
        ISNULL(SD.S_Last_Name,ED.S_Last_Name),      
        RH.I_Enquiry_Regn_ID,      
        RH.I_Student_Detail_ID,      
        RH.S_Receipt_No,      
        RH.Dt_Upd_On AS Dt_Receipt_Date,      
        RH.I_Invoice_Header_ID,      
        RH.I_Receipt_Type,      
        0,      
        RH.I_Centre_Id,    
        IOAD.S_Invoice_Number ,   
		RH.S_Cancellation_Reason
    FROM dbo.T_Receipt_Header RH WITH (NOLOCK)      
    INNER JOIN @TempCenter TC ON RH.I_Centre_Id = TC.I_Center_ID      
    LEFT OUTER JOIN dbo.T_Student_Detail SD WITH (NOLOCK) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID      
    LEFT OUTER JOIN dbo.T_Invoice_OnAccount_Details IOAD ON IOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND IOAD.I_Status = 0                                                                                           
    LEFT JOIN T_Enquiry_Regn_Detail as ED on ED.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID
	WHERE   
        --RH.I_Student_Detail_ID IS NOT NULL      
        --AND 
		RH.I_Status = 0                
        AND  CONVERT(DATE, RH.Dt_Receipt_Date) 
          BETWEEN COALESCE(@dtDateFrom, '2000-01-01') 
              AND COALESCE(@dtDateTo, GETDATE())
		AND ISNULL(ISNULL(SD.S_First_Name,ED.S_First_Name), '') LIKE ISNULL(@sFName, '') + '%'      
        AND ISNULL(ISNULL(SD.S_Middle_Name,ED.S_Middle_Name), '') LIKE ISNULL(@sMName, '') + '%'      
        AND ISNULL(ISNULL(SD.S_Last_Name,ED.S_Last_Name), '') LIKE ISNULL(@sLName, '') + '%' 
        --AND ISNULL(SD.S_First_Name, '') LIKE ISNULL(@sFName, '') + '%'      
        --AND ISNULL(SD.S_Middle_Name, '') LIKE ISNULL(@sMName, '') + '%'      
        --AND ISNULL(SD.S_Last_Name, '') LIKE ISNULL(@sLName, '') + '%'
		 AND (RH.I_Student_Detail_ID = ISNULL(@iStudentDetailID, RH.I_Student_Detail_ID)      
        OR RH.I_Enquiry_Regn_ID = ISNULL(@iEnquiryID, RH.I_Enquiry_Regn_ID))
		AND RH.S_Receipt_No = ISNULL(@iReceiptNo,RH.S_Receipt_No)
		--AND RH.I_Enquiry_Regn_ID = ISNULL(@sEnquiryNo,RH.I_Enquiry_Regn_ID)
		AND (
    @sEnquiryNo IS NULL 
    OR RH.I_Enquiry_Regn_ID = @sEnquiryNo
)

    -- Default Currency Details  
    DECLARE @DEFAULTCurrencyID INT;    
    DECLARE @DEFAULTCurrencyCode nvarchar(max);    

    SELECT     
        @DEFAULTCurrencyID = CurM.I_Currency_ID,    
        @DEFAULTCurrencyCode = CurM.S_Currency_Code     
    FROM @tempTable T     
    INNER JOIN dbo.T_Centre_Master CM ON T.I_Centre_Id = CM.I_Centre_Id      
    INNER JOIN dbo.T_Country_Master COU ON CM.I_Country_ID = COU.I_Country_ID    
    INNER JOIN T_Currency_Master as CurM ON CurM.I_Currency_ID = COU.I_Currency_ID    
    WHERE Is_Default = 1;    

    -- Final Data Selection    
    SELECT DISTINCT 
        T.N_Receipt_Amount AS ReceiptAmount,      
        RH.N_Tax_Amount AS TaxAmount, 
        T.N_Receipt_Amount+RH.N_Tax_Amount  AS AmountWithTax,
        T.I_Receipt_Header_ID AS ReceiptHeaderID,      
        T.S_First_Name AS FirstName,      
        T.S_Middle_Name AS MiddleName,      
        T.S_Last_Name AS LastName,      
        T.I_Enquiry_Regn_ID AS EnquiryRegnID,      
        T.I_Student_Detail_ID AS StudentDetailID,  
        SD.S_Student_ID AS StudentID,
        T.S_Receipt_No AS ReceiptNo,      
        T.Dt_Receipt_Date AS ReceiptDate,      
        T.I_Invoice_Header_ID AS InvoiceHeaderID,      
        T.I_Receipt_Type AS ReceiptType,     
        --SM.S_Status_Desc AS ReceiptTypeDesc, 
		CASE 
    WHEN SM.S_Status_Desc = 'Admission' THEN 'Invoicable'
    ELSE SM.S_Status_Desc
END AS ReceiptTypeDesc,
        T.I_Status AS IStatus,      
        T.I_Centre_Id AS CentreId,      
        CM.S_Center_Code AS CenterCode,      
        CM.S_Center_Short_Name AS CenterShortName,      
        ISNULL(CM2.I_Currency_ID, @DEFAULTCurrencyID) AS CurrencyID,    
        ISNULL(CM2.S_Currency_Code, @DEFAULTCurrencyCode) AS CurrencyCode,    
        T.OnAccountInvoiceNo    ,
		T.S_Cancellation_Reason Reason
    FROM @tempTable T      
    INNER JOIN dbo.T_Centre_Master CM ON T.I_Centre_Id = CM.I_Centre_Id      
    INNER JOIN dbo.T_Receipt_Header RH ON T.I_Receipt_Header_ID = RH.I_Receipt_Header_ID    
    LEFT JOIN T_Currency_Master AS CM2 ON CM2.I_Currency_ID = ISNULL(RH.I_Currency_ID, 0)    
    INNER JOIN T_Brand_Center_Details AS BCD ON BCD.I_Centre_Id = CM.I_Centre_Id    
    LEFT JOIN T_Status_Master AS SM ON SM.I_Status_Value = T.I_Receipt_Type 
        AND (BCD.I_Brand_ID = SM.I_Brand_ID OR SM.I_Brand_ID IS NULL) 
        AND SM.S_Status_Type = 'ReceiptType'    
    LEFT JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = T.I_Student_Detail_ID   
    ORDER BY T.I_Receipt_Header_ID DESC;                

END

