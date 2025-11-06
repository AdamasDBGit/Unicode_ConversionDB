-- =============================================
-- Author:		Swagata De
-- Create date: 31/01/2007
-- Description:	Modifies the Module Master Table
--exec uspModifyModule 0,1,2,'M001','Module Name','1,2,3,4,5,6,78','ram','','10/10/2004','',1
-- =============================================


CREATE PROCEDURE [dbo].[uspModifyModule] 
(
	@iModuleID int,
	@iBrandID int = null,
	@iModuleSkill int = null,
	@sModuleCode varchar(50) = null,
	@sModuleName varchar(250) = null,
	@sBookList varchar(1000) = null,
	@sCreatedBy varchar(20),	
	@dCreatedOn datetime,	
	@iFlag int
)

AS
BEGIN TRY
	SET NOCOUNT OFF;

--======================Start 4 Split=================
	DECLARE @TempList table
	(
		
		TLBookID int,
		TLModuleID int,
		TLAddBy varchar(20),
		TLAddOn datetime,
		TLValidFrom datetime,
		TLValidTo datetime,
		TLStatus int
	)

	DECLARE @iBookID varchar(10), @iPos int

	SET @sBookList = LTRIM(RTRIM(@sBookList))+ ','
	SET @iPos = CHARINDEX(',', @sBookList, 1)

	IF REPLACE(@sBookList, ',', '') <> ''
	BEGIN
		WHILE @iPos > 0
		BEGIN
			SET @iBookID = LTRIM(RTRIM(LEFT(@sBookList, @iPos - 1)))
			IF @iBookID <> ''
			BEGIN
				INSERT INTO @TempList (TLBookID) VALUES (CAST(@iBookID AS int)) --Use Appropriate conversion
			END
			SET @sBookList = RIGHT(@sBookList, LEN(@sBookList) - @iPos)
			SET @iPos = CHARINDEX(',', @sBookList, 1)

		END
	END	
--SELECT * FROM @TempList
--======================End 4 Split===================
	BEGIN TRAN T1
    IF @iFlag = 1
	BEGIN
			INSERT INTO dbo.T_Module_Master
			(	I_Skill_ID,
				I_Brand_ID, 
				S_Module_Code, 
				S_Module_Name, 
				S_Crtd_By,
				Dt_Crtd_On,
				I_Status	)
			VALUES
			(	@iModuleSkill,
				@iBrandID,
				@sModuleCode,
				@sModuleName,
				@sCreatedBy,
				@dCreatedOn,
				1	)    
			
			SET @iModuleID = @@IDENTITY
			
			UPDATE @TempList 
					SET TLModuleID = @iModuleID,
					TLAddBy=@sCreatedBy,
					TLAddOn=@dCreatedOn,
					TLValidFrom=@dCreatedOn,
					TLValidTo=null,
					TLStatus=1
			INSERT INTO T_Module_Book_Map(I_Book_ID,I_Module_ID,S_Crtd_By,Dt_Crtd_On,Dt_Valid_From,Dt_Valid_To,I_Status)
				SELECT * FROM @TempList
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Module_Master
		SET I_Skill_ID = @iModuleSkill,
		I_Brand_ID = @iBrandID,
		S_Module_Code = @sModuleCode,
		S_Module_Name = @sModuleName,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dCreatedOn
		where I_Module_ID = @iModuleID
		
		UPDATE dbo.T_Module_Book_Map
		SET  I_Status=0,
		Dt_Valid_To=@dCreatedOn,
		S_Upd_By=@sCreatedBy,
		Dt_Upd_On=@dCreatedOn
		WHERE I_Module_ID=@iModuleID
		
		UPDATE @TempList
		 SET TLModuleID=@iModuleID,
			TLAddBy=@sCreatedBy,
			TLAddOn=@dCreatedOn,
			TLValidFrom=@dCreatedOn,
			TLValidTo=null,
			TLStatus=1

		INSERT INTO T_Module_Book_Map(I_Book_ID,I_Module_ID,S_Crtd_By,Dt_Crtd_On,Dt_Valid_From,Dt_Valid_To,I_Status)
				SELECT *
					FROM @TempList

	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Module_Master
		SET I_Status = 0,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dCreatedOn
		where I_Module_ID = @iModuleID

		UPDATE dbo.T_Module_Book_Map
		SET  I_Status=0,
		Dt_Valid_To=@dCreatedOn,
		S_Upd_By=@sCreatedBy,
		Dt_Upd_On=@dCreatedOn
		WHERE I_Module_ID=@iModuleID
	END
	
		SELECT @iModuleID AS ModuleID
	COMMIT TRAN T1
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
