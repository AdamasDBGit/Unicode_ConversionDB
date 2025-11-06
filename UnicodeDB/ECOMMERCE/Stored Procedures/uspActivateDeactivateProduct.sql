CREATE PROCEDURE [ECOMMERCE].[uspActivateDeactivateProduct]
(
	@ProductID INT,
	@Flag BIT
)
AS
BEGIN

BEGIN TRY
	BEGIN TRANSACTION

		IF(@Flag=0)
		BEGIN

			IF EXISTS
			(
				select * from ECOMMERCE.T_Plan_Product_Map A
				inner join ECOMMERCE.T_Plan_Master B on A.PlanID=B.PlanID
				where
				B.IsPublished=1 and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()) and B.StatusID=1
				and A.ProductID=@ProductID and A.StatusID=1
			)
			BEGIN

				RAISERROR('Product is attached to published plans. Cannot be deactivated.',11,1)

			END
			ELSE
			BEGIN

				UPDATE ECOMMERCE.T_Product_Master set IsPublished=@Flag where ProductID=@ProductID and StatusID=1

			END

		END
		ELSE
		BEGIN

			UPDATE ECOMMERCE.T_Product_Master set IsPublished=@Flag where ProductID=@ProductID and StatusID=1

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
