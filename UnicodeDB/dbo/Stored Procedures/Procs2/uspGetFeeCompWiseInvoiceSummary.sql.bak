CREATE PROCEDURE [dbo].[uspGetFeeCompWiseInvoiceSummary]    
(                  
@iInvoiceHeaderId INT           
)           
AS          
BEGIN          
          
          
CREATE TABLE #FINALTABLE      
(          
 I_Fee_Component_Id INT          
,N_Amount_Due  NUMERIC(18,2)          
,N_Discount_Amount NUMERIC(18,10)  
,I_Display_Fee_Component_ID INT        
)         
          
INSERT INTO #FINALTABLE         
SELECT ICD.I_Fee_Component_Id,SUM(ISNULL(ICD.N_Amount_Due,0)),NULL , ICD.I_Display_Fee_Component_ID       
FROM dbo.T_Invoice_Parent IP WITH(NOLOCK)          
INNER JOIN dbo.T_Invoice_Child_Header ICH WITH(NOLOCK) ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID          
INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH(NOLOCK) ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID          
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderId          
GROUP BY ICD.I_Fee_Component_Id,ICD.I_Display_Fee_Component_ID       
          
CREATE TABLE #TaxTable(I_Fee_Component_Id INT,I_Tax_ID INT,S_Tax_Desc VARCHAR(50) ,N_Tax_Value NUMERIC(18,2))          
INSERT INTO #TaxTable          
SELECT ICD.I_Fee_Component_Id,IDT.I_Tax_ID,TM.S_Tax_Desc,SUM(ISNULL(IDT.N_Tax_Value,0))          
FROM dbo.T_Invoice_Parent IP WITH(NOLOCK)          
INNER JOIN dbo.T_Invoice_Child_Header ICH WITH(NOLOCK) ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID          
INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH(NOLOCK) ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID          
INNER JOIN dbo.T_Invoice_Detail_Tax   IDT WITH(NOLOCK) ON ICD.I_Invoice_Detail_ID = IDT.I_Invoice_Detail_ID          
INNER JOIN dbo.T_Tax_Master      TM WITH(NOLOCK) ON TM.I_Tax_Id = IDT.I_Tax_Id      
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderId          
GROUP BY ICD.I_Fee_Component_Id, IDT.I_Tax_ID,TM.S_Tax_Desc       
          
          
DECLARE @nDiscountPercentage NUMERIC(18,10)          
DECLARE @nDiscountAmount  NUMERIC(18,10)     
DECLARE @nDiscountGivenOn  NUMERIC(18,10)        
DECLARE @dtInvoiceDate DATETIME          
          
SELECT @nDiscountAmount = ISNULL(N_Discount_Amount,0)    
      ,@dtInvoiceDate  = Dt_Invoice_Date          
FROM dbo.T_Invoice_Parent WHERE I_Invoice_Header_Id = @iInvoiceHeaderId      
    
SET  @nDiscountGivenOn = 0    
    
SELECT @nDiscountGivenOn = @nDiscountGivenOn + ISNULL(N_Amount_Due,0)    
FROM #FINALTABLE WHERE dbo.ufnGetFeeCompDiscountStatus(I_Fee_Component_Id,@dtInvoiceDate) = 1    
    
IF @nDiscountGivenOn = 0    
BEGIN    
 SET @nDiscountGivenOn = 1    
END    
    
SET @nDiscountPercentage = ISNULL((@nDiscountAmount/@nDiscountGivenOn),0)    
          
--------------------------------------        
          
UPDATE #FINALTABLE        
SET N_Discount_Amount =ISNULL((FT.N_Amount_Due * @nDiscountPercentage * dbo.ufnGetFeeCompDiscountStatus(FT.I_Fee_Component_Id,@dtInvoiceDate)),0)      
FROM #FINALTABLE FT     
    
UPDATE  #FINALTABLE SET  N_Amount_Due = N_Amount_Due + N_Discount_Amount     
        
      
DECLARE @TAX TABLE (ROWID INT IDENTITY(1,1),I_Tax_ID VARCHAR(50),S_Tax_Desc VARCHAR(50))      
INSERT INTO @TAX      
SELECT DISTINCT I_Tax_ID,S_Tax_Desc FROM #TaxTable      
      
DECLARE @min INT      
DECLARE @max INT      
DECLARE @strSQL NVARCHAR(500)      
DECLARE @strSQL2 NVARCHAR(500)      
DECLARE @sColumnName VARCHAR(50)      
      
      
SELECT @min = MIN(ROWID), @max = MAX(ROWID) FROM @TAX      
WHILE @min <= @max      
BEGIN      
 SET @sColumnName = 'TAX'      
 SELECT @sColumnName = @sColumnName+I_Tax_ID FROM @TAX WHERE ROWID = @min      
 SET @strSQL = N'ALTER TABLE #FINALTABLE ADD ' + @sColumnName + ' VARCHAR(100)'      
 exec sp_executesql @strSQL      
      
 UPDATE #TaxTable SET S_Tax_Desc = @sColumnName FROM #TaxTable WHERE I_Tax_ID IN      
 (      
  SELECT I_Tax_ID FROM @TAX WHERE ROWID = @min      
 )      
       
 SET @strSQL = ''      
 SET @min = @min + 1      
END      
      
      
SELECT @min = MIN(ROWID), @max = MAX(ROWID) FROM @TAX      
WHILE @min <= @max      
BEGIN      
 SET @sColumnName = 'TAX'      
 SELECT @sColumnName = @sColumnName+I_Tax_ID FROM @TAX WHERE ROWID = @min      
      
 set @strSQL = 'UPDATE #FINALTABLE SET ' + @sColumnName + ' = TT.N_Tax_Value      
 FROM #TaxTable TT      
 INNER JOIN #FINALTABLE FT ON FT.I_Fee_Component_Id = TT.I_Fee_Component_Id      
 WHERE TT.S_Tax_Desc = '+''''+@sColumnName+''''      
      
 exec sp_executesql @strSQL      
       
 SET @strSQL = ''      
 SET @min = @min + 1      
END      
      
SELECT FCM.S_Component_Name, FT.*      
FROM  #FINALTABLE FT      
INNER JOIN dbo.T_Fee_Component_Master FCM ON FT.I_Display_Fee_Component_ID = FCM.I_Fee_Component_Id       
      
SELECT * FROM @TAX      
      
DROP TABLE #FINALTABLE      
DROP TABLE #TaxTable      
      
          
END
