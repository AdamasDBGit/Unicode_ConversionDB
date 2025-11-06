
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Feb-28>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspBulkUpdateInsertTransportDetails] 
	-- Add the parameters for the stored procedure here    
      @I_Brand_ID INT ,    
      @S_PickupPoint_Name NVARCHAR(MAX) ,    
      @N_Fees NUMERIC(18, 2) ,  
	  @Academic NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Route_ID INT=NULL
	DECLARE @I_Pickup_Id INT=NULL
	DECLARE @IBulkTransportID INT
	declare @TDate datetime;
	set @TDate = getdate();
	DECLARE @RouteLists VARCHAR(MAX) 

	set @S_PickupPoint_Name=LTRIM(RTRIM(REPLACE(@S_PickupPoint_Name, CHAR(160), '')));

	create table #result
	(
	Result INT
	)

	IF ( SELECT COUNT(*)    
                     FROM   dbo.T_Transport_Master AS TERD    
                     WHERE  S_PickupPoint_Name = @S_PickupPoint_Name    
                            AND I_Status = 1
                            --akash 28.3.2017
                            AND I_Brand_ID= @I_Brand_ID
                            --akash 28.3.2017  
                   ) = 0     
                    BEGIN 
					
					 
					SELECT @RouteLists = COALESCE(@RouteLists + ', ', '') + Route_No 
					FROM Temp_Transport_For_Bulk_Import where S_PickupPoint_Name=@S_PickupPoint_Name and I_Brand_ID=@I_Brand_ID and ActinStatus IS NULL
					

					insert into #result
					exec [dbo].[uspInsertUpdateTransportDetails] 0,@I_Brand_ID,@S_PickupPoint_Name, @N_Fees,1,'RICE-ADMIN-DBA','RICE-ADMIN-DBA',1,@TDate,@TDate,@RouteLists

					insert into T_Bulk_Transport_Import_History
					(
					I_PickupPoint_ID,
					I_Brand_ID,
					S_PickupPoint_Name,
					N_Fees,
					S_Crtd_By,
					Dt_Crtd_On,
					S_Academic_Session,
					ActionType
					)
					values
					(
					0,
					@I_Brand_ID,
					@S_PickupPoint_Name,
					@N_Fees,
					'RICE-ADMIN-DBA',
					GETDATE(),
					@Academic,
					'NEW'
					)

					SELECT  @IBulkTransportID = @@IDENTITY  

					IF ((select count(*) from #result) > 0 )
						BEGIN

						update T_Bulk_Transport_Import_History 
						set I_PickupPoint_ID=(SELECT I_PickupPoint_ID    
							FROM   dbo.T_Transport_Master AS TERD    
							WHERE  S_PickupPoint_Name = @S_PickupPoint_Name    
                            AND I_Status = 1
                            --akash 28.3.2017
                            AND I_Brand_ID= @I_Brand_ID), ActionStatus='Success' where I_Bulk_Transport_ID=@IBulkTransportID


						update Temp_Transport_For_Bulk_Import set ActinStatus='NEW' 
						where S_PickupPoint_Name=@S_PickupPoint_Name and I_Brand_ID=@I_Brand_ID and Route_No in (
						 SELECT CAST(Val AS VARCHAR(max)) FROM    dbo.fnString2Rows(@RouteLists, ',') 
						)

						END

				END
						ELSE


							BEGIN

							IF ( SELECT COUNT(*)    
								 FROM   dbo.Temp_Transport_For_Bulk_Import     
								 WHERE  S_PickupPoint_Name = @S_PickupPoint_Name    
								AND ActinStatus IS NULL
								AND I_Brand_ID= @I_Brand_ID  
								) > 0 

								BEGIN

								DECLARE @iPickupID INT

								 SELECT  TOP 1 @iPickupID=TTM.I_PickupPoint_ID  
								 FROM    dbo.T_Transport_Master AS TTM  
								 LEFT OUTER JOIN dbo.T_Route_Transport_Map AS TRTM ON TTM.I_PickupPoint_ID = TRTM.I_PickupPoint_ID  
								 LEFT OUTER JOIN dbo.T_BusRoute_Master AS TBRM ON TRTM.I_Route_ID = TBRM.I_Route_ID  
								 WHERE   TTM.I_Status = 1  AND TTM.S_PickupPoint_Name=@S_PickupPoint_Name AND TTM.I_Brand_ID=@I_Brand_ID
								 AND ( TRTM.I_Status = 1  OR TRTM.I_Status IS NULL) AND ( TBRM.I_Status = 1  OR TBRM.I_Status IS NULL ) 
								 

									SELECT @RouteLists = COALESCE(@RouteLists + ', ', '') + Route_No 
									FROM Temp_Transport_For_Bulk_Import where S_PickupPoint_Name=@S_PickupPoint_Name and I_Brand_ID=@I_Brand_ID  AND ActinStatus IS NULL
					

									insert into #result
									exec [dbo].[uspInsertUpdateTransportDetails] @iPickupID,@I_Brand_ID,@S_PickupPoint_Name, @N_Fees,1,'RICE-ADMIN-DBA','RICE-ADMIN-DBA',0,@TDate,@TDate,@RouteLists

									insert into T_Bulk_Transport_Import_History
									(
									I_PickupPoint_ID,
									I_Brand_ID,
									S_PickupPoint_Name,
									N_Fees,
									S_Crtd_By,
									Dt_Crtd_On,
									S_Academic_Session,
									ActionType
									)
									values
									(
									@iPickupID,
									@I_Brand_ID,
									@S_PickupPoint_Name,
									@N_Fees,
									'RICE-ADMIN-DBA',
									GETDATE(),
									@Academic,
									'Update'
									)

									SELECT  @IBulkTransportID = @@IDENTITY  

									IF ((select count(*) from #result) > 0 )
										BEGIN

										update T_Bulk_Transport_Import_History 
										set I_PickupPoint_ID=@iPickupID, ActionStatus='Success' where I_Bulk_Transport_ID=@IBulkTransportID


										update Temp_Transport_For_Bulk_Import set ActinStatus='Update' 
										where S_PickupPoint_Name=@S_PickupPoint_Name and I_Brand_ID=@I_Brand_ID and Route_No in (
										 SELECT CAST(Val AS VARCHAR(max)) FROM    dbo.fnString2Rows(@RouteLists, ',') 
										)

										END


								END




							END


				
END

