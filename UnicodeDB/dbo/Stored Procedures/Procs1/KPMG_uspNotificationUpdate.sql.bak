
CREATE PROCEDURE [dbo].[KPMG_uspNotificationUpdate]
@XmlData XML
AS

BEGIN TRY 

DECLARE @TEMP_ORACLE_MO TABLE(OracleMoLineId INT ,OracleMoNumber INT,SMSMoId INT,SMSMoLineNo INT)

INSERT INTO @TEMP_ORACLE_MO(OracleMoLineId,OracleMoNumber,SMSMoId,SMSMoLineNo)
SELECT 
                        T.c.value('OracleMoLineId[1]', 'INT') ,
                        T.c.value('OracleMoNumber[1]', 'NVARCHAR(255)') ,
                        T.c.value('SMSMoId[1]', 'INT') ,                        
                        T.c.value('SMSMoLineNo[1]', 'INT')                        
                FROM    @XmlData.nodes('/ROOT/OracleMoveOrder') T ( c )   


UPDATE A SET A.Fld_KPMG_GrnNumber=B.OracleMoNumber ,A.Fld_KPMG_ISCollected='Y'
FROM  Tbl_KPMG_MoMaster A INNER JOIN  @TEMP_ORACLE_MO B
ON A.Fld_KPMG_Mo_Id=B.SMSMoId

UPDATE A SET A.Fld_KPMG_OracleLineNumber=C.OracleMoLineId FROM Tbl_KPMG_MoItems A INNER JOIN Tbl_KPMG_MoMaster  B ON A.Fld_KPMG_Mo_Id=B.Fld_KPMG_Mo_Id
INNER JOIN @TEMP_ORACLE_MO C ON A.Fld_KPMG_MoItem_Id=C.SMSMoLineNo




END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
