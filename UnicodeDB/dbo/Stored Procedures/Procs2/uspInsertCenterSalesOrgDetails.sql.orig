CREATE PROCEDURE [dbo].[uspInsertCenterSalesOrgDetails]
	(
		@iSelectedHierarchyId int,
		@iSelectedBrandId int,
		@iCourseID int,
		@iDeliveryID int,
		@iFeePlanID int,
		@sCreatedBy varchar(20),
		@dCreatedOn datetime
	)
AS
BEGIN
	SET NOCOUNT OFF;
	DECLARE @sSearchCriteria varchar(20)
	
	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
		
	IF @iSelectedBrandId =0 
		BEGIN
			INSERT INTO T_Course_Center_Delivery_FeePlan 
			(I_Course_Delivery_ID,
			I_Course_Center_ID,
			I_Course_Fee_Plan_ID,
			Dt_Valid_From,
			I_Status)	
			SELECT @iDeliveryID,TCHD.I_Center_Id,@iFeePlanID,getdate(),1
			FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
			TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + ',%') 
			

			INSERT INTO T_Course_Center_Detail
			(I_Centre_Id,
			I_Course_ID,
			S_Crtd_By,
			Dt_Valid_From,
			Dt_Crtd_On,
			I_Status)			
			SELECT TCHD.I_Center_Id,@iCourseID,@sCreatedBy,getdate(),@dCreatedOn,1
			FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
			TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + ',%') 
			
		END
	ELSE
		BEGIN
			INSERT INTO T_Course_Center_Delivery_FeePlan 
			(I_Course_Delivery_ID,
			I_Course_Center_ID,
			I_Course_Fee_Plan_ID,
			Dt_Valid_From,
			I_Status)			
			SELECT @iDeliveryID,TCHD.I_Center_Id,@iFeePlanID,getdate(),1
			FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD 
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
		    (SELECT I_HIERARCHY_DETAIL_ID 
			FROM T_Hierarchy_Mapping_Details 
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + ',%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id
			

			INSERT INTO T_Course_Center_Detail
			(I_Centre_Id,
			I_Course_ID,
			S_Crtd_By,
			Dt_Valid_From,
			Dt_Crtd_On,
			I_Status)
			SELECT TCHD.I_Center_Id,@iCourseID,@sCreatedBy,getdate(),@dCreatedOn,1
			FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD 
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
		    (SELECT I_HIERARCHY_DETAIL_ID 
			FROM T_Hierarchy_Mapping_Details 
			WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + ',%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id
			
		END
END
