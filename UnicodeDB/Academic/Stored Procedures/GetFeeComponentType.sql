-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <5th September, 2023>
-- Description:	<to fetch the class IDs>
-- =============================================
CREATE PROCEDURE [Academic].[GetFeeComponentType] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  select TFCT.I_Fee_Component_Type_ID as FeeComponentTypeID,
  CASE WHEN TFCT.S_Fee_Component_Type_Name like '%Individual%' THEN 'Additional'    
  ELSE TFCT.S_Fee_Component_Type_Name END as FeeComponentTypeName
  from [dbo].[T_Fee_Component_Type] as TFCT
  where TFCT.I_Status = 1
END
