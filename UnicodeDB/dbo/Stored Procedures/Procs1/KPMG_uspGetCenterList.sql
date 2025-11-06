
CREATE PROCEDURE [dbo].[KPMG_uspGetCenterList]  
AS   
    BEGIN TRY 
    		   
        SELECT  CM.I_Centre_Id as Centre_Id, 
				CM.S_Center_Name as CenterName				
        FROM    T_Centre_Master CM  
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details CD ON CM.I_Centre_Id = CD.I_Center_ID   
                INNER JOIN Tbl_KPMG_BranchConfiguration TBR ON CD.S_Center_Name=TBR.fld_kpmg_BranchName               
        WHERE   CD.I_Brand_ID = '109'
        
    END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg Nnvarchar(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
