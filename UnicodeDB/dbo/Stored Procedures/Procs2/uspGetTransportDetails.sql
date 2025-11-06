CREATE PROCEDURE [dbo].[uspGetTransportDetails]  
AS   
    BEGIN TRY      
        SELECT  TTM.I_PickupPoint_ID ,  
                TTM.I_Brand_ID ,  
                S_PickupPoint_Name ,  
                N_Fees ,  
                TBRM.I_Route_ID ,  
                S_Route_No  
        FROM    dbo.T_Transport_Master AS TTM  
                LEFT OUTER JOIN dbo.T_Route_Transport_Map AS TRTM ON TTM.I_PickupPoint_ID = TRTM.I_PickupPoint_ID  
                LEFT OUTER JOIN dbo.T_BusRoute_Master AS TBRM ON TRTM.I_Route_ID = TBRM.I_Route_ID  
        WHERE   TTM.I_Status = 1  
                AND ( TRTM.I_Status = 1  
                      OR TRTM.I_Status IS NULL  
                    )  
                AND ( TBRM.I_Status = 1  
                      OR TBRM.I_Status IS NULL  
                    )  
     
    END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

