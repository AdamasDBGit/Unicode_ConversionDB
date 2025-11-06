--------------- script modified --------------------------
CREATE PROCEDURE [MBP].[uspGetDistinctCenterForSelectedHierarchy] 

	(
		@iSelectedHierarchyId int,
		@iSelectedBrandId int = null
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
	
		BEGIN
			SELECT distinct TCHD.I_Center_Id ,CM.S_Center_Name,CM.S_Center_Short_Name,CM.S_Center_Code,CM.I_Status
			FROM 
			T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD, T_Centre_Master CM
			WHERE
			TCHD.I_Hierarchy_Detail_ID IN 
		   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
			AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id AND
			TBCD.I_Centre_Id = CM.I_Centre_Id AND 
			CM.I_Status = 1			
		END
END
