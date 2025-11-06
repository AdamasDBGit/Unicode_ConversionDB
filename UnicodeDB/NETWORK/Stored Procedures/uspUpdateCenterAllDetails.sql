CREATE PROCEDURE [NETWORK].[uspUpdateCenterAllDetails]    
 @iCenterID int,     
 @iAgreementID int,    
 @sCenterCode varchar(20) = null,    
 @sSAPCustomerId varchar (20) =null,    
 @sCenterName varchar(100),    
 @sShortName varchar(50),    
 @iCategory int,    
 @iRFFType int,    
 @sAddress1 varchar(100),    
 @sAddress2 varchar(100) =null,    
 @iCityID int,    
 @iStateID int,    
 @iCountryID int,    
 @sPinCode varchar(10),    
 @sPhoneNumber varchar(20),    
 @sEmail varchar(50),    
 @sDelAddress1 varchar(100),    
 @sDelAddress2 varchar(100) =null,    
 @iDelCityID int,    
 @iDelStateID int,    
 @iDelCountryID int,    
 @sDelPinCode varchar(10),    
 @sDelPhoneNumber varchar(20),    
 @sDelEmail varchar(50),    
 @iStartUpInPlace bit = null,    
 @iLibraryInPlace bit = null,    
 @sCreatedBy varchar(20),    
 @dtCreatedDt Datetime,    
 @iStatus int,    
 @iFlag int,    
 @sCharges xml,    
 @iIsOwnCenter int,    
 @sSTRegNo varchar(20),    
 @dtExpiryDt Datetime=null,  
 @bIsCenterServiceTaxRequired BIT = FALSE,
 @sCostCenter varchar(10)  
AS    
BEGIN    
 DECLARE @iBrandID INT    
  print @sCenterCode  
--  for insert    
 IF (@iFlag = 1)    
  BEGIN    
   INSERT INTO dbo.T_Centre_Master    
      (S_Center_Name,    
    s_center_code,   
 s_center_short_name,  
    S_SAP_Customer_Id,    
    I_Center_Category,    
    I_RFF_Type,    
    I_Country_ID,    
    S_Crtd_By,    
    Dt_Crtd_On,    
    Dt_Valid_From,    
    I_Status,    
    I_Is_OwnCenter,  
    I_Is_Center_Serv_Tax_Reqd,  
    S_ServiceTax_Regd_Code,    
    Dt_Valid_To,
    S_cost_Center)    
   VALUES    
   (@sCenterName,@sCenterCode,@sShortName,@sSAPCustomerId,@iCategory,    
   @iRFFType,@iCountryID,@sCreatedBy,@dtCreatedDt,@dtCreatedDt,@iStatus,    
   @iIsOwnCenter,@bIsCenterServiceTaxRequired,@sSTRegNo,@dtExpiryDt,@sCostCenter)    
    
   SELECT @iCenterID=SCOPE_IDENTITY()    
    
   INSERT INTO NETWORK.T_Center_Address    
      (I_Centre_Id,    
    S_Center_Address1,    
    S_Center_Address2,    
    I_City_ID,    
    I_State_ID,    
    S_Pin_Code,    
    I_Country_ID,    
    S_Telephone_No,    
    S_Email_ID,    
    S_Delivery_Address1,    
    S_Delivery_Address2,    
    I_Delivery_City_ID,    
    I_Delivery_State_ID,    
    S_Delivery_Pin_No,    
    I_Delivery_Country_ID,    
    S_Delivery_Phone_No,    
    S_Delivery_Email_ID)    
   VALUES    
      (@iCenterID,@sAddress1,@sAddress2,@iCityID,    
    @iStateID,@sPinCode,@iCountryID,@sPhoneNumber,@sEmail,    
    @sDelAddress1,@sDelAddress2,@iDelCityID,    
    @iDelStateID,@sDelPinCode,@iDelCountryID,@sDelPhoneNumber,     
    @sDelEmail)    
    
   INSERT INTO NETWORK.T_Agreement_Center    
    (I_Agreement_ID,I_Centre_Id)    
   VALUES    
    (@iAgreementID,@iCenterID)    
        
   SELECT @iBrandID = I_Brand_ID     
   FROM NETWORK.T_Agreement_Details    
   WHERE I_Agreement_ID = @iAgreementID    
    
   INSERT INTO dbo.T_Brand_Center_Details    
   (I_Centre_Id,I_Brand_ID,S_Crtd_By,Dt_Crtd_On,    
    Dt_Valid_From,I_Status)    
   VALUES    
   (@iCenterID,@iBrandID,@sCreatedBy,@dtCreatedDt,    
    @dtCreatedDt,1)    
    
    
  END    
--  for update    
 IF (@iFlag = 2)    
  BEGIN    
   INSERT INTO NETWORK.T_Center_Master_Audit      
   SELECT * FROM dbo.T_Centre_Master    
    WHERE I_Centre_Id = @iCenterID    
    
   UPDATE dbo.T_Centre_Master    
   SET     
    S_Center_Name = @sCenterName,    
    S_SAP_Customer_Id= @sSAPCustomerId,    
    s_center_short_name=@sShortName,  
    s_center_code = @sCenterCode,    
    I_Center_Category = @iCategory,    
    I_RFF_Type = @iRFFType,    
    I_Country_ID = @iCountryID,    
    S_Upd_By = @sCreatedBy,    
    Dt_Upd_On = @dtCreatedDt,    
    I_Is_Startup_Material_In_Place = @iStartUpInPlace,    
    I_Is_Library_In_Place = @iLibraryInPlace,    
    I_Status = @iStatus,    
    I_Is_OwnCenter = @iIsOwnCenter,  
    I_Is_Center_Serv_Tax_Reqd = @bIsCenterServiceTaxRequired,  
    S_ServiceTax_Regd_Code = @sSTRegNo,    
    Dt_Valid_To=@dtExpiryDt,
    S_Cost_Center = @sCostCenter    
   WHERE I_Centre_Id = @iCenterID    
    
   UPDATE NETWORK.T_Center_Address    
   SET S_Center_Address1 = @sAddress1,    
    S_Center_Address2 = @sAddress2,    
    I_City_ID = @iCityID,    
    I_State_ID = @iStateID,    
    S_Pin_Code = @sPinCode,    
    I_Country_ID = @iCountryID,    
    S_Telephone_No = @sPhoneNumber,    
    S_Email_ID = @sEmail,    
    S_Delivery_Address1 = @sDelAddress1,    
    S_Delivery_Address2 = @sDelAddress2,    
    I_Delivery_City_ID = @iDelCityID,    
    I_Delivery_State_ID = @iDelStateID,    
    S_Delivery_Pin_No = @sDelPinCode,    
    I_Delivery_Country_ID = @iDelCountryID,    
    S_Delivery_Phone_No = @sDelPhoneNumber,    
    S_Delivery_Email_ID = @sDelEmail    
   WHERE I_Centre_Id = @iCenterID    
    
   UPDATE NETWORK.T_Agreement_Center    
   SET I_Agreement_ID = @iAgreementID    
    WHERE I_Centre_Id = @iCenterID      
       
   UPDATE dbo.T_Hierarchy_Details    
   SET S_Hierarchy_Name=@sCenterName,I_Status=@iStatus    
   WHERE I_Hierarchy_Detail_ID in     
   (SELECT I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE i_center_id=@iCenterID)    
   
   UPDATE dbo.T_Center_Hierarchy_Details
   SET I_Status=@iStatus
   WHERE I_Center_Id=@iCenterID
   
   UPDATE dbo.T_Brand_Center_Details
   SET I_Status=@iStatus
   WHERE I_Centre_Id=@iCenterID
   
   UPDATE dbo.T_User_Hierarchy_Details
   SET I_Status=@iStatus
   WHERE I_Hierarchy_Detail_ID IN(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE i_center_id=@iCenterID) 
  
   
  END    
    
--  for delete    
 IF (@iFlag = 3)    
  BEGIN    
   INSERT INTO NETWORK.T_Center_Master_Audit      
   SELECT * FROM dbo.T_Centre_Master    
    WHERE I_Centre_Id = @iCenterID    
    
   UPDATE dbo.T_Centre_Master    
   SET I_Status = @iStatus,    
    S_Upd_By = @sCreatedBy,    
    Dt_Upd_On = @dtCreatedDt,    
    Dt_Valid_To = @dtExpiryDt    
   WHERE I_Centre_Id = @iCenterID     
  END    
    
    
 CREATE TABLE #tempTable     
 (    
  I_Center_Periodic_Charges_ID INT,    
  I_Payment_Charges_ID INT,    
  I_Currency_ID INT,    
  Dt_From_Date datetime,    
  Dt_To_Date datetime,    
  Dt_Due_Date datetime,    
  I_Total_Amount decimal(18,2),    
  I_Transfer_To_SAP bit,    
  Mode int    
 )    
    
 INSERT INTO #tempTable    
 SELECT T.c.value('@PeriodicChargesID','int'),    
   T.c.value('@PaymentChargeID','int'),    
   T.c.value('@CurrencyID','int'),       
   T.c.value('@FromDate','datetime'),    
   T.c.value('@ToDate','datetime'),    
   T.c.value('@DueDate','datetime'),    
   T.c.value('@TotalAmount','decimal(18,2)'),    
   T.c.value('@TransferToSAP','bit'),    
   T.c.value('@Mode','int')    
 FROM   @sCharges.nodes('/Element/PeriodicCharges/Node') T(c)    
    
    
    
-- Insert the values of Periodic Charges to table    
 INSERT INTO NETWORK.T_Center_Periodic_Charges    
 (I_Centre_Id,I_Payment_Charges_ID,I_Currency_ID,Dt_From_Date,    
 Dt_To_Date,Dt_Due_Date,I_Total_Amount,I_Transfer_To_SAP,    
 I_Status,S_Crtd_By,Dt_Crtd_On    
 )    
 SELECT @iCenterID,I_Payment_Charges_ID,I_Currency_ID,Dt_From_Date,    
   Dt_To_Date,Dt_Due_Date,I_Total_Amount,I_Transfer_To_SAP,    
   1,@sCreatedBy,@dtCreatedDt    
 FROM #tempTable WHERE Mode = 1    
    
-- Delete rows from the Periodic Charges table    
 UPDATE NETWORK.T_Center_Periodic_Charges    
  SET I_Status = 0,    
   S_Upd_By = @sCreatedBy,    
   Dt_Upd_On = @dtCreatedDt    
 WHERE I_Center_Periodic_Charges_ID IN    
  (SELECT I_Center_Periodic_Charges_ID FROM #tempTable    
   WHERE Mode = 3)    
    
--  Update periodic charges table    
 UPDATE NETWORK.T_Center_Periodic_Charges    
  SET NETWORK.T_Center_Periodic_Charges.Dt_From_Date = B.Dt_From_Date,    
   NETWORK.T_Center_Periodic_Charges.I_Payment_Charges_ID = B.I_Payment_Charges_ID,    
   NETWORK.T_Center_Periodic_Charges.I_Currency_ID = B.I_Currency_ID,       
   NETWORK.T_Center_Periodic_Charges.Dt_To_Date = B.Dt_To_Date,    
   NETWORK.T_Center_Periodic_Charges.Dt_Due_Date = B.Dt_Due_Date,    
   NETWORK.T_Center_Periodic_Charges.I_Total_Amount = B.I_Total_Amount,    
   NETWORK.T_Center_Periodic_Charges.I_Transfer_To_SAP = B.I_Transfer_To_SAP,    
   NETWORK.T_Center_Periodic_Charges.S_Upd_By = @sCreatedBy,    
   NETWORK.T_Center_Periodic_Charges.Dt_Upd_On = @dtCreatedDt    
 FROM #tempTable B    
 WHERE NETWORK.T_Center_Periodic_Charges.I_Center_Periodic_Charges_ID = B.I_Center_Periodic_Charges_ID    
  AND NETWORK.T_Center_Periodic_Charges.I_Status <> 0     
  AND B.Mode = 2    
    
    
-- return the CenterID    
 SELECT  @iCenterID AS I_Center_ID    
 DROP TABLE #tempTable    
     
END
