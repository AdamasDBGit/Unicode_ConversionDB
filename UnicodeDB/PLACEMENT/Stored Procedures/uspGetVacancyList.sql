/*  
-- =================================================================  
-- Author:Shankha Roy  
-- Create date:12/05/2007  
-- Description:Get vacancy record From T_Vacancy_Detail table  
-- Parameter :     
-- =================================================================       
*/  
  
CREATE PROCEDURE [PLACEMENT].[uspGetVacancyList]  
(  
@iEmployerID INT = null,  
@dtDateofInterview DATETIME = NULL  
)  
AS  
BEGIN   
  
  
		DECLARE @V_STUDID INT
		DECLARE @V_TMPSTUDID INT
		DECLARE @V_CITY VARCHAR(50)
		DECLARE @V_OPENING INT
		DECLARE @V_LOCATION VARCHAR(1000)

		SET @V_STUDID = 0
		SET @V_TMPSTUDID = 0
		SET @V_CITY = ''
		SET @V_OPENING = 0
		SET @V_LOCATION = ''

		DECLARE @TBLOPENING TABLE  (STUDID INT, LOCATION VARCHAR(2000) )

		DECLARE CUR_PREFLOC CURSOR FOR  
		SELECT L.I_VACANCY_ID, CM.S_City_Name as CityName, L.I_VACANCY  
		FROM [PLACEMENT].T_Job_Opening L  
		INNER JOIN T_City_Master CM      
		ON L.I_CITY_ID=CM.I_City_ID  
		WHERE L.I_VACANCY_ID IN 
		(SELECT I_Vacancy_ID FROM [PLACEMENT].T_Vacancy_Detail WHERE I_Employer_ID = @iEmployerID AND I_Status=1 AND   Dt_Date_Of_Interview =  COALESCE(@dtDateofInterview,Dt_Date_Of_Interview))
		ORDER BY 1
		OPEN CUR_PREFLOC  
		FETCH NEXT FROM CUR_PREFLOC INTO @V_STUDID, @V_CITY, @V_OPENING  
		WHILE @@FETCH_STATUS=0  
		BEGIN  
		  
		 IF (@V_TMPSTUDID = @V_STUDID)  
		 BEGIN  
		  SET @V_LOCATION = @V_LOCATION + ', ' + @V_CITY + '(' +  CAST(@V_OPENING AS VARCHAR) + ')'  
		 END  
		 ELSE  
		 BEGIN  
		  SET @V_LOCATION = @V_CITY + '(' +  CAST(@V_OPENING AS VARCHAR) + ')'
		 END
		 IF EXISTS(SELECT * FROM @TBLOPENING WHERE STUDID = @V_STUDID)
		 BEGIN
			UPDATE @TBLOPENING SET LOCATION = @V_LOCATION WHERE STUDID = @V_STUDID
		 END
		 ELSE
		 BEGIN
			INSERT INTO @TBLOPENING VALUES (@V_STUDID, @V_LOCATION)
		 END
		 SET @V_TMPSTUDID = @V_STUDID  
		FETCH NEXT FROM CUR_PREFLOC INTO @V_STUDID, @V_CITY, @V_OPENING  
		END  
		CLOSE CUR_PREFLOC   
		DEALLOCATE CUR_PREFLOC   

  
 SELECT ISNULL(I_Employer_ID,0) AS I_Employer_ID ,  
     ISNULL(I_Vacancy_ID,0)   AS I_Vacancy_ID  ,  
           ISNULL(S_Min_Height,' ') AS S_Min_Height ,  
           ISNULL(S_Max_Height,' ') AS S_Max_Height ,  
           ISNULL(S_Min_Weight,' ') AS S_Min_Weight ,  
           ISNULL(S_Height_UOM,' ') AS S_Height_UOM ,   
        ISNULL(S_Max_Weight,' ') AS  S_Max_Weight ,  
           ISNULL(C_Gender,' ') AS  C_Gender ,  
           ISNULL(I_No_Of_Openings,0) AS I_No_Of_Openings ,  
           ISNULL(S_Weight_UOM,' ') AS S_Weight_UOM ,  
           ISNULL(S_Job_Type,' ') AS  S_Job_Type ,   
        ISNULL(S_Pay_Scale,' ') AS S_Pay_Scale ,  
           ISNULL(S_Vacancy_Description,' ') AS S_Vacancy_Description ,  
           ISNULL(S_Remarks,' ') AS  S_Remarks ,  
                  B_Transport ,  
           ISNULL(S_Role_Designation,' ') AS S_Role_Designation ,   
        ISNULL(Dt_Date_Of_Interview,' ') AS Dt_Date_Of_Interview ,  
           ISNULL(I_Nature_Of_Business,0) AS I_Nature_Of_Business ,  
                  B_Fresher_Allowed ,  
           ISNULL(S_Work_Experience,' ') AS S_Work_Experience ,  
            B_Shift, 
            ISNULL(B.LOCATION, ' ')  AS CITYWISELOCATION
 FROM  [PLACEMENT].T_Vacancy_Detail A INNER JOIN @TBLOPENING B ON  A.I_Vacancy_ID = B.STUDID
 WHERE I_Status=1  
    AND   I_Employer_ID = @iEmployerID  
 AND   Dt_Date_Of_Interview =  COALESCE(@dtDateofInterview,Dt_Date_Of_Interview)  
      
END
