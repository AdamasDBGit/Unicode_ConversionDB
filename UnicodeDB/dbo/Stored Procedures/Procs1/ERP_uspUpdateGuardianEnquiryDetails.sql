-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[ERP_uspUpdateGuardianEnquiryDetails]     
(    
 @iEnquiryRegnID int = NULL,    
    
 @sFatherFirstName nvarchar(70) = NULL,    
 @sFatherMiddleName nvarchar(60) = NULL,    
 @sFatherLastName nvarchar(70) = NULL,    
 @sFatherMobileNo nvarchar(20) = NULL,    
 @sFatherEmailID nvarchar(200) = NULL,    
 @iFatherQualification int = NULL,    
 @iFatherOccupation int = NULL,    
 @sFatherNameOfCompany nvarchar(200) = NULL,    
 @sFatherDesignation nvarchar(200) = NULL,    
 @iFatherIncome int = NULL,    
 @sFatherPhotoFilePath nvarchar(500) = NULL,    
    
 @sMotherFirstName nvarchar(70) = NULL,    
 @sMotherMiddleName nvarchar(60) = NULL,    
 @sMotherLastName nvarchar(70) = NULL,    
 @sMotherMobileNo nvarchar(20) = NULL,    
 @sMotherEmailID nvarchar(200) = NULL,    
 @iMotherQualification int = NULL,    
 @iMotherOccupation int = NULL,    
 @sMotherNameOfCompany nvarchar(200) = NULL,    
 @sMotherDesignation nvarchar(200) = NULL,    
 @iMotherIncome int = NULL,    
 @sMotherPhotoFilePath nvarchar(500) = NULL,    
    
 --@sAddressType nvarchar(20) = NULL,    
 @sAddressLine1 nvarchar(200) = NULL,    
 @sAddressLine2 nvarchar(200) = NULL,    
 @iCountry int = NULL,    
 @iState int = NULL,    
 @iCity int = NULL,    
 @sPincode nvarchar(20) = NULL,    
    
 @iUpdatedBy NVARCHAR(MAX) = NULL,    
 @ITabNo int = null    
)    
AS    
begin transaction    
BEGIN    
 BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 DECLARE @currentTabNo int;    
 IF @sFatherPhotoFilePath IS NULL    
 BEGIN    
  SET @sFatherPhotoFilePath = (SELECT S_Father_Photo FROM [dbo].[T_Enquiry_Regn_Detail] WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID)    
 END    
 IF @sMotherPhotoFilePath IS NULL    
 BEGIN    
  SET @sMotherPhotoFilePath = (SELECT S_Mother_Photo FROM [dbo].[T_Enquiry_Regn_Detail] WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID)    
 END     
    
 declare @FatherName varchar(300) = (CONCAT(COALESCE(LTRIM(RTRIM(@sFatherFirstName))+' ', ''), COALESCE(LTRIM(RTRIM(@sFatherMiddleName))+' ', ''), COALESCE(LTRIM(RTRIM(@sFatherLastName)), '')));    
 declare @MotherName varchar(300) = (CONCAT(COALESCE(LTRIM(RTRIM(@sMotherFirstName))+' ', ''), COALESCE(LTRIM(RTRIM(@sMotherMiddleName))+' ', ''), COALESCE(LTRIM(RTRIM(@sMotherLastName)), '')));    
 IF LEN(@FatherName) = 0    
   set @FatherName = null;    
 IF LEN(@MotherName) = 0    
  set @MotherName = null;    
    -- Insert statements for procedure here    
 UPDATE [dbo].[T_Enquiry_Regn_Detail]    
 SET       
  S_Father_Mobile_No = @sFatherMobileNo,    
  --S_Father_Name = CONCAT(COALESCE(@sFatherFirstName+' ', ''), COALESCE(@sFatherMiddleName+' ', ''), COALESCE(@sFatherLastName, '')),     
  S_Father_Name = @FatherName,    
  S_Father_Email = @sFatherEmailID,    
  I_Father_Qualification_ID = @iFatherQualification,    
  I_Father_Occupation_ID = @iFatherOccupation,    
  S_Father_Company_Name = @sFatherNameOfCompany,    
  S_Father_Designation = @sFatherDesignation,    
  I_Father_Income_Group_ID = @iFatherIncome,    
  S_Father_Photo = @sFatherPhotoFilePath,    
    
  S_Mother_Mobile_No = @sMotherMobileNo,    
  --S_Mother_Name = CONCAT(COALESCE(@sMotherFirstName+' ', ''), COALESCE(@sMotherMiddleName+' ', ''), COALESCE(@sMotherLastName, '')),    
  S_Mother_Name = @MotherName,    
  S_Mother_Email = @sMotherEmailID,    
  I_Mother_Qualification_ID = @iMotherQualification,    
  I_Mother_Occupation_ID = @iMotherOccupation,    
  S_Mother_Company_Name = @sMotherNameOfCompany,    
  S_Mother_Designation = @sMotherDesignation,    
  I_Mother_Income_Group_ID = @iMotherIncome,    
  S_Mother_Photo = @sMotherPhotoFilePath,    
    
  S_Curr_Address1 = @sAddressLine1,    
  S_Curr_Address2 = @sAddressLine2,    
  I_Curr_Country_ID = @iCountry,    
  I_Curr_State_ID = @iState,    
  I_Curr_City_ID = @iCity,    
  S_Curr_Pincode = @sPincode,    
  Dt_Upd_On = GETDATE(),    
  S_Upd_By = @iUpdatedBy    
 WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID    
    
 -- Email update on T_Parent_Master table for fatheremail and motheremail    
 UPDATE PM    
SET     
    PM.S_Guardian_Email =     
        CASE     
            WHEN PM.I_Relation_ID = 1 THEN @sFatherEmailID     
            WHEN PM.I_Relation_ID IN (2, 3, 5) THEN @sMotherEmailID    
        END,    
    PM.S_Mobile_No =     
        CASE     
            WHEN PM.I_Relation_ID = 1 THEN @sFatherMobileNo    
            WHEN PM.I_Relation_ID IN (2, 3, 5) THEN @sMotherMobileNo    
        END    
FROM T_Parent_Master PM    
INNER JOIN T_Student_Parent_Maps SPM ON PM.I_Parent_Master_ID = SPM.I_Parent_Master_ID    
INNER JOIN T_Student_Detail SD ON SPM.I_Student_Detail_ID = SD.I_Student_Detail_ID    
WHERE SD.I_Enquiry_Regn_ID = @iEnquiryRegnID;    
    
    
    
    
 set @currentTabNo = (select I_Tab_No from [T_Enquiry_Regn_Detail] WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID)    
 IF(@ITabNo>(CAST(@currentTabNo AS INT)))    
 BEGIN    
 update [T_Enquiry_Regn_Detail] set I_Tab_No = @ITabNo WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID    
 END    
    
 select 1 StatusFlag,'Guardian Details saved successfully' Message    
    
 END TRY    
 BEGIN CATCH    
  rollback transaction    
  DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    
  SELECT @ErrMsg = ERROR_MESSAGE(),    
    @ErrSeverity = ERROR_SEVERITY()    
  select 0 StatusFlag,@ErrMsg Message    
 END CATCH    
commit transaction    
END    
