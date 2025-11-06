CREATE Proc [dbo].[USP_Fetch_FormID](@Brandid int)

as    
begin     
DECLARE @PatternHeaderID  INT= (select SPH.I_Pattern_HeaderID from [T_ERP_Saas_Pattern_Header] as SPH where SPH.I_Brand_ID=107 and SPH.S_Property_Name='Form Number')
DECLARE @incrementid int = (Select ISNULL(PCH.I_Increment_ID, 0) FROM [T_ERP_Saas_Pattern_Child_Header] AS PCH WHERE I_Pattern_HeaderID=@PatternHeaderID); 
UPDATE [T_ERP_Saas_Pattern_Child_Header]
SET I_Increment_ID =  @incrementid+1
WHERE I_Pattern_HeaderID=@PatternHeaderID

  DECLARE @Result VARCHAR(20);

SET @Result = dbo.GenerateFormNumber(@PatternHeaderID);

SELECT @Result AS FormNumber;


end