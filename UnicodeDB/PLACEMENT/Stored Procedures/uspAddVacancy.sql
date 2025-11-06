/*  
-- =================================================================  
-- Author:Shankha Roy  
-- Create date:12/05/2007   
-- Description:Insert vacancy record in T_Vacancy_Detail table   
-- =================================================================  
*/  
CREATE PROCEDURE [PLACEMENT].[uspAddVacancy]  
(  
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
       @sCrtdBy            VARCHAR(20) ,  
       @sUpdBy             VARCHAR(20) ,  
       @DtCrtdOn           DATETIME ,  
       @DtUpdOn            DATETIME,  
       @bTransport         BIT,  
       @sRoleDesignation   VARCHAR(50) ,  
       @DtDateOfInterview  DATETIME ,  
       @iNatureOFBusiness   INT ,  
       @bFresherAllowed    BIT,  
       @sWorkExperience    VARCHAR(200) ,  
       @bShift              BIT ,  
    @iStatus    INT,  
--XML file for Vacancy Skill data  
    @sVacancySkillList XML,  
--XML file for Vacancy Qualification data  
    @sVacancyQualificationList XML,  
    @sVacancyPrefLocList XML  
      
)   
AS  
BEGIN TRY  
   
 DECLARE @iVacancyID INT  
  
 SET NOCOUNT OFF;  
-- Insert vacacncy detail in T_Vcancy_Detail  
 INSERT INTO PLACEMENT.T_Vacancy_Detail  
 (  
 I_Employer_ID,   
 S_Min_Height,   
 S_Max_Height,   
 S_Min_Weight,   
 S_Height_UOM,   
 S_Max_Weight,   
 C_Gender,   
 I_No_Of_Openings,   
 S_Weight_UOM,  
 S_Job_Type,   
 S_Pay_Scale,   
 S_Vacancy_Description,   
 S_Remarks,   
 B_Transport,   
 S_Role_Designation,   
 Dt_Date_Of_Interview,  
 I_Nature_OF_Business,   
 B_Fresher_Allowed,   
 S_Work_Experience,   
 B_Shift,  
 I_Status,  
 S_Crtd_By,   
 Dt_Crtd_On,  
 S_Upd_By,   
 Dt_Upd_On   
)  
VALUES(  
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
 @bTransport,   
 @sRoleDesignation,   
 @DtDateOfInterview,  
 @iNatureOFBusiness,   
 @bFresherAllowed,   
 @sWorkExperience,   
 @bShift,  
    @iStatus,  
 @sCrtdBy,   
 @DtCrtdOn,  
 @sUpdBy,  
 @DtUpdOn  
    )     
   
-- Get the insert vacacy id  
 SET @iVacancyID=SCOPE_IDENTITY()  
  
  
-- Add Vacancy Skills in table T_Vacancy_Skills  
  
-- Create Temporary Table To store skill properties from XML  
 CREATE TABLE #tempSkillTable  
 (              
  I_Skill_ID INT,  
  B_Soft_Skill BIT,  
  B_Technical_Skill BIT,  
  B_Mandatory_Skill BIT  
 )   
  
-- Insert Values into Temporary Table  
 INSERT INTO #tempSkillTable  
 SELECT T.c.value('@SkillID','int'),  
   T.c.value('@SoftSkill','bit'),  
   T.c.value('@TechnicalSkill','bit'),  
   T.c.value('@Mandatory','bit')  
 FROM   @sVacancySkillList.nodes('/Skill/VacancySkill') T(c)  
  
  
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
     I_Skill_ID,   
     B_Soft_Skill,   
     B_Mandatory_Skill,   
     B_Technical_Skill,  
     1,   
     @sCrtdBy,   
     @DtCrtdOn,  
     @sUpdBy,   
     @DtUpdOn   
       
   FROM #tempSkillTable  
  
  
  
  
-- Add Vacancy Qualifications in T_Vacancy_Qualification table  
  
-- Create Temporary Table To store skill properties from XML  
 CREATE TABLE #tempQualificationTable  
 (              
  I_Qualification_Name_ID INT  
    
 )   
  
 --Insert Values into Temporary Table  
 INSERT INTO #tempQualificationTable  
 SELECT T.c.value('@QualificationNameID','int')     
 FROM @sVacancyQualificationList.nodes('/Qualification/VacancyQualification') T(c)  
  

--Insert Values into Location wise vacancy
 INSERT INTO [PLACEMENT].T_JOB_OPENING
 (
 I_VACANCY_ID, I_CITY_ID, I_VACANCY
 )
 SELECT @iVacancyID, T.c.value('@I_Location_ID','int'),
     T.c.value('@Openings','int')
 FROM @sVacancyPrefLocList.nodes('/PrefLocList/VacancyQualification') T(c)  


 --Insert values into the T_Vacancy_Skill table from temporary Skill table  
  
 INSERT INTO PLACEMENT.T_Vacancy_Qualifications  
  (  
  I_Vacancy_ID,   
  I_Qualification_Name_ID,   
  I_Status,  
  S_Crtd_By,   
  Dt_Crtd_On,  
  S_Upd_By,   
  Dt_Upd_On   
  )  
 SELECT  
  @iVacancyID,   
  I_Qualification_Name_ID,   
  1,  
  @sCrtdBy,   
  @DtCrtdon,  
  @sUpdBy,   
  @DtUpdOn   
 FROM #tempQualificationTable    
  
SELECT @iVacancyID  
   
        
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
