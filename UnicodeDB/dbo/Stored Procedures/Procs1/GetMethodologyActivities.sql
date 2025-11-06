CREATE PROCEDURE  [dbo].[GetMethodologyActivities]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 28-09-2023
-- Description:	Get Methodology Activities
-- =============================================
-- Add the parameters for the stored procedure here

@BrandID int =null,
@MethodologyActivityID int =null,
@MethodologyCategoryID int =null,
@MethodologyActivityName nvarchar(400)=null,
@MeasureUnit nvarchar(400) =null,
@Status int =null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	select 
	TEMC.I_Brand_ID as BrandID,
	TEMA.I_Methodology_Activity_ID as Activity_ID,
	TEMA.I_Methodology_Category_ID as Category_ID,
	TEMC.S_Methodology_Category_Name as Category_Name,
	TEMA.S_Methodology_Activity_Name as Activity_Name,
	TEMA.S_Methodology_Activity_Description as Activity_Description, 
	TEMA.S_Measure_Unit as Measure_Unit,
	TEMA.I_CreatedBy  as Crtd_By,
	TEMA.Dt_CreatedAt as Crtd_On,
	(Case
	 when TEMA.I_Status=1 then 'Active' Else 'Inactive' end) as Activity_Status

    from 
    T_ERP_Methodology_Activity TEMA
	left join
	T_ERP_Methodology_Category TEMC
	on 
	TEMA.I_Methodology_Category_ID=TEMC.I_Methodology_Category_ID
    where
	
	(TEMC.I_Brand_Id=@BrandID or @BrandID is null)
	and
	(TEMA.I_Methodology_Activity_ID=@MethodologyActivityID or @MethodologyActivityID is null)
	and 
	(TEMA.I_Methodology_Category_ID=@MethodologyCategoryID or @MethodologyCategoryID is null)
	and 
	(TEMA.S_Methodology_Activity_Name=@MethodologyActivityName or @MethodologyActivityName is null)
	and 
	(TEMA.S_Measure_Unit=@MeasureUnit or @MeasureUnit is null)
    and 
	(TEMA.I_Status=@Status or @Status is null)
	




END
