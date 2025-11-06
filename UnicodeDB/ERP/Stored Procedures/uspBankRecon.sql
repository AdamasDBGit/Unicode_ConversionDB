CREATE PROCEDURE [ERP].[uspBankRecon]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS
    BEGIN
    
    
        DECLARE @BrandName VARCHAR(MAX)
		
        IF @iBrandID = 109
            SET @BrandName = 'RICE Private Limited'
        ELSE
            IF @iBrandID = 111
                SET @BrandName = 'Adamas Career'
            ELSE
                IF @iBrandID = 107
                    SET @BrandName = 'AIS'
                ELSE
                    IF @iBrandID = 108
                        SET @BrandName = 'AIT'
                    ELSE
                        IF @iBrandID = 110
                            SET @BrandName = 'AWS'
                        ELSE
                            IF @iBrandID = 112
                                SET @BrandName = 'AHSMS'

        CREATE TABLE #DEPDATA
            (
              Brand VARCHAR(MAX) ,
              Center VARCHAR(MAX) ,
              StudentOrEnquiryID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ReceiptID INT ,
              ReceiptNo VARCHAR(MAX) ,
              ReceiptDate DATETIME ,
              UpdateDate DATETIME ,
              InstrumentNo VARCHAR(MAX) ,
              BankName VARCHAR(MAX) ,
              BranchName VARCHAR(MAX) ,
              ChqDDDate DATETIME ,
              BankAcc VARCHAR(MAX) ,
              DepositDate DATETIME ,
              TotalAmount DECIMAL(14, 2) ,
              Category VARCHAR(MAX)
            )
            
            
        INSERT  INTO #DEPDATA
                EXEC REPORT.uspGetChequeAndCardDetailsReport @iBrandID = @iBrandID, -- int
                    @sHierarchyListID = @sHierarchyListID, -- varchar(max)
                    @dtStartDate = @dtStartDate, -- date
                    @dtEndDate = @dtEndDate -- date
                    
        
        INSERT  INTO ERP.T_Oracle_SMS_Recon_Temp
                ( Brand ,
                  MonthYear ,
                  TypeName ,
                  FeeComponent ,
                  Amount
                )
                SELECT  @BrandName ,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'BANK' ,
                        D.BankAcc ,
                        SUM(ISNULL(CASE WHEN D.Category LIKE 'Settled%'
                                        THEN D.TotalAmount
                                        WHEN D.Category LIKE 'Bounce%'
                                        THEN -D.TotalAmount
                                   END, 0)) AS TotalAmount
                FROM    #DEPDATA AS D
                GROUP BY D.BankAcc
                UNION ALL
                SELECT  @BrandName ,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'BANK' ,
                        'BankClearingAcc' ,
                        SUM(ISNULL(CASE WHEN D.Category LIKE 'Unsettled%'
                                        THEN D.TotalAmount
										--WHEN D.Category LIKE 'Bounce%'
										--THEN -D.TotalAmount
                                        WHEN D.Category LIKE 'Collection%'
                                        THEN -D.TotalAmount
                                        WHEN D.Category LIKE 'Reversal%'
                                        THEN -D.TotalAmount
                                   END, 0)) AS TotalAmount
                FROM    #DEPDATA AS D          




        DROP TABLE #DEPDATA

    END
