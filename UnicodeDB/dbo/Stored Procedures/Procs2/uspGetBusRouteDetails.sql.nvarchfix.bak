CREATE PROCEDURE [dbo].[uspGetBusRouteDetails] ( @SRouteNo Nnvarchar(max) = NULL,@iBrandID INT )
AS 
    BEGIN    
        SET NOCOUNT ON  
   
        SELECT  A.I_Route_ID ,
                A.S_Route_No ,
                A.I_Brand_ID ,
                A.I_Status ,
                A.S_Crtd_by ,
                A.Dt_Crtd_On
        FROM    dbo.T_BusRoute_Master A
        WHERE   A.I_Status = 1
                AND A.S_Route_No LIKE ISNULL(@SRouteNo, '') + '%'   
                AND I_Brand_ID = @iBrandID
    END

