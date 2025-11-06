CREATE PROCEDURE [dbo].[usp_ERP_StudentFuzzySearch]    
(    
    @brandid INT,    
    @StudentID NVARCHAR(MAX) = NULL,    
    @StudentName NVARCHAR(MAX) = NULL,    
    @Search NVARCHAR(MAX) = NULL    
)    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    -- Get total records count (students + enquiries)  
    DECLARE @TotalRecords INT;    
    SELECT @TotalRecords = (  
        SELECT COUNT(*) FROM [dbo].[T_Student_Detail] AS SD    
        JOIN [dbo].[T_Student_Class_Section] AS SCS     
            ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID    
        WHERE SCS.I_Brand_ID = @brandid AND SD.I_Status = 1  
    ) + (  
        SELECT COUNT(*) FROM [dbo].[T_Enquiry_Regn_Detail] AS ER  
        INNER JOIN [dbo].[T_Brand_Center_Details] AS BCD  
            ON ER.I_Centre_Id = BCD.I_Centre_Id  
        WHERE BCD.I_Brand_ID = @brandid AND ER.I_Is_Active = 1  
    );  
    
    -- Get filtered records count  
    DECLARE @FilteredRecords INT;    
    SELECT @FilteredRecords = (  
        -- Count students matching criteria  
        SELECT COUNT(*)    
        FROM [dbo].[T_Student_Detail] AS SD    
        JOIN [dbo].[T_Student_Class_Section] AS SCS     
            ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID    
        INNER JOIN [dbo].[T_School_Group_Class] AS SGC     
            ON SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID    
        INNER JOIN [dbo].[T_School_Group] AS SG     
            ON SGC.I_School_Group_ID = SG.I_School_Group_ID    
        INNER JOIN [dbo].[T_Class] AS TC     
            ON TC.I_Class_ID = SGC.I_Class_ID    
        INNER JOIN T_Enquiry_Regn_Detail ER     
            ON ER.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID    
        WHERE SCS.I_Brand_ID = @brandid    
          AND SD.I_Status = 1    
          AND (    
                @StudentName IS NULL OR     
                LTRIM(RTRIM(REPLACE(REPLACE(    
                    ISNULL(SD.S_First_Name, '') +    
                    CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +    
                    CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,    
                    '  ', ' '    
                ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'    
            )    
          AND (@StudentID IS NULL OR SD.S_Student_ID LIKE @StudentID + '%')    
          AND (    
                @Search IS NULL OR     
                SD.S_Student_ID LIKE '%' + @Search + '%' OR     
                LTRIM(RTRIM(REPLACE(REPLACE(    
                    ISNULL(SD.S_First_Name, '') +    
                    CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +    
                    CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,    
                    '  ', ' '    
                ), '  ', ' '))) LIKE '%' + @Search + '%' OR     
                SCS.S_Class_Roll_No LIKE '%' + @Search + '%' OR     
                SD.S_Mobile_No LIKE '%' + @Search + '%' OR     
                ER.S_Enquiry_No = @Search  -- Exact match for enquiry number  
            )  
    ) + (  
        -- Count enquiries matching criteria (only if no student record exists)  
        SELECT COUNT(*)    
        FROM [dbo].[T_Enquiry_Regn_Detail] AS ER  
        INNER JOIN [dbo].[T_Brand_Center_Details] AS BCD  
            ON ER.I_Centre_Id = BCD.I_Centre_Id  
        LEFT JOIN [dbo].[T_Class] AS TC_Enquiry  
            ON ER.I_Class_ID = TC_Enquiry.I_Class_ID  
        WHERE BCD.I_Brand_ID = @brandid    
          AND ER.I_Is_Active = 1  
          AND NOT EXISTS (  
              SELECT 1 FROM [dbo].[T_Student_Detail] AS SD   
              WHERE SD.I_Enquiry_Regn_ID = ER.I_Enquiry_Regn_ID  
          )  
          AND (    
                @StudentName IS NULL OR     
                LTRIM(RTRIM(REPLACE(REPLACE(    
                    ISNULL(ER.S_First_Name, '') +    
                    CASE WHEN ER.S_Middle_Name IS NULL OR LTRIM(RTRIM(ER.S_Middle_Name)) = '' THEN '' ELSE ' ' + ER.S_Middle_Name END +    
                    CASE WHEN ER.S_Last_Name IS NULL OR LTRIM(RTRIM(ER.S_Last_Name)) = '' THEN '' ELSE ' ' + ER.S_Last_Name END,    
                    '  ', ' '    
                ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'    
            )    
          AND (    
                @Search IS NULL OR     
                LTRIM(RTRIM(REPLACE(REPLACE(    
                    ISNULL(ER.S_First_Name, '') +    
                    CASE WHEN ER.S_Middle_Name IS NULL OR LTRIM(RTRIM(ER.S_Middle_Name)) = '' THEN '' ELSE ' ' + ER.S_Middle_Name END +    
                    CASE WHEN ER.S_Last_Name IS NULL OR LTRIM(RTRIM(ER.S_Last_Name)) = '' THEN '' ELSE ' ' + ER.S_Last_Name END,    
                    '  ', ' '    
                ), '  ', ' '))) LIKE '%' + @Search + '%' OR     
                ER.S_Mobile_No LIKE '%' + @Search + '%' OR     
                ER.S_Enquiry_No = @Search  -- Exact match for enquiry number  
            )  
    );  
    
    -- Main query combining students and enquiries  
    SELECT     
        SD.S_Student_ID AS StudentID,    
        SD.I_Student_Detail_ID AS StudentDetailID,    
        LTRIM(RTRIM(REPLACE(REPLACE(    
            ISNULL(SD.S_First_Name, '') +    
            CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +    
            CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,    
            '  ', ' '    
        ), '  ', ' '))) AS FullName,    
        SCS.S_Class_Roll_No AS RollNo,    
        SD.S_Mobile_No AS MobileNo,    
        SD.I_Status AS StudentStatus,    
        @TotalRecords AS TotalRecords,    
        @FilteredRecords AS FilteredRecords,    
        SCS.I_Status AS Status,    
        TC.S_Class_Name AS Class,    
        ER.S_Enquiry_No AS EnquiryNo,  
        'Student' AS RecordType  -- Indicates this is a student record  
    FROM [dbo].[T_Student_Detail] AS SD    
    JOIN [dbo].[T_Student_Class_Section] AS SCS     
        ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID    
    INNER JOIN T_Enquiry_Regn_Detail ER     
        ON ER.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID    
    INNER JOIN [dbo].[T_School_Group_Class] AS SGC     
        ON SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID    
    INNER JOIN [dbo].[T_School_Group] AS SG     
        ON SGC.I_School_Group_ID = SG.I_School_Group_ID    
    INNER JOIN [dbo].[T_Class] AS TC     
        ON TC.I_Class_ID = SGC.I_Class_ID    
    WHERE SCS.I_Brand_ID = @brandid    
      AND SD.I_Status = 1 AND SCS.I_Status = 1    
      AND (    
            @StudentName IS NULL OR     
            LTRIM(RTRIM(REPLACE(REPLACE(    
                ISNULL(SD.S_First_Name, '') +    
                CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +    
                CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,    
                '  ', ' '    
            ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'    
        )    
      AND (@StudentID IS NULL OR SD.S_Student_ID LIKE @StudentID + '%')    
      AND (    
            @Search IS NULL OR     
            SD.S_Student_ID LIKE '%' + @Search + '%' OR     
            LTRIM(RTRIM(REPLACE(REPLACE(    
                ISNULL(SD.S_First_Name, '') +    
                CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +    
                CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,    
                '  ', ' '    
            ), '  ', ' '))) LIKE '%' + @Search + '%' OR     
       SCS.S_Class_Roll_No LIKE '%' + @Search + '%' OR     
            SD.S_Mobile_No LIKE '%' + @Search + '%' OR     
            ER.S_Enquiry_No = @Search  -- Exact match for enquiry number  
        )  
      
    UNION ALL  
      
    -- Add enquiry records (only those without student records)  
    SELECT     
        NULL AS StudentID,  -- No student ID for enquiries  
        NULL AS StudentDetailID,  -- No student detail ID for enquiries  
        LTRIM(RTRIM(REPLACE(REPLACE(    
            ISNULL(ER.S_First_Name, '') +    
            CASE WHEN ER.S_Middle_Name IS NULL OR LTRIM(RTRIM(ER.S_Middle_Name)) = '' THEN '' ELSE ' ' + ER.S_Middle_Name END +    
            CASE WHEN ER.S_Last_Name IS NULL OR LTRIM(RTRIM(ER.S_Last_Name)) = '' THEN '' ELSE ' ' + ER.S_Last_Name END,    
            '  ', ' '    
        ), '  ', ' '))) AS FullName,    
        NULL AS RollNo,  -- No roll no for enquiries  
        ER.S_Mobile_No AS MobileNo,    
        ER.I_Enquiry_Status_Code AS StudentStatus,    
        @TotalRecords AS TotalRecords,    
        @FilteredRecords AS FilteredRecords,    
        ER.I_Is_Active AS Status,    
        TC_Enquiry.S_Class_Name AS Class,  -- Get class name from enquiry's class ID  
        ER.S_Enquiry_No AS EnquiryNo,  
        'Enquiry' AS RecordType  -- Indicates this is an enquiry record  
    FROM [dbo].[T_Enquiry_Regn_Detail] AS ER  
    INNER JOIN [dbo].[T_Brand_Center_Details] AS BCD  
        ON ER.I_Centre_Id = BCD.I_Centre_Id  
    LEFT JOIN [dbo].[T_Class] AS TC_Enquiry  -- Join with class table for enquiry class  
        ON ER.I_Class_ID = TC_Enquiry.I_Class_ID  
    WHERE BCD.I_Brand_ID = @brandid    
      AND ER.I_Is_Active = 1  
      AND NOT EXISTS (  
          SELECT 1 FROM [dbo].[T_Student_Detail] AS SD   
          WHERE SD.I_Enquiry_Regn_ID = ER.I_Enquiry_Regn_ID  
      )  
      AND (    
            @StudentName IS NULL OR     
            LTRIM(RTRIM(REPLACE(REPLACE(    
                ISNULL(ER.S_First_Name, '') +    
                CASE WHEN ER.S_Middle_Name IS NULL OR LTRIM(RTRIM(ER.S_Middle_Name)) = '' THEN '' ELSE ' ' + ER.S_Middle_Name END +    
                CASE WHEN ER.S_Last_Name IS NULL OR LTRIM(RTRIM(ER.S_Last_Name)) = '' THEN '' ELSE ' ' + ER.S_Last_Name END,    
                '  ', ' '    
            ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'    
        )    
      AND (    
            @Search IS NULL OR     
            LTRIM(RTRIM(REPLACE(REPLACE(    
                ISNULL(ER.S_First_Name, '') +    
                CASE WHEN ER.S_Middle_Name IS NULL OR LTRIM(RTRIM(ER.S_Middle_Name)) = '' THEN '' ELSE ' ' + ER.S_Middle_Name END +    
                CASE WHEN ER.S_Last_Name IS NULL OR LTRIM(RTRIM(ER.S_Last_Name)) = '' THEN '' ELSE ' ' + ER.S_Last_Name END,    
                '  ', ' '    
            ), '  ', ' '))) LIKE '%' + @Search + '%' OR     
            ER.S_Mobile_No LIKE '%' + @Search + '%' OR     
            ER.S_Enquiry_No = @Search  -- Exact match for enquiry number  
        )  
    ORDER BY FullName;  
END
