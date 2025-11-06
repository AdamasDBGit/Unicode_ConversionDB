--    exec  [ERP_REPORTS].[USP_ERP_GetStudentInfo_Details]   --'107','1,2','11,13,12,9','1,2,3','2025-04-01','2025-04-29','7'      
          
CREATE PROCEDURE [ERP_REPORTS].[USP_ERP_GetStudentInfo_Details]            
    @BrandID INT,            
    @schoolGroupID Varchar(100),            
    --@classID INT,            
 @strclass varchar(100),            
    --@SectionID INT = NULL,            
 @strSection varchar(100),                    
    @sessionID INT            
AS            
BEGIN            
    SET NOCOUNT ON;            
            
-- --step1  IF OBJECT_ID('tempdb..#Courses') IS NULL  BEGIN     CREATE TABLE #Courses (         Id INT IDENTITY(1,1), CourseID INT     )  END    --step2 INSERT INTO #Courses (CourseID) -- Adjust ColumnName to match your table's column                     
  
    
      
        
            
--            SELECT Value                                   FROM dbo.ERP_SplitString(@strclass, ',');            
            
----step1  IF OBJECT_ID('tempdb..#Sections') IS NULL  BEGIN     CREATE TABLE #Sections (         Id INT IDENTITY(1,1), SectionID INT     )  END   --step2 INSERT INTO #Sections (SectionID) -- Adjust ColumnName to match your table's column                  
  
    
      
        
            
--               SELECT Value                                   FROM dbo.ERP_SplitString(@strSection, ',');            
            
    SELECT             
       -- SC.S_Section_Name AS SectionName,            
        RD.S_Enquiry_No AS Enquiry_No,            
        SD.S_Student_ID AS Student_ID,            
        SG.S_School_Group_Name AS School_Programme,          
  tc.S_Class_Name as Class,        
        St.S_Stream AS Stream,        
  sc.S_Section_Name as Section,        
        SD.S_First_Name +                 
            CASE                 
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''                 
                THEN ' ' + SD.S_Middle_Name                 
                ELSE ''                 
            END +                 
            ' ' + SD.S_Last_Name AS Studentname,            
        SD.S_Mobile_No AS Phone,            
        Convert(date,SD.Dt_Birth_Date) AS Date_Of_Birth,            
        US.S_Sex_Name AS Gender,            
        TCM.S_Caste_Name AS Social_Category,            
        vsp.Father_Name,            
        vsp.Father_Mobile, 
		COALESCE(RD.S_Email_ID, RD.S_Father_Email,RD.S_Mother_Email) AS Email,
        vsp.Mother_Name,            
        vsp.Mother_Mobile,            
        RD.S_Curr_Address1 AS Address1,            
        RD.S_Curr_Address2 AS Address2,            
        CM.S_Country_Name AS Country,            
        SM.S_State_Name AS State,            
        CTM.S_City_Name AS City,            
        RD.S_Curr_Pincode AS Pincode            
    FROM             
        T_Student_Class_Section SCS            
    INNER JOIN             
        T_Student_Detail SD ON SCS.I_Student_Detail_ID = SD.I_Student_Detail_ID            
                    
    INNER JOIN             
        T_School_Group_Class SGC ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID            
    INNER JOIN             
        T_School_Group SG ON SG.I_School_Group_ID = SGC.I_School_Group_ID            
        AND SG.I_Brand_Id = @BrandID            
    INNER JOIN             
        T_Class TC ON TC.I_Class_ID = SGC.I_Class_ID             
        AND TC.I_Brand_ID=@BrandID          
 --INNER JOIN            
 -- #Courses cs ON cs.CourseID = TC.I_Class_ID            
    LEFT JOIN             
        T_Enquiry_Regn_Detail RD ON RD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID            
    LEFT JOIN             
        T_Section SC ON SC.I_Section_ID = SCS.I_Section_ID            
 --LEFT JOIN            
 -- #Sections ss ON ss.SectionID = SCS.I_Section_ID            
    LEFT JOIN             
        T_Stream St ON St.I_Stream_ID = SCS.I_Stream_ID            
        AND St.I_Brand_ID = @BrandID            
    LEFT JOIN             
        T_User_Sex US ON US.I_Sex_ID = RD.I_Sex_ID              
    LEFT JOIN              
        T_Caste_Master TCM ON TCM.I_Caste_ID = RD.I_Caste_ID            
    LEFT JOIN      
        vw_Student_pareents_Info vsp ON vsp.I_Student_Detail_ID = SCS.I_Student_Detail_ID            
        AND vsp.I_Brand_ID = @BrandID            
    LEFT JOIN             
        T_Country_Master CM ON CM.I_Country_ID = RD.I_Curr_Country_ID            
    LEFT JOIN             
        T_State_Master SM ON SM.I_State_ID = RD.I_Curr_State_ID            
    LEFT JOIN             
        T_City_Master CTM ON CTM.I_City_ID = RD.I_Curr_City_ID       
    WHERE             
        (SG.I_School_Group_ID in (SELECT Value FROM dbo.ERP_SplitString(@schoolGroupID, ',')) or @schoolGroupID is null )          
        AND (TC.I_Class_ID in (SELECT Value FROM dbo.ERP_SplitString(@strclass, ',')) or @strclass is null)          
        AND (sc.I_Section_ID in (SELECT Value FROM dbo.ERP_SplitString(@strSection, ',')) OR @strSection IS NULL)            
        --AND CONVERT(DATE, SD.Dt_Crtd_On) >= @AdmStartDt            
        --AND CONVERT(DATE, SD.Dt_Crtd_On) <= @AdmEndDate      
  AND SCS.I_Status = 1             
        AND SCS.I_Brand_ID = @BrandID             
        AND SCS.I_School_Session_ID = @sessionID      
END;