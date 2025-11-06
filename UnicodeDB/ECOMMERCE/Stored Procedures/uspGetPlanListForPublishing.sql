CREATE PROCEDURE [ECOMMERCE].[uspGetPlanListForPublishing](@BrandIDList VARCHAR(MAX), @CanBePublished BIT=1)
AS
BEGIN

	IF(@CanBePublished=1)
	BEGIN

		select DISTINCT A.* from ECOMMERCE.T_Plan_Master A
		inner join ECOMMERCE.T_Plan_Config B on A.PlanID=B.PlanID and B.StatusID=1
		inner join ECOMMERCE.T_Plan_Brand_Map C on A.PlanID=C.PlanID and C.StatusID=1
		inner join ECOMMERCE.T_Plan_Product_Map D on A.PlanID=D.PlanID
		inner join ECOMMERCE.T_Product_Master E on D.ProductID=E.ProductID and E.IsPublished=1
		where
		A.IsPublished in (0,1) and ISNULL(A.ValidTo,GETDATE())>=GETDATE()
		and A.StatusID=1
		and C.BrandID in
		(
			select CAST(FSR.Val as INT) from fnString2Rows(@BrandIDList,',') AS FSR
		) order by A.SequenceNo -- added by susmita 2022-09-28

	END
	ELSE
	BEGIN

		select DISTINCT A.* from ECOMMERCE.T_Plan_Master A
		inner join ECOMMERCE.T_Plan_Brand_Map C on A.PlanID=C.PlanID and C.StatusID=1
		where
		A.IsPublished in (0) and ISNULL(A.ValidTo,GETDATE())>=GETDATE()
		and A.StatusID=1
		and C.BrandID in
		(
			select CAST(FSR.Val as INT) from fnString2Rows(@BrandIDList,',') AS FSR
		) order by A.SequenceNo -- added by susmita 2022-09-28

	END

END
