
-- exec [dbo].[ERP_uspGetPreEnquiryDetails] 234871, null, null, null, 1          
--exec [dbo].[ERP_uspGetPreEnquiryDetails_POC] 235009,null, null,null, null,null, null, 100, 0, 0, 'asc', null,107,null,8,null  


CREATE PROCEDURE [dbo].[ERP_uspGetPreEnquiryDetails_POC]                          
(
    @IEnquiryID INT = NULL ,               
    @S_Fullname NVARCHAR(MAX) = NULL,              
    @S_FatherName NVARCHAR(MAX) = NULL,            
    @S_MotherName NVARCHAR(MAX) = NULL,            
    @sMobileNo NVARCHAR(MAX) = NULL ,            
    @AdmissionStageID INT = NULL,            
    @iCenterID INT = NULL,          
    @Limit INT,          
    @Offset INT,          
    @SortCol INT,          
    @SortDir NVARCHAR(MAX),          
    @Search NVARCHAR(MAX) = NULL,      
    @BrandID int ,    
    @FollowTypeID int=Null,    
    @FollowupStatusID char = null,    
    @datefiltervalue int=Null,  
    @sessionID int=Null  
)                
AS                
BEGIN        
    SET NOCOUNT ON;

    DECLARE @Nextdt date;
    
    IF @datefiltervalue IS NOT NULL
        SET @Nextdt = DATEADD(day, @datefiltervalue, GETDATE());
    ELSE
        SET @Nextdt = NULL;

    -- Determine center ID based on brand
    IF @BrandID = 107       
        SET @iCenterID = 1;       
    ELSE IF @BrandID = 110      
        SET @iCenterID = 36;      
    ELSE
        SET @iCenterID = (SELECT TOP 1 I_Centre_Id FROM T_Brand_Center_Details WHERE I_Brand_ID = @BrandID);

    -- Temporary table for top follow-up
    CREATE TABLE #TempTopFollowUpDate         
    (        
        I_Enquiry_Regn_ID int,        
        Dt_Next_Followup_Date datetime,      
        FollowupType_ID int,    
        S_Followup_Status char,    
        S_FollowupStatus_Desc nvarchar(100)    
    );

    -- Insert top follow-up record for each enquiry
    INSERT INTO #TempTopFollowUpDate        
    SELECT F.I_Enquiry_Regn_ID, F.Dt_Next_Followup_Date, F.ERP_R_I_FollowupType_ID, 
           F.S_Followup_Status, M.S_FollowupStatus_Desc    
    FROM dbo.T_Enquiry_Regn_Detail A        
    LEFT JOIN 
    (
        SELECT I_Followup_ID, I_Enquiry_Regn_ID, Dt_Next_Followup_Date, ERP_R_I_FollowupType_ID, S_Followup_Status,
               ROW_NUMBER() OVER (PARTITION BY I_Enquiry_Regn_ID ORDER BY I_Followup_ID DESC) AS RowNumber        
        FROM T_Enquiry_Regn_Followup
    ) F ON A.I_Enquiry_Regn_ID = F.I_Enquiry_Regn_ID      
    LEFT JOIN T_ERP_Followup_StatusM M 
           ON M.I_FollowupStatus_ID = CAST(F.S_Followup_Status AS INT)    
    WHERE (F.RowNumber = 1 OR F.I_Followup_ID IS NULL) -- top follow-up or none
      AND A.R_I_School_Session_ID = @sessionID;

    DECLARE @TotalRecords int, @FilteredRecords int;

    -- Count total records
    SELECT @TotalRecords = COUNT(*)          
    FROM dbo.T_Enquiry_Regn_Detail A                
    INNER JOIN T_ERP_Admission_Stage_Master TEASM 
            ON TEASM.I_Admission_Stage_ID = A.R_I_AdmStgTypeID            
    LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS 
            ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID                
    LEFT JOIN Enquiry_Source_Details AS ESD 
            ON ESD.I_Info_Source_ID=A.I_Info_Source_ID 
           AND ESD.I_Enquiry_ID=A.I_Enquiry_Regn_ID 
           AND ESD.I_Status=1              
    LEFT JOIN T_Enquiry_Course AS TEC 
            ON TEC.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID   -- ✅ FIXED               
    LEFT JOIN T_Course_Group_Class_Mapping AS TCGCM 
            ON TCGCM.I_Course_ID = TEC.I_Course_ID              
    LEFT JOIN T_Class AS TC ON TC.I_Class_ID = A.I_Class_ID              
    WHERE A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id )       
      AND A.R_I_School_Session_ID = @sessionID
      AND B_IsPreEnquiry = 1            
      AND I_ERP_Entry = 1
      AND (A.App_Payment_Status = 0 OR A.App_Payment_Status IS NULL);

    -- Final selection
    SELECT  
        ISNULL(A.I_Tab_No,0) AS TabNo,
        A.I_Enquiry_Regn_ID AS EnquiryRegnID,              
        A.S_Enquiry_No AS EnquiryNo,                
        A.I_Enquiry_Type_ID AS EnquiryTypeID,              
        A.Dt_Crtd_On AS LeadDate,              
        CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) AS FullName,              
        A.S_Mobile_No AS MobileNumber,              
        TEC.I_Course_ID AS CourseID,              
        A.I_Class_ID AS CourseAppliedForID,              
        TC.S_Class_Name AS CourseAppliedFor,            
        A.R_I_AdmStgTypeID AS AdmissionStage,              
        TEASM.S_Admission_Current_Stage AS AdmissionCurrentStage,            
        TEASM.S_Admission_Current_Stage_Desc AS AdmissionCurrentStageDesc,            
        TEASM.S_Admission_Next_Stage AS AdmissionNextStage,            
        TEASM.S_Admission_Next_Stage_Desc AS AdmissionNextStageDesc,                 
        A.App_Payment_Status AS ApplicationPayment,          
        A.I_Is_Active AS IsActive,              
        A.S_Father_Name AS FatherName,                
        A.S_Mother_Name AS MotherName,          
        F.Dt_Next_Followup_Date AS NextFollowUpDate,        
        ISNULL(F.S_FollowupStatus_Desc,'NA') AS FollowupStatusDesc,    
        F.S_Followup_Status,    
        @TotalRecords AS TotalRecords          
    FROM dbo.T_Enquiry_Regn_Detail A                
    INNER JOIN T_ERP_Admission_Stage_Master TEASM 
            ON TEASM.I_Admission_Stage_ID = A.R_I_AdmStgTypeID            
    LEFT JOIN T_Enquiry_Course AS TEC 
            ON TEC.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID   -- ✅ FIXED
    LEFT JOIN T_Class AS TC 
            ON TC.I_Class_ID = A.I_Class_ID        
    LEFT JOIN #TempTopFollowUpDate F 
            ON F.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID        
    WHERE A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id )    
      AND A.R_I_School_Session_ID=@sessionID  
      AND A.I_Enquiry_Regn_ID=ISNULL(@IEnquiryID, A.I_Enquiry_Regn_ID)              
      AND B_IsPreEnquiry = 1     
      AND I_ERP_Entry = 1
      AND (A.App_Payment_Status=0 OR A.App_Payment_Status IS NULL)
    ORDER BY
        CASE WHEN (@SortCol = 0 AND @SortDir = 'asc') THEN A.I_Enquiry_Regn_ID END ASC,
        CASE WHEN (@SortCol = 0 AND @SortDir = 'desc') THEN A.I_Enquiry_Regn_ID END DESC
    OFFSET @Offset ROWS
    FETCH NEXT @Limit ROWS ONLY;

    DROP TABLE #TempTopFollowUpDate;
END



--------------------------------------------------------------------------------------------------

--ALTER PROCEDURE [dbo].[ERP_uspGetPreEnquiryDetails_POC]                          
--(                
--    @IEnquiryID INT = NULL ,               
--    @S_Fullname VARCHAR(MAX) = NULL,              
--    @S_FatherName VARCHAR(MAX) = NULL,            
--    @S_MotherName VARCHAR(MAX) = NULL,            
--    @sMobileNo VARCHAR(20) = NULL ,            
--    @AdmissionStageID INT = NULL,            
--    @iCenterID INT = NULL,          
--    @Limit INT,          
--    @Offset INT,          
--    @SortCol INT,          
--    @SortDir varchar(10),          
--    @Search varchar(max) = NULL,      
--    @BrandID int ,    
--    @FollowTypeID int=Null,    
--    @FollowupStatusID char = null,    
--    @datefiltervalue int=Null,  
--    @sessionID int=Null  
--)                
--AS                
--BEGIN        
--    SET NOCOUNT ON;

--    DECLARE @Nextdt date;
    
--    IF @datefiltervalue IS NOT NULL
--        SET @Nextdt = DATEADD(day, @datefiltervalue, GETDATE());
--    ELSE
--        SET @Nextdt = NULL;

--    -- Determine center ID based on brand
--    IF @BrandID = 107       
--        SET @iCenterID = 1;       
--    ELSE IF @BrandID = 110      
--        SET @iCenterID = 36;      
--    ELSE
--        SET @iCenterID = (SELECT TOP 1 I_Centre_Id FROM T_Brand_Center_Details WHERE I_Brand_ID = @BrandID);

--    -- Temporary table for top follow-up
--    CREATE TABLE #TempTopFollowUpDate         
--    (        
--        I_Enquiry_Regn_ID int,        
--        Dt_Next_Followup_Date datetime,      
--        FollowupType_ID int,    
--        S_Followup_Status char,    
--        S_FollowupStatus_Desc nvarchar(100)    
--    );

--    -- Insert top follow-up record for each enquiry
--    INSERT INTO #TempTopFollowUpDate        
--    SELECT F.I_Enquiry_Regn_ID, F.Dt_Next_Followup_Date, F.ERP_R_I_FollowupType_ID, F.S_Followup_Status, M.S_FollowupStatus_Desc    
--    FROM dbo.T_Enquiry_Regn_Detail A        
--    LEFT JOIN 
--    (
--        SELECT I_Followup_ID, I_Enquiry_Regn_ID, Dt_Next_Followup_Date, ERP_R_I_FollowupType_ID, S_Followup_Status,
--               ROW_NUMBER() OVER (PARTITION BY I_Enquiry_Regn_ID ORDER BY I_Followup_ID DESC) AS RowNumber        
--        FROM T_Enquiry_Regn_Followup
--    ) F ON A.I_Enquiry_Regn_ID = F.I_Enquiry_Regn_ID      
--    LEFT JOIN T_ERP_Followup_StatusM M ON M.I_FollowupStatus_ID = CAST(F.S_Followup_Status AS INT)    
--    WHERE (F.RowNumber = 1 OR F.I_Followup_ID IS NULL) -- top follow-up or none
--      AND A.R_I_School_Session_ID = @sessionID;

--    DECLARE @TotalRecords int, @FilteredRecords int;

--    -- Count total records
--    SELECT @TotalRecords = COUNT(*)          
--    FROM dbo.T_Enquiry_Regn_Detail A                
--    INNER JOIN T_ERP_Admission_Stage_Master TEASM ON TEASM.I_Admission_Stage_ID = A.R_I_AdmStgTypeID            
--    LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID                
--    LEFT JOIN Enquiry_Source_Details AS ESD ON ESD.I_Info_Source_ID=A.I_Info_Source_ID AND ESD.I_Enquiry_ID=A.I_Enquiry_Regn_ID AND ESD.I_Status=1              
--    LEFT JOIN T_Enquiry_Course AS TEC ON TEC.I_Enquiry_Regn_ID = @IEnquiryID              
--    LEFT JOIN T_Course_Group_Class_Mapping AS TCGCM ON TCGCM.I_Course_ID = TEC.I_Course_ID              
--    LEFT JOIN T_Class AS TC ON TC.I_Class_ID = A.I_Class_ID              
--    WHERE A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id )       
--      AND A.R_I_School_Session_ID = @sessionID
--      AND B_IsPreEnquiry = 1            
--      AND I_ERP_Entry = 1
--      AND (A.App_Payment_Status = 0 OR A.App_Payment_Status IS NULL);

--    -- Count filtered records
--    SELECT @FilteredRecords = COUNT(*)           
--    FROM (
--        SELECT A.I_Enquiry_Regn_ID          
--        FROM dbo.T_Enquiry_Regn_Detail A                
--        INNER JOIN T_ERP_Admission_Stage_Master TEASM ON TEASM.I_Admission_Stage_ID = A.R_I_AdmStgTypeID            
--        LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID                
--        LEFT JOIN Enquiry_Source_Details AS ESD ON ESD.I_Info_Source_ID=A.I_Info_Source_ID AND ESD.I_Enquiry_ID=A.I_Enquiry_Regn_ID AND ESD.I_Status=1                
--        LEFT JOIN T_Enquiry_Course AS TEC ON TEC.I_Enquiry_Regn_ID = @IEnquiryID              
--        LEFT JOIN T_Course_Group_Class_Mapping AS TCGCM ON TCGCM.I_Course_ID = TEC.I_Course_ID              
--        LEFT JOIN T_Class AS TC ON TC.I_Class_ID = A.I_Class_ID              
--        WHERE A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id )    
--          AND A.R_I_School_Session_ID = @sessionID
--          AND A.I_Enquiry_Regn_ID = ISNULL(@IEnquiryID, A.I_Enquiry_Regn_ID)              
--          AND (@S_FatherName IS NULL OR A.S_Father_Name LIKE '%' + @S_FatherName + '%')             
--          AND (@S_MotherName IS NULL OR A.S_Mother_Name LIKE '%' + @S_MotherName + '%')             
--          AND (CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) LIKE '%' + @S_Fullname + '%' OR @S_Fullname IS NULL)              
--          AND S_Mobile_No = ISNULL(@sMobileNo, S_Mobile_No)                
--          AND B_IsPreEnquiry = 1            
--          AND I_ERP_Entry = 1            
--          AND (A.App_Payment_Status=0 OR A.App_Payment_Status IS NULL)            
--          AND A.R_I_AdmStgTypeID = ISNULL(@AdmissionStageID, A.R_I_AdmStgTypeID)            
--          AND (@Search IS NULL OR A.S_Enquiry_No LIKE '%' + @Search + '%' 
--               OR CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) LIKE '%' + @Search + '%' 
--               OR A.S_Mobile_No LIKE '%' + @Search + '%' 
--               OR TC.S_Class_Name LIKE '%' + @Search + '%' 
--               OR TEASM.S_Admission_Current_Stage LIKE '%' + @Search + '%' 
--               OR TEASM.S_Admission_Current_Stage_Desc LIKE '%' + @Search + '%' 
--               OR TEASM.S_Admission_Next_Stage LIKE '%' + @Search + '%' 
--               OR TEASM.S_Admission_Next_Stage_Desc LIKE '%' + @Search + '%')
--    ) AS CountedRecords;

--    -- Final selection with follow-up filters (Koushik modification)
--    SELECT  
--        ISNULL(A.I_Tab_No,0) AS TabNo,
--        A.I_Enquiry_Regn_ID AS EnquiryRegnID,              
--        A.S_Enquiry_No AS EnquiryNo,                
--        A.I_Enquiry_Type_ID AS EnquiryTypeID,              
--        A.Dt_Crtd_On AS LeadDate,              
--        CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) AS FullName,              
--        A.S_Mobile_No AS MobileNumber,              
--        TEC.I_Course_ID AS CourseID,              
--        A.I_Class_ID AS CourseAppliedForID,              
--        TC.S_Class_Name AS CourseAppliedFor,            
--        A.R_I_AdmStgTypeID AS AdmissionStage,              
--        TEASM.S_Admission_Current_Stage AS AdmissionCurrentStage,            
--        TEASM.S_Admission_Current_Stage_Desc AS AdmissionCurrentStageDesc,            
--        TEASM.S_Admission_Next_Stage AS AdmissionNextStage,            
--        TEASM.S_Admission_Next_Stage_Desc AS AdmissionNextStageDesc,                 
--        A.App_Payment_Status AS ApplicationPayment,          
--        A.I_Is_Active AS IsActive,              
--        A.S_Father_Name AS FatherName,                
--        A.S_Mother_Name AS MotherName,          
--        F.Dt_Next_Followup_Date AS NextFollowUpDate,        
--        ISNULL(F.S_FollowupStatus_Desc,'NA') AS FollowupStatusDesc,    
--        F.S_Followup_Status,    
--        @TotalRecords AS TotalRecords,          
--        @FilteredRecords AS FilteredRecords          
--    FROM dbo.T_Enquiry_Regn_Detail A                
--    INNER JOIN T_ERP_Admission_Stage_Master TEASM ON TEASM.I_Admission_Stage_ID = A.R_I_AdmStgTypeID            
--    LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus AS TEECS ON TEECS.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID                
--    LEFT JOIN Enquiry_Source_Details AS ESD ON ESD.I_Info_Source_ID=A.I_Info_Source_ID AND ESD.I_Enquiry_ID=A.I_Enquiry_Regn_ID AND ESD.I_Status=1
--    LEFT JOIN T_Enquiry_Course AS TEC ON TEC.I_Enquiry_Regn_ID = @IEnquiryID              
--    LEFT JOIN T_Course_Group_Class_Mapping AS TCGCM ON TCGCM.I_Course_ID = TEC.I_Course_ID              
--    LEFT JOIN T_Class AS TC ON TC.I_Class_ID = A.I_Class_ID        
--    LEFT JOIN #TempTopFollowUpDate F ON F.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID        
--    WHERE A.I_Centre_Id = ISNULL(@iCenterID, A.I_Centre_Id )    
--      AND A.R_I_School_Session_ID=@sessionID  
--      AND A.I_Enquiry_Regn_ID=ISNULL(@IEnquiryID, A.I_Enquiry_Regn_ID)              
--      AND (@S_FatherName IS NULL OR A.S_Father_Name LIKE '%' + @S_FatherName + '%')             
--      AND (@S_MotherName IS NULL OR A.S_Mother_Name LIKE '%' + @S_MotherName + '%')             
--      AND (CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) LIKE '%' + @S_Fullname + '%' OR @S_Fullname IS NULL)              
--      AND S_Mobile_No = ISNULL(@sMobileNo, S_Mobile_No)                
--      AND B_IsPreEnquiry = 1     
--      -- Koushik modification to include enquiries with no follow-ups
--      AND (@FollowupStatusID IS NULL OR F.S_Followup_Status = @FollowupStatusID OR F.I_Enquiry_Regn_ID IS NULL)
--      AND (@Nextdt IS NULL OR F.I_Enquiry_Regn_ID IS NULL OR (CONVERT(Date,F.Dt_Next_Followup_Date) >= CONVERT(Date,GETDATE()) AND CONVERT(Date,F.Dt_Next_Followup_Date) < @Nextdt))
--      AND I_ERP_Entry = 1
--      AND (A.App_Payment_Status=0 OR A.App_Payment_Status IS NULL)
--      AND A.R_I_AdmStgTypeID = ISNULL(@AdmissionStageID, A.R_I_AdmStgTypeID)
--      AND (@Search IS NULL OR A.S_Enquiry_No LIKE '%' + @Search + '%' 
--           OR CONCAT(COALESCE(A.S_First_Name+' ', ''), COALESCE(A.S_Middle_Name+' ', ''), COALESCE(A.S_Last_Name, '')) LIKE '%' + @Search + '%' 
--           OR A.S_Mobile_No LIKE '%' + @Search + '%' 
--           OR TC.S_Class_Name LIKE '%' + @Search + '%' 
--           OR TEASM.S_Admission_Current_Stage LIKE '%' + @Search + '%' 
--           OR TEASM.S_Admission_Current_Stage_Desc LIKE '%' + @Search + '%' 
--           OR TEASM.S_Admission_Next_Stage LIKE '%' + @Search + '%' 
--           OR TEASM.S_Admission_Next_Stage_Desc LIKE '%' + @Search + '%')
--    ORDER BY
--        CASE WHEN (@SortCol = 0 AND @SortDir = 'asc') THEN A.I_Enquiry_Regn_ID END ASC,
--        CASE WHEN (@SortCol = 0 AND @SortDir = 'desc') THEN A.I_Enquiry_Regn_ID END DESC
--    OFFSET @Offset ROWS
--    FETCH NEXT @Limit ROWS ONLY;

--    DROP TABLE #TempTopFollowUpDate;
--END


