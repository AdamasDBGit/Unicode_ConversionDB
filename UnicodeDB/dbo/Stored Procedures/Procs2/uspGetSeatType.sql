CREATE PROCEDURE [dbo].[uspGetSeatType]     
   
    
AS    
BEGIN    
    
 SELECT I_Seat_Type_ID, S_Seat_Type,S_Crtd_By,S_Updt_By,Dt_Crtd_On,Dt_Updt_On,I_Status    
 FROM dbo.T_Seat_Type_Master    
 WHERE I_Status <> 0    
 ORDER BY S_Seat_Type    
    
END
