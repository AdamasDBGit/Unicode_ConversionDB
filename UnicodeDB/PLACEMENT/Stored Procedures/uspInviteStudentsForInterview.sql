CREATE PROCEDURE [PLACEMENT].[uspInviteStudentsForInterview]        
(        
@sSkillList Varchar(2000)=null,        
@sQualificationList Varchar(2000)=null,        
@iLocationId VARCHAR(2000) =null,        
@sLocationType Varchar(10)=null,        
@iVacancyID INT = null,        
@iMinHight INT = NULL,        
@iMaxHight INT= NULL,        
@iMinWeight INT= NULL,        
@iMaxWeight INT= NULL,        
@sWeightUOM VARCHAR(10) = NULL,        
@sHeightUOM VARCHAR(10) = NULL,        
@HierarchyDetailID INT = null,        
@iBrandID INT = null,        
@iMinAge INT = NULL,      
@iMaxAge INT= NULL        
)        
AS        
BEGIN          
DECLARE @ShortListedStudent TABLE         
(        
I_Student_Detail_Id INT,        
S_Student_ID VARCHAR(500),        
S_First_Name VARCHAR(50),        
S_Middle_Name VARCHAR(50),        
S_Last_Name VARCHAR(50),        
S_Center_Name VARCHAR(100),        
S_Location_Type VARCHAR(10),        
I_Location_ID VARCHAR(2000),        
S_Preferred_Location VARCHAR(2000),        
I_Vacancy_ID INT,        
C_Company_Invitation CHAR(1),      
I_Age INT      
)         
        
DECLARE @SQL VARCHAR(8000)        
SET @SQL='        
     SELECT         
     DISTINCT(ISNULL(SD.I_Student_Detail_Id,'+CHAR(39)+' '+CHAR(39)+')) AS I_Student_Detail_Id,        
           ISNULL(SD.S_Student_ID,'+CHAR(39)+' '+CHAR(39)+') AS S_Student_ID,        
        ISNULL(SD.S_First_Name,'+CHAR(39)+' '+CHAR(39)+') AS S_First_Name   ,        
           ISNULL(SD.S_Middle_Name,'+CHAR(39)+' '+CHAR(39)+') AS S_Middle_Name ,        
           ISNULL(SD.S_Last_Name,'+CHAR(39)+' '+CHAR(39)+') AS S_Last_Name     ,        
           ISNULL(CM.S_Center_Name,'+CHAR(39)+' '+CHAR(39)+') AS S_Center_Name ,        
         ISNULL(H.S_Location_Type,'+CHAR(39)+' '+CHAR(39)+') AS S_Location_Type,        
     ISNULL(H.I_Location_ID,'+CHAR(39)+' '+CHAR(39)+') AS I_Location_ID,        
     ISNULL(PR.S_Preferred_Location, '+CHAR(39)+' '+CHAR(39)+') AS S_Preferred_Location,        
     SS.I_Vacancy_ID AS I_Vacancy_ID,        
     SS.C_Company_Invitation AS C_Company_Invitation,      
     ISNULL(DATEDIFF(yy, sd.dt_birth_date, getdate()),'+CHAR(39)+' '+CHAR(39)+') AS S_AGE          
           FROM                  
          [PLACEMENT].T_Placement_Registration  PR         
    INNER JOIN [dbo].T_Student_Detail   SD        
    ON SD.I_Student_Detail_ID=PR.I_Student_Detail_ID        
    INNER JOIN [dbo].T_Student_Center_Detail E        
    ON SD.I_Student_Detail_ID=E.I_Student_Detail_ID        
    INNER JOIN [dbo].T_Centre_Master  CM        
    ON  E.I_Centre_Id = CM.I_Centre_Id         
    LEFT OUTER JOIN [PLACEMENT].T_Placement_Skills AS D        
    ON  D.I_Student_Detail_ID=PR.I_Student_Detail_ID            
    LEFT OUTER JOIN  [PLACEMENT].T_Educational_Qualification AS C        
    ON  C.I_Student_Detail_ID=PR.I_Student_Detail_ID        
    INNER JOIN [dbo].[T_Qualification_Name_Master]  I        
    ON C.I_Qualification_Name_ID=I.I_Qualification_Name_ID        
    INNER JOIN  [dbo].T_EOS_Skill_Master G         
    ON  D.I_Skills_ID=G.I_Skill_ID        
    LEFT OUTER JOIN [PLACEMENT].[T_Pref_Location] H          
    ON PR.I_Student_Detail_ID=H.I_Student_Detail_ID          
    LEFT OUTER JOIN [PLACEMENT].T_Shortlisted_Students AS SS        
    ON PR.I_Student_Detail_ID = SS.I_Student_Detail_ID          
    INNER JOIN  PLACEMENT.T_Vacancy_Detail VD        
    ON  VD.I_Vacancy_ID  = '+CONVERT(VARCHAR(10),@iVacancyID)+'
    WHERE SD.I_Status = 1        
    AND PR.I_Acknowledgement_Count <=3        
                AND E.I_Status = 1 AND CM.I_Centre_Id IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy]('+CONVERT(VARCHAR(10),@HierarchyDetailID)+','+CONVERT(VARCHAR(10),@iBrandID)+')) 
                
    AND PR.I_Job_Type_ID = (CASE WHEN VD.S_Job_Type = ''Placement'' THEN 1 WHEN VD.S_Job_Type = ''Internship'' THEN 2 ELSE 0 END)'
        
        
      
-- Chcek For SKILL        
IF(@sSkillList IS NOT NULL)        
BEGIN        
        
SET @SQL=@SQL+ 'AND D.I_Skills_ID In (Select ID From fnSplitter('+CHAR(39)+@sSkillList+CHAR(39)+'))        
                  AND PR.I_Status = 1         
      AND D.I_Status = 1     
      AND G.I_Status = 1'        
END        
        
-- CHECK FOR QUALIFICATION        
IF(@sQualificationList IS NOT NULL)        
BEGIN        
 SET @SQL = @SQL+ 'AND C.I_Qualification_Name_ID In (Select ID From fnSplitter('+CHAR(39)+@sQualificationList+CHAR(39)+'))        
                  AND PR.I_Status = 1         
      AND C.I_Status = 1         
      AND I.I_Status = 1 '        
END        
      
------------CHECK LOCATION----        
IF(@sLocationType IS NOT NULL)        
BEGIN        
 SET @SQL = @SQL+ 'AND H.S_Location_Type=COALESCE('+CHAR(39)+@sLocationType+CHAR(39)+',S_Location_Type)        
        AND H.I_Location_ID in ('+ @iLocationId +')      
                   AND PR.I_Student_Detail_ID=H.I_Student_Detail_ID        
       AND PR.I_Status = 1         
       AND H.I_Status = 1'        
END        
        
---CHECK FOR HEIGHT ---        
IF(@iMaxHight IS NOT NULL AND @iMinHight IS NOT NULL )        
BEGIN        
    SET @SQL = @SQL+ 'AND PR.S_Height >= COALESCE('+CONVERT(VARCHAR(10),@iMinHight)+',PR.S_Height)        
    AND PR.S_Height <=COALESCE('+CONVERT(VARCHAR(10),@iMaxHight)+',PR.S_Height)            
    '            
END        
        
---CHECK FOR WEIGHT----        
IF(@iMaxWeight IS NOT NULL AND @iMinWeight IS NOT NULL)        
BEGIN        
   SET @SQL = @SQL+ 'AND PR.S_Weight >=COALESCE('+CONVERT(VARCHAR(10),@iMinWeight)+',PR.S_Weight)        
   AND PR.S_Weight <=COALESCE('+CONVERT(VARCHAR(10),@iMaxWeight)+',PR.S_Weight)        
   '        
END        
        
------------CHECK AGE----        
IF(@iMinAge IS NOT NULL AND @iMaxAge IS NOT NULL)        
BEGIN        
 SET @SQL = @SQL+ ' AND SD.S_AGE>=COALESCE('+CONVERT(VARCHAR(10),@iMinAge)+',SD.S_AGE)        
   AND SD.S_AGE <=COALESCE('+CONVERT(VARCHAR(10),@iMaxAge)+',SD.S_AGE)  '      
END        
        
    
INSERT INTO @ShortListedStudent        
EXEC(@SQL)  
    
SELECT          
 DISTINCT(ISNULL(SD.I_Student_Detail_Id,' ')) AS I_Student_Detail_Id,        
           ISNULL(SD.S_Student_ID,' ') AS S_Student_ID,        
        ISNULL(SD.S_First_Name,' ') AS S_First_Name   ,        
           ISNULL(SD.S_Middle_Name,' ') AS S_Middle_Name ,        
           ISNULL(SD.S_Last_Name,' ') AS S_Last_Name     ,        
           ISNULL(CM.S_Center_Name,' ') AS S_Center_Name ,        
         'City' AS S_Location_Type,        
     cast('' as varchar(2000)) AS I_Location_ID,        
     cast('' as varchar(2000)) AS S_Preferred_Location,      
     ISNULL(SD.S_Age, ' ') AS S_Age  INTO #INVITESTUDENTS            
           FROM                  
          [PLACEMENT].T_Placement_Registration  PR         
    INNER JOIN [dbo].T_Student_Detail   SD        
    ON SD.I_Student_Detail_ID=PR.I_Student_Detail_ID        
    INNER JOIN [dbo].T_Student_Center_Detail E        
    ON SD.I_Student_Detail_ID=E.I_Student_Detail_ID        
    INNER JOIN [dbo].T_Centre_Master  CM        
    ON  E.I_Centre_Id = CM.I_Centre_Id         
    LEFT OUTER JOIN [PLACEMENT].[T_Pref_Location] H          
    ON PR.I_Student_Detail_ID=H.I_Student_Detail_ID and H.I_Location_ID IN ( @iLocationId )    
               
WHERE SD.I_Student_Detail_Id IN (        
SELECT DISTINCT(I_Student_Detail_Id) FROM @ShortListedStudent WHERE I_Student_Detail_Id NOT IN         
(SELECT I_Student_Detail_Id FROM @ShortListedStudent 
WHERE I_Vacancy_ID in 
( SELECT I_Vacancy_ID FROM PLACEMENT.T_Vacancy_Detail AS TVD  
WHERE I_Employer_ID = (SELECT I_Employer_ID FROM PLACEMENT.T_Vacancy_Detail WHERE I_Vacancy_ID = @iVacancyID ))))    
order by 1      
    
-- Pref Location list        
DECLARE @V_STUDID INT    
DECLARE @V_TMPSTUDID INT    
DECLARE @V_CITY VARCHAR(50)    
DECLARE @V_LOCATION VARCHAR(2000)    
    
SET @V_STUDID=0    
SET @V_TMPSTUDID=0    
SET @V_CITY=''    
SET @V_LOCATION=''    
DECLARE @V_STRWHERE VARCHAR(4000)  
SET @V_STRWHERE = ''  
   
 IF (ISNULL(@iLocationId, '') <> '')  
 BEGIN  
  SET @V_STRWHERE = ' and cast(L.I_Location_ID as varchar(2000)) IN ('+ @iLocationId +') '  
 END   
 SET @SQL = 'DECLARE CUR_PREFLOC CURSOR FOR    
 SELECT L.I_Student_Detail_ID as I_Student_Detail_ID , CM.S_City_Name as CityName    
 FROM [PLACEMENT].T_Pref_Location L    
 INNER JOIN T_City_Master CM        
 ON L.I_Location_ID=CM.I_City_ID    
 INNER JOIN #INVITESTUDENTS STUD     
 ON L.I_Student_Detail_ID = STUD.I_Student_Detail_ID    
 WHERE L.I_Status = 1 ' + @V_STRWHERE + ' ORDER BY 1'    
 exec(@SQL)    
 OPEN CUR_PREFLOC    
 FETCH NEXT FROM CUR_PREFLOC INTO @V_STUDID, @V_CITY    
 WHILE @@FETCH_STATUS=0    
 BEGIN    
     
  IF (@V_TMPSTUDID = @V_STUDID)    
  BEGIN    
   SET @V_LOCATION = @V_LOCATION + ', ' + @V_CITY    
  END    
  ELSE    
  BEGIN    
   SET @V_LOCATION = @V_CITY    
  END    
  UPDATE #INVITESTUDENTS SET S_Preferred_Location = @V_LOCATION WHERE I_Student_Detail_Id = @V_STUDID    
  SET @V_TMPSTUDID = @V_STUDID    
  FETCH NEXT FROM CUR_PREFLOC INTO @V_STUDID, @V_CITY    
 END    
 CLOSE CUR_PREFLOC     
 DEALLOCATE CUR_PREFLOC     
     
     
 -- Pref Location list ENDS       
SELECT * FROM #INVITESTUDENTS    
    
-- Skill set         
SELECT ESM.S_Skill_Desc AS S_Skill_Desc,ESM.S_Skill_No AS S_Skill_No, PS.I_Student_Detail_ID as I_Student_Detail_ID   FROM [PLACEMENT].T_Placement_Skills PS        
INNER JOIN [dbo].T_EOS_Skill_Master ESM        
ON PS.I_Skills_ID = ESM.I_Skill_ID        
WHERE PS.I_Student_Detail_ID IN (        
SELECT DISTINCT(I_Student_Detail_Id) FROM @ShortListedStudent WHERE I_Student_Detail_Id NOT IN         
(SELECT I_Student_Detail_Id FROM @ShortListedStudent WHERE I_Vacancy_ID = @iVacancyID ))        
AND  PS.I_Status = 1         
        
-- Qualification list        
SELECT QNM.S_Qualification_Name AS S_Qualification_Name , EQ.I_Student_Detail_ID as I_Student_Detail_ID , EQ.I_Qualification_Name_ID FROM [PLACEMENT].T_Educational_Qualification  EQ        
INNER JOIN dbo.T_Qualification_Name_Master QNM        
ON EQ.I_Qualification_Name_ID = QNM.I_Qualification_Name_ID        
WHERE EQ.I_Student_Detail_ID IN (        
SELECT DISTINCT(I_Student_Detail_Id) FROM @ShortListedStudent WHERE I_Student_Detail_Id NOT IN         
(SELECT I_Student_Detail_Id FROM @ShortListedStudent WHERE I_Vacancy_ID = @iVacancyID ))        
 AND EQ.I_Status = 1         
    
END
