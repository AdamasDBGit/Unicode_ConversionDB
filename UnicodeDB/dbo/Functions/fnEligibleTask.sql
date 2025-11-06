/*******************************************************************************************************
* Author		:	Aritra Saha
* Create date	:	04/07/2007
* Description	:	This Function checks whether the Task matches the Key Value pairs(except the 
					Trust_Domain Key)
* Return		:	Integer
*******************************************************************************************************/
CREATE FUNCTION [dbo].[fnEligibleTask]
(
	@iTaskDetailId INT,
	@iCondition INT,
	@sKeyValue XML 
)
RETURNS INT

AS
BEGIN

	DECLARE @iTemp INT
	SET @iTemp = 1
	DECLARE @COUNT1 INT
	DECLARE @COUNT2 INT
	DECLARE @tempTableKeyValues TABLE 
	(
		seq int identity(1,1),
		S_Key varchar(50),
		S_Value varchar(100),
		bStatus int
	)
	
	INSERT INTO @tempTableKeyValues
		(
			S_Key,
			S_Value
		)
		SELECT T.c.value('@S_Key','VARCHAR(50)'),
	T.c.value('@S_Value','VARCHAR(50)')
	FROM   @sKeyValue.nodes('/KeyValueList/KeyValue') T(c)		
	
	SELECT @COUNT2 = COUNT(*) FROM @tempTableKeyValues TTKV WHERE TTKV.S_Key <> 'TrustDomain'
	
	IF(@COUNT2 > 0 ) -- For Keys other than Role Hierarchy
	BEGIN
		IF @iCondition = 1 --For AND Condition
			BEGIN
				
				SELECT @COUNT1 = COUNT(*) FROM dbo.T_Task_Mapping TM, @tempTableKeyValues TTKV 
					  WHERE 
					  TM.I_Task_Details_Id = @iTaskDetailId 
					  AND TM.S_Key <> 'TrustDomain' -- match for all keys, except Role Hierarchy
					  AND TM.S_Key = TTKV.S_Key 
					  AND TTKV.S_Value = TM.S_Value			 
								
				IF (@COUNT1 <> @COUNT2)
					SET @iTemp	= 0
			
			END
		
		ELSE IF @iCondition = 0 --For OR Condition
			BEGIN
				SELECT @COUNT1 = COUNT(*) FROM dbo.T_Task_Mapping TM, @tempTableKeyValues TTKV 
					 WHERE
					 TM.I_Task_Details_Id = @iTaskDetailId 
					 AND TM.S_Key <> 'TrustDomain' -- match for all keys, except Role Hierarchy
					 AND TM.S_Key = TTKV.S_Key 
					 AND TTKV.S_Value = TM.S_Value
			
				if(@COUNT1 = 0)
					SET @iTemp	= 0
			END
	 END

	RETURN @iTemp
END