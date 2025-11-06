CREATE PROCEDURE [dbo].[uspValidateModuleTermAssociation] 
(
	-- Add the parameters for the stored procedure here
	@xModuleList xml,
	@dtCurrentDate datetime = null
)

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DECLARE @iReturn INT, @iModuleID INT, @iFlag INT
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE @sModuleListXML XML, @sModuleXML XML
	
	SET @iReturn = 0
	SET @iFlag = 0
	SET @AdjPosition = 1
	SET @sModuleListXML= @xModuleList.query('/ModuleList[position()=sql:variable("@AdjPosition")]')
	Set @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())
	SET @AdjCount = @xModuleList.value('count((ModuleList/Module))','int')
	WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sModuleXML = @xModuleList.query('/ModuleList/Module[position()=sql:variable("@AdjPosition")]')
			SELECT @iModuleID = T.a.value('@I_Module_ID','int')
			FROM @sModuleXML.nodes('/Module') T(a)
			
			IF NOT EXISTS(	SELECT	I_Session_ID 
							FROM dbo.T_Session_Module_Map WITH(NOLOCK)
							WHERE I_Module_ID = @iModuleID
							AND @dtCurrentDate >= ISNULL(Dt_Valid_From, @dtCurrentDate)
							AND @dtCurrentDate <= ISNULL(Dt_Valid_To, @dtCurrentDate)
							AND I_Status <> 0	)
			BEGIN
				SET @iFlag = 1
				BREAK 		
			END
			
			SET @AdjPosition=@AdjPosition+1
		END	
		
	SELECT @iFlag Flag 		

END
