CREATE PROCEDURE [REPORT].[uspGetDailySalesComparisonReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS
    BEGIN

        DECLARE @dtStartDateLY DATETIME
        DECLARE @dtEndDateLY DATETIME
        DECLARE @dtStartDateLLY DATETIME
        DECLARE @dtEndDateLLY DATETIME


        SET @dtStartDateLY = DATEADD(yy, -1, @dtStartDate)
        SET @dtEndDateLY = DATEADD(yy, -1, @dtEndDate)
        
        SET @dtStartDateLLY = DATEADD(yy, -2, @dtStartDate)
        SET @dtEndDateLLY = DATEADD(yy, -2, @dtEndDate)

        PRINT @dtStartDateLY
        PRINT @dtEndDateLY
        
        
        CREATE TABLE #SALESDATATY
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              MonthYear VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              Category VARCHAR(MAX) ,
              Value DECIMAL(14, 2)
            )
        
        CREATE TABLE #SALESDATALY
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              MonthYear VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              Category VARCHAR(MAX) ,
              Value DECIMAL(14, 2)
            )
            
            CREATE TABLE #SALESDATALLY
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              MonthYear VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              Category VARCHAR(MAX) ,
              Value DECIMAL(14, 2)
            )
            
        CREATE TABLE #SALESDATAFINAL
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              MonthYear VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              Category VARCHAR(MAX) ,
              Value DECIMAL(14, 2),
              UpdStatus INT,
              ParentCategory VARCHAR(MAX),
              Sequence INT
            )    

        INSERT  INTO #SALESDATATY
                EXEC REPORT.uspGetDailySalesReportNew @iBrandID = @iBrandID, -- int
                    @sHierarchyListID = @sHierarchyListID, -- varchar(max)
                    @dtStartDate = @dtStartDate, -- date
                    @dtEndDate = @dtEndDate -- date
    
    
        INSERT  INTO #SALESDATALY
                EXEC REPORT.uspGetDailySalesReportNew @iBrandID = @iBrandID, -- int
                    @sHierarchyListID = @sHierarchyListID, -- varchar(max)
                    @dtStartDate = @dtStartDateLY, -- date
                    @dtEndDate = @dtEndDateLY -- date
                    
        INSERT  INTO #SALESDATALLY
                EXEC REPORT.uspGetDailySalesReportNew @iBrandID = @iBrandID, -- int
                    @sHierarchyListID = @sHierarchyListID, -- varchar(max)
                    @dtStartDate = @dtStartDateLLY, -- date
                    @dtEndDate = @dtEndDateLLY-- date            
    
        --SELECT  *
        --FROM    #SALESDATATY AS S1
        --UNION ALL
        --SELECT  *
        --FROM    #SALESDATALY AS S2
        
                INSERT INTO #SALESDATAFINAL
                ( CenterID ,
                  CenterName ,
                  MonthYear ,
                  CourseID ,
                  CourseName ,
                  Category ,
                  Value
                  )
        SELECT * FROM #SALESDATALY AS S
        
        
        UPDATE #SALESDATAFINAL SET Category=Category+'LY',UpdStatus=1 
        
        
        INSERT INTO #SALESDATAFINAL
                ( CenterID ,
                  CenterName ,
                  MonthYear ,
                  CourseID ,
                  CourseName ,
                  Category ,
                  Value
                  )
                 
        SELECT * FROM #SALESDATATY AS S
        
        
        UPDATE #SALESDATAFINAL SET Category=Category+'TY',UpdStatus=1 WHERE UpdStatus IS NULL
        
        
        INSERT INTO #SALESDATAFINAL
                ( CenterID ,
                  CenterName ,
                  MonthYear ,
                  CourseID ,
                  CourseName ,
                  Category ,
                  Value
                  )
                 
        SELECT * FROM #SALESDATALLY AS S
        
        
        UPDATE #SALESDATAFINAL SET Category=Category+'LLY',UpdStatus=1 WHERE UpdStatus IS NULL
        
        
        UPDATE #SALESDATAFINAL SET ParentCategory='Form',Sequence=2 WHERE Category LIKE '%Form%'
        UPDATE #SALESDATAFINAL SET ParentCategory='Enquiry',Sequence=1 WHERE Category LIKE '%Enquiry%'
        UPDATE #SALESDATAFINAL SET ParentCategory='Enrolment',Sequence=3 WHERE Category LIKE '%Registration%'
        UPDATE #SALESDATAFINAL SET ParentCategory='Collection',Sequence=4 WHERE Category LIKE '%Collection%'
        UPDATE #SALESDATAFINAL SET ParentCategory='Promotion/Conversion',Sequence=5 WHERE Category LIKE '%Promotion%'
        
        
        SELECT * FROM #SALESDATAFINAL AS S 

	

    END
