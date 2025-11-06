-- =====================================================================================  
-- Author:  Sayan Basu  
-- Created On:  07/01/2009  
-- Description: Gets the List of infrastructure update requests for a particular center  
-- =====================================================================================  
  
--[NETWORK].[uspGetInfrastructureRequestForCenter] 13  
  
CREATE PROCEDURE [NETWORK].[uspGetInfrastructureRequestForCenter] ( @iCenterId INT )  
AS   
    BEGIN  
   
        CREATE TABLE #Temp  
            (  
              Id INT,  
              RequestType VARCHAR(50)  
            )  
        DECLARE @iStatus INT  
   
  
 ---checking for new center sign up request  
  
        IF EXISTS(SELECT  'true' FROM dbo.T_Centre_Master WHERE   I_Centre_Id = @iCenterId AND I_Status=5)   
            BEGIN  
                INSERT  INTO #Temp  
                VALUES  ( 1, 'New Center Sign Up' )   
            END  
             
    
 ---checking for center upgrade request  
 IF EXISTS(SELECT  'true' FROM  NETWORK.T_Upgrade_Request WHERE   I_Centre_Id = @iCenterId AND I_Status=1 AND I_Is_Upgrade=1 )   
          BEGIN  
                INSERT  INTO #Temp  
                VALUES  ( 2, 'Center Upgrade' )   
    
            END  
   
 ---checking for center location transfer request  
   IF EXISTS(SELECT  'true' FROM  NETWORK.T_AddressChange_Request WHERE   I_Centre_Id = @iCenterId AND I_Status=2)     
           BEGIN  
                INSERT  INTO #Temp  
                VALUES  ( 3,'Change In Location')   
            END  
   
 ---checking for center resurrection request  
 IF EXISTS(SELECT  'true' FROM  NETWORK.T_Resurrection_Request WHERE   I_Centre_Id = @iCenterId AND I_Status=3)   
           BEGIN  
                INSERT  INTO #Temp  
                VALUES  (4,'Center Resurrection')  
            END              
      
 ---returning the temp table populated with infrastructure update requests  
        BEGIN  
            SELECT  *  
            FROM    #Temp  
            ORDER BY Id  
        END  
        DROP TABLE #Temp  
    END
