CREATE PROCEDURE [dbo].[ERP_uspSearchAdhocPaymentScheduleDetailsForStudent]  
(  
    @StudentDetailID INT  -- Single input field for searching  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    -- ✅ Check if Student Exists  
    IF NOT EXISTS (SELECT 1 FROM T_Student_Detail WHERE I_Student_Detail_ID = @StudentDetailID)  
    BEGIN  
        PRINT 'No student found with the given ID';  
        RETURN;  
    END  
  
    -- ✅ Fix: Add a semicolon before the CTE  
    ;WITH PaginatedData AS  -- Notice the semicolon added before WITH  
    (  
        SELECT   
            EAPSSD.inAdhocPaymentScheduleStudentDetailID AS Id,  
            SD.I_Student_Detail_ID AS StudentDetailID,  
            SD.S_Student_ID AS StudentID,  
            ERD.I_Enquiry_Regn_ID AS EnquiryNo,  
            SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name AS StudentName,  
            SG.S_School_Group_Name AS SchoolGroupName,  
            C.S_Class_Name + ' ' + ISNULL(S.S_Stream, '') + ' ' + Section.S_Section_Name AS Class,  
            SD.S_Mobile_No AS MobileNo,  
            EAPSD.dtEndDate AS DueDate,  
            TS.S_Status_Desc AS Description,  
            EAPSSD.inPaymentStatus AS PaymentStatus,  
            EAPSSD.sInvoiceNo AS InvoiceNo,  
            EAPSSD.SRemarks AS Remarks,  
            EAPSD.inAdHocFeeComponentID AS AdHocFeeComponentID,  
            EAPSD.inBrandID AS BrandID,  
            ISNULL(EAPSSD.IsFreeze,'false') as IsFreeze,
            -- ✅ ADDED: High Priority Flag
            ISNULL(EAPSD.IsCollectWithHighPriority, 0) AS IsCollectWithHighPriority,
			LatestInvoice.I_ERP_TransactionNo as ERP_TransactionNo,
			LatestInvoice.Order_ID as Order_ID
        FROM T_ERP_AdhocPaymentScheduleStudentDetail EAPSSD  
        INNER JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = EAPSSD.inStudentDetailID  
        INNER JOIN T_Enquiry_Regn_Detail ERD ON ERD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID  
        INNER JOIN T_ERP_AdhocPaymentScheduleHeaderDetail EAPSHD ON EAPSHD.inAdhocPaymentScheduleHeaderDetailID = EAPSSD.inAdhocPaymentScheduleHeaderDetailID  
        INNER JOIN T_ERP_AdhocPaymentScheduleHeader EAPSD ON EAPSD.inAdhocPaymentScheduleHeaderID = EAPSHD.inAdhocPaymentScheduleHeaderID  
        INNER JOIN T_Status_Master TS ON TS.I_Status_Value = EAPSD.inAdHocFeeComponentID  
        INNER JOIN T_School_Group SG ON SG.I_School_Group_ID = EAPSD.inSchoolProgramID  
        INNER JOIN T_Class C ON C.I_Class_ID = EAPSHD.inClassID  
        LEFT JOIN T_Stream S ON S.I_Stream_ID = EAPSHD.inStreamID  
        INNER JOIN T_Section Section ON Section.I_Section_ID = EAPSHD.inSectionID 
		LEFT JOIN (
				SELECT 
					TID.PaymentScheduleID,
					TID.I_ERP_Transaction_Master_ID,
					TM.I_ERP_TransactionNo,
					TM.Order_ID
				FROM T_ERP_Transaction_Invoice_Details TID
				INNER JOIN (
					SELECT 
						PaymentScheduleID, 
						MAX(TM.Dt_TransactionDate) AS LatestTransactionDate
					FROM T_ERP_Transaction_Invoice_Details TID2
					INNER JOIN T_ERP_Transaction_Master TM 
						ON TID2.I_ERP_Transaction_Master_ID = TM.I_ERP_Transaction_Master_ID
					GROUP BY PaymentScheduleID
				) AS LatestTx ON TID.PaymentScheduleID = LatestTx.PaymentScheduleID
				INNER JOIN T_ERP_Transaction_Master TM 
					ON TID.I_ERP_Transaction_Master_ID = TM.I_ERP_Transaction_Master_ID
				   AND TM.Dt_TransactionDate = LatestTx.LatestTransactionDate
			) AS LatestInvoice ON EAPSSD.inAdhocPaymentScheduleStudentDetailID = LatestInvoice.PaymentScheduleID

        WHERE SD.I_Student_Detail_ID = @StudentDetailID and EAPSSD.I_Receipt_Header_ID IS NULL  
    )  
  
    -- ✅ Fetch Tax & Configuration Details and Merge with PaginatedData  
    SELECT   
        P.*,  
        SM.N_Amount AS Amount,  
        SM.S_Status_Desc AS Description,  
        ECM.S_config_code AS ConfigCode,  
        ECM.S_config_Value AS ConfigValue,  
          
        -- Tax Details  
        CASE   
            WHEN SM.N_Amount BETWEEN GICD.N_Start_Amount AND GICD.N_End_Amount   
            THEN CONVERT(NUMERIC(18,2), ((SM.N_Amount * N_SGST / 100)))   
            ELSE 0  
        END AS SGST,  
        N_SGST AS SGSTPercentage,  
        8 AS SGST_Tax_ID,  
  
        CASE   
            WHEN SM.N_Amount BETWEEN GICD.N_Start_Amount AND GICD.N_End_Amount   
            THEN CONVERT(NUMERIC(18,2), ((SM.N_Amount * N_CGST / 100)))  
            ELSE 0  
        END AS CGST,  
        N_CGST AS CGSTPercentage,  
        7 AS CGST_Tax_ID,  
  
        CASE   
            WHEN SM.N_Amount BETWEEN GICD.N_Start_Amount AND GICD.N_End_Amount   
            THEN CONVERT(NUMERIC(18,2), ((SM.N_Amount * N_IGST / 100)))  
            ELSE 0  
        END AS IGST,  
        N_IGST AS IGSTPercentage,  
        9 AS IGST_Tax_ID,  
  
        SM.Is_AllowAmountChange AS AllowAmountChange,
        EBM.LinkedAccountId linkedAccountID  
  
    FROM PaginatedData P  
    LEFT JOIN T_Status_Master SM ON SM.I_Status_Value = P.AdHocFeeComponentID AND SM.I_Brand_ID=P.BrandID  
    LEFT JOIN [dbo].[T_ERP_Configuration_Master] as ECM             
        ON SM.I_ConFig_ID=ECM.I_Config_ID             
    LEFT JOIN T_ERP_GST_Component_Mapping GIC ON GIC.I_Fee_Component_ID=SM.I_Status_Value            
        AND GIC.I_GST_Component_Type=2   
    LEFT JOIN T_ERP_GST_Item_Category GICM   
        ON GICM.I_GST_FeeComponent_Catagory_ID=GIC.I_GST_FeeComponent_Catagory_ID  
        AND GICM.Is_Active=1  
    LEFT JOIN T_ERP_GST_Configuration_Details GICD             
        ON GICD.I_GST_FeeComponent_Catagory_ID=GIC.I_GST_FeeComponent_Catagory_ID    
    LEFT JOIN T_ERP_BankMaster as EBM ON SM.BankID=EBM.ID AND EBM.inBrandID=P.BrandID  
    ORDER BY P.DueDate DESC, P.InvoiceNo DESC;  -- Sorting by DueDate and InvoiceNo  
END;
