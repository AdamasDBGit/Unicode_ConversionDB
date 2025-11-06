CREATE PROCEDURE [ERP].[uspRevenueRecon]
    (
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS
    BEGIN
    
		DECLARE @BrandName VARCHAR(MAX)
		
		IF @iBrandID=109
			SET @BrandName='RICE Private Limited'
		ELSE IF @iBrandID=111
			SET @BrandName='Adamas Career'
		ELSE IF @iBrandID=107
			SET @BrandName='AIS'
		ELSE IF @iBrandID=108
			SET @BrandName='AIT'
		ELSE IF @iBrandID=110
			SET @BrandName='AWS'
		ELSE IF @iBrandID=112
			SET @BrandName='AHSMS'							


        CREATE TABLE #ERPSYNC
            (
              [Type] VARCHAR(MAX) ,
              S_Brand_Name VARCHAR(MAX) ,
              S_Center_Name VARCHAR(MAX) ,
              I_Transaction_Nature_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              S_Student_Name VARCHAR(MAX) ,
              S_Transaction_Code VARCHAR(MAX) ,
              Amount DECIMAL(14, 2)
            )

        INSERT  INTO #ERPSYNC
                EXEC REPORT.uspGetERPSyncReport @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtStartDate = @dtStartDate, -- datetime
                    @dtEndDate = @dtEndDate -- datetime
    

        INSERT  INTO ERP.T_Oracle_SMS_Recon_Temp
                ( 
                  Brand ,
                  MonthYear ,
                  TypeName ,
                  FeeComponent,
                  Amount 
                )
                SELECT  @BrandName,
                        DATENAME(MONTH, @dtStartDate) + ' '
                        + CAST(DATEPART(YYYY, @dtStartDate) AS VARCHAR) AS MonthYear ,
                        'Revenue' AS [Type] ,
                        E.S_Transaction_Code,
                        ISNULL(SUM(ISNULL(E.Amount, 0)), 0) AS Amount
                FROM    #ERPSYNC AS E
                GROUP BY E.S_Transaction_Code
                ORDER BY E.S_Transaction_Code 


        DROP TABLE #ERPSYNC   
    
    
    END
