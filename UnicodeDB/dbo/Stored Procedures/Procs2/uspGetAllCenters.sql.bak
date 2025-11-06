CREATE PROCEDURE [dbo].[uspGetAllCenters]
(
	@iSelectedHierarchyId int,
	@iSelectedBrandId int
)
 

AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @sSearchCriteria varchar(20)
	
	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
	
	IF @iSelectedBrandId =0 
		BEGIN
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
			TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE
			S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
		END
	ELSE
		BEGIN
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE
			TCHD.I_Hierarchy_Detail_ID IN 
		   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id 
			 
		END

END
