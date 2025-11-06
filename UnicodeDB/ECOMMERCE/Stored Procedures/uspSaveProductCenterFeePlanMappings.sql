CREATE PROCEDURE [ECOMMERCE].[uspSaveProductCenterFeePlanMappings]
(
	@ProductID INT,
	@CenterID INT,
	@FeePlanID INT,
	@ValidFrom DATETIME,
	@ValidTo DATETIME,
	@CreatedBy VARCHAR(MAX)='rice-group-admin'
)
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION

			DECLARE @ProductCenterID INT=0

			IF NOT EXISTS(select * from ECOMMERCE.T_Product_Master where ProductID=@ProductID and StatusID=1 and IsPublished=0)
			BEGIN

				RAISERROR('Product does not exist',11,1)

			END

			IF NOT EXISTS
			(
				select * from ECOMMERCE.T_Product_Center_Map A
				where
				A.ProductID=@ProductID and A.CenterID=@CenterID and A.StatusID=1
			)
			BEGIN

				insert into ECOMMERCE.T_Product_Center_Map
				(
					ProductID,
					CenterID,
					StatusID,
					IsPublished,
					CreatedBy,
					CreatedOn
				)
				VALUES
				(
					@ProductID,
					@CenterID,
					1,
					1,
					@CreatedBy,
					GETDATE()
				)


				SET @ProductCenterID=SCOPE_IDENTITY()

				END
				ELSE
				BEGIN

					select @ProductCenterID=ProductCentreID from ECOMMERCE.T_Product_Center_Map A
					where
					A.ProductID=@ProductID and A.CenterID=@CenterID and A.StatusID=1

				END

				IF(@ProductCenterID>0)
				BEGIN

					IF NOT EXISTS
					(
						select * from ECOMMERCE.T_Product_FeePlan A
						where
						A.ProductCentreID=@ProductCenterID and A.StatusID=1
					)
					BEGIN

						insert into ECOMMERCE.T_Product_FeePlan
						(
							ProductCentreID,
							CourseFeePlanID,
							ProductFeePlanDisplayName,
							StatusID,
							ValidFrom,
							ValidTo,
							CreatedBy,
							CreatedOn,
							IsPublished
						)
						select @ProductCenterID,@FeePlanID,S_Fee_Plan_Name,1,@ValidFrom,@ValidTo,@CreatedBy,GETDATE(),1
						from 
						T_Course_Fee_Plan where I_Status=1 and I_Course_Fee_Plan_ID=@FeePlanID

					END
					ELSE
					BEGIN

						DECLARE @FeePlanName VARCHAR(MAX)=''

						select @FeePlanName= S_Fee_Plan_Name
						from 
						T_Course_Fee_Plan where I_Status=1 and I_Course_Fee_Plan_ID=@FeePlanID

						UPDATE ECOMMERCE.T_Product_FeePlan 
						set 
						ProductFeePlanDisplayName=@FeePlanName,
						CourseFeePlanID=@FeePlanID, 
						ValidFrom=@ValidFrom,
						ValidTo=@ValidTo,
						UpdatedBy=@CreatedBy,
						UpdatedOn=GETDATE()
						WHERE
						ProductCentreID=@ProductCenterID and StatusID=1

					END


				END

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
	--Error occurred:  
		ROLLBACK TRANSACTION
		DECLARE @ErrMsg NVARCHAR(4000) ,
			@ErrSeverity INT
		SELECT  @ErrMsg = ERROR_MESSAGE() ,
				@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
