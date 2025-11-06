CREATE PROCEDURE [ECOMMERCE].[uspSaveBatchNotification]
(
	@CustomerID VARCHAR(MAX),
	@PlanID INT,
	@ProductID INT,
	@MobileNo VARCHAR(MAX),
	@EmailID VARCHAR(MAX),
	@CenterID INT
)
AS
BEGIN

	IF NOT EXISTS
	(
		select * from ECOMMERCE.T_Batch_Availability_Notification where CustomerID=@CustomerID and ProductID=@ProductID and StatusID=1
																		and MobileNo=@MobileNo and EmailID=@EmailID and CenterID=@CenterID
	)
	BEGIN

		insert into ECOMMERCE.T_Batch_Availability_Notification
		(
			CustomerID,
			PlanID,
			ProductID,
			CenterID,
			MobileNo,
			EmailID,
			StatusID,
			CreatedOn,
			CreatedBy
		)
		VALUES
		(
			@CustomerID,
			@PlanID,
			@ProductID,
			@CenterID,
			@MobileNo,
			@EmailID,
			1,
			GETDATE(),
			'rice-group-admin'
		)

	END


END
