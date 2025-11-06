CREATE PROCEDURE [dbo].[uspInsertSMSReceiptDetailsFromAPI]
    (
      @sReceiptDetail NVARCHAR(MAX) ,
      @iReceiptHeaderID INT
    )
AS

INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'Starting inside Receipt Detail' -- LogText - varchar(max)
          
          )


    BEGIN TRY
    
    
    INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'Starting inside Receipt Detail TRY BLOCK' -- LogText - varchar(max)
          
          )


        --DECLARE @ReceiptDetailXML NVARCHAR(MAX) 
        DECLARE @iInvoiceDetailId INT
        --DECLARE @iReceiptDetailId INT
        DECLARE @nAmountPaid NUMERIC(18, 2)
        DECLARE @TaxDetailXML XML 
        DECLARE @iReceiptComponentDetailId INT
        DECLARE @iTaxId INT
        DECLARE @nTaxPaid NUMERIC(18, 2)
        DECLARE @AdjPosition SMALLINT ,
            @AdjCount SMALLINT 
        DECLARE @CompanyShare NUMERIC(18, 2)
        DECLARE @TaxShare NUMERIC(18, 2)
        DECLARE @bUseCenterServiceTax BIT
        DECLARE @iInvoiceParentId INT
        DECLARE @iInvoiceNo VARCHAR(256)

        DECLARE @iInvoiceChildHeaderID INT
        DECLARE @iInvoiceHeaderID INT
        DECLARE @iInstallmentNo INT
        DECLARE @dtInstallmentDate DATE

        BEGIN TRANSACTION

        SET @bUseCenterServiceTax = 'FALSE'

        --SET @AdjPosition = 1
        --SET @AdjCount = @sReceiptDetail.value('count((TblRctCompDtl/RowRctCompDtl))',
        --                                      'int')]
		DECLARE @items TABLE(id INT, amount numeric(18,2));

		DECLARE @id INT;
		DECLARE @amount numeric(18,2);

WHILE EXISTS(SELECT * FROM @items) BEGIN
    SELECT TOP(1) @id = id, @amount = amount FROM @items;
    DELETE FROM @items WHERE (id = @id);
    --do what is needed with the values here.
	SELECT  @CompanyShare = [dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,
                                                              CM.I_Country_ID,
                                                              RH.I_Centre_Id,
                                                              ICH.I_Course_ID,
                                                              ICD.I_Fee_Component_ID,
                                                              BCD.I_Brand_ID)
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH ( NOLOCK ) ON ICD.I_Invoice_Detail_ID = @iInvoiceDetailId
                        INNER JOIN dbo.T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Brand_Center_Details BCD ON BCD.I_Centre_Id = RH.I_Centre_Id
                                                              AND BCD.I_Status = 1
                        INNER JOIN dbo.T_Centre_Master CM ON RH.I_Centre_Id = CM.I_Centre_Id
                WHERE   RH.I_Receipt_Header_ID = @iReceiptHeaderID
				 SELECT  @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,
                                                       'False')
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN [dbo].[T_Centre_Master] CM WITH ( NOLOCK ) ON RH.[I_Centre_Id] = CM.[I_Centre_Id]
                WHERE   RH.I_Receipt_Header_ID = @iReceiptHeaderID
				  IF ( @bUseCenterServiceTax = 'TRUE' )
                    BEGIN
                        SET @TaxShare = @CompanyShare
                    END
                ELSE
                    BEGIN
                        SET @TaxShare = 100
                    END
					 INSERT  INTO T_Receipt_Component_Detail
                        ( I_Invoice_Detail_ID ,
                          I_Receipt_Detail_ID ,
                          N_Amount_Paid ,
                          N_Comp_Amount_Rff
	                    )
                VALUES  ( @id ,
                          @iReceiptHeaderID ,
                          @amount ,
                          @CompanyShare * @amount / 100
                        )	
	
                SET @iReceiptComponentDetailId = SCOPE_IDENTITY()
				 SELECT TOP ( 1 )
                        @iInvoiceChildHeaderID = I_Invoice_Child_Header_ID ,
                        @iInstallmentNo = I_Installment_No ,
                        @dtInstallmentDate = Dt_Installment_Date
                FROM    T_Invoice_Child_Detail
                WHERE   I_Invoice_Detail_ID = @id

				 SELECT TOP ( 1 )
                        @iInvoiceHeaderID = I_Invoice_Header_ID
                FROM    T_Invoice_Child_Header
                WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID

				 EXEC dbo.uspGenerateInvoiceNumber @iInvoiceHeaderID,
                    @iInstallmentNo, @dtInstallmentDate, 'I',
                    @iInvoiceNo OUTPUT

					  UPDATE  T_Invoice_Child_Detail
                SET     S_Invoice_Number = @iInvoiceNo
                WHERE   I_Invoice_Detail_ID = @iInvoiceDetailId

    --SELECT @id, @amount;
END
		--select I_Invoice_Detail_ID,N_Due from T_Invoice_Child_Detail where  CHARINDEX(cast(S_Invoice_Number as varchar(8000)), @sReceiptDetail) > 0
--        WHILE ( @AdjPosition <= @AdjCount )
--            BEGIN
--                SET @ReceiptDetailXML = @sReceiptDetail.query('/TblRctCompDtl/RowRctCompDtl[position()=sql:variable("@AdjPosition")]')
--                SELECT  @iInvoiceDetailId = T.a.value('@I_Invoice_Detail_ID',
--                                                      'int') ,
--                        @iReceiptDetailId = @iReceiptHeaderID ,
--                        @nAmountPaid = T.a.value('@N_Amount_Paid',
--                                                 'numeric(18,2)')
--                FROM    @ReceiptDetailXML.nodes('/RowRctCompDtl') T ( a )

--                SELECT  @CompanyShare = [dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,
--                                                              CM.I_Country_ID,
--                                                              RH.I_Centre_Id,
--                                                              ICH.I_Course_ID,
--                                                              ICD.I_Fee_Component_ID,
--                                                              BCD.I_Brand_ID)
--                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
--                        INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH ( NOLOCK ) ON ICD.I_Invoice_Detail_ID = @iInvoiceDetailId
--                        INNER JOIN dbo.T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
--                        INNER JOIN dbo.T_Brand_Center_Details BCD ON BCD.I_Centre_Id = RH.I_Centre_Id
--                                                              AND BCD.I_Status = 1
--                        INNER JOIN dbo.T_Centre_Master CM ON RH.I_Centre_Id = CM.I_Centre_Id
--                WHERE   RH.I_Receipt_Header_ID = @iReceiptDetailId
	
--                SELECT  @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,
--                                                       'False')
--                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
--                        INNER JOIN [dbo].[T_Centre_Master] CM WITH ( NOLOCK ) ON RH.[I_Centre_Id] = CM.[I_Centre_Id]
--                WHERE   RH.I_Receipt_Header_ID = @iReceiptDetailId
	
--                IF ( @bUseCenterServiceTax = 'TRUE' )
--                    BEGIN
--                        SET @TaxShare = @CompanyShare
--                    END
--                ELSE
--                    BEGIN
--                        SET @TaxShare = 100
--                    END

----set @CompanyShare = 80
	
--                INSERT  INTO T_Receipt_Component_Detail
--                        ( I_Invoice_Detail_ID ,
--                          I_Receipt_Detail_ID ,
--                          N_Amount_Paid ,
--                          N_Comp_Amount_Rff
--	                    )
--                VALUES  ( @iInvoiceDetailId ,
--                          @iReceiptDetailId ,
--                          @nAmountPaid ,
--                          @CompanyShare * @nAmountPaid / 100
--                        )	
	
--                SET @iReceiptComponentDetailId = SCOPE_IDENTITY()

--                SELECT TOP ( 1 )
--                        @iInvoiceChildHeaderID = I_Invoice_Child_Header_ID ,
--                        @iInstallmentNo = I_Installment_No ,
--                        @dtInstallmentDate = Dt_Installment_Date
--                FROM    T_Invoice_Child_Detail
--                WHERE   I_Invoice_Detail_ID = @iInvoiceDetailId

--                SELECT TOP ( 1 )
--                        @iInvoiceHeaderID = I_Invoice_Header_ID
--                FROM    T_Invoice_Child_Header
--                WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID

--                EXEC dbo.uspGenerateInvoiceNumber @iInvoiceHeaderID,
--                    @iInstallmentNo, @dtInstallmentDate, 'I',
--                    @iInvoiceNo OUTPUT

--                UPDATE  T_Invoice_Child_Detail
--                SET     S_Invoice_Number = @iInvoiceNo
--                WHERE   I_Invoice_Detail_ID = @iInvoiceDetailId

--                DECLARE @InnerPosition SMALLINT ,
--                    @InnerCount SMALLINT

--                SET @InnerPosition = 1
--                SET @InnerCount = @ReceiptDetailXML.value('count((RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl))',
--                                                          'int')
--                WHILE ( @InnerPosition <= @InnerCount )
--                    BEGIN
--                        DECLARE @ColTaxAmt DECIMAL(14, 2)= 0.00
--                        SET @TaxDetailXML = @ReceiptDetailXML.query('RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl[position()=sql:variable("@InnerPosition")]')
--                        SELECT  @iTaxId = T.b.value('@I_Tax_ID', 'int') ,
--                                @iInvoiceDetailId = T.b.value('@I_Invoice_Detail_ID',
--                                                              'int') ,
--                                @nTaxPaid = T.b.value('@N_Tax_Paid',
--                                                      'numeric(18,2)')
--                        FROM    @TaxDetailXML.nodes('/RowRctTaxDtl') T ( b )
                        
--                        PRINT 'nTaxPaid='+CAST(@nTaxPaid AS VARCHAR)
                        
--                        SELECT  @ColTaxAmt=ISNULL(SUM(ISNULL(TTax.TaxToBePaid,0)),0)
--                        FROM    ( SELECT    T1.* ,
--                                            ISNULL(T2.TaxPaidTillDate,0) AS  TaxPaidTillDate,
--                                            CASE WHEN (ISNULL(T1.N_Tax_Value,0)
--                                            - ISNULL(T2.TaxPaidTillDate,0))<0.2 THEN 0
--                                            ELSE
--                                            (ISNULL(T1.N_Tax_Value,0)
--                                            - ISNULL(T2.TaxPaidTillDate,0)) END 
--                                             AS TaxToBePaid		
--                                  FROM      ( SELECT    TICD.I_Invoice_Detail_ID ,
--                                                        TIDT.I_Tax_ID ,
--                                                        TIDT.N_Tax_Value ,
--                                                        TTCFC.N_Tax_Rate
--        --CAST(( TTCFC.N_Tax_Rate / 100 ) * 1250 AS DECIMAL(18, 2)) AS PaidTaxAPI
--                                              FROM      dbo.T_Invoice_Child_Detail
--                                                        AS TICD
--                                                        INNER JOIN dbo.T_Invoice_Detail_Tax
--                                                        AS TIDT ON TIDT.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
--                                                        INNER JOIN dbo.T_Tax_Country_Fee_Component
--                                                        AS TTCFC ON TTCFC.I_Fee_Component_ID = TICD.I_Fee_Component_ID
--                                                              AND TTCFC.I_Tax_ID = TIDT.I_Tax_ID
--                                              WHERE     TICD.I_Invoice_Detail_ID = @iInvoiceDetailId 
--                                                        AND TICD.Dt_Installment_Date >= TTCFC.Dt_Valid_From
--                                                        AND TICD.Dt_Installment_Date <= TTCFC.Dt_Valid_To
--                                            ) T1
--                                            LEFT JOIN ( SELECT
--                                                              TRTD.I_Invoice_Detail_ID ,
--                                                              TRTD.I_Tax_ID ,
--                                                              ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid,
--                                                              0)), 0) AS TaxPaidTillDate
--                                                        FROM  dbo.T_Receipt_Tax_Detail
--                                                              AS TRTD
--                                                              INNER JOIN dbo.T_Receipt_Component_Detail
--                                                              AS TRCD ON TRCD.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
--                                                              AND TRCD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
--                                                              INNER JOIN dbo.T_Receipt_Header
--                                                              AS TRH ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
--                                                        WHERE TRH.I_Status = 1
--                                                              AND TRTD.I_Invoice_Detail_ID = @iInvoiceDetailId 
--                                                        GROUP BY TRTD.I_Invoice_Detail_ID ,
--                                                              TRTD.I_Tax_ID
--                                                      ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
--                                                              AND T2.I_Tax_ID = T1.I_Tax_ID
--                                ) TTax
                        
--                        PRINT 'ColTaxAmt='+CAST(@ColTaxAmt AS VARCHAR)
                                
--                        IF (ABS(@ColTaxAmt-@nTaxPaid)<=0.09 AND @ColTaxAmt<>0 AND @nTaxPaid<>0)        
--                        BEGIN
	
--                        INSERT  INTO T_Receipt_Tax_Detail
--                                ( I_Receipt_Comp_Detail_ID ,
--                                  I_Tax_ID ,
--                                  I_Invoice_Detail_ID ,
--                                  N_Tax_Paid ,
--                                  N_Tax_Rff
--		                        )
--                        --VALUES  ( @iReceiptComponentDetailId ,
--                        --          @iTaxId ,
--                        --          @iInvoiceDetailId ,
--                        --          @nTaxPaid ,
--                        --          @TaxShare * @nTaxPaid / 100
--                        --        )
--                        SELECT  @iReceiptComponentDetailId,TTax.I_Tax_ID,TTax.I_Invoice_Detail_ID,TTax.TaxToBePaid,@TaxShare * TTax.TaxToBePaid / 100
--                        --@ColTaxAmt=SUM(TTax.TaxToBePaid)
--                        FROM    ( SELECT    T1.I_Invoice_Detail_ID ,T1.I_Tax_ID,
--                                            ISNULL(T2.TaxPaidTillDate,0) AS  TaxPaidTillDate,
--                                            ISNULL(T1.N_Tax_Value,0)
--                                            - ISNULL(T2.TaxPaidTillDate,0) AS TaxToBePaid
--                                  FROM      ( SELECT    TICD.I_Invoice_Detail_ID ,
--                                                        TIDT.I_Tax_ID ,
--                                                        TIDT.N_Tax_Value ,
--                                                        TTCFC.N_Tax_Rate
--        --CAST(( TTCFC.N_Tax_Rate / 100 ) * 1250 AS DECIMAL(18, 2)) AS PaidTaxAPI
--                                              FROM      dbo.T_Invoice_Child_Detail
--                                                        AS TICD
--                                                        INNER JOIN dbo.T_Invoice_Detail_Tax
--                                                        AS TIDT ON TIDT.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
--                                                        INNER JOIN dbo.T_Tax_Country_Fee_Component
--                                                        AS TTCFC ON TTCFC.I_Fee_Component_ID = TICD.I_Fee_Component_ID
--                                                              AND TTCFC.I_Tax_ID = TIDT.I_Tax_ID
--                                              WHERE     TICD.I_Invoice_Detail_ID = @iInvoiceDetailId 
--                                                        AND TICD.Dt_Installment_Date >= TTCFC.Dt_Valid_From
--                                                        AND TICD.Dt_Installment_Date <= TTCFC.Dt_Valid_To
--                                            ) T1
--                                            LEFT JOIN ( SELECT
--                                                              TRTD.I_Invoice_Detail_ID ,
--                                                              TRTD.I_Tax_ID ,
--                                                              ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid,
--                                                              0)), 0) AS TaxPaidTillDate
--                                                        FROM  dbo.T_Receipt_Tax_Detail
--                                                              AS TRTD
--                                                              INNER JOIN dbo.T_Receipt_Component_Detail
--                                                              AS TRCD ON TRCD.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
--                                                              AND TRCD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
--                                                              INNER JOIN dbo.T_Receipt_Header
--                                                              AS TRH ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
--                                                        WHERE TRH.I_Status = 1
--                                                              AND TRTD.I_Invoice_Detail_ID = @iInvoiceDetailId 
--                                                        GROUP BY TRTD.I_Invoice_Detail_ID ,
--                                                              TRTD.I_Tax_ID
--                                                      ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
--                                                              AND T2.I_Tax_ID = T1.I_Tax_ID
--                                ) TTax
                        
--                         END 
                         
--                         ELSE IF (@ColTaxAmt<>@nTaxPaid)
                         
--                         BEGIN
                         
--                         RAISERROR('Tax Amount Does Not Match',11,1)
                         
--                         END      

--                        SET @InnerPosition = @InnerPosition + 1
--                    END
-- -- update existing records T_Invoice_Child_Detail for which advance have been received. AdvanceCollection to be updated and tax will be based on ScheduleAmount-AdvanceCollection
--                SET @AdjPosition = @AdjPosition + 1
--            END
            
            INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'After tax block' -- LogText - varchar(max)
          
          )
            
-- if advance received, one record to be inserted into T_Invoice_Child_Detail for Tax component only. Amount_Due=0, AdvanceCollection=advancetaken, tax is based on advanceAmount. Also tax details
        EXEC [dbo].[uspInsertUpdateForAdvancePayment] @iReceiptHeaderID
        
        INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'After uspInsertUpdateForAdvancePayment' -- LogText - varchar(max)
          
          )
        
        
        EXEC [dbo].[uspUpdateInvoiceParentForAdvanceTax] @iReceiptHeaderID
        
        
        INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'After uspUpdateInvoiceParentForAdvanceTax' -- LogText - varchar(max)
          
          )

        DECLARE @N_Amount_Rff NUMERIC(18, 2)
        DECLARE @N_Receipt_Tax_Rff NUMERIC(18, 2)

        SELECT  @N_Amount_Rff = SUM(ISNULL(N_Comp_Amount_Rff, 0))
        FROM    dbo.T_Receipt_Component_Detail WITH ( NOLOCK )
        WHERE   I_Receipt_Detail_ID = @iReceiptHeaderID

        SELECT  @N_Receipt_Tax_Rff = SUM(ISNULL(RTD.N_Tax_Rff, 0))
        FROM    dbo.T_Receipt_Tax_Detail RTD WITH ( NOLOCK )
                INNER JOIN dbo.T_Receipt_Component_Detail RCD WITH ( NOLOCK ) ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
        WHERE   RCD.I_Receipt_Detail_ID = @iReceiptHeaderID

        UPDATE  dbo.T_Receipt_Header
        SET     N_Amount_Rff = @N_Amount_Rff ,
                N_Receipt_Tax_Rff = @N_Receipt_Tax_Rff
        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID

        UPDATE  dbo.T_Student_Registration_Details
        SET     I_Status = 0
        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID

        SELECT  @iInvoiceParentId = I_Invoice_Header_ID
        FROM    T_Receipt_Header
        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
        
        INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'Before KPMG_uspGetInstallmentDetailsAPI block '+CAST(@iInvoiceParentId AS VARCHAR) -- LogText - varchar(max)
          
          )
        
        
        --IF ( ISNULL(@iInvoiceParentId, 0) > 0 )
        --    BEGIN
        --        EXEC dbo.KPMG_uspGetInstallmentDetailsAPI @InvoiceDetailId = @iInvoiceParentId
        --    END

        COMMIT TRANSACTION
        
      INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'End of Receipt Detail' -- LogText - varchar(max)
          
          )  

    END TRY
    BEGIN CATCH
    
      INSERT INTO dbo.T_SP_Transaction_Log
        ( CreatedOn, LogText )
VALUES  ( GETDATE(), -- CreatedOn - datetime
          'Inside of Receipt Detail CATCH BLOCK' -- LogText - varchar(max)
          
          ) 
	--Error occurred:  
        ROLLBACK TRANSACTION
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
