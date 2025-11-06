CREATE PROCEDURE [REPORT].[uspGetFinancialSummaryDataForAPI]
(
@Period VARCHAR(20)
)

AS

BEGIN

DECLARE @UptoDate DATETIME=GETDATE()
DECLARE @BrandID INT
DECLARE @HierarchyID VARCHAR(MAX)


--IF (@BrandName='RICE')
--BEGIN
--	SET @BrandID=109
--	SET @HierarchyID='54'
--END
CREATE TABLE #temp
(
I_Brand_ID INT ,
          S_Brand_Name VARCHAR(MAX),
          FinancialRange VARCHAR(10),
          Enrolment INT,
          ProspectusSale INT,
          FreshCollection INT,
          MTFCollection INT,
          Enquiry INT,
          TotalCollection INT
)

CREATE TABLE #FINDATA
            (
              I_Brand_ID INT ,
              S_Brand_Name VARCHAR(MAX) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(MAX) ,
              TypeofCentre VARCHAR(MAX) ,
              TransactionDate DATETIME ,
              MonthYear VARCHAR(MAX) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(MAX) ,
              FinancialRange VARCHAR(10) ,
              Category VARCHAR(MAX) ,
              NValue DECIMAL(14, 2) ,
              I_FeeComponent_ID INT ,
              FeeComponentName VARCHAR(MAX) ,
              TypeofComp VARCHAR(10) ,
              Sequence INT ,
              ParentCategory VARCHAR(MAX) ,
              FSequence INT
            )
            
INSERT INTO #FINDATA
EXEC REPORT.uspGetSalesDetailReportNew @dtUptoDate = @UptoDate, -- datetime
    @sHierarchyListID ='54', -- varchar(max)
    @iBrandID = 109 -- int
    
INSERT INTO #FINDATA
EXEC REPORT.uspGetSalesDetailReportNew @dtUptoDate = @UptoDate, -- datetime
    @sHierarchyListID ='93', -- varchar(max)
    @iBrandID = 111 -- int 
    
INSERT INTO #FINDATA
EXEC REPORT.uspGetSalesDetailReportNew @dtUptoDate = @UptoDate, -- datetime
    @sHierarchyListID ='53', -- varchar(max)
    @iBrandID = 107 -- int
    
INSERT INTO #FINDATA
EXEC REPORT.uspGetSalesDetailReportNew @dtUptoDate = @UptoDate, -- datetime
    @sHierarchyListID ='126', -- varchar(max)
    @iBrandID = 110 -- int 

DELETE FROM #FINDATA WHERE FinancialRange!=@Period

--UPDATE #FINDATA SET NValue=ROUND(NValue,0)

--SELECT I_Brand_ID,S_Brand_Name,FinancialRange,Category,CAST(SUM(ROUND(F.NValue,0)) AS INT) FROM #FINDATA AS F GROUP BY I_Brand_ID,S_Brand_Name,FinancialRange,Category

DECLARE @cols NVARCHAR(MAX)
DECLARE @query NVARCHAR(MAX)
SET @cols= STUFF((SELECT  ',' + QUOTENAME(A.Category) FROM (SELECT DISTINCT Category FROM #FINDATA) A 
                                                        ORDER BY A.Category 
                                        FOR XML PATH(''), TYPE 
                                        ).value('.', 'NVARCHAR(MAX)') 
                                ,1,1,'') 
PRINT @cols                                
SET @query='
SELECT I_Brand_ID,S_Brand_Name,FinancialRange,' +@cols+' FROM                                        
(   
SELECT I_Brand_ID,S_Brand_Name,FinancialRange,Category,CAST(SUM(ISNULL(NValue,0)) AS INT) AS NValue  
FROM #FINDATA
GROUP BY I_Brand_ID,S_Brand_Name,FinancialRange,Category
) T1 
PIVOT
(
MIN(T1.NValue) FOR Category IN ('+@cols+')
)X 
ORDER BY S_Brand_Name'

INSERT INTO #temp
EXECUTE(@query)  
        
SELECT * FROM #temp AS T

END
