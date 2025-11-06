CREATE PROCEDURE [dbo].[uspGetDelivery]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

    -- Insert statements for procedure here
	SELECT 
		I_Delivery_Pattern_ID,
		S_Pattern_Name,
		I_Status,
		I_No_Of_Session,
		N_Session_Day_Gap,
		S_DaysOfWeek
	FROM 
		T_Delivery_Pattern_Master 
	WHERE 	
		I_Status <> 0	
END
