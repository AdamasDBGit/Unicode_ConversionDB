
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Feb-28>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[importTransportRoutesforBulk]
	 @I_Brand_ID INT ,    
     @S_PickupPoint_Name NVARCHAR(MAX) ,    
     @N_Fees NUMERIC(18, 2) , 
	 @Route_No NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Route_ID INT=NULL
	DECLARE @RouteID table (RouteID INT)
	declare @TDate datetime;
	set @TDate = getdate();


	SELECT TOP 1 @Route_ID=A.I_Route_ID
					FROM  dbo.T_BusRoute_Master A
					WHERE   A.I_Status = 1
					AND A.S_Route_No=@Route_No
					AND I_Brand_ID = @I_Brand_ID
					order by A.I_Route_ID 


	IF @Route_ID IS NULL
		BEGIN

			insert into @RouteID
			exec [dbo].[uspInsertUpdateBusRouteDetails] NULL,@Route_No,@I_Brand_ID,1,'RICE_ADMIN_DBA',@TDate,1

			select Top 1 @Route_ID=RouteID from @RouteID
		END

	IF ( SELECT COUNT(*)    
                     FROM   Temp_Transport_For_Bulk_Import   
                     WHERE  S_PickupPoint_Name = @S_PickupPoint_Name    
                            AND I_Brand_ID= @I_Brand_ID
							And Route_No=@Route_ID and ActinStatus IS NULL
                   ) = 0     
                    BEGIN

					insert into Temp_Transport_For_Bulk_Import
					(
					S_PickupPoint_Name,
					I_Brand_ID,
					Route_No,
					N_Fees,
					CreationDate
					)
					values
					(
					@S_PickupPoint_Name ,
					@I_Brand_ID,
					@Route_ID,
					@N_Fees,
					@TDate
					)

					END

END

