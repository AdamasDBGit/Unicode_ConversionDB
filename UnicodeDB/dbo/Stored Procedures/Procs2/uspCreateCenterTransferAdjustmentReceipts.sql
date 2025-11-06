CREATE PROCEDURE [dbo].[uspCreateCenterTransferAdjustmentReceipts]
    (
      @iPositiveAdjustmentCenterID INT ,
      @iNegativeAdjustmentCenterID INT ,
      @nPositiveAdjustmentAmount DECIMAL(18, 2) ,
      @nNegativeAdjustmentAmount DECIMAL(18, 2) ,
      @iStudentID INT ,
      @iReceiptTypeID INT ,
      @sAdjustmentText NVARCHAR(MAX),
      @iBrandID INT
    )
AS 
    BEGIN
     
        DECLARE @CompanyShare NUMERIC(8, 4)  
        DECLARE @TaxShare NUMERIC(18, 2)  
        DECLARE @bUseCenterServiceTax BIT  
    
        DECLARE @nTaxRate DECIMAL(18, 2)  
  /* 
        SELECT  @nTaxRate = SUM(ISNULL(N_Tax_Rate, 0))
        FROM    dbo.T_Tax_Country_ReceiptType
        WHERE   I_Receipt_Type = @iReceiptTypeID
                AND I_Status = 1
                AND ISNULL(Dt_Valid_From, GETDATE()) <= GETDATE()
                AND ISNULL(Dt_Valid_To, GETDATE()) >= GETDATE()  
  
        SET @nTaxRate = ISNULL(@nTaxRate, 0)  
  
        DECLARE @nPositiveTaxAmount DECIMAL(18, 2)  
        DECLARE @nNegativeTaxAmount DECIMAL(18, 2)  
  
        SET @nPositiveTaxAmount = @nPositiveAdjustmentAmount * ( @nTaxRate
                                                              / 100 )  
        SET @nNegativeTaxAmount = @nNegativeAdjustmentAmount * ( @nTaxRate
                                                              / 100 )  
  
  
--Insert positive receipt   
        SELECT  @CompanyShare = [dbo].fnGetCompanyShareOnAccountReceipts(GETDATE(),
                                                              CM.I_Country_ID,
                                                              CM.I_Centre_Id,
                                                              @iReceiptTypeID,
                                                              BCD.I_Brand_ID)
        FROM    dbo.T_Centre_Master CM
                INNER JOIN dbo.T_Brand_Center_Details BCD ON BCD.I_Centre_Id = CM.I_Centre_Id
                                                             AND BCD.I_Status = 1
        WHERE   CM.I_Centre_ID = @iPositiveAdjustmentCenterID  
   
        SELECT  @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,
                                               'False')
        FROM    dbo.T_Centre_Master CM WITH ( NOLOCK )
        WHERE   CM.I_Centre_ID = @iPositiveAdjustmentCenterID  
   
        IF ( @bUseCenterServiceTax = 'TRUE' ) 
            BEGIN  
                SET @TaxShare = @CompanyShare  
            END  
        ELSE 
            BEGIN  
                SET @TaxShare = 100  
            END  
  
        INSERT  INTO T_RECEIPT_HEADER
                ( I_Centre_Id ,
                  N_Receipt_Amount ,
                  Dt_Receipt_Date ,
                  I_PaymentMode_ID ,
                  I_Student_Detail_ID ,
                  S_Crtd_By ,
                  Dt_Crtd_On ,
                  I_Status ,
                  S_Fund_Transfer_Status ,
                  I_Receipt_Type ,
                  N_Tax_Amount ,
                  N_Amount_Rff ,
                  N_Receipt_Tax_Rff ,
                  S_AdjustmentRemarks
                )
        VALUES  ( @iPositiveAdjustmentCenterID ,
                  @nPositiveAdjustmentAmount ,
                  GETDATE() ,
                  1 ,--Hardcoded cash  
                  @iStudentID ,
                  'system' ,
                  GETDATE() ,
                  1 ,
                  'N' ,
                  @iReceiptTypeID ,
                  @nPositiveTaxAmount ,
                  @nPositiveAdjustmentAmount * @CompanyShare / 100 ,
                  @nPositiveTaxAmount * @CompanyShare / 100 ,
                  @sAdjustmentText
                )  
   
        DECLARE @iReceiptIDnew INT  
        SET @iReceiptIDnew = SCOPE_IDENTITY()  
  
        DECLARE @iReceiptNo BIGINT  
  
        SELECT  @iReceiptNo = MAX(CAST(S_Receipt_No AS BIGINT))
        FROM    T_RECEIPT_HEADER TRH
        WHERE   S_Receipt_No NOT LIKE '%[A-Z]'  
		AND TRH.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)        
  
        SET @iReceiptNo = ISNULL(@iReceiptNo, 0) + 1  
  
        UPDATE  T_RECEIPT_HEADER
        SET     S_Receipt_No = @iReceiptNo
        WHERE   I_Receipt_Header_ID = @iReceiptIDnew  
  
        INSERT  INTO dbo.T_OnAccount_Receipt_Tax
                SELECT  @iReceiptIDnew ,
                        I_Tax_ID ,
                        @nPositiveAdjustmentAmount * N_Tax_Rate / 100 ,
                        ( @nPositiveAdjustmentAmount * N_Tax_Rate / 100 )
                        * @TaxShare / 100
                FROM    dbo.T_Tax_Country_ReceiptType
                WHERE   I_Receipt_Type = @iReceiptTypeID
                        AND I_Status = 1
                        AND ISNULL(Dt_Valid_From, GETDATE()) <= GETDATE()
                        AND ISNULL(Dt_Valid_To, GETDATE()) >= GETDATE()  
  
--Insert negative receipt   
        SELECT  @CompanyShare = [dbo].fnGetCompanyShareOnAccountReceipts(GETDATE(),
                                                              CM.I_Country_ID,
                                                              CM.I_Centre_Id,
                                                              @iReceiptTypeID,
                                                              BCD.I_Brand_ID)
        FROM    dbo.T_Centre_Master CM
                INNER JOIN dbo.T_Brand_Center_Details BCD ON BCD.I_Centre_Id = CM.I_Centre_Id
                                                             AND BCD.I_Status = 1
        WHERE   CM.I_Centre_ID = @iNegativeAdjustmentCenterID  
   
        SELECT  @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,
                                               'False')
        FROM    dbo.T_Centre_Master CM WITH ( NOLOCK )
        WHERE   CM.I_Centre_ID = @iNegativeAdjustmentCenterID  
   
        IF ( @bUseCenterServiceTax = 'TRUE' ) 
            BEGIN  
                SET @TaxShare = @CompanyShare  
            END  
        ELSE 
            BEGIN  
                SET @TaxShare = 100  
            END  
  
        INSERT  INTO T_RECEIPT_HEADER
                ( I_Centre_Id ,
                  N_Receipt_Amount ,
                  Dt_Receipt_Date ,
                  I_PaymentMode_ID ,
                  I_Student_Detail_ID ,
                  S_Crtd_By ,
                  Dt_Crtd_On ,
                  I_Status ,
                  S_Fund_Transfer_Status ,
                  I_Receipt_Type ,
                  N_Tax_Amount ,
                  N_Amount_Rff ,
                  N_Receipt_Tax_Rff ,
                  S_AdjustmentRemarks
                )
        VALUES  ( @iNegativeAdjustmentCenterID ,
                  ( -1 ) * @nNegativeAdjustmentAmount ,
                  GETDATE() ,
                  1 ,--Hardcoded cash  
                  @iStudentID ,
                  'system' ,
                  GETDATE() ,
                  1 ,
                  'N' ,
                  @iReceiptTypeID ,
                  ( -1 ) * @nNegativeTaxAmount ,
                  ( -1 ) * ( @nNegativeAdjustmentAmount * @CompanyShare / 100 ) ,
                  ( -1 ) * ( @CompanyShare * @nNegativeTaxAmount / 100 ) ,
                  @sAdjustmentText
                )  
   
        SET @iReceiptIDnew = SCOPE_IDENTITY()  
  
        SELECT  @iReceiptNo = MAX(CAST(S_Receipt_No AS BIGINT))
        FROM    T_RECEIPT_HEADER TRH
        WHERE   S_Receipt_No NOT LIKE '%[A-Z]'
        AND TRH.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)
  
        SET @iReceiptNo = ISNULL(@iReceiptNo, 0) + 1  
  
        UPDATE  T_RECEIPT_HEADER
        SET     S_Receipt_No = @iReceiptNo
        WHERE   I_Receipt_Header_ID = @iReceiptIDnew  
  
        INSERT  INTO dbo.T_OnAccount_Receipt_Tax
                SELECT  @iReceiptIDnew ,
                        I_Tax_ID ,
                        ( -1 ) * ( @nNegativeAdjustmentAmount * N_Tax_Rate
                                   / 100 ) ,
                        ( -1 ) * ( ( @nNegativeAdjustmentAmount * N_Tax_Rate
                                     / 100 ) * @TaxShare / 100 )
                FROM    dbo.T_Tax_Country_ReceiptType
                WHERE   I_Receipt_Type = @iReceiptTypeID
                        AND I_Status = 1
                        AND ISNULL(Dt_Valid_From, GETDATE()) <= GETDATE()
                        AND ISNULL(Dt_Valid_To, GETDATE()) >= GETDATE()  
  
   */
  
    END

