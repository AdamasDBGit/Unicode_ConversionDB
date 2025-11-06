
CREATE PROCEDURE [dbo].[uspGetNonFeeComponent]
AS 
    BEGIN    
		SELECT 
				A.I_Status_Id, 
                A.S_Status_Type ,               
                A.S_Status_Desc S_Component_Name ,
                A.I_Status_Value ,
                A.I_Brand_ID,
                A.S_Status_Desc_SMS
        FROM    dbo.T_Status_Master A
               
        ORDER BY S_Component_Name    
    
    END
