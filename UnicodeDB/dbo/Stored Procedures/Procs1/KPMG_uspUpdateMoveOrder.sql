
CREATE PROCEDURE [dbo].[KPMG_uspUpdateMoveOrder]
@XmlData XML
AS

BEGIN TRY 

DECLARE @TEMP_ORACLE_MO TABLE(Id INT identity, OracleMoLineId INT ,OracleMoNumber INT,SMSMoId INT,SMSMoLineNo INT)

INSERT INTO @TEMP_ORACLE_MO(OracleMoLineId,OracleMoNumber,SMSMoId,SMSMoLineNo)
SELECT 
                        T.c.value('OracleMoLineId[1]', 'INT') ,
                        T.c.value('OracleMoNumber[1]', 'NVARCHAR(max)') ,
                        T.c.value('SMSMoId[1]', 'INT') ,                        
                        T.c.value('SMSMoLineNo[1]', 'INT')                        
                FROM    @XmlData.nodes('/ROOT/OracleMoveOrder') T ( c )   


UPDATE A SET A.Fld_KPMG_GrnNumber=B.OracleMoNumber ,A.Fld_KPMG_ISCollected='Y'
FROM  Tbl_KPMG_MoMaster A INNER JOIN  @TEMP_ORACLE_MO B
ON A.Fld_KPMG_Mo_Id=B.SMSMoId

UPDATE A SET A.Fld_KPMG_OracleLineNumber=C.OracleMoLineId FROM Tbl_KPMG_MoItems A INNER JOIN Tbl_KPMG_MoMaster 
 B ON A.Fld_KPMG_Mo_Id=B.Fld_KPMG_Mo_Id
INNER JOIN @TEMP_ORACLE_MO C ON A.Fld_KPMG_MoItem_Id=C.SMSMoLineNo

DECLARE @ROW_CNT INT
DECLARE @CNTR INT = 1 
DECLARE @MOV_ID INT
DECLARE @BRNCH_ID INT
DECLARE @AMNT INT
DECLARE @BRNCH_NAME nvarchar(max)
SELECT @ROW_CNT = COUNT(1) FROM @TEMP_ORACLE_MO


WHILE @CNTR < @ROW_CNT
BEGIN
	SELECT @MOV_ID = SMSMoId FROM @TEMP_ORACLE_MO WHERE @CNTR  = Id
	SELECT @BRNCH_ID = Fld_KPMG_Branch_Id FROM Tbl_KPMG_MoMaster WHERE  Fld_KPMG_Mo_Id = @MOV_ID
	SELECT @BRNCH_NAME = fld_kpmg_BranchName FROM Tbl_KPMG_BranchConfiguration WHERE fld_kpmg_BranchId = @BRNCH_ID 
	SELECT @AMNT = SUM(Fld_KPMG_Quantity) FROM Tbl_KPMG_MoItems WHERE  Fld_KPMG_Mo_Id = @MOV_ID
	
	INSERT INTO tbl_KPMG_Notifications (NotificationMessage,TaskMessage,UniqueKey,BranchId,ItemAmount)
	VALUES ('A new MoveOrder(#'+Convert(varchar(255), @MOV_ID)+') has been generated from Branch '+ @BRNCH_NAME,
			'TASK messgae',
			@MOV_ID,@BRNCH_ID,	@AMNT)		
			 
	SET @CNTR  = @CNTR  +1 
END






END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

