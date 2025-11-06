CREATE FUNCTION [dbo].[fnGetCentreIdByBrandId] (@BrandID INT) RETURNS  @rtnTable TABLE      
(      
 brandID INT,        
 centerID INT,      
 centerCode VARCHAR(20),      
 centerName VARCHAR(100)      
)      
      
 AS BEGIN  Insert Into @rtnTable     SELECT TOP 1  @BrandID,CM.I_Centre_Id,CM.S_Center_Code,CM.S_Center_Name     FROM T_Brand_Master BM     INNER JOIN T_Brand_Center_Details BCD ON BCD.I_Brand_ID = BM.I_Brand_ID   Inner Join T_Centre_Master CM ON 
 CM.I_Centre_Id=BCD.I_Centre_Id and CM.I_Status=1     WHERE BM.I_Brand_ID = @BrandID        AND BM.I_Status = 1       AND BCD.I_Status = 1;  RETURN;      END