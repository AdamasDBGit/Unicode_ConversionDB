CREATE PROCEDURE [ERP].[uspPrepareStudentFinancialData]
    (
      @dtExecutionDate DATETIME = NULL,
      @iBrandID INT=NULL
    )
AS 
    BEGIN
        IF ( @dtExecutionDate IS NULL ) 
            SET @dtExecutionDate = DATEADD(dd,-1,GETDATE())
		
        EXEC ERP.uspPrepareStudentFeeAccrualData @dtExecutionDate, @iBrandID					-- 1
        EXEC ERP.uspPrepareStudentFeeCancellationData @dtExecutionDate, @iBrandID				-- 2
        EXEC ERP.uspPrepareStudentCollectionData @dtExecutionDate, @iBrandID					-- 3
        EXEC ERP.uspPrepareStudentCollectionDepositData @dtExecutionDate, @iBrandID			    -- 4
        EXEC ERP.uspPrepareStudentCollectionCashData @dtExecutionDate, @iBrandID				-- 5
        EXEC ERP.uspPrepareStudentAccrualAdjustmentData @dtExecutionDate, @iBrandID			    -- 6
        EXEC ERP.uspPrepareStudentCollectionReversalData @dtExecutionDate, @iBrandID			-- 7
        EXEC ERP.uspPrepareStudentCollectionCashReversalData @dtExecutionDate, @iBrandID		-- 8
        EXEC ERP.uspPrepareStudentAccrualAdjustmentReversalData @dtExecutionDate, @iBrandID	    -- 9
        EXEC ERP.uspPrepareStudentSecurityDepositRefundData @dtExecutionDate, @iBrandID		    -- 10,11
        EXEC ERP.uspPrepareStudentAgencyPaymentData @dtExecutionDate, @iBrandID				    -- 12,13
        EXEC ERP.uspPrepareStudentAgencyPaymentDataReversal @dtExecutionDate, @iBrandID   --akash  15,17
        EXEC ERP.uspPrepareStudentCollectionDataDebitCreditCrd @dtExecutionDate, @iBrandID
        EXEC ERP.uspPrepareStudentCollectionDepositDataDebitCreditCrd @dtExecutionDate, @iBrandID
        EXEC ERP.uspPrepareStudentCollectionReversalDataDebitCreditCrd @dtExecutionDate, @iBrandID
        EXEC ERP.uspPrepareStudentCollectionTDSReceivableData @dtExecutionDate, @iBrandID
        EXEC ERP.uspPrepareStudentCollectionTDSReceivableReversalData @dtExecutionDate, @iBrandID
        
        
        
        
        
        
        IF @iBrandID IS NOT NULL
        
        BEGIN
        
        DECLARE @Entity VARCHAR(MAX)=NULL
        
        SELECT @Entity=TBM.S_Brand_Code FROM dbo.T_Brand_Master AS TBM WHERE TBM.I_Brand_ID=@iBrandID
        
        
        
        INSERT  INTO ERP.Transaction_Interface_Template
                ( Entity ,
                  [Cost Centre] ,
                  [Transaction Type] ,
                  Amount ,
                  Date ,
                  [Instrument Number] ,
                  [Bank Account Name] ,
                  [Interfaced Flag] ,
                  [Error Message]
	          )
                SELECT  tbm.S_Brand_Code ,
                        CAST(tstd.S_Cost_Center AS INT) ,
                        tttm.S_Transaction_Type ,
                        SUM(tstd.N_Amount) ,
                        tstd.Transaction_Date ,
                        tstd.Instrument_Number ,
                        tstd.Bank_Account_Name ,
                        NULL ,
                        NULL
                FROM    ERP.T_Student_Transaction_Details AS tstd
                        INNER JOIN dbo.T_Brand_Master AS tbm ON tstd.I_Brand_ID = tbm.I_Brand_ID
                        INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Transaction_Type_ID = tstd.I_Transaction_Type_ID
                WHERE   DATEDIFF(dd, tstd.Transaction_Date, @dtExecutionDate) = 0
                AND tbm.I_Brand_ID=@iBrandID
                GROUP BY tbm.S_Brand_Code ,
                        tstd.S_Cost_Center ,
                        tttm.S_Transaction_Type ,
                        tstd.Transaction_Date ,
                        tstd.Instrument_Number ,
                        tstd.Bank_Account_Name

        --INSERT  OPENQUERY(PROD, 'SELECT ENTITY_NAME,
								--			  COST_CENTRE_CODE,
								--			  TRANSACTION_TYPE_NAME,
								--			  TRANSACTION_NUMBER,
								--			  TOTAL_AMOUNT,
								--			  TRANSACTION_DATE,
								--			  INSTRUMENT_NO,
								--			  BANK_ACCOUNT_NAME,
								--			  INTERFACE_FLAG,
								--			  ERROR_MESSAGE
								--			FROM apps.XXRICE_SMS_INT_TBA')
        --        SELECT  tit.Entity ,
        --                tit.[Cost Centre] ,
        --                tit.[Transaction Type] ,
        --                tit.[Transaction Number] ,
        --                tit.Amount ,
        --                tit.[Date] ,
        --                tit.[Instrument Number] ,
        --                tit.[Bank Account Name] ,
        --                tit.[Interfaced Flag] ,
        --                tit.[Error Message]
        --        FROM    ERP.Transaction_Interface_Template AS tit
        --        WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0
        --        AND tit.Entity=@Entity


				----Added For Oracle Push Replica Table : 2023Sep After Attack: Susmita ---

				INSERT INTO [ERP].[T_Oracle_Push]
					([Oracle_ENTITY_NAME],
					 [COST_CENTRE_CODE],
					 [TRANSACTION_TYPE_NAME],
					 [TRANSACTION_NUMBER],
					 [TOTAL_AMOUNT],
					 [TRANSACTION_DATE],
					 [INSTRUMENT_NO],
					 [BANK_ACCOUNT_NAME],
					 [INTERFACE_FLAG],
					 [Oracle_ERROR_MESSAGE])
                SELECT  tit.Entity ,
                        tit.[Cost Centre] ,
                        tit.[Transaction Type] ,
                        tit.[Transaction Number] ,
                        tit.Amount ,
                        tit.[Date] ,
                        tit.[Instrument Number] ,
                        tit.[Bank Account Name] ,
                        tit.[Interfaced Flag] ,
                        tit.[Error Message]
                FROM    ERP.Transaction_Interface_Template AS tit
                WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0
                AND tit.Entity=@Entity


				------------------------------------------------------



		
        INSERT  INTO ERP.Transaction_Interface_Template_History
                SELECT  *
                FROM    ERP.Transaction_Interface_Template AS tit
                WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0
                AND tit.Entity=@Entity
                
        DELETE FROM ERP.Transaction_Interface_Template
                WHERE   DATEDIFF(dd, [Date], @dtExecutionDate) = 0
                AND Entity=@Entity
                
    END
    
    ELSE
    
    BEGIN
    
            INSERT  INTO ERP.Transaction_Interface_Template
                ( Entity ,
                  [Cost Centre] ,
                  [Transaction Type] ,
                  Amount ,
                  Date ,
                  [Instrument Number] ,
                  [Bank Account Name] ,
                  [Interfaced Flag] ,
                  [Error Message]
	          )
                SELECT  tbm.S_Brand_Code ,
                        CAST(tstd.S_Cost_Center AS INT) ,
                        tttm.S_Transaction_Type ,
                        SUM(tstd.N_Amount) ,
                        tstd.Transaction_Date ,
                        tstd.Instrument_Number ,
                        tstd.Bank_Account_Name ,
                        NULL ,
                        NULL
                FROM    ERP.T_Student_Transaction_Details AS tstd
                        INNER JOIN dbo.T_Brand_Master AS tbm ON tstd.I_Brand_ID = tbm.I_Brand_ID
                        INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Transaction_Type_ID = tstd.I_Transaction_Type_ID
                WHERE   DATEDIFF(dd, tstd.Transaction_Date, @dtExecutionDate) = 0
                GROUP BY tbm.S_Brand_Code ,
                        tstd.S_Cost_Center ,
                        tttm.S_Transaction_Type ,
                        tstd.Transaction_Date ,
                        tstd.Instrument_Number ,
                        tstd.Bank_Account_Name

        --INSERT  OPENQUERY(PROD, 'SELECT ENTITY_NAME,
								--			  COST_CENTRE_CODE,
								--			  TRANSACTION_TYPE_NAME,
								--			  TRANSACTION_NUMBER,
								--			  TOTAL_AMOUNT,
								--			  TRANSACTION_DATE,
								--			  INSTRUMENT_NO,
								--			  BANK_ACCOUNT_NAME,
								--			  INTERFACE_FLAG,
								--			  ERROR_MESSAGE
								--			FROM apps.XXRICE_SMS_INT_TBA')
        --        SELECT  tit.Entity ,
        --                tit.[Cost Centre] ,
        --                tit.[Transaction Type] ,
        --                tit.[Transaction Number] ,
        --                tit.Amount ,
        --                tit.[Date] ,
        --                tit.[Instrument Number] ,
        --                tit.[Bank Account Name] ,
        --                tit.[Interfaced Flag] ,
        --                tit.[Error Message]
        --        FROM    ERP.Transaction_Interface_Template AS tit
        --        WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0



				----Added For Oracle Push Replica Table : 2023Sep After Attack: Susmita ---

				INSERT INTO [ERP].[T_Oracle_Push]
					([Oracle_ENTITY_NAME],
					 [COST_CENTRE_CODE],
					 [TRANSACTION_TYPE_NAME],
					 [TRANSACTION_NUMBER],
					 [TOTAL_AMOUNT],
					 [TRANSACTION_DATE],
					 [INSTRUMENT_NO],
					 [BANK_ACCOUNT_NAME],
					 [INTERFACE_FLAG],
					 [Oracle_ERROR_MESSAGE])
                SELECT  tit.Entity ,
                        tit.[Cost Centre] ,
                        tit.[Transaction Type] ,
                        tit.[Transaction Number] ,
                        tit.Amount ,
                        tit.[Date] ,
                        tit.[Instrument Number] ,
                        tit.[Bank Account Name] ,
                        tit.[Interfaced Flag] ,
                        tit.[Error Message]
                FROM    ERP.Transaction_Interface_Template AS tit
                WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0
                AND tit.Entity=@Entity


				------------------------------------------------------


		
        INSERT  INTO ERP.Transaction_Interface_Template_History
                SELECT  *
                FROM    ERP.Transaction_Interface_Template AS tit
                WHERE   DATEDIFF(dd, tit.[Date], @dtExecutionDate) = 0
                
        DELETE FROM ERP.Transaction_Interface_Template
                WHERE   DATEDIFF(dd, [Date], @dtExecutionDate) = 0
    
    END
    
                
                
    END
