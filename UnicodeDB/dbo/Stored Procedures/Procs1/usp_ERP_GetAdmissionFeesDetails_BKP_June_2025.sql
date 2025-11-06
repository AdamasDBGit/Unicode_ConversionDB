

CREATE PROCEDURE [dbo].[usp_ERP_GetAdmissionFeesDetails_BKP_June_2025]          
(          
    @EnquiryID INT,          
    @Brand_ID INT = NULL,          
    @SessionID INT = NULL,
	@iDiscountSchemeID int=null          
)          
AS          
BEGIN          
    DECLARE @formcellid INT;        
    SET @formcellid = (SELECT I_Status_Value      
                       FROM T_Status_Master      
                       WHERE Status_Type = 1 AND I_Brand_ID = @Brand_ID);   
        If @SessionID is NULL --or @SessionID IS NOT NULL  
        Begin  
     SET @SessionID=  
     (Select top 1 R_I_School_Session_ID from T_Enquiry_Regn_Detail   
     where I_Enquiry_Regn_ID=@EnquiryID)  
     End  
        
    -- Correcting the SELECT DISTINCT issue    
    SELECT DISTINCT     
           ---t1.I_Fee_Component_InstallmentID, 
		   0 as I_Fee_Component_InstallmentID,
           t1.R_I_Enquiry_Regn_ID,          
           t1.Seq,          
           CONVERT(VARCHAR, t1.Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,          
           CASE          
               WHEN t1.N_Installment_Amount - FLOOR(t1.N_Installment_Amount) >= 0.5 THEN          
                   CEILING(t1.N_Installment_Amount)          
               ELSE          
                   FLOOR(t1.N_Installment_Amount)          
           END AS N_Installment_Amount,          
           CASE          
               WHEN (t1.N_Installment_Amount + N_IGST_Value) - FLOOR(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0)) >= 0.5 THEN          
                   CEILING(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0))          
               ELSE          
                   FLOOR(t1.N_Installment_Amount + ISNULL(N_IGST_Value, 0))          
           END AS N_Installment_Amount_IncludeTax,          
           t1.R_I_Fee_Structure_ID,  
     t2.I_Fee_Component_ID as Fee_ComponentID,   
           t2.S_Component_Name AS S_Fee_Component_Name,          
           t3.S_Fee_Structure_Name,          
           DENSE_RANK() OVER (ORDER BY t1.Dt_Payment_Installment_Dt) AS DateWiseInstallmentSequenceNo,          
           t4.CGST_per,          
           t1.N_CGST_Value,          
           t4.SGST_per,          
           t1.N_SGST_Value,          
           t4.IGST_per,          
           t1.N_IGST_Value,          
           TS.S_Label        
    INTO #Temp_Fee_Installment          
    FROM T_ERP_Fee_Payment_Installment t1          
        LEFT JOIN T_Fee_Component_Master t2          
            ON t2.I_Fee_Component_ID = t1.R_I_Fee_Component_ID          
        LEFT JOIN T_ERP_Fee_Structure t3          
            ON t3.I_Fee_Structure_ID = t1.R_I_Fee_Structure_ID          
               AND t2.I_Fee_Component_ID = t1.R_I_Fee_Component_ID          
        LEFT JOIN T_ERP_Stud_Fee_Struct_Comp_Mapping SCM          
            ON SCM.R_I_Enquiry_Regn_ID = @EnquiryID and SCM.R_I_School_Session_ID=@SessionID         
               AND SCM.I_Brand_ID = @Brand_ID          
        INNER JOIN T_ERP_Stud_Fee_Struct_Comp_Mapping_Details t4           
            ON t4.I_Stud_Fee_Struct_CompMap_Details_ID = t1.I_Stud_Fee_Struct_CompMap_Details_ID           
            AND t4.R_I_Fee_Component_ID = t1.R_I_Fee_Component_ID         
        INNER JOIN T_School_Academic_Session_Master TS         
            ON TS.I_School_Session_ID = SCM.R_I_School_Session_ID       
    WHERE          
        t1.R_I_Enquiry_Regn_ID = @EnquiryID          
        AND t1.Is_Moved IS NULL    
  AND TS.I_School_Session_ID=@SessionID;   
  


    DECLARE @InstallmentComponentDetails UT_Installments_Component_Details;

  DECLARE @iERPFeeStructureID int=null

  Create table #EligibleDiscountedComponentDetails
	(
	ID int,	
	FeeComponentID int,
	InstallmentNo int,
	DtInstallmentDate datetime,
	ActualBaseAmount decimal(8,2) NULL,
	ActualSGST decimal(8,2) NULL,
	ActualCGST decimal(8,2) NULL,
	ActualIGST decimal(8,2) NULL,
	DiscountedBaseAmount decimal(8,2) NULL,
	DiscountedSGST decimal(8,2) NULL,
	DiscountedCGST decimal(8,2) NULL,
	DiscountedIGST decimal(8,2) NULL,
	DiscountedRate int NULL,
	DiscountedAmount int NULL
	)

	Create table #DiscountDetails
	(
	DiscountSchemeID int,
	DiscountSchemeName nvarchar(max),
	StatusID bit,
	ErrorMsg nvarchar(max)
	)

	set @iERPFeeStructureID= (select top 1 R_I_Fee_Structure_ID from #Temp_Fee_Installment where R_I_Fee_Structure_ID IS NOT NULL and R_I_Fee_Structure_ID > 0 )

  IF @iDiscountSchemeID IS NOT NULL
	BEGIN

		 BEGIN TRY

			IF exists(			
			select DSM.I_Discount_Scheme_ID as DiscountSchemeID,
   DSM.S_Discount_Scheme_Name as DiscountSchemeName
   from 
   T_Discount_Scheme_Master as DSM 
   inner join
   T_Discount_Brand_Map as DBM on DSM.I_Discount_Scheme_ID=DBM.I_Discount_Scheme_ID
   inner join
   T_Discount_Fee_Schedule_Detail as DFSD on DBM.I_Discount_Brand_ID=DFSD.I_Discount_Brand_ID
   where DFSD.I_ERP_Fee_Structure_ID=@iERPFeeStructureID and DSM.I_Discount_Scheme_ID=@iDiscountSchemeID
   and DFSD.I_Status_ID=1 and DBM.I_Status_ID=1 and DSM.I_Status=1
   and GETDATE() between  DSM.Dt_Valid_From  and DSM.Dt_Valid_To
			)
			BEGIN
		       
			SELECT 
				DateWiseInstallmentSequenceNo,
				CONVERT(VARCHAR, Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt, 
				SUM(N_Installment_Amount) AS BasicAmount,            
				Fee_ComponentID,
				SUM(ISNULL(N_CGST_Value,0)) CGSTAmount,
				SUM(ISNULL(N_SGST_Value,0)) SGSTAmount,     
				SUM(ISNULL(N_IGST_Value,0)) IGSTAmount,
				CGST_per,             
				SGST_per,            
				IGST_per 
				INTO #TotalAmountForDiscount            
			FROM #Temp_Fee_Installment            
			GROUP BY           
				DateWiseInstallmentSequenceNo,            
				Dt_Payment_Installment_Dt,
				Fee_ComponentID,
				CGST_per,
				SGST_per,
				IGST_per;
		
		print 'insert into #TotalAmountForDiscount'
			INSERT INTO @InstallmentComponentDetails (
				I_InstallmentNo,
				Dt_Installment_Date,
				I_Component_ID,
				BaseAmount,
				CGST,
				SGST,
				IGST
			)
			select DateWiseInstallmentSequenceNo,Dt_Payment_Installment_Dt,Fee_ComponentID,BasicAmount,CGSTAmount,SGSTAmount,IGSTAmount
			from #TotalAmountForDiscount
			ORDER BY DateWiseInstallmentSequenceNo;


			print 'insert into @InstallmentComponentDetails'
			--select * from @InstallmentComponentDetails

			INSERT INTO #EligibleDiscountedComponentDetails
			EXEC [dbo].[usp_ERP_Get_Discounted_Revised_Installments]
			@iDiscountSchemeID = @iDiscountSchemeID,
			@iBrandID = @Brand_ID,
			@iERPFeeStructure = @iERPFeeStructureID,
			@InstallmentComponentDetails = @InstallmentComponentDetails

			print 'getting discounts'

			--select
			--  0 as I_Fee_Component_InstallmentID,  
   --           TFI.R_I_Enquiry_Regn_ID,            
			--  TFI.Seq,            
			--  CONVERT(VARCHAR, TFI.Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,            
			--   CASE            
			--	   WHEN DCD.DiscountedBaseAmount - FLOOR(DCD.DiscountedBaseAmount) >= 0.5 THEN            
			--		   CEILING(DCD.DiscountedBaseAmount)            
			--	   ELSE            
			--		   FLOOR(DCD.DiscountedBaseAmount)            
			--   END AS N_Installment_Amount,            
			--   CASE            
			--	   WHEN (DCD.DiscountedBaseAmount + DCD.DiscountedIGST) - FLOOR(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0)) >= 0.5 THEN            
			--		   CEILING(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0))            
			--	   ELSE            
			--		   FLOOR(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0))            
			--   END AS N_Installment_Amount_IncludeTax,            
			--   TFI.R_I_Fee_Structure_ID,    
			--   TFI.Fee_ComponentID as Fee_ComponentID,     
			--   TFI.S_Fee_Component_Name AS S_Fee_Component_Name,            
			--   TFI.S_Fee_Structure_Name,            
			--   DCD.InstallmentNo,            
			--   TFI.CGST_per,            
			--   DCD.DiscountedCGST,            
			--   TFI.SGST_per,            
			--   DCD.DiscountedSGST,            
			--   TFI.IGST_per,            
			--   DCD.DiscountedIGST,            
			--   TFI.S_Label,
			--   DCD.DiscountedAmount,
			--   DCD.DiscountedRate
			--from 
			--#EligibleDiscountedComponentDetails as DCD
			--inner join
			--#Temp_Fee_Installment as TFI on DCD.InstallmentNo=TFI.DateWiseInstallmentSequenceNo
			--and DCD.FeeComponentID=TFI.Fee_ComponentID and DCD.DtInstallmentDate=TFI.Dt_Payment_Installment_Dt
			--where DCD.DiscountedBaseAmount IS NOT NULL


			insert into #Temp_Fee_Installment
			select
			  0 as I_Fee_Component_InstallmentID,  
              TFI.R_I_Enquiry_Regn_ID,            
			  TFI.Seq,            
			  CONVERT(VARCHAR, TFI.Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,            
			   CASE            
				   WHEN DCD.DiscountedBaseAmount - FLOOR(DCD.DiscountedBaseAmount) >= 0.5 THEN            
					   CEILING(DCD.DiscountedBaseAmount)            
				   ELSE            
					   FLOOR(DCD.DiscountedBaseAmount)            
			   END AS N_Installment_Amount,            
			   CASE            
				   WHEN (DCD.DiscountedBaseAmount + DCD.DiscountedIGST) - FLOOR(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0)) >= 0.5 THEN            
					   CEILING(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0))            
				   ELSE            
					   FLOOR(DCD.DiscountedBaseAmount + ISNULL(DCD.DiscountedIGST, 0))            
			   END AS N_Installment_Amount_IncludeTax,            
			   TFI.R_I_Fee_Structure_ID,
			   TFI.Fee_ComponentID,
			  
				CASE 
					WHEN DCD.DiscountedAmount IS NOT NULL 
					THEN ' - (' + CAST(ISNULL(DCD.DiscountedAmount, 0) AS VARCHAR) + ') Flat Discount on ' + TFI.S_Fee_Component_Name
					WHEN DCD.DiscountedRate IS NOT NULL
					THEN ' - (' + CAST(ISNULL(DCD.DiscountedRate, 0) AS VARCHAR) + '%) Discount on ' + TFI.S_Fee_Component_Name
					ELSE TFI.S_Fee_Component_Name
				END AS S_Fee_Component_Name,           
			   TFI.S_Fee_Structure_Name,            
			   DCD.InstallmentNo,            
			   TFI.CGST_per,            
			   DCD.DiscountedCGST,            
			   TFI.SGST_per,            
			   DCD.DiscountedSGST,            
			   TFI.IGST_per,            
			   DCD.DiscountedIGST,            
			   TFI.S_Label 
			from 
			#EligibleDiscountedComponentDetails as DCD
			inner join
			#Temp_Fee_Installment as TFI on DCD.InstallmentNo=TFI.DateWiseInstallmentSequenceNo
			and DCD.FeeComponentID=TFI.Fee_ComponentID and DCD.DtInstallmentDate=TFI.Dt_Payment_Installment_Dt
			where DCD.DiscountedBaseAmount IS NOT NULL

			insert into #DiscountDetails
			select 
			@iDiscountSchemeID,
			(select top 1 S_Discount_Scheme_Name from T_Discount_Scheme_Master where I_Discount_Scheme_ID=@iDiscountSchemeID)
			,1,NULL


			END
			ELSE
			BEGIN

			insert into #DiscountDetails
			select 0,'',0,'Invalid Discount Scheme'

			END
			

		END TRY
		BEGIN CATCH
			-- Catch block: show error
			PRINT 'Error occurred while creating or inserting into #TotalAmountForDiscount';
			PRINT ERROR_MESSAGE();

			insert into #DiscountDetails
			select 0,'',0,ERROR_MESSAGE()

		END CATCH
	
	END




        
    -- Summarize and group data    
    SELECT *          
    FROM #Temp_Fee_Installment        
    order by seq    
    SELECT         
        SUM(N_Installment_Amount) + SUM(ISNULL(N_IGST_Value, 0)) AS Total_AMt,          
        DateWiseInstallmentSequenceNo,          
        CONVERT(VARCHAR, Dt_Payment_Installment_Dt, 107) AS Dt_Payment_Installment_Dt,        
        Dt_Payment_Installment_Dt AS D1          
    INTO #TotalAmount          
    FROM #Temp_Fee_Installment          
    GROUP BY         
        DateWiseInstallmentSequenceNo,          
        Dt_Payment_Installment_Dt;        
        
    -- Query and order the results from #TotalAmount        
    SELECT *         
    FROM #TotalAmount          
    ORDER BY DateWiseInstallmentSequenceNo;        
        
    SELECT SUM(Total_AMt) AS ComponentTotalAmount          
    FROM #TotalAmount          
    WHERE CONVERT(DATE, D1) <= CONVERT(DATE, GETDATE());        
        
    SELECT SUM(N_Installment_Amount) AS TotalBaseAmount,          
           SUM(ISNULL(N_Installment_Amount_IncludeTax, 0)) AS TotalTaxBaseAmount,            
           SUM(ISNULL(N_SGST_Value, 0)) AS SGST,          
           SUM(ISNULL(N_CGST_Value, 0)) AS CGST,          
           SUM(ISNULL(N_IGST_Value, 0)) AS IGST,        
           S_Label AS Label     
    FROM #Temp_Fee_Installment     
    GROUP BY S_Label;        
        
 --   SELECT     
 --       t1.S_Receipt_No AS ReceiptNo,     
 --       t1.N_Receipt_Amount AS ReceiptAmount,     
 --       t2.S_Status_Desc AS Status,     
 --       t1.I_Receipt_Header_ID AS ReceiptHeaderID,      
 --       CONVERT(VARCHAR, t1.Dt_Receipt_Date, 107) AS ReceiptDate     
 --   FROM T_Receipt_Header t1        
 --   INNER JOIN T_Status_Master t2     
 --       ON t2.I_Status_value = t1.I_Receipt_type        
 --   WHERE t1.I_Enquiry_Regn_ID = @EnquiryID   
 --and t2.Is_AdmissionToken = 'true'  
 --and t1.I_Status=1 
  SELECT     
        t1.S_Receipt_No AS ReceiptNo,     
        t1.N_Receipt_Amount AS ReceiptAmount,     
        t2.S_Status_Desc AS Status,     
        t1.I_Receipt_Header_ID AS ReceiptHeaderID,      
        CONVERT(VARCHAR, t1.Dt_Receipt_Date, 107) AS ReceiptDate     
    FROM T_Receipt_Header t1
	left join T_Student_Detail SD on t1.I_Student_Detail_ID=SD.I_Student_Detail_ID
    INNER JOIN T_Status_Master t2     
        ON t2.I_Status_value = t1.I_Receipt_type         
    WHERE (t1.I_Enquiry_Regn_ID = @EnquiryID OR SD.I_Enquiry_Regn_ID=@EnquiryID)
 and t2.Is_AdmissionToken = 'true'  
 and t1.I_Status=1 
      --AND t1.I_Receipt_Type != @formcellid     
    ORDER BY t1.S_Receipt_No DESC; 
	

	select * from #DiscountDetails
         
    DROP TABLE #Temp_Fee_Installment; 
	IF OBJECT_ID('tempdb..#TotalAmountForDiscount') IS NOT NULL
	DROP TABLE #TotalAmountForDiscount;
END; 
