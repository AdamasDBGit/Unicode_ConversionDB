CREATE PROCEDURE [dbo].[GetMethodologyCategory] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 28-09-2023 
-- Description:	To Fatch Methodology Category 
-- =============================================
-- Add the parameters for the stored procedure here
@MethodologyID int =null,
@BrandID int =null,
@MethodologyName nnvarchar(max) =null,
@Status int= null


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
	I_Methodology_Category_ID as MethodologyID,
	I_Brand_ID as Brand_ID,
	S_Methodology_Category_Name as Methodology_Category_Name,
	I_CreatedBy as Crated_By,
	Dt_CreatedAt as Created_On,
	(case when
	I_Status=1 then 'Active' else 'Inactive'end) as Status



	from 
	T_ERP_Methodology_Category 
	where 
	(I_Methodology_Category_ID=@MethodologyID or @MethodologyID is null)
	and 
	(I_Brand_ID=@BrandID or @BrandID is null)
	and 
	(S_Methodology_Category_Name=@MethodologyName or @MethodologyName is null)
	and
	(I_Status=@Status or @Status is null)


END
