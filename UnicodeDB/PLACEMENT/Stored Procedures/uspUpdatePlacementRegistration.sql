--sp_helptext '[PLACEMENT].uspUpdatePlacementRegistration'

/*    
-- =================================================================    
-- Author:Shankha Roy    
-- Create date:12/05/2007     
-- Description: Update method in of T_Placement_Registration table    
-- Parameters :     
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
  @iAcknowledgementCount,    
  @sUpdBy,    
  @dtUpdOn,    
  @dtExpecCourseCompDate,    
  @sCellNo,    
  @sCurrentOrganization,    
  @sDesignation,    
  @iStatus,    
  @iStudentDetailID     
-- =================================================================    
*/    
CREATE PROCEDURE [PLACEMENT].[uspUpdatePlacementRegistration]     
(    
  @iJobTypeID INT = null,    
  @iCountryID INT = null,    
  @iCentreID INT = null,    
  @iBrandID INT = null,    
  @iEnrollNo INT = null,    
  @sPreferredLocation VARCHAR(200) = null,    
  @sJobPreference VARCHAR(200) = null,      
  @iDocumentID INT = null,    
  @sHeight VARCHAR(20) = null,    
  @sWeight VARCHAR(20) = null,    
  @sAge VARCHAR(20) = null,    
  @iAcknowledgementCount INT = null,    
  @sUpdBy VARCHAR(20) = null,    
  @dtUpdOn DATETIME = null,      
  @sCellNo VARCHAR(50) = null,    
  @sCurrentOrganization VARCHAR(50) = null,    
  @sDesignation VARCHAR(20) = null,    
  @iStatus INT = null,    
  @bAssistance BIT = null,    
  @bViewAll BIT = null,    
  @iStudentDetailID INT = null,    
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
   -- Update records in T_Placement_Registration table    
   UPDATE    PLACEMENT.T_Placement_Registration    
   SET                  
     I_Job_Type_ID = COALESCE(@iJobTypeID,I_Job_Type_ID),    
     --I_Country_ID = @iCountryID,    
     --I_Centre_ID = @iCentreID,    
     --I_Brand_ID = @iBrandID,    
     I_Enroll_No = COALESCE(@iEnrollNo,I_Enroll_No),    
     S_Preferred_Location =COALESCE(@sPreferredLocation,S_Preferred_Location),    
     S_Job_Preference = COALESCE(@sJobPreference,S_Job_Preference),        
     I_Document_ID = COALESCE(@iDocumentID,I_Document_ID),    
     S_Height = COALESCE(@sHeight,S_Height),    
     S_Weight = COALESCE(@sWeight,S_Weight),    
     S_Age = COALESCE(@sAge,S_Age),      
     I_Acknowledgement_Count = COALESCE(@iAcknowledgementCount,I_Acknowledgement_Count),         
     S_Cell_No = COALESCE(@sCellNo,S_Cell_No),    
     S_Current_Organization = COALESCE(@sCurrentOrganization,S_Current_Organization),    
     S_Designation = COALESCE(@sDesignation,S_Designation),    
     I_Status = COALESCE(@iStatus,I_Status),    
     B_Profile_Viewed = COALESCE(@bViewAll,B_Profile_Viewed),    
     B_Placement_Asistance = COALESCE(@bAssistance,B_Placement_Asistance),    
     S_Upd_By = @sUpdBy,     
     Dt_Upd_On = @dtUpdOn     
   WHERE     
     I_Student_Detail_ID =@iStudentDetailID     
    
  --update record on T_Placement_Skill table      
  -- Update the Placement Skill table all present skill status 0 for this student          
     UPDATE PLACEMENT.T_Placement_Skills    
         SET   I_Status = 0    
     WHERE I_Student_Detail_ID=@iStudentDetailID        
            
  -- Create Temporary Table To store skill properties from XML    
   DECLARE @tempSkillTable TABLE     
   (    
       ID INT identity(1,1),    
    I_Skills_ID INT,    
    B_Soft_Skill BIT,    
    B_Technical_Skill BIT,    
    S_Skill_Proficiency VARCHAR(50)    
   )    
      
  -- Insert Values into Temporary Table for skill    
   INSERT INTO @tempSkillTable    
   SELECT  T.c.value('@SkillID','int'),    
     T.c.value('@SoftSkill','bit'),    
     T.c.value('@TechnicalSkill','bit'),    
     T.c.value('@SkillProficiency','varchar(50)')    
   FROM   @sPlacementSkill.nodes('/Skill/PlacementSkill') T(c)    
      
   DECLARE @iCount int    
   DECLARE @iRowCountSkill int    
   SELECT @iRowCountSkill= count (ID) FROM @tempSkillTable    
      
   SET @iCount = 1    
         
   WHILE (@iCount <= @iRowCountSkill)    
   BEGIN    
      
     DECLARE @SkillID INT    
     DECLARE @SoftSkill BIT    
     DECLARE @Technical BIT    
     DECLARE @SkillProficiency VARCHAR(50)    
        
       SELECT    
              @SkillID=I_Skills_ID,    
              @SoftSkill=B_Soft_Skill,    
           @Technical=B_Technical_Skill,    
           @SkillProficiency=S_Skill_Proficiency    
       FROM    
            @tempSkillTable    
       WHERE    
         ID = @iCount              
        
        -- Checking the skill Id alredy present in T_Vacancy_Skills or not    
        
        IF EXISTS( SELECT I_Skills_ID FROM PLACEMENT.T_Placement_Skills WHERE I_Student_Detail_ID=@iStudentDetailID AND I_Skills_ID=@SkillID)    
        
          BEGIN    
             UPDATE PLACEMENT.T_Placement_Skills    
             SET     
                 B_Soft_Skill=@SoftSkill,    
              B_Technical_Skill=@Technical,    
              S_Skill_Proficiency =@SkillProficiency,    
              I_Status = 1,    
              S_Upd_By=@sUpdBy,    
              Dt_Upd_On=@DtUpdOn    
             WHERE    
              I_Student_Detail_ID=@iStudentDetailID    
             AND I_Skills_ID=@SkillID        
          END    
        ELSE    
          BEGIN    
           -- Insert values into the T_Plcament_Skill table from temporary Skill table    
          INSERT  INTO T_Placement_Skills     
            (   I_Skills_ID,    
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
              SELECT      @SkillID,    
             S_Skill_Proficiency,             
             B_Soft_Skill,    
             B_Technical_Skill,    
             @iStudentDetailID,    
             @sUpdBy,    
             @sUpdBy,    
             @DtUpdOn,                 
             @DtUpdOn,    
             1    
        
           FROM @tempSkillTable    
           WHERE    
             ID = @iCount     
          END    
    SET @iCount =@iCount+1;        
   END      
  -- Update record on T_Educational_Qualification       
  -- Create Temporary Table To store qualification properties from XML    
   DECLARE @tempQualificationTable TABLE     
   (    
       ID INT identity(1,1),    
    I_Qualification_Name_ID INT,    
    S_Marks VARCHAR(10),    
    I_Year_of_Passing INT    
   )      
  -- Insert Values into Temporary Table for qualification    
   INSERT INTO @tempQualificationTable    
   SELECT    
   T.c.value ('@iQualificationNameId' , 'int'),    
         T.c.value ('@iYearOfpassing','int'),    
         T.c.value ('@sParcentageOfMarks','varchar(10)')    
   FROM @sPlacementQualification.nodes('/Qualification/Placement') T(c)      
   DECLARE @iCount2 int    
   DECLARE @iRowCountQualification int    
   SELECT @iRowCountQualification= count (ID) FROM @tempQualificationTable      
   SET @iCount2 = 1        
    
   -- Change all the present qualification inactive       
     UPDATE [PLACEMENT].T_Educational_Qualification    
     SET I_Status = 0    
     WHERE I_Student_Detail_ID=@iStudentDetailID       
      
   WHILE (@iCount2 <= @iRowCountQualification)    
   BEGIN    
          
       DECLARE @QualificationNameID INT    
       DECLARE @YearOfpassing INT    
       DECLARE @ParcentageOfMarks VARCHAR(10)    
        
       SELECT    
         @QualificationNameID= I_Qualification_Name_ID,    
         @YearOfpassing =I_Year_of_Passing,    
         @ParcentageOfMarks =S_Marks    
       FROM    @tempQualificationTable    
       WHERE    
         ID = @iCount2     
        
        
    -- Checking the qualification Id alredy present in T_Educational_Qualification or not    
         IF EXISTS( SELECT I_Qualification_Name_ID FROM [PLACEMENT].T_Educational_Qualification WHERE I_Student_Detail_ID=@iStudentDetailID AND I_Qualification_Name_ID=@QualificationNameID)    
          -- Update old records    
          BEGIN    
            UPDATE [PLACEMENT].T_Educational_Qualification    
            SET  I_Qualification_Name_ID = @QualificationNameID,    
              I_Year_Of_Passing  = @YearOfpassing,    
              S_Percentage_Of_Marks = @ParcentageOfMarks,    
              I_Status = 1    
            WHERE I_Student_Detail_ID=@iStudentDetailID     
             AND  I_Qualification_Name_ID=@QualificationNameID     
                  
          END    
         ELSE    
          -- Insert new record    
          BEGIN    
           INSERT INTO [PLACEMENT].T_Educational_Qualification    
                  (    
               I_Qualification_Name_ID,     
               I_Year_Of_Passing,     
               S_Percentage_Of_Marks,    
               I_Student_Detail_ID,     
               I_Status,     
               S_Crtd_By,    
               S_Upd_by,    
               Dt_Crtd_On,    
               Dt_Upd_On )    
           SELECT      
             I_Qualification_Name_ID ,    
             I_Year_of_Passing,    
             S_Marks,    
             @iStudentDetailID,    
             1,    
             @sUpdBy,                 
             @sUpdBy,    
             @DtUpdOn,    
             @DtUpdOn    
                  
             FROM    @tempQualificationTable    
             WHERE    
             ID = @iCount2    
          END    
        
   SET @iCount2 =@iCount2+1;         
       END     
      
      
    
    
  -- Update records on T_International_Certificate    
      
     
    
  -- Create Temporary Table To store qualification properties from XML    
   DECLARE @tempCertificateTable TABLE     
   (    
       ID INT identity(1,1),    
    I_Certificate_ID INT    
   )    
      
  -- Insert Values into Temporary Table for certificates    
   INSERT INTO @tempCertificateTable    
   SELECT  T.c.value ('@iInternalCertificate' , 'int')    
   FROM @sInternationalCertification.nodes('/Certificate/International') T(c)    
      
   DECLARE @iCount3 int    
   DECLARE @iRowCountCert int    
   SELECT @iRowCountCert= count (ID) FROM @tempCertificateTable     
  -- Change all present certificate status inactive    
   UPDATE [PLACEMENT].T_International_Certificate    
   SET I_Status = 0    
   WHERE I_Student_Detail_ID=@iStudentDetailID    
       
   SET @iCount3 = 1      
   WHILE (@iCount3 <= @iRowCountCert)    
   BEGIN    
          
       DECLARE @InternalCertificate INT    
       SELECT @InternalCertificate= I_Certificate_ID    
       FROM @tempCertificateTable    
       WHERE ID = @iCount3        
        
    -- Checking the certificate present or not    
         IF NOT EXISTS( SELECT I_International_Certificate_ID FROM [PLACEMENT].T_International_Certificate WHERE I_Student_Detail_ID=@iStudentDetailID AND I_International_Certificate_ID=@InternalCertificate)    
         BEGIN  -- Insert records      
           INSERT INTO [PLACEMENT].T_International_Certificate      
               (      
               I_Student_Detail_ID,     
               I_International_Certificate_ID,     
               I_Status     
               )    
           SELECT     
              @iStudentDetailID,    
              I_Certificate_ID,    
              1                                
           FROM    @tempCertificateTable    
           WHERE ID = @iCount3    
         END    
         ELSE    
          BEGIN    
           UPDATE [PLACEMENT].T_International_Certificate    
           SET I_Status = 1    
           WHERE I_Student_Detail_ID=@iStudentDetailID AND    
           I_International_Certificate_ID=@InternalCertificate    
          END     
   SET @iCount3 =@iCount3+1;    
      
        END     
  
-- Update  prefer location    
  DELETE FROM  PLACEMENT.T_Pref_Location WHERE I_Student_Detail_ID=@iStudentDetailID  
       
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
  
     
END TRY    
BEGIN CATCH    
 --Error occurred:    
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
