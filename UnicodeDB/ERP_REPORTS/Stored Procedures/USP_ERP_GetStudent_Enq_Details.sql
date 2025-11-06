CREATE PROCEDURE ERP_REPORTS.USP_ERP_GetStudent_Enq_Details           
    @brandID INT,          
    @SchoolGroupID varchar(100)=NULL,          
    @SessionID INT,          
    @ClassID varchar(100)=NULL,          
    @Startdate DATE,          
    @Enddate DATE          
AS          
BEGIN          
    SET NOCOUNT ON;       
--  IF OBJECT_ID('tempdb..#SchoolGroup') IS NULL          
-- BEGIN     CREATE TABLE #SchoolGroup (         Id INT IDENTITY(1,1), SchoolGroupID INT     )          
-- END        
    
-- --step2          
--INSERT INTO #SchoolGroup (SchoolGroupID) -- Adjust ColumnName to match your table's column                                            
--SELECT Value                                            
--FROM dbo.ERP_SplitString(@SchoolGroupID, ',');       
--   select * from #SchoolGroup    
--  IF OBJECT_ID('tempdb..#class') IS NULL          
-- BEGIN     CREATE TABLE #class (         Id INT IDENTITY(1,1), ClassID INT     )          
-- END            
-- --step2          
--INSERT INTO #class (ClassID) -- Adjust ColumnName to match your table's column                                            
--SELECT Value                                            
--FROM dbo.ERP_SplitString(@ClassID, ',');       
--      select * from #class    
    SELECT DISTINCT           
        @brandID AS BrandID,          
        SD.S_Student_ID AS StudentID,          
        SD.S_First_Name +             
            CASE             
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''             
                THEN ' ' + SD.S_Middle_Name             
                ELSE ''             
            END +             
            ' ' + SD.S_Last_Name AS Studentname,          
        TC.S_Class_Name AS Class_Name,      
  SG.S_School_Group_Name AS SchoolGroup,      
        SD.S_Mobile_No AS Phone,          
        SD.S_Email_ID AS Email,          
        US.S_Sex_Name AS Gender,          
        RD.S_Enquiry_No AS EnquiryNo,          
        RD.S_Form_No AS FormNo,          
        ET.S_Enquiry_Type_Desc AS Enquiry_Type,          
        ISM.S_Info_Source_Name AS Source_Name,          
        CONVERT(DATE, SD.Dt_Crtd_On) AS AdmissionDate         
        --Inv.S_Invoice_No AS Invoice_No,          
       -- CONVERT(DATE, Inv.Dt_Invoice_Date) AS Last_Invoice_date         
        --CASE           
        --    WHEN Inv.I_Status = 1 THEN 'Active Invoice'          
        --    WHEN Inv.I_Status = 0 THEN 'Cancel Invoice'          
        --END AS Inv_Status          
    FROM T_Student_Detail SD          
    INNER JOIN T_Student_Class_Section SCS           
        ON SCS.I_Student_Detail_ID = SD.I_Student_Detail_ID          
    Left JOIN T_School_Group_Class SGC           
        ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID          
    Left JOIN T_Class TC           
        ON TC.I_Class_ID = SGC.I_Class_ID           
        AND TC.I_Brand_ID = @brandID          
    Left JOIN T_School_Group SG           
        ON SG.I_School_Group_ID = SGC.I_School_Group_ID          
        AND SG.I_Brand_Id = @brandID     
   --Inner Join #SchoolGroup tsg on tsg.SchoolGroupID=SG.I_School_Group_ID      
   --      Inner Join #class ttc on ttc.ClassID=TC.ClassId      
    LEFT JOIN T_Enquiry_Regn_Detail RD           
        ON SD.I_Enquiry_Regn_ID = RD.I_Enquiry_Regn_ID          
    LEFT JOIN T_User_Sex US           
        ON US.I_Sex_ID = RD.I_Sex_ID          
    LEFT JOIN T_Enquiry_Type ET           
        ON ET.I_Enquiry_Type_ID = RD.I_Enquiry_Type_ID          
    LEFT JOIN T_Information_Source_Master ISM           
        ON ISM.I_Info_Source_ID = RD.I_Info_Source_ID           
        AND ISM.I_ERP_Status = 1          
    --Left JOIN T_Invoice_Parent Inv           
    --    ON Inv.I_Student_Detail_ID = SD.I_Student_Detail_ID       
    
    WHERE           
        SCS.I_Brand_ID = @brandID           
        AND SCS.I_School_Session_ID = @SessionID         
        AND (SGC.I_School_Group_ID in (SELECT Value FROM dbo.ERP_SplitString(@SchoolGroupID, ',')) 
		OR @SchoolGroupID is NULL)
        AND (SGC.I_Class_ID in (SELECT Value FROM dbo.ERP_SplitString(@ClassID, ','))  
		OR @ClassID is NULL)
        AND (convert(date,sd.Dt_Crtd_On) BETWEEN @Startdate AND @Enddate)     
       -- and Inv.I_Status=1  
    ORDER BY SD.S_Student_ID;          
          
    SET NOCOUNT OFF;          
END; 