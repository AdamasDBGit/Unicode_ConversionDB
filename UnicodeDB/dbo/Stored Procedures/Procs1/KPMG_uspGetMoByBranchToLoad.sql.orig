
CREATE PROCEDURE [dbo].[KPMG_uspGetMoByBranchToLoad]
@CenterName NVARCHAR(255),
@Context VARCHAR(255)
AS
BEGIN Try
	DECLARE @idBranch INT
		
	If((@CenterName IS NOT null)OR (@CenterName <> ''))		
	Select @idBranch =	CM.I_Centre_Id		
    FROM    T_Centre_Master CM  
            INNER JOIN dbo.T_Center_Hierarchy_Name_Details CD ON CM.I_Centre_Id = CD.I_Center_ID                  
    WHERE   CD.I_Brand_ID = '109' AND CM.S_Center_Name = @CenterName

       
	Select Fld_KPMG_Mo_Id as MoveOrderId, @idBranch as BranchId from dbo.Tbl_KPMG_MoMaster where
	Fld_KPMG_Status=0 AND Fld_KPMG_Branch_Id=@idBranch AND Fld_KPMG_Context = @Context
	AND ISNULL(Fld_KPMG_GrnNumber,0) > 0
		
	
	END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
