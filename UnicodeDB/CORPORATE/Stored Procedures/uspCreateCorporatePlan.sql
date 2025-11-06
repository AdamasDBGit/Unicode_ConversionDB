CREATE PROCEDURE [CORPORATE].[uspCreateCorporatePlan]        
( 
 @iCorporatePlanID INT,        
 @sCorporatePlanName VARCHAR(200),        
 @iCorporateID INT,        
 @dtValidFrom DATETIME,        
 @dtValidTo DATETIME,        
 @bIsFundShared BIT,      
 @iCorpPlanTypeID INT,        
 @iMinStrength INT,       
 @iMaxStrength INT,        
 @nPercentStudentShare DECIMAL(18,2),       
 @FeePlanIdXML XML,      
 @sCrtdBy VARCHAR(20) ,  
 @sUpdatedBy VARCHAR(20) ,  
 @IsCertificateEligible BIT       
)        
AS    
 
    
BEGIN TRY     

  DECLARE @iCorpPlanID INT,@handle INT      
   
IF @iCorporatePlanID IS NULL
BEGIN  
	
	       
	 INSERT INTO CORPORATE.T_Corporate_Plan      
			 ( S_Corporate_Plan_Name ,      
			   I_Corporate_ID ,      
			   Dt_Valid_From ,      
			   Dt_Valid_To ,      
			   B_Is_Fund_Shared ,      
			   I_Corporate_Plan_Type_ID ,      
			   I_Minimum_Strength ,      
			   I_Maximum_Strength ,      
			   N_Percent_Student_Share ,      
			   I_Status ,      
			   S_Crtd_By ,      
			   Dt_Crtd_On ,  
			   IsCertificate_Eligible     
			 )      
	 VALUES  ( @sCorporatePlanName , -- S_Corporate_Plan_Name - varchar(200)      
			   @iCorporateID , -- I_Corporate_ID - int      
			   @dtValidFrom , -- Dt_Valid_From - datetime      
			   @dtValidTo , -- Dt_Valid_To - datetime      
			   @bIsFundShared , -- B_Is_Fund_Shared - bit      
			   @iCorpPlanTypeID , -- I_Corporate_Plan_Type_ID - int      
			   @iMinStrength , -- I_Minimum_Strength - int      
			   @iMaxStrength , -- I_Maximum_Strength - int      
			   @nPercentStudentShare , -- N_Percent_Student_Share - decimal      
			   1 , -- I_Status - int      
			   @sCrtdBy , -- S_Crtd_By - varchar(20)      
			   GETDATE() ,  -- Dt_Crtd_On - datetime      
			   @IsCertificateEligible  
			  )      
	          
	SELECT @iCorpPlanID = SCOPE_IDENTITY()        
	    
	IF(@iCorpPlanID > 0 AND @FeePlanIdXML IS NOT NULL)        
	BEGIN        
	 EXEC sp_xml_preparedocument @handle OUTPUT, @FeePlanIdXML      
	       
	 --INSERT INTO CORPORATE.T_Corporate_Plan_Batch_Map      
	 --        ( I_Corporate_Plan_ID, I_Batch_ID )      
	 --SELECT @iCorpPlanID AS I_Corporate_Plan_ID,BatchID AS I_Batch_ID         
	 --FROM OPENXML(@handle,'/Root/FeePlan',2) WITH        
	 --(        
	 -- BatchID INT        
	 --)        
	      
	  INSERT INTO [CORPORATE].T_CorporatePlan_FeePlan_Map       
	  ( I_Corporate_Plan_ID , I_Course_Fee_Plan_ID)    
	      
	  SELECT @iCorpPlanID AS I_Corporate_Plan_ID,FeePlanID AS I_Course_Fee_Plan_ID         
	  FROM OPENXML(@handle,'/Root/FeePlan',2) WITH        
	  (        
	   FeePlanID INT        
	  )       
	     
	 EXEC sp_xml_removedocument @handle       
 
 END
   
 END 
 ELSE
 BEGIN
 
 UPDATE CORPORATE.T_Corporate_Plan
 SET S_Corporate_Plan_Name = @sCorporatePlanName,
     I_Corporate_ID = @iCorporateID,
     Dt_Valid_From = @dtValidFrom,
     Dt_Valid_To = @dtValidTo,
     B_Is_Fund_Shared = @bIsFundShared,
     I_Corporate_Plan_Type_ID = @iCorpPlanTypeID,
     I_Minimum_Strength = @iMinStrength,
     I_Maximum_Strength =  	@iMaxStrength,
     N_Percent_Student_Share = @nPercentStudentShare,
     I_Status = 1,
     IsCertificate_Eligible = @IsCertificateEligible,
     S_Updt_by = @sUpdatedBy,
     Dt_Updt_On = GETDATE()
     
     WHERE I_Corporate_Plan_ID = @iCorporatePlanID
     
     
     DELETE FROM [CORPORATE].T_CorporatePlan_FeePlan_Map       
     WHERE I_Corporate_Plan_ID = @iCorporatePlanID
     
     IF(@iCorporatePlanID > 0 AND @FeePlanIdXML IS NOT NULL)        
	BEGIN        
	 EXEC sp_xml_preparedocument @handle OUTPUT, @FeePlanIdXML      
	       
	 --INSERT INTO CORPORATE.T_Corporate_Plan_Batch_Map      
	 --        ( I_Corporate_Plan_ID, I_Batch_ID )      
	 --SELECT @iCorpPlanID AS I_Corporate_Plan_ID,BatchID AS I_Batch_ID         
	 --FROM OPENXML(@handle,'/Root/FeePlan',2) WITH        
	 --(        
	 -- BatchID INT        
	 --)        
	      
	  INSERT INTO [CORPORATE].T_CorporatePlan_FeePlan_Map       
	  ( I_Corporate_Plan_ID , I_Course_Fee_Plan_ID)    
	      
	  SELECT @iCorporatePlanID AS I_Corporate_Plan_ID,FeePlanID AS I_Course_Fee_Plan_ID         
	  FROM OPENXML(@handle,'/Root/FeePlan',2) WITH        
	  (        
	   FeePlanID INT        
	  )       
	     
	 EXEC sp_xml_removedocument @handle       
	 
     
 END
 
END  
        
          
END TRY       
 
BEGIN CATCH        
 --Error occurred:          
        
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)        
END CATCH
