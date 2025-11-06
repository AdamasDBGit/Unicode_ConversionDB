CREATE PROCEDURE [dbo].[uspCreateTransferInInvoice]  --exec uspCreateTransferInInvoice 158949, 3265, 1, 'sarmisthasanyal', 107, 0
    @iCancelledInvoiceId INT ,   
    @iStudentId INT ,   
    @iCenterId INT ,   
    @iUserId NVARCHAR(max),   
    @iBrandID INT , 
    @iInvoiceHeaderId INT 
AS   
    BEGIN                     
        BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @iInvoiceID INT
		DECLARE @iInvoiceDetailId INT
		DECLARE @iFeeComponentID INT
		DECLARE @dtInstallmentDate datetime
		DECLARE @nAmountDue numeric(18,2)
		DECLARE @iInvoiceChildID INT                     
		DECLARE @iInvoiceChildDetailsID INT   
		DECLARE @iTransferInvChildID int

		DECLARE @IPTempTable TABLE   
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
		  S_Crtd_By nvarchar(max) ,   
		  Dt_Crtd_On DATETIME   
		)

		DECLARE @ICHTempTable TABLE
		(   
		  I_Invoice_Child_Header_ID INT ,   
		  I_Invoice_Header_ID INT ,   
		  I_Course_ID INT ,   
		  I_Course_FeePlan_ID INT ,   
		  C_Is_LumpSum CHAR(1) ,   
		  N_Amount NUMERIC(18, 2) ,   
		  N_Tax_Amount NUMERIC(18, 2)   
		)
		                
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
		)

		DECLARE @IDTTempTable TABLE    
		(    
		  I_Tax_ID INT ,    
		  I_Invoice_Detail_ID INT ,
		  N_Tax_Value NUMERIC(18,6),
		  N_Tax_Value_Schedule NUMERIC(18,6)
		) 

		INSERT INTO @ICDTempTable
		SELECT DISTINCT ICD.I_Invoice_Detail_ID,ICD.I_Fee_Component_ID,ICD.I_Invoice_Child_Header_ID,ICD.I_Installment_No,ICD.Dt_Installment_Date
						,(ISNULL(ICD.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due
						,ICD.I_Display_Fee_Component_ID,ICD.I_Sequence,ICD.N_Amount_Adv_Coln,ICD.Flag_IsAdvanceTax             
		FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )    
				INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
				LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID    
															  AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID  
		LEFT JOIN (SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
		FROM T_Receipt_Header RH
		INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
		WHERE RH.I_Invoice_Header_ID = @iCancelledInvoiceId
		AND ISNULL(RH.I_Status,0) <> 0
		GROUP BY RCD.I_Invoice_Detail_ID) A	ON ICD.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID  
		WHERE   ICH.I_Invoice_Header_ID = @iCancelledInvoiceId    
		--ADDITION STARTED ON 26/06/2017
		AND ISNULL(ICD.Flag_IsAdvanceTax,'') <> 'Y'
		AND CONVERT(DATE, ICD.Dt_Installment_Date) > CONVERT(DATE, GETDATE())
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
					   CAST(@nAmountDue * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value_Schedule
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

		INSERT INTO @IPTempTable
		SELECT TIP.I_Invoice_Header_ID,TIP.I_Student_Detail_ID,TIP.I_Centre_Id,
			   ISNULL((SELECT SUM(N_Amount_Due) FROM @ICDTempTable),0.00) N_Invoice_Amount,
				TIP.N_Discount_Amount
			   ,TIP.I_Coupon_Discount
			   ,ISNULL((SELECT SUM(N_Tax_Value) FROM @IDTTempTable),0.00) N_Tax_Amount,
			   TIP.Dt_Invoice_Date,TIP.I_Status,TIP.I_Discount_Scheme_ID,TIP.I_Discount_Applied_At,TIP.S_Crtd_By,TIP.Dt_Crtd_On
		FROM    T_Invoice_Parent TIP WITH ( NOLOCK )    
		LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID    
		LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2 ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID
		WHERE   TIP.I_Invoice_Header_ID = @iCancelledInvoiceId

		INSERT INTO @ICHTempTable
		SELECT  TIVC.I_Invoice_Child_Header_ID ,    
				TIVC.I_Invoice_Header_ID ,    
				TIVC.I_Course_ID ,    
				TIVC.I_Course_FeePlan_ID ,    
				TIVC.C_Is_LumpSum ,    
				ISNULL(C.N_Amount_Due, 0) AS N_Amount ,    
				ISNULL(C.N_Tax_Value, 0) AS N_Tax_Amount
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
		WHERE   TIVC.I_Invoice_Header_ID = @iCancelledInvoiceId  

		--SELECT * FROM @IPTempTable

		--SELECT * FROM @ICHTempTable 

		--SELECT * FROM @ICDTempTable

		--SELECT * FROM @IDTTempTable

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
		DECLARE @ipS_Crtd_By nvarchar(max)                     
		DECLARE @ipDt_Crtd_On DATETIME                     
		--defination of the variables of the invoice child                     
		DECLARE @icI_Invoice_Child_Header_ID INT                     
		DECLARE @icI_Invoice_Header_ID INT                     
		DECLARE @icI_Course_ID INT                     
		DECLARE @icI_Course_FeePlan_ID INT                     
		DECLARE @icC_Is_LumpSum CHAR(1)                     
		DECLARE @icN_Amount NUMERIC(18, 2)                     
		DECLARE @icN_Tax_Amount NUMERIC(18, 2)                     
		--DEFINATION OF THE VARIABLES OF THE INVOICE CHILD DETAILS                     
		DECLARE @icdI_Invoice_Detail_ID INT                     
		DECLARE @icdI_Fee_Component_ID INT                     
		DECLARE @icdI_Invoice_Child_Header_ID INT                     
		DECLARE @icdI_Installment_No INT                     
		DECLARE @icdDt_Installment_Date DATETIME                     
		DECLARE @icdN_Amount_Due NUMERIC(18, 2)                     
		DECLARE @icdI_Display_Fee_Component_ID INT                     
		DECLARE @icdI_Sequence INT                     
		-- DEFINATION OF THE VARIABLE TO INSERT TAX DETAILS                     
		DECLARE @itdI_Tax_ID INT                     
		DECLARE @itdI_Invoice_Detail_ID INT                     
		DECLARE @itdN_Tax_Value NUMERIC(18, 2)   
		DECLARE @itdN_Tax_Value_Schedule NUMERIC(18, 2) 
		            
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
			FROM @IPTempTable
		            
			OPEN UPLOADINVOICEPARENT_CURSOR                     
			FETCH NEXT FROM UPLOADINVOICEPARENT_CURSOR INTO @ipI_Invoice_Header_ID,@ipI_Student_Detail_ID,@ipI_Centre_Id,@ipN_Invoice_Amount,@ipN_Discount_Amount,                     
															@ipI_Coupon_Discount,@ipN_Tax_Amount,@ipDt_Invoice_Date,@ipI_Status,@ipI_Discount_Scheme_ID,                     
															@ipI_Discount_Applied_At,@ipS_Crtd_By,@ipDt_Crtd_On			 
					              
				WHILE @@FETCH_STATUS = 0   
				BEGIN                    
					UPDATE  dbo.T_Invoice_Parent   
					SET     I_Status = 0 ,   
							S_Upd_By = @iUserId ,   
							Dt_Upd_On = GETDATE()   
					WHERE   I_Student_Detail_Id = @iStudentId   
							AND I_Invoice_Header_Id = @ipI_Invoice_Header_ID                     
				    
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
							  @iCenterId ,   
							  @ipN_Invoice_Amount ,   
							  @ipN_Discount_Amount ,   
							  @ipI_Coupon_Discount ,   
							  @ipN_Tax_Amount ,   
							  @ipDt_Invoice_Date ,   
							  @ipI_Status ,   
							  @ipI_Discount_Scheme_ID ,   
							  @ipI_Discount_Applied_At ,   
							  @iUserId ,   
							  GETDATE() , 
							  @iCancelledInvoiceId 
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
					
					DECLARE UPLOADINVOICECHILD_CURSOR CURSOR FOR                     
							SELECT I_Invoice_Child_Header_ID,                     
							I_Invoice_Header_ID,                     
							I_Course_ID,                     
							I_Course_FeePlan_ID,                     
							C_Is_LumpSum,                     
							N_Amount,                     
							N_Tax_Amount                     
							FROM @ICHTempTable           
							WHERE I_Invoice_Header_ID = @ipI_Invoice_Header_ID 
		            
		            
					OPEN UPLOADINVOICECHILD_CURSOR                     
					FETCH NEXT FROM UPLOADINVOICECHILD_CURSOR INTO @icI_Invoice_Child_Header_ID,@icI_Invoice_Header_ID,@icI_Course_ID,                     
																   @icI_Course_FeePlan_ID,@icC_Is_LumpSum,@icN_Amount,@icN_Tax_Amount 
					WHILE @@FETCH_STATUS = 0   
						BEGIN                     
						INSERT  INTO dbo.T_Invoice_Child_Header   
						(	I_Invoice_Header_ID ,   
							I_Course_ID ,   
							I_Course_FeePlan_ID ,   
							C_Is_LumpSum ,   
							N_Amount ,   
							N_Tax_Amount   
						)   
						VALUES  ( 
							@iInvoiceID ,   
							@icI_Course_ID ,   
							@icI_Course_FeePlan_ID ,   
							@icC_Is_LumpSum ,   
							@icN_Amount ,   
							@icN_Tax_Amount 
						)                     

						SET @iInvoiceChildID = SCOPE_IDENTITY()   
						    
						IF  @icI_Course_ID IS NOT NULL 
						BEGIN 
						SELECT @iTransferInvChildID=I_Invoice_Child_Header_ID FROM dbo.T_Invoice_Child_Header AS tich 
						INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_Header_ID = tip.I_Invoice_Header_ID 
						WHERE I_Course_ID=@icI_Course_ID AND I_Student_Detail_ID=@iStudentId AND tip.I_Invoice_Header_ID=@iInvoiceHeaderId 

						UPDATE dbo.T_Invoice_Batch_Map SET I_Invoice_Child_Header_ID=@iInvoiceChildID 
						WHERE I_Invoice_Child_Header_ID =@iTransferInvChildID END
						
						DECLARE UPLOADINVOICECHILDDETAILS_CURSOR CURSOR FOR                     
								SELECT I_Invoice_Detail_ID,                     
								I_Fee_Component_ID,                     
								I_Invoice_Child_Header_ID,                     
								I_Installment_No,                     
								Dt_Installment_Date,                     
								N_Amount_Due,                     
								I_Display_Fee_Component_ID,                     
								I_Sequence                     
								FROM @ICDTempTable                     
								WHERE I_Invoice_Child_Header_ID = @icI_Invoice_Child_Header_ID                     
		                
									OPEN UPLOADINVOICECHILDDETAILS_CURSOR                     
									FETCH NEXT FROM UPLOADINVOICECHILDDETAILS_CURSOR  INTO @icdI_Invoice_Detail_ID,@icdI_Fee_Component_ID,                     
																					  @icdI_Invoice_Child_Header_ID,@icdI_Installment_No,                     
																					  @icdDt_Installment_Date,@icdN_Amount_Due,@icdI_Display_Fee_Component_ID,                     
																					  @icdI_Sequence                     
		                        
										WHILE @@FETCH_STATUS = 0   
											BEGIN                     
												INSERT  INTO dbo.T_Invoice_Child_Detail   
														( I_Fee_Component_ID ,   
														  I_Invoice_Child_Header_ID ,   
														  I_Installment_No ,   
														  Dt_Installment_Date ,   
														  N_Amount_Due ,   
														  I_Display_Fee_Component_ID ,   
														  I_Sequence   
														)   
												VALUES  ( @icdI_Fee_Component_ID ,   
														  @iInvoiceChildID ,   
														  @icdI_Installment_No ,   
														  @icdDt_Installment_Date ,   
														  @icdN_Amount_Due ,   
														  @icdI_Display_Fee_Component_ID ,   
														  @icdI_Sequence   
														)
												SET @iInvoiceChildDetailsID = SCOPE_IDENTITY()
												
												DECLARE @INVN nvarchar(max)
												
												EXEC dbo.uspGenerateInvoiceNumber  @iInvoiceID,@icdI_Installment_No,@icdDt_Installment_Date,'I', @INVN OUTPUT
												UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @iInvoiceChildDetailsID
												
												DECLARE UPLOADINVOICECHILDDETAILSTAX_CURSOR CURSOR FOR                     
												SELECT I_Tax_ID,                     
												I_Invoice_Detail_ID,                     
												N_Tax_Value,
												N_Tax_Value_Schedule                     
												FROM @IDTTempTable                     
												WHERE I_Invoice_Detail_ID = @icdI_Invoice_Detail_ID                     
		                
										OPEN UPLOADINVOICECHILDDETAILSTAX_CURSOR                     
										FETCH NEXT FROM UPLOADINVOICECHILDDETAILSTAX_CURSOR INTO @itdI_Tax_ID,@itdI_Invoice_Detail_ID,@itdN_Tax_Value,@itdN_Tax_Value_Schedule                    
		                        
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
														  @itdN_Tax_Value_Schedule  
														)                     
		                
		                
												FETCH NEXT FROM UPLOADINVOICECHILDDETAILSTAX_CURSOR INTO @itdI_Tax_ID,@itdI_Invoice_Detail_ID,                     
																										 @itdN_Tax_Value,@itdN_Tax_Value_Schedule                     
											END                     
										CLOSE UPLOADINVOICECHILDDETAILSTAX_CURSOR                     
										DEALLOCATE UPLOADINVOICECHILDDETAILSTAX_CURSOR
												
								FETCH NEXT FROM UPLOADINVOICECHILDDETAILS_CURSOR INTO @icdI_Invoice_Detail_ID,@icdI_Fee_Component_ID,                     
																					  @icdI_Invoice_Child_Header_ID,@icdI_Installment_No,                     
																					  @icdDt_Installment_Date,@icdN_Amount_Due,                     
																					  @icdI_Display_Fee_Component_ID,@icdI_Sequence                     
								END                     
							CLOSE UPLOADINVOICECHILDDETAILS_CURSOR                     
							DEALLOCATE UPLOADINVOICECHILDDETAILS_CURSOR
						
						FETCH NEXT FROM UPLOADINVOICECHILD_CURSOR INTO @icI_Invoice_Child_Header_ID,@icI_Invoice_Header_ID,@icI_Course_ID,                     
																  @icI_Course_FeePlan_ID,@icC_Is_LumpSum,@icN_Amount,@icN_Tax_Amount                     
					END                     
				CLOSE UPLOADINVOICECHILD_CURSOR                     
				DEALLOCATE UPLOADINVOICECHILD_CURSOR
		        
				FETCH NEXT FROM UPLOADINVOICEPARENT_CURSOR INTO @ipI_Invoice_Header_ID,@ipI_Student_Detail_ID,@ipI_Centre_Id,@ipN_Invoice_Amount,                     
																@ipN_Discount_Amount,@ipI_Coupon_Discount,@ipN_Tax_Amount,@ipDt_Invoice_Date,                     
																@ipI_Status,@ipI_Discount_Scheme_ID,@ipI_Discount_Applied_At,@ipS_Crtd_By,                     
																@ipDt_Crtd_On                     
				END            
				CLOSE UPLOADINVOICEPARENT_CURSOR                     
				DEALLOCATE UPLOADINVOICEPARENT_CURSOR
				
				UPDATE  T_Invoice_Parent   
				SET     I_Status = 3   
				WHERE   I_Invoice_Header_ID = @iInvoiceID                 
	                
		END TRY                     
		BEGIN CATCH                     
	--Error occurred:                       
	                
			DECLARE @ErrMsg NVARCHAR(max) ,   
				@ErrSeverity INT                     
			SELECT  @ErrMsg = ERROR_MESSAGE() ,   
					@ErrSeverity = ERROR_SEVERITY()                     
	                
			RAISERROR(@ErrMsg, @ErrSeverity, 1)                     
		END CATCH                      
    END


