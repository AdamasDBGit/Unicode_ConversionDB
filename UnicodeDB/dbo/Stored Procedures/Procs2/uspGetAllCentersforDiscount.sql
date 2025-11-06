CREATE PROCEDURE [dbo].[uspGetAllCentersforDiscount]

	(
		@iSelectedHierarchyId int = null,
		@iSelectedBrandId int = null
	)
 

AS

BEGIN 
	SET NOCOUNT ON;
	DECLARE @sSearchCriteria varchar(max)
	
	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
	
	IF @iSelectedBrandId IS NULL
		BEGIN
			SELECT DISTINCT TCHD.I_Center_Id, TCM.I_Country_ID, CM.I_Currency_ID
			FROM T_CENTER_HIERARCHY_DETAILS TCHD
			INNER JOIN dbo.T_Centre_Master TCM 
			ON TCHD.I_Center_ID = TCM.I_Centre_ID
			INNER JOIN dbo.T_Country_Master CM WITH(NOLOCK)
			ON TCM.I_Country_ID = CM.I_Country_ID
			WHERE  
			 TCHD.I_Hierarchy_Detail_ID IN 
				(SELECT I_HIERARCHY_DETAIL_ID 
					FROM T_Hierarchy_Mapping_Details 
					WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%')
 
		END
	ELSE
		BEGIN
			SELECT DISTINCT TCHD.I_Center_Id, TCM.I_Country_ID, CM.I_Currency_ID
			FROM T_CENTER_HIERARCHY_DETAILS TCHD 
			INNER JOIN T_BRAND_CENTER_DETAILS TBCD
			ON TBCD.I_Centre_Id = TCHD.I_Center_Id
				AND TBCD.I_Brand_ID = @iSelectedBrandId 	
			INNER JOIN dbo.T_Centre_Master TCM 
			ON TCHD.I_Center_ID = TCM.I_Centre_ID
			INNER JOIN dbo.T_Country_Master CM WITH(NOLOCK)
			ON TCM.I_Country_ID = CM.I_Country_ID
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID 
				FROM T_Hierarchy_Mapping_Details WITH(NOLOCK)
				WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
 
			 
		END

END
