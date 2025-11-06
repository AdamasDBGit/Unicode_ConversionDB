CREATE PROCEDURE [ECOMMERCE].[uspGetRegistrationDetails](@CustomerID VARCHAR(MAX)=NULL,@RegID INT=NULL)
AS
BEGIN

	IF(@CustomerID IS NOT NULL)
	BEGIN

		select * from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1

	END
	ELSE IF (@RegID IS NOT NULL)
	BEGIN

		select * from ECOMMERCE.T_Registration where RegID=@RegID and StatusID=1

	END

END
