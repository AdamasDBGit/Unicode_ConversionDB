CREATE PROCEDURE [dbo].[uspGetTaskDetails] 
(
    @S_TUM_Login_ID VARCHAR(200)
	
)

AS
BEGIN 
			SELECT	 S_UST_Task_Details,
					 Dt_UST_Date_Initiated,  
					 S_UST_Task_Type
	
			
		    FROM 	 dbo.T_User_Task TUT,
					 dbo.T_User_Master TUM
						
				 
		   WHERE	 TUM.S_TUM_Login_ID = @S_TUM_Login_ID
		   AND		 TUM.I_TUM_User_ID	= TUT.I_UST_To_User_ID
		
END
