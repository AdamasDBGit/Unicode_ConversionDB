CREATE PROCEDURE [ECOMMERCE].[uspSavePlanProductMap](@PlanID int, @ProductIDList VARCHAR(MAX))
AS
BEGIN


	delete from ECOMMERCE.T_Plan_Product_Map where PlanID=@PlanID

	insert into ECOMMERCE.T_Plan_Product_Map
	select @PlanID,CAST(Val as INT),1 from fnString2Rows(@ProductIDList,',') AS FSR


END
