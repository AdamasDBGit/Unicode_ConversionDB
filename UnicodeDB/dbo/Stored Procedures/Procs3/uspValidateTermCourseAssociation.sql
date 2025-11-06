CREATE PROCEDURE [dbo].[uspValidateTermCourseAssociation] 
(
	-- Add the parameters for the stored procedure here
	@xTermList xml
)

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DECLARE @iReturn INT, @iTermID INT, @iFlag INT
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE @sTermListXML XML, @sTermXML XML
	
	SET @iReturn = 0
	SET @iFlag = 0
	SET @AdjPosition = 1
	SET @sTermListXML = @xTermList.query('/TermList[position()=sql:variable("@AdjPosition")]')
	
	SET @AdjCount = @xTermList.value('count((TermList/Term))','int')
	WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sTermXML = @xTermList.query('/TermList/Term[position()=sql:variable("@AdjPosition")]')
			SELECT @iTermID = T.a.value('@I_Term_ID','int')
			FROM @sTermXML.nodes('/Term') T(a)
			
			IF NOT EXISTS(	SELECT	I_Module_ID
							FROM dbo.T_Module_Term_Map WITH(NOLOCK)
							WHERE I_Term_ID = @iTermID
							AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
							AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
							AND I_Status <> 0	)
			BEGIN
				SET @iFlag = 1
				BREAK 		
			END
			
			SET @AdjPosition=@AdjPosition+1
		END	
		
	SELECT @iFlag Flag 		

END
