/*  
-- =================================================================  
-- Author:Shankha Roy  
-- Create date:12/05/2007   
-- Description:Insert Plcacement registration record in T_Placement_Registration table   
-- =================================================================  
*/  
CREATE PROCEDURE [PLACEMENT].[uspAddPlacementRegistration]  
(  
   @iJobTypeID INT,  
  @iCountryID INT,  
  @iCentreID INT,  
  @iBrandID INT,  
  @iEnrollNo INT,  
  @sPreferredLocation VARCHAR(200),  
  @sJobPreference VARCHAR(200),  
  @dtActualCourseCompDate DATETIME,  
  @iDocumentID INT,  
  @sHeight VARCHAR(20),  
  @sWeight VARCHAR(20),  
  @sAge VARCHAR(20),  
  @iAcknowledgementCount INT,  
  @sCrtdBy VARCHAR(20),  
  @dtCrtdOn DATETIME,  
  @sUpdBy VARCHAR(20),  
  @dtUpdOn DATETIME,  
  @dtExpecCourseCompDate DATETIME,  
  @sCellNo VARCHAR(50),  
  @sCurrentOrganization VARCHAR(50),  
  @sDesignation VARCHAR(20),  
  @iStatus INT,  
  @bAssistance BIT,  
  @bViewAll BIT,  
  @iStudentDetailID INT,    
  -- XML string for skill list  
  @sPlacementSkill XML,  
  -- XML String for Placement Qualification   
  @sPlacementQualification XML,  
  -- XML string for International certification  
  @sInternationalCertification XML,
  -- XML string for Preferred Location List
  @xmlPreferredLocation XML  

)  
AS  
BEGIN TRY  
   
  
-- Insert record in  T_Placement_Registration Table  
  
INSERT INTO [PLACEMENT].T_Placement_Registration  
  (  
  I_Job_Type_ID,   
  I_Country_ID,   
  I_Centre_ID,   
  I_Brand_ID,   
  I_Enroll_No,   
  S_Preferred_Location,   
  S_Job_Preference,   
  Dt_Actual_Course_Comp_Date,   
  I_Document_ID,   
  S_Height,   
  S_Weight,   
  S_Age,   
  S_Crtd_By,   
  I_Acknowledgement_Count,   
  S_Upd_By,   
  Dt_Crtd_On,   
  Dt_Upd_On,   
  Dt_Expec_Course_Comp_Date,   
  S_Cell_No,   
  S_Current_Organization,   
  S_Designation,   
  I_Status,  
  I_Student_Detail_ID,  
  B_Profile_Viewed,  
  B_Placement_Asistance  
  )  
VALUES (  
  @iJobTypeID,  
  @iCountryID,  
  @iCentreID,  
  @iBrandID,  
  @iEnrollNo,  
  @sPreferredLocation,  
  @sJobPreference,  
  @dtActualCourseCompDate,  
  @iDocumentID,  
  @sHeight,  
  @sWeight,  
  @sAge,  
  @sCrtdBy,  
  @iAcknowledgementCount,  
  @sUpdBy,  
  @dtCrtdOn,  
  @dtUpdOn,  
  @dtExpecCourseCompDate,  
  @sCellNo,  
  @sCurrentOrganization,  
  @sDesignation,  
  1,  
  @iStudentDetailID,    
  @bViewAll,  
  @bAssistance  
   )  
     
  
   -- Insert records in T_placement_Skill Table  
 INSERT  INTO [PLACEMENT].T_Placement_Skills   
   (  
   I_Skills_ID,   
   S_Skill_Proficiency,   
   B_Soft_Skill,   
   B_Technical_Skill,   
   I_Student_Detail_ID,   
   S_Crtd_By,   
   S_Upd_By,   
   Dt_Crtd_on,   
   Dt_Upd_On,   
   I_Status  
   )  
  
   SELECT   T.c.value('@SkillID','INT'),  
   T.c.value('@SkillProficiency','varchar(50)'),  
            T.c.value('@SoftSkill','bit'),  
         T.c.value('@TechnicalSkill','bit'),  
   @iStudentDetailID,  
   @sCrtdBy,  
   @sUpdBy,  
   @dtCrtdOn,  
   @dtUpdOn,  
   1     
 FROM   @sPlacementSkill.nodes('/Skill/PlacementSkill') T(c)  
   
 -- Insert records T_Educational_Qualification table  
   
 INSERT INTO [PLACEMENT].T_Educational_Qualification  
     (  
   I_Qualification_Name_ID,   
   I_Year_Of_Passing,   
   S_Percentage_Of_Marks,  
   I_Student_Detail_ID,   
   I_Status,   
   S_Crtd_By,  
   S_Upd_By,  
   Dt_Crtd_On,  
   Dt_Upd_On   
  )  
  
 SELECT         
         T.c.value ('@iQualificationNameId' , 'int'),  
         T.c.value ('@iYearOfpassing','int'),  
         T.c.value ('@sParcentageOfMarks','varchar(10)'),  
   @iStudentDetailID,  
   1,  
   @sCrtdBy,  
   @sUpdBy,  
   @dtCrtdOn,  
      @dtUpdOn    
 FROM @sPlacementQualification.nodes('/Qualification/Placement') T(c)  
   
 -- Insert International certification  
 INSERT INTO [PLACEMENT].T_International_Certificate    
 (    
 I_Student_Detail_ID,   
 I_International_Certificate_ID,   
 I_Status   
 )  
 SELECT   
       @iStudentDetailID,  
       T.c.value ('@iInternalCertificate','int'),  
       1  
 FROM @sInternationalCertification.nodes('/Certificate/International') T(c)  
  
  
  
  
  
 -- Insert Records in T_Pref_Location table  
  INSERT INTO [PLACEMENT].T_Pref_Location  
  ( I_Location_ID,  
    S_Location_Type,  
    I_Student_Detail_ID,  
    I_Status  
  )  
SELECT   T.c.value('@LocationID','INT'),  
   T.c.value('@LocationByType','varchar(50)'),  
   @iStudentDetailID,  
   1     
 FROM   @xmlPreferredLocation.nodes('/PreferLocation/PrefLocation') T(c) 

--IF(@sPreferredLocation IS NOT NULL)  
--BEGIN  
-- DECLARE @ID VARCHAR(20)  
-- DECLARE @Type VARCHAR(20)  
-- DECLARE @pos INT  
-- SET @pos = CHARINDEX(',',@sPreferredLocation,0)  
-- SET @ID= SUBSTRING(@sPreferredLocation,0,@pos)  
-- SET @Type= SUBSTRING(@sPreferredLocation,(@pos+1),LEN(@sPreferredLocation))  
  
-- IF(@ID IS NOT NULL )  
-- BEGIN  
--  INSERT INTO [PLACEMENT].T_Pref_Location  
--  ( I_Location_ID,  
--    S_Location_Type,  
--    I_Student_Detail_ID,  
--    I_Status  
--  )  
-- VALUES  
--    (  
--  @ID,  
--  @Type,    
--  @iStudentDetailID,  
--  1  
--    )  
-- END  
--END  
        
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
