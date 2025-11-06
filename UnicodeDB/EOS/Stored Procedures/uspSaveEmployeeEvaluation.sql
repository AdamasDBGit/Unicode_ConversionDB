/**************************************************************************************************************
Created by  : Swagata De
Date		: 22.06.2007
Description : This SP will save the employee KRA evaluation
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveEmployeeEvaluation]
(	
 @iEmployeeID INT,
 @sEvaluations XML,
 @sCreatedBy VARCHAR(20),
 @sUpdatedBy VARCHAR(20),
 @dtCreatedOn DATETIME,
 @dtUpdatedOn DATETIME 
)
	
AS
BEGIN TRY
	--	Create Temporary Table to store KRA details
	CREATE TABLE #tempTable
	( 
		I_Employee_ID int,           
		I_KRA_ID int,
		I_SubKRA_Id int,
		N_Weightage numeric(18,2)		
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable(I_KRA_ID,I_SubKRA_Id,N_Weightage)
	SELECT T.c.value('@KRAID','int'),
		   T.c.value('@SubKRAID','int')	,
		   T.c.value('@Weightage','numeric(18,2)')		
	FROM   @sEvaluations.nodes('/KRAEvalList/KRAEvalElement') T(c)
	
	UPDATE  #tempTable
	SET  I_Employee_ID=@iEmployeeID
	
	UPDATE #tempTable
	SET I_SubKRA_Id = NULL
	WHERE I_SubKRA_Id=0
	
	--Delete the existing employee KRA Mapping	
	DELETE FROM EOS.T_Employee_KRA_Map WHERE I_Employee_ID=@iEmployeeID
	
	--Insert the new Employee KRA info into the table
	
	INSERT INTO EOS.T_Employee_KRA_Map
	(
		I_KRA_ID,
		I_Employee_ID,
		N_Weightage,
		I_SubKRA_Id,
		I_Status
	)	
	SELECT I_KRA_ID,I_Employee_ID,N_Weightage,I_SubKRA_Id,1
	FROM #tempTable
	
	UPDATE EOS.T_Employee_KRA_Map
	SET S_Crtd_By = @sCreatedBy,Dt_Crtd_On = @dtCreatedOn
	WHERE I_Employee_ID = @iEmployeeID
	
	
END TRY
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
