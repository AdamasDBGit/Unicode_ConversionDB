/**************************************************************************************************************  
Created by  : Swagata De  
Date  : 01.05.2007  
Description : This SP save all Employee Details  
Parameters  :   
Returns     : Dataset  
**************************************************************************************************************/  
  
CREATE PROCEDURE [EOS].[uspCreateEmployeeDetails]
    (
      @sTitle VARCHAR(10) ,
      @iCenterID INT ,
      @sFirstName VARCHAR(50) ,
      @sMiddleName VARCHAR(50) ,
      @sLastName VARCHAR(50) ,
      @dtDOB DATETIME ,
      @sPhoneNumber VARCHAR(20) ,
      @sEmail VARCHAR(100) ,
      @iDocumentID INT = NULL ,
      @sAddress1 VARCHAR(200) ,
      @sAddress2 VARCHAR(200) = NULL ,
      @sArea VARCHAR(50) ,
      @iCityID INT ,
      @iStateID INT ,
      @iCountryID INT ,
      @sPinCode VARCHAR(20) ,
      @sAddressPhNo VARCHAR(50) ,
      @iAddressType INT ,
      @iStatus INT ,
      @sCreatedBy VARCHAR(20) ,
      @sUpdatedBy VARCHAR(20) ,
      @dtCreatedOn DATETIME ,
      @DtUpdatedOn DATETIME,
      @IsRoamingFaculty BIT = NULL,
      @iEmpNo INT,
	  @LeaveDay VARCHAR(MAX)=NULL
    )
AS 
    BEGIN TRY  
        DECLARE @iEmpID INT  
        INSERT  INTO dbo.T_Employee_Dtls
                ( S_Title ,
                  I_Centre_Id ,
                  S_First_Name ,
                  S_Middle_Name ,
                  S_Last_Name ,
                  Dt_DOB ,
                  S_Phone_No ,
                  S_Email_ID ,
                  Dt_Joining_Date ,
                  I_Document_ID ,
                  I_Status ,
                  S_Crtd_By ,
                  Dt_Crtd_On,
                  B_IsRoamingFaculty,
                  S_Emp_ID,
				  S_LeaveDay
                )
        VALUES  ( @sTitle ,
                  @iCenterID ,
                  @sFirstName ,
                  @sMiddleName ,
                  @sLastName ,
                  @dtDOB ,
                  @sPhoneNumber ,
                  @sEmail ,
                  @dtCreatedOn ,
                  @iDocumentID ,
                  @iStatus ,
                  @sCreatedBy ,
                  @dtCreatedOn,
                  @IsRoamingFaculty,
                  CAST(@iEmpNo AS VARCHAR) ,
				  @LeaveDay
                )  
        SET @iEmpID = ( SELECT  SCOPE_IDENTITY()
                      )  
   
        --UPDATE  dbo.T_Employee_Dtls
        --SET     S_Emp_ID = CONVERT(VARCHAR(20), @iEmpID)
        --WHERE   I_Employee_ID = @iEmpID  
   
        INSERT  INTO EOS.T_Employee_Address
                ( I_Employee_ID ,
                  I_Country_ID ,
                  I_State_ID ,
                  I_City_ID ,
                  S_District_Name ,
                  S_Address_Line1 ,
                  S_Address_Line2 ,
                  S_Zip_Code ,
                  S_Address_Phone_No ,
                  I_Address_Type ,
                  I_Status ,
                  S_Crtd_By ,
                  Dt_Crtd_On  
                )
        VALUES  ( @iEmpID ,
                  @iCountryID ,
                  @iStateID ,
                  @iCityID ,
                  @sArea ,
                  @sAddress1 ,
                  @sAddress2 ,
                  @sPinCode ,
                  @sAddressPhNo ,
                  @iAddressType ,
                  1 ,--active status  
                  @sCreatedBy ,
                  @dtCreatedOn  
                )  
   
        SELECT  @iEmpID AS I_Employee_ID  
  
   
    END TRY  
    BEGIN CATCH  
--Error occurred:    
  
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH
