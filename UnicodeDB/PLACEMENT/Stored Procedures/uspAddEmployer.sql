/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Insert Employer record in T_Employer_Detail table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspAddEmployer]
(
-- Input params

	    @iStateID             int = NULL,
        @iNatureofBusiness int = NULL,
        @iCountryID         int = NULL,
        @iCityID            int ,
        @sCompanyCode       varchar(50) ,
        @sCompanyName       varchar(250),
        @DtFirstEnquiryDate datetime,
        @sGroupCompanyCode varchar(50) = NULL,
        @sAddress            varchar(200) = NULL,
        @sPincode            varchar(50) = NULL,
        @iStatus			 int,
        @sCrtdBy            varchar(20) = NULL,
        @DtCrtdOn           DATETIME,
        @sGroupCompanyTurnOver VARCHAR(MAX)=NULL,
        @sMCAList varchar(6)=NULL,
        @sPhNo VARCHAR(20)=NULL,
        @sMobNo VARCHAR(20)=NULL

        
) 
AS
BEGIN TRY
      
	  DECLARE  @iEmployerID int 
	SET @iEmployerID = 0
	
	IF (@sMCAList='0')
	BEGIN
		SET @sMCAList='YES'
	END
	ELSE IF (@sMCAList='1')
	BEGIN
	SET @sMCAList='NO'
	END

 IF NOT EXISTS(SELECT S_Company_Name FROM PLACEMENT.T_Employer_Detail WHERE S_Company_Name = @sCompanyName) 

 BEGIN
		
	INSERT INTO PLACEMENT.T_Employer_Detail
			(
			   I_State_ID,
		       I_Nature_of_Business,
		       I_Country_ID,
		       I_City_ID,
		       --S_Company_Code,
		       S_Company_Name,
		       Dt_First_Enquiry_Date,
		       S_Group_Company_Code,
		       S_Address,
		       S_Pincode,
			   I_Status,	
		       S_Crtd_By, 
			   Dt_Crtd_On,
			   S_GroupCompanyTurnOver,
			   S_MCAList,
			   S_Phone_No,
			   S_Mobile_No
		
		   )
		VALUES(	
			 	@iStateID ,
		        @iNatureofBusiness,
		        @iCountryID,
		        @iCityID,
		        --@sCompanyCode,
		        @sCompanyName,
		        @DtFirstEnquiryDate,
		        @sGroupCompanyCode,
		        @sAddress,
		        @sPincode,
				1,
		        @sCrtdBy,
		        @DtCrtdOn,
		        @sGroupCompanyTurnOver	,
		        @sMCAList,
		        @sPhNo,
		        @sMobNo
		    )   
			

-- Get the insert employer id
			SET @iEmployerID=SCOPE_IDENTITY()
			UPDATE PLACEMENT.T_Employer_Detail SET S_Company_Code='C'+CAST(@iEmployerID AS VARCHAR) WHERE I_Employer_ID=@iEmployerID;

END
		
			SELECT @iEmployerID
			

						
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
