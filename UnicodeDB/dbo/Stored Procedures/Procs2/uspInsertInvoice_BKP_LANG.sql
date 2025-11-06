/**************************************************************************************************************          
Created by  : Debarshi Basu          
Date  : 01.05.2007          
Description : This SP will save the Invoice Details          
Parameters  :  @sInvoice xml          
**************************************************************************************************************/          
          
          
CREATE PROCEDURE [dbo].[uspInsertInvoice_BKP_LANG] 
(
	@sInvoice XML,
	@iBrandID INT = NULL,
	@iParentInvoiceID INT = NULL
)
AS 
    BEGIN TRY           
          
        DECLARE @iInvoiceID INT          
        DECLARE @iInvoiceChildID INT          
        DECLARE @iInvoiceChildDetailsID INT          
           
        BEGIN TRANSACTION   
        --  CREATE INVOICE NUMBER

		DECLARE @StudentDetailID INT=0
		DECLARE @BatchID INT=0
        
         CREATE TABLE #tempInvoiceNOChildDetail
            (
			  I_Invoice_Header_ID INT ,             
              I_Fee_Component_ID INT ,
              I_Invoice_Detail_ID INT ,
              I_Installment_No INT ,
              Dt_Installment_Date DATETIME ,
              N_Amount_Due NUMERIC(18, 2) ,
			  N_Amount_Discount NUMERIC(18, 2) ,
			  N_Amount_Payable NUMERIC(18, 2) ,
              I_Display_Fee_Component_ID INT ,
              I_Sequence INT,
              ID INT IDENTITY(1,1)
            ) 
               
-- Create Temporary Table To store Invoice Parent Information          
        CREATE TABLE #tempInvoice
            (
              I_Invoice_Header_ID INT ,
              I_Student_Detail_ID INT ,
              I_Centre_Id INT ,
              N_Invoice_Amount NUMERIC(18, 2) ,
              N_Discount_Amount NUMERIC(18, 2) ,
              I_Coupon_Discount INT ,
              N_Tax_Amount NUMERIC(18, 2) ,
              Dt_Invoice_Date DATETIME ,
              I_Status INT ,
              I_Discount_Scheme_ID INT ,
              I_Discount_Applied_At INT ,
              S_Crtd_By VARCHAR(20) ,
              Dt_Crtd_On DATETIME
            )          
          
-- Insert Values into Temporary Table          
        INSERT  INTO #tempInvoice
                SELECT  T.c.value('@I_Invoice_Header_ID', 'int') ,
                        T.c.value('@I_Student_Detail_ID', 'int') ,
                        T.c.value('@I_Centre_Id', 'int') ,
                        T.c.value('@N_Invoice_Amount', 'numeric(18, 2)') ,
                        T.c.value('@N_Discount_Amount', 'numeric(18, 2)') ,
                        T.c.value('@I_Coupon_Discount', 'INT') ,
                        T.c.value('@N_Tax_Amount', 'numeric(18, 2)') ,
                        T.c.value('@Dt_Invoice_Date', 'datetime') ,
                        T.c.value('@I_Status', 'int') ,
                        T.c.value('@I_Discount_Scheme_ID', 'int') ,
                        T.c.value('@I_Discount_Applied_At', 'int') ,
                        T.c.value('@S_Crtd_By', 'varchar(20)') ,
                        T.c.value('@Dt_Crtd_On', 'datetime')
                FROM    @sInvoice.nodes('/Invoice') T ( c )          
          
-- create temporary table for storing Invoice Child Header Information           
        CREATE TABLE #tempInvoiceChild
            (
              I_Invoice_Child_Header_ID INT ,
              I_Invoice_Header_ID INT ,
              I_Course_ID INT ,
              I_Batch_ID INT ,
              I_Course_FeePlan_ID INT ,
              C_Is_LumpSum CHAR(1) ,
              N_Discount_Amount NUMERIC(18, 2) ,
              I_Discount_Scheme_ID INT ,
              I_Discount_Applied_At INT
            )          
          
-- insert value for the invoice child           
        INSERT  INTO #tempInvoiceChild
                SELECT  T.c.value('@I_Invoice_Child_Header_ID', 'int') ,
                        T.c.value('@I_Invoice_Header_ID', 'int') ,
                        CASE WHEN T.c.value('@I_Course_ID', 'int') = 0
                             THEN NULL
                             ELSE T.c.value('@I_Course_ID', 'int')
                        END ,
                        CASE WHEN T.c.value('@I_Batch_ID', 'int') = 0
                             THEN NULL
                             ELSE T.c.value('@I_Batch_ID', 'int')
                        END ,
                        CASE WHEN T.c.value('@I_Course_FeePlan_ID', 'int') = 0
                             THEN NULL
                             ELSE T.c.value('@I_Course_FeePlan_ID', 'int')
                        END ,
                        T.c.value('@C_Is_LumpSum', 'char(1)') ,
                        T.c.value('@N_Discount_Amount', 'numeric(18, 2)') ,
                        T.c.value('@I_Discount_Scheme_ID', 'int') ,
                        T.c.value('@I_Discount_Applied_At', 'int')
                FROM    @sInvoice.nodes('/Invoice/InvoiceChild') T ( c )          
           
-- create temporary table for the insertion of invoice child details          
        CREATE TABLE #tempInvoiceChildDetail
            (
              I_Invoice_Detail_ID INT ,
              I_Fee_Component_ID INT ,
              I_Invoice_Child_Header_ID INT ,
              I_Installment_No INT ,
              Dt_Installment_Date DATETIME ,
              N_Amount_Due NUMERIC(18, 2) ,
			  N_Amount_Discount NUMERIC(18, 2) ,
			  N_Amount_Payable NUMERIC(18, 2) ,
              I_Display_Fee_Component_ID INT ,
              I_Sequence INT,
              ID INT IDENTITY(1,1)
            )          
-- insert values for the invoice child details          
        INSERT  INTO #tempInvoiceChildDetail
                SELECT  T.c.value('@I_Invoice_Detail_ID', 'int') ,
                        T.c.value('@I_Fee_Component_ID', 'int') ,
                        T.c.value('@I_Invoice_Child_Header_ID', 'int') ,
                        T.c.value('@I_Installment_No', 'int') ,
                        T.c.value('@Dt_Installment_Date', 'datetime') ,
                        T.c.value('@N_Amount_Due', 'numeric(18, 2)') ,
						T.c.value('@N_Amount_Discount', 'numeric(18, 2)') ,
						T.c.value('@N_Amount_Payable', 'numeric(18, 2)') ,
                        T.c.value('@I_Display_Fee_Component_ID', 'int') ,
                        T.c.value('@I_Sequence', 'int')
                FROM    @sInvoice.nodes('/Invoice/InvoiceChild/InvoiceChildDetails/Installment') T ( c )          
          
-- create table to store tax details for the invoice          
        CREATE TABLE #tempInvoiceTax
            (
              I_Tax_ID INT ,
              I_Invoice_Detail_ID INT ,
              N_Tax_Value NUMERIC(18, 2)
            )          
          
-- insert the details of the tax components in the temp table           
        INSERT  INTO #tempInvoiceTax
                SELECT  T.c.value('@I_Tax_ID', 'int') ,
                        T.c.value('@I_Invoice_Detail_ID', 'int') ,
                        T.c.value('@N_Tax_Value', 'numeric(18, 2)')
                FROM    @sInvoice.nodes('/Invoice/InvoiceChild/InvoiceChildDetails/Installment/InvoiceChildTaxDetails/TaxDetails') T ( c )          
          
--- start the insertion process          
--- using cursors          
--          
-- START THE DEFINATIONS FOR THE VARIABLES          
-- defination of the variables of the invoice parent          
        DECLARE @ipI_Invoice_Header_ID INT          
        DECLARE @ipI_Student_Detail_ID INT          
        DECLARE @ipI_Centre_Id INT          
        DECLARE @ipN_Invoice_Amount NUMERIC(18, 2)          
        DECLARE @ipN_Discount_Amount NUMERIC(18, 2)          
        DECLARE @ipI_Coupon_Discount INT          
        DECLARE @ipN_Tax_Amount NUMERIC(18, 2)          
        DECLARE @ipDt_Invoice_Date DATETIME          
        DECLARE @ipI_Status INT          
        DECLARE @ipI_Discount_Scheme_ID INT          
        DECLARE @ipI_Discount_Applied_At INT          
        DECLARE @ipS_Crtd_By VARCHAR(20)          
        DECLARE @ipDt_Crtd_On DATETIME           
--defination of the variables of the invoice child          
        DECLARE @icI_Invoice_Child_Header_ID INT          
        DECLARE @icI_Invoice_Header_ID INT          
        DECLARE @icI_Course_ID INT          
        DECLARE @icI_Batch_ID INT          
        DECLARE @icI_Course_FeePlan_ID INT          
        DECLARE @icC_Is_LumpSum CHAR(1)        
        DECLARE @icN_Discount_Amount NUMERIC(18, 2)    
        DECLARE @icI_Discount_Scheme_ID INT    
        DECLARE @icI_Discount_Applied_At INT            
--DEFINATION OF THE VARIABLES OF THE INVOICE CHILD DETAILS          
        DECLARE @icdI_Invoice_Detail_ID INT          
        DECLARE @icdI_Fee_Component_ID INT          
        DECLARE @icdI_Invoice_Child_Header_ID INT          
        DECLARE @icdI_Installment_No INT          
        DECLARE @icdDt_Installment_Date DATETIME          
        DECLARE @icdN_Amount_Due NUMERIC(18, 2)  
		DECLARE @icdN_Amount_Discount NUMERIC(18, 2)
		DECLARE @icdN_Amount_Payable NUMERIC(18, 2)
        DECLARE @icdI_Display_Fee_Component_ID INT          
        DECLARE @icdI_Sequence INT 
        
        DECLARE @insertedI_InstallmentNo INT
        DECLARE @insertedPre_InstallmentNo INT
        DECLARE @insertedDt_Installment_Date DATETIME
        DECLARE @insertedN_Amount_Due NUMERIC(18,2)
        DECLARE @InvoiceType VARCHAR(10)
        DECLARE @InvoiceNumber VARCHAR(10)
        DECLARE @insertedI_Invoice_Header_ID INT
                 
-- DEFINATION OF THE VARIABLE TO INSERT TAX DETAILS          
        DECLARE @itdI_Tax_ID INT          
        DECLARE @itdI_Invoice_Detail_ID INT          
        DECLARE @itdN_Tax_Value NUMERIC(18, 2)          
          
       
        
   --SELECT * FROM #tempInvoiceChildDetail   
  
          
 -- declare cursor for invoice details          
        DECLARE UPLOADINVOICEPARENT_CURSOR CURSOR FOR           
        SELECT I_Invoice_Header_ID,          
        I_Student_Detail_ID,          
        I_Centre_Id,          
        N_Invoice_Amount,          
        N_Discount_Amount,          
        I_Coupon_Discount,          
        N_Tax_Amount,          
        Dt_Invoice_Date,          
        I_Status,          
        I_Discount_Scheme_ID,          
        I_Discount_Applied_At,          
        S_Crtd_By,            
        Dt_Crtd_On          
        FROM #tempInvoice          
          
        OPEN UPLOADINVOICEPARENT_CURSOR           
        FETCH NEXT FROM UPLOADINVOICEPARENT_CURSOR           
 INTO @ipI_Invoice_Header_ID,          
 @ipI_Student_Detail_ID,          
 @ipI_Centre_Id,          
 @ipN_Invoice_Amount,          
 @ipN_Discount_Amount,          
 @ipI_Coupon_Discount,          
 @ipN_Tax_Amount,          
 @ipDt_Invoice_Date,          
 @ipI_Status,          
 @ipI_Discount_Scheme_ID,          
 @ipI_Discount_Applied_At,          
 @ipS_Crtd_By,          
 @ipDt_Crtd_On          
              
        WHILE @@FETCH_STATUS = 0 
            BEGIN           
                INSERT  INTO dbo.T_Invoice_Parent
                        ( I_Student_Detail_ID ,
                          I_Centre_Id ,
                          N_Invoice_Amount ,
                          N_Discount_Amount ,
                          I_Coupon_Discount ,
                          N_Tax_Amount ,
                          Dt_Invoice_Date ,
                          I_Status ,
                          I_Discount_Scheme_ID ,
                          I_Discount_Applied_At ,
                          S_Crtd_By ,
                          Dt_Crtd_On,
                          I_Parent_Invoice_ID
                        )
                VALUES  ( @ipI_Student_Detail_ID ,
                          @ipI_Centre_Id ,
                          @ipN_Invoice_Amount ,
                          @ipN_Discount_Amount ,
                          @ipI_Coupon_Discount ,
                          @ipN_Tax_Amount ,
                          @ipDt_Invoice_Date ,
                          @ipI_Status ,
                          @ipI_Discount_Scheme_ID ,
                          @ipI_Discount_Applied_At ,
                          @ipS_Crtd_By ,
                          @ipDt_Crtd_On,
                          @iParentInvoiceID
                        )          
          
                SET @iInvoiceID = SCOPE_IDENTITY()          
                DECLARE @iInvoiceNo BIGINT          
            
                SELECT  @iInvoiceNo = MAX(CAST(S_Invoice_No AS BIGINT))
                FROM    T_Invoice_Parent TIP
                WHERE   I_Invoice_Header_ID NOT IN (
                        SELECT  I_Invoice_Header_ID
                        FROM    T_Invoice_Parent
                        WHERE   @iInvoiceNo LIKE '%[A-Z]' )          
				AND TIP.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)        
          
                SET @iInvoiceNo = ISNULL(@iInvoiceNo, 0) + 1          
          
                UPDATE  T_INVOICE_PARENT
                SET     S_Invoice_No = CAST(@iInvoiceNo AS VARCHAR(20))
                WHERE   I_Invoice_Header_ID = @iInvoiceID 
				
				SET @StudentDetailID=@ipI_Student_Detail_ID
          
             
   -- open cursor for invoice child          
                DECLARE UPLOADINVOICECHILD_CURSOR CURSOR FOR           
                SELECT I_Invoice_Child_Header_ID,          
                I_Invoice_Header_ID,          
                I_Course_ID,          
                I_Batch_ID,          
                I_Course_FeePlan_ID,          
                C_Is_LumpSum ,        
                N_Discount_Amount,    
                I_Discount_Scheme_ID,    
                I_Discount_Applied_At         
                FROM #tempInvoiceChild          
                WHERE I_Invoice_Header_ID = @ipI_Invoice_Header_ID          
          
                OPEN UPLOADINVOICECHILD_CURSOR           
                FETCH NEXT FROM UPLOADINVOICECHILD_CURSOR           
   INTO @icI_Invoice_Child_Header_ID,          
    @icI_Invoice_Header_ID,          
    @icI_Course_ID,          
    @icI_Batch_ID,          
    @icI_Course_FeePlan_ID,          
    @icC_Is_LumpSum ,         
    @icN_Discount_Amount,    
    @icI_Discount_Scheme_ID,    
    @icI_Discount_Applied_At            
            
                WHILE @@FETCH_STATUS = 0 
                    BEGIN           
                        INSERT  INTO dbo.T_Invoice_Child_Header
                                ( I_Invoice_Header_ID ,
                                  I_Course_ID ,
                                  I_Course_FeePlan_ID ,
                                  C_Is_LumpSum ,
                                  N_Discount_Amount ,
                                  I_Discount_Scheme_ID ,
                                  I_Discount_Applied_At
                                )
                        VALUES  ( @iInvoiceID ,
                                  @icI_Course_ID ,
                                  @icI_Course_FeePlan_ID ,
                                  @icC_Is_LumpSum ,
                                  @icN_Discount_Amount ,
                                  @icI_Discount_Scheme_ID ,
                                  @icI_Discount_Applied_At
                                )          
              
                        SET @iInvoiceChildID = SCOPE_IDENTITY()          
          
                        IF @icI_Batch_ID IS NOT NULL 
                            BEGIN      
                                INSERT  INTO dbo.T_Invoice_Batch_Map
                                        ( I_Invoice_Child_Header_ID ,
                                          I_Batch_ID ,
                                          I_Status ,
                                          S_Crtd_By ,
                                          Dt_Crtd_On
                                        )
                                VALUES  ( @iInvoiceChildID ,
                                          @icI_Batch_ID ,
                                          @ipI_Status ,
                                          @ipS_Crtd_By ,
                                          @ipDt_Crtd_On
                                        )
										
								SET @BatchID=@icI_Batch_ID
								
                            END        
              
    -- START INSERTION PROCESS FOR INVOICE CHILD DETAILS          
          
                        DECLARE UPLOADINVOICECHILDDETAILS_CURSOR CURSOR FOR           
                        SELECT I_Invoice_Detail_ID,          
                        I_Fee_Component_ID,          
                        I_Invoice_Child_Header_ID,          
                        I_Installment_No,          
                        Dt_Installment_Date,          
                        N_Amount_Due,
						N_Amount_Discount,
						N_Amount_Payable,
                        I_Display_Fee_Component_ID,          
                        I_Sequence          
                        FROM #tempInvoiceChildDetail          
                        WHERE I_Invoice_Child_Header_ID = @icI_Invoice_Child_Header_ID          
          
                        OPEN UPLOADINVOICECHILDDETAILS_CURSOR           
                        FETCH NEXT FROM UPLOADINVOICECHILDDETAILS_CURSOR           
    INTO @icdI_Invoice_Detail_ID,          
      @icdI_Fee_Component_ID,          
      @icdI_Invoice_Child_Header_ID,          
      @icdI_Installment_No,          
      @icdDt_Installment_Date,          
      @icdN_Amount_Due,
	  @icdN_Amount_Discount,
	  @icdN_Amount_Payable,
      @icdI_Display_Fee_Component_ID,          
      @icdI_Sequence          
                 
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN           
                                INSERT  INTO dbo.T_Invoice_Child_Detail
                                        ( I_Fee_Component_ID ,
                                          I_Invoice_Child_Header_ID ,
                                          I_Installment_No ,
                                          Dt_Installment_Date ,
                                          N_Amount_Due ,
										  N_Discount_Amount,
										  N_Due,
                                          I_Display_Fee_Component_ID ,
                                          I_Sequence
                                        )
                                VALUES  ( @icdI_Fee_Component_ID ,
                                          @iInvoiceChildID ,
                                          @icdI_Installment_No ,
                                          @icdDt_Installment_Date ,
                                          @icdN_Amount_Due ,
										  @icdN_Amount_Discount,
										  @icdN_Amount_Payable,
                                          @icdI_Display_Fee_Component_ID ,
                                          @icdI_Sequence
                                        )  
          
                                SET @iInvoiceChildDetailsID = SCOPE_IDENTITY() 
                                
                                INSERT  INTO #tempInvoiceNOChildDetail    
                                                            
                                 VALUES  (
										  @iInvoiceID,
										  @icdI_Fee_Component_ID ,
                                          @iInvoiceChildDetailsID ,
                                          @icdI_Installment_No ,
                                          @icdDt_Installment_Date ,
                                          @icdN_Amount_Due ,
										  @icdN_Amount_Discount,
										  @icdN_Amount_Payable,
                                          @icdI_Display_Fee_Component_ID ,
                                          @icdI_Sequence
                                        )  
                                       
          
--     -- INITIATE PROCESS TO ENTER THE TAX DETAILS FOR THE INVOICE          
          
                                DECLARE UPLOADINVOICECHILDDETAILSTAX_CURSOR CURSOR FOR           
                                SELECT I_Tax_ID,          
                                I_Invoice_Detail_ID,          
                                N_Tax_Value          
                                FROM #tempInvoiceTax          
                                WHERE I_Invoice_Detail_ID = @icdI_Invoice_Detail_ID          
          
                                OPEN UPLOADINVOICECHILDDETAILSTAX_CURSOR           
                                FETCH NEXT FROM UPLOADINVOICECHILDDETAILSTAX_CURSOR           
     INTO @itdI_Tax_ID,          
      @itdI_Invoice_Detail_ID,          
      @itdN_Tax_Value          
                  
                                WHILE @@FETCH_STATUS = 0 
                                    BEGIN           
                                        INSERT  INTO dbo.T_Invoice_Detail_Tax
                                                ( I_Tax_ID ,
                                                  I_Invoice_Detail_ID ,
                                                  N_Tax_Value,
                                                  N_Tax_Value_Scheduled
                                                )
                                        VALUES  ( @itdI_Tax_ID ,
                                                  @iInvoiceChildDetailsID ,
                                                  @itdN_Tax_Value,
                                                  @itdN_Tax_Value
                                                )          
          
          
                                        FETCH NEXT FROM UPLOADINVOICECHILDDETAILSTAX_CURSOR           
      INTO @itdI_Tax_ID,          
       @itdI_Invoice_Detail_ID,          
       @itdN_Tax_Value          
                                    END          
                                CLOSE UPLOADINVOICECHILDDETAILSTAX_CURSOR           
                                DEALLOCATE UPLOADINVOICECHILDDETAILSTAX_CURSOR           
           
--     -- END OF PROCESS TO ENTER THE TAX DETAILS              
          
          
                                FETCH NEXT FROM UPLOADINVOICECHILDDETAILS_CURSOR           
     INTO @icdI_Invoice_Detail_ID,          
       @icdI_Fee_Component_ID,          
       @icdI_Invoice_Child_Header_ID,          
       @icdI_Installment_No,          
       @icdDt_Installment_Date,          
       @icdN_Amount_Due, 
	   @icdN_Amount_Discount,
	   @icdN_Amount_Payable,
       @icdI_Display_Fee_Component_ID,          
       @icdI_Sequence          
                            END          
                        CLOSE UPLOADINVOICECHILDDETAILS_CURSOR           
                        DEALLOCATE UPLOADINVOICECHILDDETAILS_CURSOR           
          
    -- FETCH NEXT FOR INVOICE CHILD CURSOR          
                        FETCH NEXT FROM UPLOADINVOICECHILD_CURSOR           
    INTO @icI_Invoice_Child_Header_ID,          
     @icI_Invoice_Header_ID,          
     @icI_Course_ID,          
     @icI_Batch_ID,          
     @icI_Course_FeePlan_ID,               
     @icC_Is_LumpSum,      
     @icN_Discount_Amount,    
     @icI_Discount_Scheme_ID,    
     @icI_Discount_Applied_At          
                    END          
                CLOSE UPLOADINVOICECHILD_CURSOR           
                DEALLOCATE UPLOADINVOICECHILD_CURSOR           
          
  -- FETCH NEXT FOR INVOICE PARENT CURSOR          
                FETCH NEXT FROM UPLOADINVOICEPARENT_CURSOR           
    INTO @ipI_Invoice_Header_ID,          
    @ipI_Student_Detail_ID,          
    @ipI_Centre_Id,          
    @ipN_Invoice_Amount,          
    @ipN_Discount_Amount,          
    @ipI_Coupon_Discount,          
    @ipN_Tax_Amount,          
    @ipDt_Invoice_Date,          
    @ipI_Status,          
    @ipI_Discount_Scheme_ID,          
    @ipI_Discount_Applied_At,          
    @ipS_Crtd_By,          
    @ipDt_Crtd_On          
            END          
          
        CLOSE UPLOADINVOICEPARENT_CURSOR           
        DEALLOCATE UPLOADINVOICEPARENT_CURSOR           
          
-- Update Course wise fees paid for the invoice          
        DECLARE @iInvoiceChildHeaderID INT           
        DECLARE @iCourseFee NUMERIC(18, 2)          
        DECLARE @iCourseTax NUMERIC(18, 2)          
          
          
        DECLARE UPDATE_COURSEFEE CURSOR FOR          
        SELECT I_Invoice_Child_Header_ID FROM dbo.T_Invoice_Child_Header          
        WHERE I_Invoice_Header_ID = @iInvoiceID          
          
          
        OPEN UPDATE_COURSEFEE           
        FETCH NEXT FROM UPDATE_COURSEFEE INTO @iInvoiceChildHeaderID          
            
        WHILE @@FETCH_STATUS = 0 
            BEGIN           
                SELECT  @iCourseFee = SUM(N_Amount_Due)
                FROM    dbo.T_Invoice_Child_Detail
                WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID          
          
                SELECT  @iCourseTax = SUM(IDT.N_Tax_Value)
                FROM    dbo.T_Invoice_Detail_Tax IDT
                        INNER JOIN dbo.T_Invoice_Child_Detail ICD ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                WHERE   ICD.I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID          
          
                UPDATE  dbo.T_Invoice_Child_Header
                SET     N_Amount = @iCourseFee ,
                        N_Tax_Amount = @iCourseTax
                WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID          
          
                FETCH NEXT FROM UPDATE_COURSEFEE INTO @iInvoiceChildHeaderID                
              
            END          
            
        CLOSE UPDATE_COURSEFEE           
        DEALLOCATE UPDATE_COURSEFEE
		
		
        PRINT @StudentDetailID
		PRINT @BatchID
		IF(@StudentDetailID>0 and @BatchID>0)
		BEGIN
			EXEC LMS.uspInsertStudentBatchDetailsForInterface @StudentDetailID,@BatchID,NULL,NULL
		END


         SELECT  @iInvoiceID AS I_Invoice_ID   
        
         -- INSERT Invoice Number
						DECLARE @row INT = 1
						DECLARE @count INT
						DECLARE @I_Invoice_Header_ID INT
						DECLARE @Dt_Installment_Date DATETIME
						DECLARE @I_Invoice_Detail_ID INT
						DECLARE @I_Installment_No INT
						DECLARE @INVN VARCHAR(256)
						
						SELECT @count = COUNT(I_Invoice_Detail_ID) FROM #tempInvoiceChildDetail
						
						
						WHILE (@row <= @count)
				BEGIN

					SELECT 
						@I_Invoice_Header_ID = I_Invoice_Header_ID,
						@Dt_Installment_Date = Dt_Installment_Date,
						@I_Invoice_Detail_ID = I_Invoice_Detail_ID,
						@I_Installment_No = I_Installment_No ,
						@InvoiceType = 'I' 
					FROM #tempInvoiceNOChildDetail
					WHERE ID = @row	
						
					EXEC dbo.uspGenerateInvoiceNumber  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date,@InvoiceType, @INVN OUTPUT							
						
					UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID

					
				SET @row = @row + 1
				END
				--SELECT * FROM #tempInvoiceNOChildDetail
       -- END TO INSERT INVOICE NUMBER 

	   


		--SELECT  @iInvoiceID AS I_Invoice_ID 
                
          
              
        COMMIT TRANSACTION          
    END TRY          
    BEGIN CATCH          
--Error occurred:            
        ROLLBACK TRANSACTION          
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT          
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()          
          
        RAISERROR(@ErrMsg, @ErrSeverity, 1)          
    END CATCH  
