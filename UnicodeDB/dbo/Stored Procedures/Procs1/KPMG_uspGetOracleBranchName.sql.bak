
CREATE PROCEDURE [dbo].[KPMG_uspGetOracleBranchName]  
@BranchMame NVARCHAR(255)
AS   
    BEGIN TRY 
    		   
        SELECT  CM.I_Centre_Id as Centre_Id, 
				TBR.fld_kpmg_OracleBranchName as BranchName				
        FROM    T_Centre_Master CM  
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details CD ON CM.I_Centre_Id = CD.I_Center_ID   
                INNER JOIN Tbl_KPMG_BranchConfiguration TBR ON CD.S_Center_Name=TBR.fld_kpmg_BranchName
                and CD.S_Center_Name=   @BranchMame            
        WHERE   CD.I_Brand_ID = '109'
        
    END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
