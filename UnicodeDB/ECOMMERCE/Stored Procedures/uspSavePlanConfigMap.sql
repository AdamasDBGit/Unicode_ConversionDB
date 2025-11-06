  CREATE PROCEDURE [ECOMMERCE].[uspSavePlanConfigMap]
  (
	  @PlanID INT,
	  @ConfigID INT,
	  @ConfigValue VARCHAR(MAX),
	  @ConfigDisplayName VARCHAR(MAX)=''
	  --@SubHeaderID INT=NULL,
	  --@SubHeaderDisplayName VARCHAR(MAX)=NULL,
	  --@HeaderID INT=NULL,
	  --@HeaderDisplayName VARCHAR(MAX)=NULL
  )
  AS
  BEGIN

	DECLARE @PlanConfigID INT=0

	IF NOT EXISTS(select * from ECOMMERCE.T_Plan_Config where PlanID=@PlanID and ConfigID=@ConfigID and StatusID=1)
	BEGIN

		insert into ECOMMERCE.T_Plan_Config
		select @PlanID,@ConfigID,@ConfigValue,@ConfigDisplayName,1--,@SubHeaderID,@SubHeaderDisplayName,@HeaderID,@HeaderDisplayName

		SET @PlanConfigID=SCOPE_IDENTITY()

	END


	SELECT @PlanConfigID as PlantConfigID

  END
