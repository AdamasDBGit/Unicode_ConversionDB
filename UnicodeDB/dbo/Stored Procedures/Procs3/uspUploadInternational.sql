CREATE PROCEDURE [dbo].[uspUploadInternational]
AS
BEGIN 

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
BEGIN TRANSACTION

CREATE TABLE #tempPool
(
	oldPoolID INT,
	newPoolID INT
)

CREATE TABLE #tempBank
(
	oldBankID INT,
	newBankID INT
)

CREATE TABLE #tempQuestions
(
	oldQID INT,
	newQID INT
)

declare @iBankID INT
declare @iPoolID INT
declare @iQuestionID INT
declare @newPoolID INT
declare @newBankID INT
declare @newQuestionID INT

DECLARE _CURSOR CURSOR FOR
select I_Pool_ID from EXAMINATION.T_Pool_Master where I_Brand_ID In (22,44)

	OPEN _CURSOR
	FETCH NEXT FROM _CURSOR INTO @iPoolID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO EXAMINATION.T_Pool_Master 
		SELECT 55,S_Pool_Desc,I_Status,'SYSTEM',null,'1/1/2002',null
		from EXAMINATION.T_Pool_Master 
		where I_Pool_ID = @iPoolID

		set @newPoolID = scope_identity()

		insert into #tempPool
		SELECT @iPoolID,@newPoolID		

		PRINT 'new pool id: ' + CAST(@newPoolID AS VARCHAR(10)) + ' from pool id : ' + CAST(@iPoolID AS VARCHAR(10))

		FETCH NEXT FROM _CURSOR INTO @iPoolID
	END	

CLOSE _CURSOR
DEALLOCATE _CURSOR



DECLARE _CURSOR CURSOR FOR
select I_Question_Bank_ID from EXAMINATION.T_Question_Bank_Master where I_Brand_ID In (22,44)

	OPEN _CURSOR
	FETCH NEXT FROM _CURSOR INTO @iBankID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO EXAMINATION.T_Question_Bank_Master 
		SELECT 55,S_Bank_Desc,I_Status,'SYSTEM',null,'1/1/2002',null
		from EXAMINATION.T_Question_Bank_Master 
		where I_Question_Bank_ID = @iBankID

		set @newBankID = scope_identity()

		insert into #tempBank
		SELECT @iBankID,@newBankID

		PRINT 'new bank id: ' + CAST(@newBankID AS VARCHAR(10)) + ' from bank id : ' + CAST(@iBankID AS VARCHAR(10))

		FETCH NEXT FROM _CURSOR INTO @iBankID
	END	

CLOSE _CURSOR
DEALLOCATE _CURSOR

DECLARE _CURSOR CURSOR FOR
select I_Question_ID from EXAMINATION.T_Question_Pool where I_Pool_ID In (SELECT oldPoolID from #tempPool)

	OPEN _CURSOR
	FETCH NEXT FROM _CURSOR INTO @iQuestionID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO EXAMINATION.T_Question_Pool 
		SELECT newPoolID,QP.I_Answer_Type_ID,QP.S_Question,QP.S_Question_Options,
			QP.I_Question_Type,QP.I_Document_ID,
			QP.I_Complexity_ID,QP.N_Question_Max_Marks,QP.Dt_Question_Upload_Date,
			QP.S_Crtd_By,QP.S_Upd_By,QP.Dt_Crtd_On,QP.Dt_Upd_On
		from EXAMINATION.T_Question_Pool QP
		INNER JOIN #tempPool TP
		ON QP.I_Pool_ID = TP.oldPoolID
		where I_Question_ID = @iQuestionID

		set @newQuestionID = scope_identity()

		insert into #tempQuestions
		SELECT @iQuestionID,@newQuestionID

		PRINT 'new Question id: ' + CAST(@newQuestionID AS VARCHAR(10)) + ' from Question id : ' + CAST(@iQuestionID AS VARCHAR(10))

		FETCH NEXT FROM _CURSOR INTO @iQuestionID
	END	

CLOSE _CURSOR
DEALLOCATE _CURSOR

PRINT 'Inserting into T_Question_Choices'


INSERT INTO EXAMINATION.T_Question_Choices
SELECT TP.newQID,QC.B_Is_Answer,QC.S_Answer_Desc,QC.N_Answer_Marks
	from EXAMINATION.T_Question_Choices QC
	INNER JOIN #tempQuestions TP
		ON QC.I_Question_ID = TP.oldQID

PRINT 'Inserting into T_Bank_Pool_Mapping'

INSERT INTO EXAMINATION.T_Bank_Pool_Mapping
SELECT TP.newPoolID,TQ.newBankID,'SYSTEM',NULL,'1/1/2002',NULL
FROM EXAMINATION.T_Bank_Pool_Mapping BPM
INNER JOIN #tempPool TP
ON BPM.I_Pool_ID = TP.oldPoolID
INNER JOIN #tempBank TQ
ON BPM.I_Question_Bank_ID = TQ.oldBankID
	
DROP TABLE #tempPool
DROP TABLE #tempBank
DROP TABLE #tempQuestions

COMMIT TRANSACTION
END TRY
BEGIN CATCH
PRINT 'ERROR....ERROR.....ERROR....'
PRINT ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
end
