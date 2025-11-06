CREATE PROCEDURE [dbo].[uspGetFeeComponent]  
AS   
    BEGIN      
  SELECT  I_Fee_Component_ID ,  
                A.I_Fee_Component_Type_ID ,  
                TFCT.S_Fee_Component_Type_Name ,  
                S_Component_Code ,  
                S_Component_Name ,  
                A.I_Status ,  
                A.S_Crtd_By ,  
                A.S_Upd_By ,  
                A.Dt_Crtd_On ,  
                A.Dt_Upd_On,  
                I_Brand_ID  
        FROM    dbo.T_Fee_Component_Master A  
                INNER JOIN dbo.T_Fee_Component_Type AS TFCT 
				ON A.I_Fee_Component_Type_ID = TFCT.I_Fee_Component_Type_ID  
        WHERE   A.I_Status <> 0  
        ORDER BY A.I_Fee_Component_ID, a.S_Component_Code ,  
                S_Component_Name      
      
    END
