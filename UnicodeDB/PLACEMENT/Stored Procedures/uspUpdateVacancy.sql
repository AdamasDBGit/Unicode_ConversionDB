/*  
-- =================================================================  
-- Author:Shankha Roy  
-- Create date:12/05/2007  
-- Description:Update vacancy record in T_Vacancy_Detail table  
-- Parameter :  
     @iVacancyID,  
    @iEmployerID,  
       @sMinHeight,  
       @sMaxHeight,  
       @sMinWeight,  
       @sHeightUOM,  
       @sMaxWeight,  
       @cGender,  
       @iNoOfOpenings,  
       @sWeightUOM,  
       @sJobType,  
       @sPayScale,  
       @sVacancyDescription,  
       @sRemarks,  
       @sCrtdBy,  
       @sUpdBy,  
       @DtCrtdOn,  
       @DtUpdOn,  
       @bTransport,  
       @sRoleDesignation,  
       @DtDateOfInterview,  
       @sJobTypeByNature,  
       @bFresherAllowed,  
       @sWorkExperience,  
       @bShift,  
    @iStatus  
-- =================================================================  
*/  
  
CREATE PROCEDURE [PLACEMENT].[uspUpdateVacancy]  
-- Input parameter  
(  
    @iVacancyID INT,  
    @iEmployerID        INT,  
       @sMinHeight         VARCHAR(20),  
       @sMaxHeight         VARCHAR(20),  
       @sMinWeight         VARCHAR(20),  
       @sHeightUOM         VARCHAR(10),  
       @sMaxWeight         VARCHAR(20),  
       @cGender            CHAR(1),  
       @iNoOfOpenings      INT,  
       @sWeightUOM         VARCHAR(10) ,  
       @sJobType           VARCHAR(50) ,  
       @sPayScale          VARCHAR(50) ,  
       @sVacancyDescription VARCHAR(1000) ,  
       @sRemarks            VARCHAR(1000) ,  
       @sCrtdBy          VARCHAR(20) ,  
    @DtCrtdOn    DATETIME,   
       @sUpdBy             VARCHAR(20) ,  
       @DtUpdOn            DATETIME,  
       @bTransport         BIT,  
       @sRoleDesignation   VARCHAR(50) ,  
       @DtDateOfInterview  DATETIME ,  
       @iNatureOFBusiness   INT,  
       @bFresherAllowed    BIT,  
       @sWorkExperience    VARCHAR(200) ,  
       @bShift              BIT ,  
    @iStatus             INT,  
--XML file for Vacancy Skill data  
    @sVacancySkillList XML,  
--XML file for Vacancy Qualification data  
    @sVacancyQualificationList XML,  
    @sVacancyPrefLocList XML    
)  
AS  
BEGIN TRY  
  
-- Update the T_Vacancy_Detail Table  
UPDATE [PLACEMENT].[T_Vacancy_Detail]  
SET  
    I_Employer_ID=@iEmployerID,  
 S_Min_Height=@sMinHeight,  
 S_Max_Height=@sMaxHeight,  
 S_Min_Weight=@sMinWeight,  
 S_Height_UOM=@sHeightUOM,  
 S_Max_Weight=@sMaxWeight,  
 C_Gender=@cGender,  
 I_No_Of_Openings=@iNoOfOpenings,  
 S_Weight_UOM=@sWeightUOM,  
 S_Job_Type=@sJobType,  
 S_Pay_Scale=@sPayScale,  
 S_Vacancy_Description=@sVacancyDescription,  
 S_Remarks=@sRemarks,  
 B_Transport=@bTransport,  
 S_Role_Designation=@sRoleDesignation,  
 Dt_Date_Of_Interview=@DtDateOfInterview,  
 I_Nature_OF_Business=@iNatureOFBusiness,  
 B_Fresher_Allowed=@bFresherAllowed,  
 S_Work_Experience=@sWorkExperience,  
    I_Status =@iStatus,  
 B_Shift=@bShift,  
 S_Upd_By=@sUpdBy,  
 Dt_Upd_On=@DtUpdOn  
WHERE  
    I_Vacancy_ID=@iVacancyID  
  
  
  
-- Update the vacancy Skill table  
  
-- Make all present skill of this vacancy status 0  
 UPDATE PLACEMENT.T_Vacancy_Skills  
 SET  I_Status = 0  
 WHERE  I_Vacancy_ID=@iVacancyID  
   
-- Create Temporary Table To store skill properties from XML  
 CREATE TABLE #tempSkillTable  
 (  
     ID INT identity(1,1),  
  I_Skills_ID INT,  
  B_Soft_Skill BIT,  
  B_Technical_Skill BIT,  
  B_Mandatory_Skill BIT  
 )  
  
-- Insert Values into Temporary Table for skill  
 INSERT INTO #tempSkillTable  
 SELECT T.c.value('@SkillID','int'),  
   T.c.value('@SoftSkill','bit'),  
   T.c.value('@TechnicalSkill','bit'),  
   T.c.value('@Mandatory','bit')    
 FROM   @sVacancySkillList.nodes('/Skill/VacancySkill') T(c)  
  
 DECLARE @iCount int  
 DECLARE @iRowCountSkill int  
 SELECT @iRowCountSkill= count (ID) FROM #tempSkillTable  
  
 SET @iCount = 1  
  
        UPDATE PLACEMENT.T_Vacancy_Skills  
         SET I_Status =0,  
          S_Upd_By=@sUpdBy,  
          Dt_Upd_On=@DtUpdOn  
         WHERE  
          I_Vacancy_ID=@iVacancyID  
           
  
  
  
     
 WHILE (@iCount <= @iRowCountSkill)  
 BEGIN  
  
 DECLARE @SkillID INT  
 DECLARE @SoftSkill BIT  
 DECLARE @Technical BIT  
 DECLARE @Mandatory BIT  
  
   SELECT  
          @SkillID=I_Skills_ID,  
          @SoftSkill=B_Soft_Skill,  
       @Technical=B_Technical_Skill,  
       @Mandatory=B_Mandatory_Skill  
   FROM  
        #tempSkillTable  
   WHERE  
     ID = @iCount   
  
    -- Checking the skill Id alredy present in T_Vacancy_Skills or not  
  
  
           
  
--    IF EXISTS( SELECT I_Vacancy_Skill_ID FROM PLACEMENT.T_Vacancy_Skills WHERE I_Vacancy_ID=@iVacancyID AND I_Skills_ID=@SkillID)  
--  
--      BEGIN  
--         UPDATE PLACEMENT.T_Vacancy_Skills  
--         SET I_Skills_ID=@SkillID,  
--             B_Soft_Skill=@SoftSkill,  
--          B_Mandatory=@Mandatory,  
--          B_Technical_Skill=@Technical,  
--          I_Status =1,  
--          S_Upd_By=@sUpdBy,  
--          Dt_Upd_On=@DtUpdOn  
--         WHERE  
--          I_Vacancy_ID=@iVacancyID  
--         AND I_Skills_ID=@SkillID  
--  
--      END  
--    ELSE  
--      BEGIN  
       -- Insert values into the T_Vacancy_Skill table from temporary Skill table  
  
  
       INSERT INTO PLACEMENT.T_Vacancy_Skills  
         (  
         I_Vacancy_ID,  
         I_Skills_ID,  
         B_Soft_Skill,  
         B_Mandatory,  
         B_Technical_Skill,  
         I_Status,  
         S_Crtd_By,  
         Dt_Crtd_on,  
         S_Upd_By,  
         Dt_Upd_On  
         )  
       SELECT  
         @iVacancyID,  
         I_Skills_ID,  
         B_Soft_Skill,  
         B_Mandatory_Skill,  
         B_Technical_Skill,  
         1,  
         @sCrtdBy,  
         @DtCrtdOn,  
         @sUpdBy,  
         @DtUpdOn  
  
       FROM #tempSkillTable  
       WHERE  
         ID = @iCount  
  
--      END   
  SET @iCount =@iCount+1;  
  
  
 END  
     
  
-- Update Vacancy Qualifications in T_Vacancy_Qualification table  
  
-- Make all present qualification status 0  
  
 UPDATE PLACEMENT.T_Vacancy_Qualifications  
 SET I_Status = 0  
 WHERE I_Vacancy_ID=@iVacancyID  
  
  
  
-- Create Temporary Table To store Vacancy Qualification properties from XML  
 CREATE TABLE #tempQualificationTable  
 (  
  ID INT identity(1,1),  
  I_Qualification_Name_ID INT  
  
 )  
  
-- Insert Values into Qualification Temporary Table  
 INSERT INTO #tempQualificationTable  
 SELECT T.c.value('@QualificationNameID','int')  
 FROM   @sVacancyQualificationList.nodes('/Qualification/VacancyQualification') T(c)  
  
-- Update values into the T_Vacancy_Qualifications table from temporary Vacancy Qualifiation table  
  
  DECLARE @iCount2 int  
  DECLARE @iRowCountVacancyQualification int  
  SELECT @iRowCountVacancyQualification= count (ID) FROM #tempQualificationTable  
  
  SET @iCount2 = 1  
       
    
  
  WHILE (@iCount2 <= @iRowCountVacancyQualification)  
  BEGIN  
  
    DECLARE @QualificationNameID INT  
    SELECT  @QualificationNameID=I_Qualification_Name_ID  
    FROM   #tempQualificationTable  
    WHERE  ID = @iCount2  
         
     -- Checking the Qualification Id alredy present in T_Vacancy_Qualifications or not  
  
     IF EXISTS( SELECT I_Vacancy_Qualifications_ID FROM PLACEMENT.T_Vacancy_Qualifications WHERE I_Vacancy_ID=@iVacancyID AND I_Qualification_Name_ID=@QualificationNameID)  
  
       BEGIN  
          UPDATE PLACEMENT.T_Vacancy_Qualifications  
          SET I_Qualification_Name_ID=@QualificationNameID,  
           I_Status=1,  
           S_Upd_By=@sUpdBy,  
           Dt_Upd_On=@DtUpdOn  
          WHERE  
           I_Vacancy_ID=@iVacancyID  
          AND I_Qualification_Name_ID=@QualificationNameID  
  
       END  
     ELSE  
       BEGIN  
        -- Insert values into the T_Vacancy_Qualifications table from temporary Qualifications table  
  
  
        INSERT INTO PLACEMENT.T_Vacancy_Qualifications  
          (  
          I_Vacancy_ID,  
          I_Qualification_Name_ID,  
          I_Status,  
          S_Crtd_By,  
          Dt_Crtd_on  
          )  
        SELECT  
          @iVacancyID,  
          I_Qualification_Name_ID,  
          1,  
          @sCrtdBy,  
          @DtCrtdOn  
  
        FROM #tempQualificationTable  
        WHERE  
         ID = @iCount2  
       END  
  
     
 SET @iCount2 =@iCount2+1;  
  
  
  END  
  
-- Change the status of other Vacancy Qualification to incative   
  
--Insert Values into Location wise vacancy
DELETE FROM [PLACEMENT].T_JOB_OPENING WHERE I_VACANCY_ID = @IVACANCYID

 INSERT INTO [PLACEMENT].T_JOB_OPENING
 (
 I_VACANCY_ID, I_CITY_ID, I_VACANCY
 )
 SELECT @iVacancyID, T.c.value('@I_Location_ID','int'),
     T.c.value('@Openings','int')
 FROM @sVacancyPrefLocList.nodes('/PrefLocList/VacancyQualification') T(c)  


  
  
  
END TRY  
BEGIN CATCH  
 --Error occurred:  
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
