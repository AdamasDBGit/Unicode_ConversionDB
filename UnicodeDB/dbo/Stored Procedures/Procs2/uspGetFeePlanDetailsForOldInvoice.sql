CREATE PROCEDURE [dbo].[uspGetFeePlanDetailsForOldInvoice] --uspGetFeePlanDetailsForOldInvoice 168864, 37602
( 
	@iOldInvoiceHeaderID INT,
	@iFeePlanID INT 
)
AS 
BEGIN      
    SET NOCOUNT ON    
    
    CREATE TABLE #CFPD
    (
		I_Course_Fee_Plan_Detail_ID int
	   ,I_Fee_Component_ID int
       ,I_Course_Fee_Plan_ID int
       ,I_Item_Value numeric(18,2)
       ,N_CompanyShare numeric(18,2)
       ,I_Sequence int
       ,I_Installment_No int
       ,C_Is_LumpSum char(1)
       ,I_Display_Fee_Component_ID int
    ) 
    
    CREATE TABLE #CFPDR
    (
		ID INT IDENTITY(1,1)
	   ,I_Course_Fee_Plan_Detail_ID int
	   ,I_Fee_Component_ID int
       ,I_Course_Fee_Plan_ID int
       ,I_Item_Value numeric(18,2)
       ,N_CompanyShare numeric(18,2)
       ,I_Sequence int
       ,I_Installment_No int
       ,Dt_Installment_Date DATETIME
       ,C_Is_LumpSum char(1)
       ,I_Display_Fee_Component_ID int
    ) 
    
    CREATE TABLE #IWFPD
    (
		ID INT IDENTITY(1,1),
		I_Invoice_Detail_ID int, 
		I_Invoice_Child_Header_ID int, 
		I_Course_Fee_Plan_ID int,
		I_Fee_Component_ID int, 
		I_Installment_No int, 
		Dt_Installment_Date DATETIME, 
		N_Amount_Due numeric(18,2)
    ) 
    
    CREATE TABLE #IWFPI
    (
		ID INT IDENTITY(1,1),
		I_Installment_No int, 
		Dt_Installment_Date DATETIME
    ) 
       
 -- Fee Component List      
 -- Table [1] 
	INSERT INTO #CFPD
	(
		I_Course_Fee_Plan_Detail_ID ,
        I_Fee_Component_ID ,
        I_Course_Fee_Plan_ID ,
        I_Item_Value ,
        N_CompanyShare ,
        I_Installment_No ,
        I_Sequence ,
        C_Is_LumpSum ,
        I_Display_Fee_Component_ID
	)   
    SELECT  I_Course_Fee_Plan_Detail_ID ,
            I_Fee_Component_ID ,
            I_Course_Fee_Plan_ID ,
            I_Item_Value ,
            ISNULL(N_CompanyShare, 0) AS N_CompanyShare ,
            I_Installment_No ,
            I_Sequence ,
            C_Is_LumpSum ,
            I_Display_Fee_Component_ID
    FROM    dbo.T_Course_Fee_Plan_Detail
    WHERE   I_Course_Fee_Plan_ID = @iFeePlanID
            AND I_Status = 1
    ORDER BY I_Installment_No,I_Sequence
    
    INSERT INTO #IWFPD
    (
		I_Invoice_Detail_ID, 
		I_Invoice_Child_Header_ID, 
		I_Course_Fee_Plan_ID,
		I_Fee_Component_ID, 
		I_Installment_No, 
		Dt_Installment_Date, 
		N_Amount_Due
    )     
    SELECT B.I_Invoice_Detail_ID, B.I_Invoice_Child_Header_ID, B.I_Course_FeePlan_ID, B.I_Fee_Component_ID, B.I_Installment_No, B.Dt_Installment_Date, 
    --(ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due  --Before Discount Akash 5.10.2021
	(ISNULL(B.N_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due
	FROM 
	(SELECT ICD.I_Invoice_Detail_ID, ICD.I_Invoice_Child_Header_ID, ICH.I_Course_FeePlan_ID, 
	ICD.I_Fee_Component_ID, ICD.I_Installment_No, ICD.Dt_Installment_Date, ICD.N_Amount_Due,ICD.N_Due,ICD.N_Discount_Amount
	FROM T_Invoice_Child_Detail ICD 
	INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
	INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID 
	WHERE IP.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y') B
	LEFT JOIN 
	(SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
	FROM T_Receipt_Header RH
	INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
	WHERE RH.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(RH.I_Status,0) <> 0
	GROUP BY RCD.I_Invoice_Detail_ID) A	ON B.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
	INNER JOIN T_Invoice_Child_Header ICH1 ON B.I_Invoice_Child_Header_ID = ICH1.I_Invoice_Child_Header_ID
	AND (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) > 0
	ORDER BY B.I_Installment_No
	
	INSERT INTO #IWFPI
    (
		I_Installment_No, 
		Dt_Installment_Date
    ) 
	SELECT DISTINCT I_Installment_No, Dt_Installment_Date
	FROM #IWFPD
	
	IF EXISTS
	(
		SELECT 1 FROM #IWFPI
	)
	BEGIN
	
		DECLARE @row INT = 1
		DECLARE @count INT
		
		DECLARE @I_Invoice_Detail_ID int
		DECLARE @I_Invoice_Child_Header_ID int
		DECLARE @I_Fee_Component_ID int
		DECLARE @I_Installment_No int
		DECLARE @Dt_Installment_Date DATETIME
		DECLARE @N_Amount_Due numeric(18,2)	
		DECLARE @N_Amount_Paid numeric(18,2)
		
		DECLARE @I_Course_Fee_Plan_Detail_ID int
		DECLARE @I_Course_Fee_Plan_ID int
		DECLARE @I_Item_Value numeric(18,2)
		DECLARE @N_CompanyShare numeric(18,2)
		DECLARE @I_Sequence int
		DECLARE @C_Is_LumpSum char(1)
		DECLARE @I_Display_Fee_Component_ID int
		
		SELECT @count = COUNT(*) FROM #IWFPI
		
		WHILE (@row<=@count)
		BEGIN
			SELECT @I_Installment_No = I_Installment_No
				  ,@Dt_Installment_Date = Dt_Installment_Date
			FROM #IWFPI
			WHERE ID = @row
			
			INSERT INTO #CFPDR
			(
				I_Course_Fee_Plan_Detail_ID
			   ,I_Fee_Component_ID
			   ,I_Course_Fee_Plan_ID 
			   ,I_Item_Value
			   ,N_CompanyShare
			   ,I_Sequence
			   ,I_Installment_No
			   ,Dt_Installment_Date
			   ,C_Is_LumpSum
			   ,I_Display_Fee_Component_ID
			)
			SELECT  CF.I_Course_Fee_Plan_Detail_ID
					,CF.I_Fee_Component_ID 
					,CF.I_Course_Fee_Plan_ID
					,ISNULL((SELECT IW.N_Amount_Due FROM #IWFPD IW WHERE IW.I_Course_Fee_Plan_ID = CF.I_Course_Fee_Plan_ID 
											  AND IW.I_Installment_No = CF.I_Installment_No AND IW.I_Fee_Component_ID = CF.I_Fee_Component_ID),0) AS I_Item_Value
					,CF.N_CompanyShare
					,CF.I_Sequence				
					,@I_Installment_No
					,@Dt_Installment_Date
					,CF.C_Is_LumpSum
					,CF.I_Display_Fee_Component_ID
			FROM #CFPD CF
			WHERE I_Installment_No = @I_Installment_No
			
			SET @row = @row + 1
		END
		
		-- Fee Plan List      
		-- Table [0]      
		SELECT  I_Course_Fee_Plan_ID ,
				I_Course_ID ,
				I_Course_Delivery_ID ,
				I_Currency_ID ,
				S_Fee_Plan_Name ,
				C_Is_LumpSum ,
				ISNULL((SELECT SUM(ISNULL(I_Item_Value,0))FROM #CFPDR),0) N_TotalLumpSum ,
				ISNULL((SELECT SUM(ISNULL(I_Item_Value,0))FROM #CFPDR),0) N_TotalInstallment ,
				I_Status ,
				Dt_Valid_To
		FROM    dbo.T_Course_Fee_Plan
		WHERE   I_Course_Fee_Plan_ID = @iFeePlanID
				AND I_Status = 1
	            
		SELECT	0 AS I_Course_Fee_Plan_Detail_ID
				,CF.I_Fee_Component_ID 
				,CF.I_Course_Fee_Plan_ID 
				,A.I_Item_Value 
				,CF.N_CompanyShare
				,CF.I_Sequence  
				,CF.I_Installment_No 			
				,CF.C_Is_LumpSum 
				,CF.I_Display_Fee_Component_ID
		FROM #CFPD CF
		INNER JOIN (SELECT  CFR.I_Fee_Component_ID
						   ,SUM(ISNULL(CFR.I_Item_Value,0)) AS I_Item_Value
					FROM #CFPDR CFR
					GROUP BY CFR.I_Fee_Component_ID) A ON CF.I_Fee_Component_ID = A.I_Fee_Component_ID
		WHERE CF.I_Installment_No = 0 AND CF.C_Is_LumpSum = 'Y'
		UNION ALL
		SELECT 0 AS I_Course_Fee_Plan_Detail_ID
			   ,A.I_Fee_Component_ID
			   ,A.I_Course_Fee_Plan_ID 
			   ,SUM(ISNULL(A.I_Item_Value,0)) AS I_Item_Value
			   ,A.N_CompanyShare
			   ,A.I_Sequence
			   ,A.I_Installment_No
			   ,A.C_Is_LumpSum
			   ,A.I_Display_Fee_Component_ID
		FROM(
		SELECT  I_Fee_Component_ID
			   ,I_Course_Fee_Plan_ID 
			   ,I_Item_Value
			   ,N_CompanyShare
			   ,I_Sequence
			   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN 1
					 ELSE I_Installment_No
				END I_Installment_No
			   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN DATEADD(d,DATEDIFF(d,0,getdate()),0)
					 ELSE Dt_Installment_Date
				END Dt_Installment_Date
			   ,C_Is_LumpSum
			   ,I_Display_Fee_Component_ID
		FROM #CFPDR) A
		GROUP BY A.I_Installment_No, A.I_Fee_Component_ID, A.N_CompanyShare, A.I_Sequence, A.C_Is_LumpSum, A.I_Display_Fee_Component_ID, A.I_Course_Fee_Plan_ID 
		ORDER BY I_Installment_No ASC
	END
	ELSE
	BEGIN
		-- Fee Plan List      
		-- Table [0]      
		SELECT  I_Course_Fee_Plan_ID ,
				I_Course_ID ,
				I_Course_Delivery_ID ,
				I_Currency_ID ,
				S_Fee_Plan_Name ,
				C_Is_LumpSum ,
				ISNULL((SELECT SUM(ISNULL(I_Item_Value,0))FROM #CFPDR),0) N_TotalLumpSum ,
				ISNULL((SELECT SUM(ISNULL(I_Item_Value,0))FROM #CFPDR),0) N_TotalInstallment ,
				I_Status ,
				Dt_Valid_To
		FROM    dbo.T_Course_Fee_Plan
		WHERE   I_Course_Fee_Plan_ID = @iFeePlanID
				AND I_Status = 1
				
		SELECT * FROM #CFPD
	END
		
	DROP TABLE #CFPD
	DROP TABLE #IWFPD
	DROP TABLE #CFPDR
	DROP TABLE #IWFPI
END
