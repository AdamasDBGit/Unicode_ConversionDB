/*  
-- =================================================================  
-- Author:Ujjwal Sinha  
-- Create date:20/05/2007   
-- Description:update Employer Contact record in T_Employer_Contact table   
-- =================================================================  
*/  
CREATE PROCEDURE [PLACEMENT].[uspUpdateEmployerContact]  
(  
 @iEmployerID INT,  
 @sUpdBy VARCHAR(20),  
 @DtUpdOn DATETIME,  
 @sCrtdBy VARCHAR(20)='',  
 @DtCrtdOn DATETIME ,  
 --XML file for contact detail data  
 @sEmployerContact XML  
)  
   
AS  
BEGIN TRY  
        
      -- Creating tem table   
      DECLARE @tempEmpContTable TABLE   
   (  
         ID INT identity(1,1),  
                  I_Employer_Contact_ID INT,  
      S_Contact_Name VARCHAR(50),  
      S_Contact_Designation VARCHAR(50),  
      S_Contact_Address VARCHAR(150),  
           S_Email VARCHAR(50),   
         S_Telephone VARCHAR(20),   
         S_Cellphone VARCHAR(20),   
         S_Fax     VARCHAR(20),   
         B_Is_Primary BIT ,  
         I_Status     INT      
            
   )  
  
-- Inserrt value in  tem table from XML string   
  
 INSERT INTO @tempEmpContTable  
  (  I_Employer_Contact_ID,   
    S_Contact_Name ,  
    S_Contact_Designation ,  
    S_Contact_Address ,  
         S_Email,   
       S_Telephone    ,   
       S_Cellphone    ,   
       S_Fax        ,   
       B_Is_Primary   ,  
       I_Status         
           
  )  
 SELECT   
 T.c.value('@iEmployerContactID','int'),  
 T.c.value('@sContactName','varchar(50)'),  
 T.c.value ('@sContactDesignation','varchar(50)'),  
 T.c.value ('@sContactAddress','varchar(150)'),  
 T.c.value ('@sEmail','varchar(50)'),  
 T.c.value ('@sTelephone','varchar(20)'),  
 T.c.value ('@sCellphone','varchar(20)'),  
 T.c.value ('@sFax','varchar(20)'),  
 T.c.value ('@bIsPrimary','bit'),  
 T.c.value ('@iStatus','int')  
 FROM   @sEmployerContact.nodes('/Contact/EmployerContact') T(c)    
  
  
    --update values into the T_Employer_Contact table from xml file  
 DECLARE @iCount int  
 DECLARE @iRowCountContact int  
 SELECT @iRowCountContact= count (ID) FROM @tempEmpContTable  
   
  SET @iCount = 1  
    
  DECLARE @iEmployerContactID     int           
  DECLARE @sContactName         varchar(50)   
  DECLARE @sContactDesignation  varchar(50)   
  DECLARE @sContactAddress      varchar(150)   
  DECLARE @sEmail               varchar(50)   
  DECLARE @sTelephone           varchar(20)   
  DECLARE @sCellphone           varchar(20)   
  DECLARE @sFax                 varchar(20)   
  DECLARE @bIsPrimary           bit       
  DECLARE @iStatus              int  
    
   
   
 WHILE (@iCount <= @iRowCountContact)  
 BEGIN  
          
    SELECT  
   @iEmployerContactID   = I_Employer_Contact_ID ,  
   @sContactName         = S_Contact_Name         ,  
   @sContactDesignation  = S_Contact_Designation  ,  
   @sContactAddress      = S_Contact_Address      ,  
   @sEmail               = S_Email                ,  
   @sTelephone           = S_Telephone            ,   
   @sCellphone           = S_Cellphone            ,  
   @sFax                 = S_Fax                  ,  
   @bIsPrimary           = B_Is_Primary           ,  
   @iStatus              = I_Status  
    FROM  
       @tempEmpContTable  
    WHERE  
    ID = @iCount  
  
   
  -- Checking the skill Id alredy present in T_Employer_Contact or not  
  IF EXISTS( SELECT I_Employer_Contact_ID FROM [PLACEMENT].T_Employer_Contact WHERE I_Employer_Contact_ID=@iEmployerContactID)  
     BEGIN  
   UPDATE [PLACEMENT].T_Employer_Contact  
          SET   
     I_Employer_ID  = @iEmployerID         ,   
     S_Contact_Name = @sContactName        ,   
     S_Contact_Designation = @sContactDesignation ,   
     S_Contact_Address = @sContactAddress     ,   
     S_Email  = @sEmail              ,   
     S_Telephone  = @sTelephone          ,   
     S_Cellphone  = @sCellphone          ,   
     S_Fax   = @sFax                ,   
     B_Is_Primary  = @bIsPrimary          ,  
     I_Status  = @iStatus             ,   
     S_Upd_By  = @sUpdBy              ,        
     Dt_Upd_On  = @DtUpdOn         
       WHERE I_Employer_Contact_ID = @iEmployerContactID  
     END  
    
  SET @iCount=@iCount + 1  
    
     END  
   
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
