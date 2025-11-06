-- =============================================
-- Author:		Shankha Roy
-- Create date: '11/26/2007'
-- Description:	This Function return a table 
-- constains center Id of HierarchyID 
-- Return: Table
-- =============================================
CREATE FUNCTION [dbo].[fnGetCenterIDFromHierarchy]
(
	@iSelectedHierarchyId INT,	
	@iBrandId INT
)
RETURNS  @TempCenter TABLE
	( 
		I_Center_ID int
	)

AS 
BEGIN
	DECLARE @sSearchCriteria varchar(100)
	IF @iSelectedHierarchyId IS NOT NULL	
	BEGIN

		SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
		
		IF @iBrandId = 0 
			BEGIN
				INSERT INTO @TempCenter 
				SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
				TCHD.I_Hierarchy_Detail_ID IN 
				(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
				WHERE I_Status = 1
				AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
				AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
				AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
				AND TCHD.I_Status = 1
			END
		ELSE
			BEGIN
				INSERT INTO @TempCenter 
				SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE
				TCHD.I_Hierarchy_Detail_ID IN 
			   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
				WHERE I_Status = 1
				AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
				AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
				AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
				TBCD.I_Brand_ID=@iBrandId AND
				TBCD.I_Centre_Id = TCHD.I_Center_Id
				AND TCHD.I_Status = 1 			 
			END
	END
	ELSE
	BEGIN
		INSERT INTO @TempCenter
		SELECT I_Centre_ID FROM T_Centre_Master WHERE I_Status = 1
	END
 RETURN ;
END