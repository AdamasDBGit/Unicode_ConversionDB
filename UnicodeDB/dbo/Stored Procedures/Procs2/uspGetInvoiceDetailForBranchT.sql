
CREATE PROCEDURE [dbo].[uspGetInvoiceDetailForBranchT]  --[dbo].[uspGetInvoiceDetailForBranchT] 162232     
    (    
      @iInvoiceHeaderID INT          
    )    
AS     
BEGIN          
	SET NOCOUNT ON ; 
	DECLARE @iInvoiceDetailId INT
	DECLARE @iFeeComponentID INT
	DECLARE @dtInstallmentDate datetime
	DECLARE @nAmountDue numeric(18,2)	
	DECLARE @ICDTempTable TABLE    
	(   
		I_Invoice_Detail_ID int 
	   ,I_Fee_Component_ID int
	   ,I_Invoice_Child_Header_ID int
	   ,I_Installment_No int
	   ,Dt_Installment_Date datetime
	   ,N_Amount_Due numeric(18,2)
	   ,I_Display_Fee_Component_ID int
	   ,I_Sequence int
	   ,N_Amount_Adv_Coln numeric(18,2)
	   ,Flag_IsAdvanceTax nvarchar(max)
	   ,I_Receipt_Header_ID int
	   ,S_Invoice_Number nvarchar(max)
	   ,Tmp_AutoIdTag int   
	)
	DECLARE @IDTTempTable TABLE    
    (    
      I_Tax_ID INT ,    
      I_Invoice_Detail_ID INT ,
      N_Tax_Value NUMERIC(18, 6),
      TAX_CODE nvarchar(max) ,
      TAX_DESC nvarchar(max),
      TAX_CHECK INT
    ) 
    
	INSERT INTO @ICDTempTable
	SELECT DISTINCT ICD.I_Invoice_Detail_ID,ICD.I_Fee_Component_ID,ICD.I_Invoice_Child_Header_ID,ICD.I_Installment_No,ICD.Dt_Installment_Date
					,(ISNULL(ICD.N_Due,ICD.N_Amount_Due) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due
					,ICD.I_Display_Fee_Component_ID,ICD.I_Sequence,ICD.N_Amount_Adv_Coln,ICD.Flag_IsAdvanceTax,ICD.I_Receipt_Header_ID
					,ICD.S_Invoice_Number,ICD.Tmp_AutoIdTag                    
	FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )    
			INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
			LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID    
														  AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID  
	LEFT JOIN (SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
	FROM T_Receipt_Header RH
	INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
	WHERE RH.I_Invoice_Header_ID = @iInvoiceHeaderID
	AND ISNULL(RH.I_Status,0) <> 0
	GROUP BY RCD.I_Invoice_Detail_ID) A	ON ICD.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID  
	WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID    
	--ADDITION STARTED ON 26/06/2017
	AND ISNULL(ICD.Flag_IsAdvanceTax,'') <> 'Y'
	AND CONVERT(DATE, ICD.Dt_Installment_Date) >= CONVERT(DATE, GETDATE())
	AND (ISNULL(ICD.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) > 0
	--ADDITION ENDED ON 26/06/2017
	ORDER BY ICD.Dt_Installment_Date, ICD.I_Fee_Component_ID 
    
    
	DECLARE TABLE_CURSOR CURSOR FOR          
    SELECT I_Invoice_Detail_ID FROM @ICDTempTable
       
    OPEN TABLE_CURSOR          
    FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId 
    
    WHILE @@FETCH_STATUS = 0     
		BEGIN			
			SELECT @iFeeComponentID=I_Fee_Component_ID, @dtInstallmentDate=Dt_Installment_Date, @nAmountDue=N_Amount_Due
			FROM @ICDTempTable WHERE I_Invoice_Detail_ID = @iInvoiceDetailId
			
			INSERT INTO @IDTTempTable
			SELECT TAX.I_Tax_ID, @iInvoiceDetailId, CAST(@nAmountDue * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value,
				   TAX.S_TAX_CODE AS TAX_CODE,    
				   TAX.S_TAX_DESC AS TAX_DESC,  
				   CASE WHEN TAX.S_TAX_CODE = 'SGST' then 1
						WHEN TAX.S_TAX_CODE = 'CGST' then 2
						WHEN TAX.S_TAX_CODE = 'IGST' then 3
						ELSE 0
				   END	
			FROM
			(SELECT TCFC.N_Tax_Rate, TM.I_Tax_ID, TM.S_Tax_Code, TM.S_Tax_Desc
			FROM (select * from dbo.T_Tax_Master) AS TM
			INNER JOIN (select * from dbo.T_Tax_Country_Fee_Component where I_Fee_Component_ID=@iFeeComponentID) AS TCFC
				ON (TM.I_Tax_ID = TCFC.I_Tax_ID
					AND TM.I_Country_ID = TCFC.I_Country_ID AND TCFC.N_Tax_Rate > 0
					AND @dtInstallmentDate BETWEEN TCFC.Dt_Valid_From AND TCFC.Dt_Valid_To
					)
			) TAX
			INNER JOIN @ICDTempTable ICD ON ICD.I_Invoice_Detail_ID = @iInvoiceDetailId
			        
			FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId          
		END          
		  
	CLOSE TABLE_CURSOR          
	DEALLOCATE TABLE_CURSOR
	
	SELECT TIP.I_Invoice_Header_ID,TIP.S_Invoice_No,TIP.I_Student_Detail_ID,TIP.I_Centre_Id,
		   ISNULL((SELECT SUM(N_Amount_Due) FROM @ICDTempTable),0.00) N_Invoice_Amount,
			TIP.N_Discount_Amount
		   ,ISNULL((SELECT SUM(N_Tax_Value) FROM @IDTTempTable),0.00) N_Tax_Amount,
		   TIP.Dt_Invoice_Date,TIP.I_Status,TIP.I_Discount_Scheme_ID,TIP.I_Discount_Applied_At,TIP.S_Crtd_By,TIP.S_Upd_By
		   ,TIP.Dt_Crtd_On,TIP.Dt_Upd_On,TIP.I_Coupon_Discount,TIP.I_Parent_Invoice_ID,TIP.S_Cancel_Type,TIP2.S_Invoice_No AS S_Parent_Invoice_No,
		   TSIH.I_Cancellation_Reason_ID    
	FROM    T_Invoice_Parent TIP WITH ( NOLOCK )    
	LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID    
	LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2 ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID
	WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID
	
	SELECT  TIVC.I_Invoice_Child_Header_ID ,    
            TIVC.I_Invoice_Header_ID ,    
            TIVC.I_Course_ID ,    
            TIVC.I_Course_FeePlan_ID ,    
            TIVC.C_Is_LumpSum ,    
            ISNULL(C.N_Amount_Due, 0) AS N_Amount ,    
            ISNULL(C.N_Tax_Value, 0) AS N_Tax_Amount ,    
            TCM.S_Course_Code ,    
            TCM.S_Course_Name,  
            ISNULL(TCM.[I_Is_ST_Applicable],'Y') AS I_Is_ST_Applicable,  
            TIBM.I_Batch_ID    
    FROM    T_Invoice_Child_Header TIVC    
            LEFT OUTER JOIN T_Course_Master TCM WITH ( NOLOCK ) ON TIVC.I_Course_ID = TCM.I_Course_ID  
            LEFT OUTER JOIN dbo.T_Invoice_Batch_Map TIBM ON TIVC.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID  
            LEFT OUTER JOIN (SELECT B.I_Invoice_Child_Header_ID, ISNULL(SUM(B.N_Amount_Due),0.00) N_Amount_Due, SUM(B.N_Tax_Value) N_Tax_Value
							FROM(SELECT ICD.I_Invoice_Child_Header_ID, ICD.I_Invoice_Detail_ID, ICD.N_Amount_Due, ISNULL(A.N_Tax_Value,0.00) N_Tax_Value
							FROM @ICDTempTable ICD
							LEFT JOIN (SELECT IDT.I_Invoice_Detail_ID, SUM(IDT.N_Tax_Value) N_Tax_Value
									   FROM @IDTTempTable IDT 
									   GROUP BY I_Invoice_Detail_ID) A 
							ON ICD.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID) B
							GROUP BY B.I_Invoice_Child_Header_ID) C
			ON TIVC.I_Invoice_Child_Header_ID = C.I_Invoice_Child_Header_ID
    WHERE   TIVC.I_Invoice_Header_ID = @iInvoiceHeaderID   
    
    SELECT * FROM @ICDTempTable
    
    SELECT * FROM @IDTTempTable    
END
