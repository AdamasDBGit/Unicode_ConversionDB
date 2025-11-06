
CREATE PROCEDURE [dbo].[KPMG_uspGetMoByBranch]
(		
	@CenterName NVARCHAR(max),
	@Context NVARCHAR(max) = 'DEFAULT_MO'
)
AS
	BEGIN Try
	DECLARE @idBranch INT
		
	If((@CenterName IS NOT null)OR (@CenterName <> ''))		
	Select @idBranch =	CM.I_Centre_Id		
	FROM    T_Centre_Master CM  
			INNER JOIN dbo.T_Center_Hierarchy_Name_Details CD ON CM.I_Centre_Id = CD.I_Center_ID                  
	WHERE   CD.I_Brand_ID = '109' AND CM.S_Center_Name = @CenterName

	IF ISNULL(@COntext,'DEFAULT_MO') = 'DEFAULT_MO'
	BEGIN
		Select Fld_KPMG_Mo_Id as MoveOrderId, @idBranch as BranchId from dbo.Tbl_KPMG_MoMaster
		where Fld_KPMG_Branch_Id = @idBranch AND Fld_KPMG_Status  =0 AND Fld_KPMG_Context = 'BRANCH_TO_CCT' AND ISNULL(Fld_KPMG_GrnNumber,0) > 0
	END
	ELSE IF  ISNULL(@COntext,'DEFAULT_MO') = 'REJECTED_MO'
	BEGIN
		Select Fld_KPMG_Mo_Id as MoveOrderId, @idBranch as BranchId from dbo.Tbl_KPMG_MoMaster
		where Fld_KPMG_Branch_Id = @idBranch AND Fld_KPMG_Status  =0 AND Fld_KPMG_Context = 'REV_MO' AND ISNULL(Fld_KPMG_GrnNumber,0) > 0
	END
	
	END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH


