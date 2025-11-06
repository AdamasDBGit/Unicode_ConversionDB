/*****************************************************************************************************************          
Created by: Utpal    
Date: 18/08/2011        
Description: Insert/Update Video Content  Details           
Parameters:           
Returns:           
Modified By:           
******************************************************************************************************************/                
CREATE PROCEDURE [dbo].[uspInsertUserVideoContentDtl]        
(        
 @iBatchContentDetailsID int,        
 @dtExpiryDate DATETIME,        
 @sCreatedBy Varchar(50),        
 @dtCreatedOn DATETIME,  
 @sUpdatedBy VARCHAR(50) ,
 @dtUpdatedOn DATETIME,
 @iUserID INT,    
 @iBrandID INT      
)        
AS        
BEGIN         
  
  DECLARE @iContentID INT
  
     IF EXISTS( SELECT tced.I_Content_Emp_Dtl_ID,tced.I_Batch_Content_Details_ID,tced.I_User_ID FROM dbo.T_Content_Employee_Dtl AS tced
                WHERE tced.I_Batch_Content_Details_ID = @iBatchContentDetailsID AND  tced.I_User_ID = @iUserID)
        BEGIN
        
        	SELECT @iContentID = tced.I_Content_Emp_Dtl_ID FROM dbo.T_Content_Employee_Dtl AS tced
        	WHERE tced.I_Batch_Content_Details_ID = @iBatchContentDetailsID AND  tced.I_User_ID = @iUserID
        	
        	 UPDATE dbo.T_Content_Employee_Dtl
        	 SET Dt_Expiry_Date =  @dtExpiryDate, S_Upd_By = @sUpdatedBy,Dt_Upd_On = @dtUpdatedOn
        	 WHERE I_Content_Emp_Dtl_ID = @iContentID AND I_Status_Id = 1
		END
     ELSE
          BEGIN
          		INSERT INTO dbo.T_Content_Employee_Dtl
				( 
				  I_Batch_Content_Details_ID ,
				  I_Brand_ID ,
				  I_User_ID ,
				  Dt_Expiry_Date ,
				  I_Status_Id ,
				  S_Crtd_By ,
				  S_Upd_By ,
				  Dt_Crtd_On ,
				  Dt_Upd_On
				)
			  VALUES  
			  ( 
				  @iBatchContentDetailsID , -- I_Batch_Content_Details_ID - int
				  @iBrandID , -- I_Brand_ID - int
				  @iUserID , -- I_User_ID - int
				  @dtExpiryDate , -- Dt_Expiry_Date - datetime
				  1 , -- I_Status_Id - int
				  @sCreatedBy , -- S_Crtd_By - varchar(50)
				  NULL , -- S_Upd_By - varchar(50)
				  @dtCreatedOn , -- Dt_Crtd_On - datetime
				  NULL  -- Dt_Upd_On - datetime
				)  
	    
			 SELECT @@IDENTITY        

          END    
    
  
     
      
  
END
