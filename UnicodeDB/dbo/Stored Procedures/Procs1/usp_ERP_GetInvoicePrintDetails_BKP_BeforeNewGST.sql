

CREATE PROCEDURE [dbo].[usp_ERP_GetInvoicePrintDetails_BKP_BeforeNewGST]  --[dbo].[uspGetInvoiceDetail] 168173       
    (
      @iInvoiceHeaderID INT            
    )
AS
    BEGIN            
        SET NOCOUNT ON;            
        DECLARE @iInvoiceDetailId INT            
        DECLARE @TempTable TABLE
            (
              I_Tax_ID INT ,
              I_Invoice_Detail_ID INT ,
              N_Tax_Value NUMERIC(18, 6) ,
              TAX_CODE VARCHAR(20) ,
              TAX_DESC VARCHAR(50) ,
              TAX_CHECK INT
            )            
 -- TABLE[0] RETURNS ALL THE INFORMATION FROM T_INVOICE_PARENT             
        SELECT  TIP.I_Invoice_Header_ID as InvoiceId ,
				TIP.S_Invoice_No as InvoiceNo ,
				TIP.I_Student_Detail_ID as StudentDetailId,
				TIP.I_Centre_Id as CenterID,
				TIP.N_Invoice_Amount as InvoiceAmount,
				TIP.N_Tax_Amount as TotalTaxAmount,
				TIP.Dt_Invoice_Date as InvoiceDate,
				TIP2.I_Invoice_Header_ID as ParentInvoiceID,
                TIP2.S_Invoice_No AS ParentInvoiceNumber,
                CASE WHEN TIP.I_Status = 0 THEN TSIH1.I_Cancellation_Reason_ID
                     ELSE TSIH.I_Cancellation_Reason_ID
                END AS CancellationReasonID
        FROM    T_Invoice_Parent TIP WITH ( NOLOCK )
				INNER JOIN dbo.T_Student_Detail TSD WITH ( NOLOCK ) on TIP.I_Student_Detail_ID=TSD.I_Student_Detail_ID
				INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH1 ON TIP.I_Invoice_Header_ID = TSIH1.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2 ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID
        WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID            
 
 -- TABLE[2] RETURNS ALL THE FIELDS FROM Student Enquiry



 --SELECT			TIP.I_Student_Detail_ID as StudentId,
	--			TSD.S_Student_ID as StudentCode,
	--			ERD.I_Enquiry_Regn_ID as EnquiryID,
	--			ERD.S_First_Name as FirstName,
	--			ERD.S_Middle_Name as MiddleName,
	--			ERD.S_Last_Name as LastName,
	--			ERD.S_Mobile_No as MobileNo,
	--			ERD.S_Phone_No as PhoneNo,
	--			ERD.S_Age as Age,
	--			ERD.S_Curr_Address1 as CurrAddress1,
 --               ERD.S_Curr_Address2 as CurrAddress2,
 --               ERD.S_Curr_Pincode as CurrPincode,
 --               ERD.S_Curr_Area as CurrArea,
 --               ERD.S_Perm_Address1 as PermAddress1,
 --               ERD.S_Perm_Address2 as PermAddress2,
 --               ERD.S_Perm_Pincode as PermPincode,
 --               ERD.I_Perm_City_ID as PermCityID,
 --               ERD.I_Perm_State_ID as PermStateID,
 --               ERD.I_Perm_Country_ID as PermCountryID,
 --               ERD.S_Perm_Area as  PermArea,
	--			ERD.I_Curr_City_ID  as CurrCityID ,
 --               ERD.I_Curr_State_ID as CurrStateID ,
 --               ERD.I_Curr_Country_ID as CurrCountryID
				
 --       FROM    T_Invoice_Parent TIP WITH ( NOLOCK )
	--			INNER JOIN dbo.T_Student_Detail TSD WITH ( NOLOCK ) on TIP.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	--			INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID
				
	--   WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID  





 -- TABLE[2] RETURNS ALL THE FIELDS FROM T_Invoice_Child_Header            
        SELECT  TIVC.I_Invoice_Child_Header_ID InvoiceChildHeaderId,
                TIVC.I_Invoice_Header_ID InvoiceHeaderID,
                ISNULL(TIVC.I_Course_ID,0) CourseID,
                ISNULL(TIVC.I_Course_FeePlan_ID,0) as CourseFeePlanId ,
                TIVC.C_Is_LumpSum IsLumpSum,
                TIVC.N_Amount CourseAmount,
                ISNULL(TIVC.N_Tax_Amount, 0) AS CourseTaxAmount ,
                TCM.S_Course_Code CourseCode,
                TCM.S_Course_Name CourseName,
                ISNULL(TCM.[I_Is_ST_Applicable], 'Y') AS I_Is_ST_Applicable ,
                ISNULL(TIBM.I_Batch_ID,0) BatchID,
                TSBM.S_Batch_Name BatchName,
                --akash 18.12.2017
                TSBM.Dt_BatchStartDate BatchStartDate,
                ISNULL(TSBM.Dt_BatchIntroductionDate,'1990-01-01') AS Dt_BatchIntroductionDate,
                TSBM.s_BatchIntroductionTime
                --akash 18.12.2017
        FROM    T_Invoice_Child_Header TIVC
                LEFT OUTER JOIN T_Course_Master TCM WITH ( NOLOCK ) ON TIVC.I_Course_ID = TCM.I_Course_ID
                LEFT OUTER JOIN dbo.T_Invoice_Batch_Map TIBM ON TIVC.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                LEFT JOIN dbo.T_Student_Batch_Master AS TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
        WHERE   TIVC.I_Invoice_Header_ID = @iInvoiceHeaderID            
           
            
 -- TABLE[2] RETURNS all the records from T_INVOICE_CHILD_DETAIL and TAX DEATILS ORDER BY DATE            
 --SELECT ICD.* FROM T_Invoice_Child_Detail ICD            
 --INNER JOIN T_Invoice_Child_Header ICH            
 --ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID            
 --WHERE I_Invoice_Header_ID = @iInvoiceHeaderID             
 --ORDER BY ICD.I_Fee_Component_ID            
             
             
        SELECT DISTINCT
                ICD.I_Invoice_Detail_ID InvoiceChildDetailsId,
				ICD.I_Invoice_Child_Header_ID InvoiceChildHeaderId,
				ICD.I_Fee_Component_ID as FeeComponentId,
				ICD.I_Installment_No as InstallmentNo,
				ICD.Dt_Installment_Date as DueDate,
				ICD.N_Amount_Due as AmountDue,
				ICD.N_Due as PayableAmount,
				ICD.I_Sequence as Sequence
        FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
                INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
                LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID
                                                              AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID
        WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID      
        --ADDITION STARTED ON 26/06/2017  
                AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'  
        --ADDITION ENDED ON 26/06/2017  
        ORDER BY ICD.I_Fee_Component_ID            
            
            
        DECLARE TABLE_CURSOR CURSOR
        FOR
            SELECT  ICD.I_Invoice_Detail_ID
            FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
            WHERE   ICD.I_Invoice_Child_Header_ID IN (
                    SELECT  I_Invoice_Child_Header_ID
                    FROM    T_Invoice_Child_Header ICH WITH ( NOLOCK )
                    WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID )
            ORDER BY Dt_Installment_Date             
             
        OPEN TABLE_CURSOR            
        FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId            
             
        WHILE @@FETCH_STATUS = 0
            BEGIN            
                INSERT  INTO @TempTable
                        SELECT  IDT.I_Tax_ID ,
                                IDT.I_Invoice_Detail_ID ,   
                                --IDT.N_Tax_Value,     
                                IDT.N_Tax_Value N_Tax_Value ,
                                TM.S_Tax_Code AS TAX_CODE ,
                                TM.S_Tax_Desc AS TAX_DESC ,
                                CASE WHEN TM.S_Tax_Code = 'SGST' THEN 1
                                     WHEN TM.S_Tax_Code = 'CGST' THEN 2
                                     WHEN TM.S_Tax_Code = 'IGST' THEN 3
                                     ELSE 0
                                END
                        FROM    T_Invoice_Detail_Tax IDT ,
                                T_Tax_Master TM ,  
                                --ADDITION STARTED ON 26/06/2017  
                                T_Invoice_Child_Detail ICD     
                                --ADDITION ENDED ON 26/06/2017  
                        WHERE   IDT.I_Invoice_Detail_ID = @iInvoiceDetailId
                                AND TM.I_Tax_ID = IDT.I_Tax_ID             
                                --ADDITION STARTED ON 26/06/2017  
                                AND IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'  
                                --ADDITION ENDED ON 26/06/2017  
               
                FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId            
            END            
                
        CLOSE TABLE_CURSOR            
        DEALLOCATE TABLE_CURSOR            
             
 --TABLE[3] RETURNS TAX DEATILS             
        SELECT  
		I_Tax_ID TaxID ,
              I_Invoice_Detail_ID InvoiceChildDetailsId,
              N_Tax_Value TaxValue,
              TAX_CODE TaxCode ,
              TAX_DESC TaxDesc ,
              TAX_CHECK CGST_SGST_IGST
        FROM    @TempTable 
		



		select CGCM.I_Course_ID as CourseID,
		TC.I_Class_ID ClassID,TC.S_Class_Name as ClassName,
		ISNULL(SM.I_Stream_ID ,0) StreamID,SM.S_Stream_Name StreamName
		from
		T_Invoice_Child_Header as TICH
		inner join
		T_Course_Group_Class_Mapping as CGCM on TICH.I_Course_ID=CGCM.I_Course_ID
		inner join
		T_Class as TC on CGCM.I_Class_ID=TC.I_Class_ID
		left join
		T_Stream_Master as SM on SM.I_Stream_ID=CGCM.I_Stream_ID
		where TICH.I_Invoice_Header_ID=@iInvoiceHeaderID

   
   END        
    
