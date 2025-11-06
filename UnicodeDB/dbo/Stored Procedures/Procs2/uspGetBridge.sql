CREATE PROCEDURE [dbo].[uspGetBridge]   
AS  
BEGIN  
  
 SELECT B.I_Bridge_ID,
		B.S_Bridge_Code,
	    B.S_Bridge_Desc,
	    B.I_Brand_ID,
	    B.I_Status,
	    B.S_Crtd_By,
	    B.S_Upd_By,
	    B.Dt_Crtd_On,
	    B.Dt_Upd_On	  
 FROM dbo.T_Bridge_Master B WITH (NOLOCK)  
 INNER JOIN dbo.T_Brand_Master BM WITH (NOLOCK) 
 ON B.I_Brand_ID = BM.I_Brand_ID  
 ORDER BY I_Bridge_ID   
END  

-----------------------------------------------------------------------------------------------------------------------------------------
