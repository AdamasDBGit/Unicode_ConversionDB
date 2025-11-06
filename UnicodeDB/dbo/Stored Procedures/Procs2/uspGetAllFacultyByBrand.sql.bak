CREATE PROCEDURE [dbo].[uspGetAllFacultyByBrand]
(
@iBrandID INT = 107
)
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
  ---Added by Susmita : 2023August11 --
  inner join dbo.[T_Center_Hierarchy_Name_Details] CHND ON CHND.I_Center_ID = TED.I_Centre_Id
  inner join T_Brand_Center_Details as BCD on BCD.I_Centre_Id=CHND.I_Center_ID
  inner join T_Brand_Master as BM on BM.I_Brand_ID=BCD.I_Brand_ID
  -- ------------------------------ ---
  where TRM.S_Role_Code = 'FAC' AND TUM.S_User_Type ='CE' AND TUM.I_Status = '1' AND TRD.I_Status = '1'
  and BCD.I_Brand_ID=@iBrandID
	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
