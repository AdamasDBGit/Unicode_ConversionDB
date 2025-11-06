CREATE PROCEDURE [NETWORK].[uspGetCenterStatusForSelectedHierarchy]

	(
		@iSelectedHierarchyId int,
		@iSelectedBrandId int = null,
		@iRFFType int = null,
		@iIsOwnCenter int = null
	)


AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @sSearchCriteria varchar(20)
	
	IF @iSelectedBrandId IS NULL
	BEGIN
		SET @iSelectedBrandId = 0
	END
	
	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
	
	IF @iSelectedBrandId = 0 
		BEGIN
			SELECT TCHD.I_Center_Id,
				   CM.S_Center_Name,
				   CM.S_Center_Short_Name,
                   CM.S_Center_Code,
				   CM.I_Status,
				   CM.I_Expiry_Status,
				   CM.I_RFF_Type,
                   CM.I_Is_OwnCenter
			FROM T_CENTER_HIERARCHY_DETAILS TCHD
			INNER JOIN T_Centre_Master CM 
			ON CM.I_Centre_Id = TCHD.I_Center_Id
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE
			S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
			AND TCHD.I_Center_Id = CM.I_Centre_Id
			AND CM.I_RFF_Type = ISNULL(@iRFFType,CM.I_RFF_Type)
			AND CM.I_Is_OwnCenter = ISNULL(@iIsOwnCenter,CM.I_Is_OwnCenter)
		END
	ELSE
		BEGIN
			SELECT TCHD.I_Center_Id,
				   CM.S_Center_Name,
                   CM.S_Center_Short_Name,
                   CM.S_Center_Code,
				   CM.I_Status,
				   CM.I_Expiry_Status,
				   CM.I_RFF_Type,
                   CM.I_Is_OwnCenter
			FROM T_CENTER_HIERARCHY_DETAILS TCHD
			INNER JOIN T_BRAND_CENTER_DETAILS TBCD
			ON TBCD.I_Centre_Id = TCHD.I_Center_Id
			INNER JOIN T_Centre_Master CM 
			ON CM.I_Centre_Id = TCHD.I_Center_Id
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
		   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id
			AND TCHD.I_Center_Id = CM.I_Centre_Id
			AND CM.I_RFF_Type = ISNULL(@iRFFType,CM.I_RFF_Type)
			AND CM.I_Is_OwnCenter = ISNULL(@iIsOwnCenter,CM.I_Is_OwnCenter)
			 
		END
END
