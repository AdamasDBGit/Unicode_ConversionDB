CREATE PROCEDURE [ERP].[uspCashandConvenienceChargeRecon]
    (
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX) ,
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

        CREATE TABLE #COL
            (
              Student_ID VARCHAR(MAX) ,
              Student_Name VARCHAR(MAX) ,
              S_Invoice_No VARCHAR(MAX) 
				--,Dt_Invoice_Date
              ,
              Dt_Invoice_Date VARCHAR(MAX) ,
              Invoice_Amount DECIMAL(14, 2) ,
              Tax_Amount DECIMAL(14, 2) ,
              N_Discount_Amount DECIMAL(14, 2) ,
              Counselor_Name VARCHAR(MAX) ,
              CenterCode VARCHAR(MAX) ,
              CenterName VARCHAR(MAX) ,
              TypeofCentre VARCHAR(MAX) ,
              InstanceChain VARCHAR(MAX) ,
              S_Currency_Code VARCHAR(MAX) ,
              Receipt_No VARCHAR(MAX) ,
              Receipt_Date VARCHAR(MAX) , 
				--Receipt_Date, 
              ReceiptMonthYear VARCHAR(MAX) ,
              I_Student_Detail_ID INT ,
              I_Enquiry_Regn_ID INT ,
              I_Invoice_Header_ID INT ,
              I_Receipt_Header_ID INT ,
              I_Status INT ,
              Receipt_Amount DECIMAL(14, 2) ,
              Receipt_Tax DECIMAL(14, 2) ,
              S_Receipt_Type_Desc VARCHAR(MAX) ,
              S_Form_No VARCHAR(MAX) ,
              Payment_Mode VARCHAR(MAX) ,
              S_Bank_Name VARCHAR(MAX) ,
              Instrument_No VARCHAR(MAX) 
				--,Dt_ChequeDD_Date
              ,
              Dt_ChequeDD_Date VARCHAR(MAX) ,
              Course_Fee DECIMAL(14, 2) ,
              Exam_Fee DECIMAL(14, 2) ,
              Others_Fee DECIMAL(14, 2) ,
              Tax_Component DECIMAL(14, 2) ,
              UudatedBy VARCHAR(MAX) 
				--,Dt_Upd_On
              ,
              Dt_Upd_On VARCHAR(MAX) ,
              S_Batch_Name VARCHAR(MAX) ,
              S_Course_Name VARCHAR(MAX) ,
              ConvenienceCharge DECIMAL(14, 2) ,
              ConvenienceChargeTax DECIMAL(14, 2) ,
              TotalReceptAmount DECIMAL(14, 2) ,
              TotalReceipt_Amount DECIMAL(14, 2) ,
              TotalReceipt_Tax DECIMAL(14, 2) ,
              TotalReceptAmountTax DECIMAL(14, 2) ,
              TotalConvenienceCharge DECIMAL(14, 2) ,
              TotalConvenienceChargeTax DECIMAL(14, 2) ,
              SettlementDate VARCHAR(MAX) ,
              BankAccount VARCHAR(MAX)
            )


        INSERT  INTO #COL
                EXEC REPORT.uspGetCollectionRegisterReport @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtStartDate = @dtStartDate, -- datetime
                    @dtEndDate = @dtEndDate, -- datetime
                    @sCounselorCond = 'ALL' -- varchar(20)
    
		
		
		
		
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
                        'CASH' AS [Type] ,
                        'Cash In Hand' AS FeeComponent ,
                        SUM(ISNULL(C.TotalReceptAmount, 0)) AS CashCollection
                FROM    #COL AS C
                WHERE   C.Payment_Mode = 'Cash'
                UNION ALL
                SELECT  @BrandName ,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'CONVENIENCE CHARGE' AS [Type] ,
                        'Convenience Charge' AS FeeComponent ,
                        SUM(ISNULL(C.ConvenienceCharge,0)+ISNULL(C.ConvenienceChargeTax, 0)) AS CashCollection
                FROM    #COL AS C
                --UNION ALL
                --SELECT  @BrandName ,
                --        DATENAME(MONTH, @dtStartDate) + ' '
                --        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                --        'CONVENIENCE CHARGE TAX' AS [Type] ,
                --        'Convenience Charge Tax' AS FeeComponent ,
                --        SUM(ISNULL(C.ConvenienceChargeTax, 0)) AS CashCollection
                --FROM    #COL AS C 


    END
