
CREATE PROCEDURE [dbo].[uspGetAllFacultyByBrand_BKP_BeforeDynamic]

AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT TED.[I_Employee_ID] EmployeeID
      
      ,ISNULL(TED.[S_First_Name],'') +' '+ ISNULL(TED.[S_Middle_Name],'') +' '+ ISNULL(TED.[S_Last_Name],'')+' ('+TUM.S_Login_ID+')' AS EmployeeName
	  
      
  FROM [dbo].[T_Employee_Dtls] TED inner join T_User_Master TUM 
  ON TED.I_Employee_ID = TUM.I_Reference_ID 
  inner join T_User_Role_Details TRD ON TRD.I_User_ID = TUM.I_User_ID 
  inner join T_Role_Master TRM ON TRM.I_Role_ID = TRD.I_Role_ID
  where TRM.S_Role_Code = 'FAC' AND TUM.S_User_Type ='CE' AND TUM.I_Status = '1' AND TRD.I_Status = '1'
	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
