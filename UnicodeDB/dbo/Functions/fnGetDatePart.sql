CREATE FUNCTION [dbo].[fnGetDatePart]  
(  
@Dt DATETIME = NULL  
)  
RETURNS DATETIME  
AS  
BEGIN  
DECLARE @dCustomDate  DATETIME    
   
 SET @dCustomDate= CAST(CAST(ISNULL(@Dt,GETDATE()) AS VARCHAR(11)) AS DATETIME)  
   
RETURN  @dCustomDate  
  
END