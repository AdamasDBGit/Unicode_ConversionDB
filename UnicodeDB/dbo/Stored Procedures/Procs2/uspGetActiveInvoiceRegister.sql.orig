CREATE PROCEDURE [dbo].[uspGetActiveInvoiceRegister]      
    (      
      @iSelectedHierarchyId int,      
      @iSelectedBrandId int,      
      @dtDateTo datetime = null,      
      @dtDateFrom datetime = null,      
      @dtCurrentDate datetime,      
      @sFName varchar(50) = null,      
      @sMName varchar(50) = null,      
      @sLName varchar(50) = NULL,    
      @sStudentCode VARCHAR(100) = NULL,    
      @sInvoiceNo VARCHAR(50) = NULL        
    )      
AS       
    BEGIN      
        SET NOCOUNT ON ;      
            DECLARE @sSearchCriteria varchar(100)      
        DECLARE @TempCenter TABLE ( I_Center_ID int )      
        SELECT  @sSearchCriteria = S_Hierarchy_Chain      
        from    T_Hierarchy_Mapping_Details      
        where   I_Hierarchy_detail_id = @iSelectedHierarchyId      
        IF @iSelectedBrandId = 0       
            BEGIN      
                INSERT  INTO @TempCenter      
                        SELECT  TCHD.I_Center_Id      
                        FROM    T_CENTER_HIERARCHY_DETAILS TCHD      
                        WHERE   TCHD.I_Hierarchy_Detail_ID IN (      
                                SELECT  I_HIERARCHY_DETAIL_ID      
                                FROM    T_Hierarchy_Mapping_Details      
                                WHERE   I_Status = 1      
                                        AND DATEDIFF(DD, @dtCurrentDate,      
                                                     ISNULL(DT_VALID_FROM,      
                                                            @dtCurrentDate)) <= 0      
                                        AND DATEDIFF(DD, @dtCurrentDate,      
                                                     ISNULL(DT_VALID_TO,      
                                                            @dtCurrentDate)) >= 0      
                                        AND S_Hierarchy_Chain LIKE @sSearchCriteria      
                                        + '%' )      
            END        
        ELSE       
            BEGIN       
                INSERT  INTO @TempCenter      
                        SELECT  TCHD.I_Center_Id      
                        FROM    T_CENTER_HIERARCHY_DETAILS TCHD,      
                                T_BRAND_CENTER_DETAILS TBCD      
                        WHERE   TCHD.I_Hierarchy_Detail_ID IN (      
                                SELECT  I_HIERARCHY_DETAIL_ID      
                                FROM    T_Hierarchy_Mapping_Details      
                                WHERE   I_Status = 1      
                                        AND DATEDIFF(DD, @dtCurrentDate,      
                                                     ISNULL(DT_VALID_FROM,      
                                                            @dtCurrentDate)) <= 0      
                                        AND DATEDIFF(DD, @dtCurrentDate,      
                                                     ISNULL(DT_VALID_TO,      
                                                            @dtCurrentDate)) >= 0      
                                        AND S_Hierarchy_Chain LIKE @sSearchCriteria      
                                        + '%' )      
                                AND TBCD.I_Brand_ID = @iSelectedBrandId      
                                AND TBCD.I_Centre_Id = TCHD.I_Center_Id      
            END      
        DECLARE @InvoiceDetail TABLE      
            (      
              S_Invoice_No VARCHAR(100),      
              I_Invoice_Header_ID INT,      
              N_Invoice_Amount NUMERIC(18, 2),      
              Dt_Invoice_Date DATETIME,      
              I_Student_Detail_ID INT,      
              S_Student_ID VARCHAR(100),      
              S_First_Name VARCHAR(100),      
              S_Middle_Name VARCHAR(100),      
              S_Last_Name VARCHAR(100),      
              I_Status INT,      
              I_Centre_Id INT,      
              I_Currency_ID INT,      
              N_Tax_Amount NUMERIC(18, 2),      
              S_Center_Code VARCHAR(50),      
              S_Center_Short_Name VARCHAR(50)      
            )      
        INSERT  INTO @InvoiceDetail      
                SELECT  IP.S_Invoice_No,      
    IP.I_Invoice_Header_ID,      
                        IP.N_Invoice_Amount,      
                        IP.Dt_Invoice_Date,      
                        IP.I_Student_Detail_ID,      
                        SD.S_Student_ID,      
                        SD.S_First_Name,      
                        SD.S_Middle_Name,      
                        SD.S_Last_Name,      
                        1,      
                        IP.I_Centre_Id,      
                        COU.I_Currency_ID,      
                        ISNULL(IP.N_Tax_Amount, 0) AS N_Tax_Amount,      
                        CM.S_Center_Code,      
                        CM.S_Center_Short_Name      
                FROM    dbo.T_Invoice_Parent IP      
                        INNER JOIN dbo.T_Student_Detail SD ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID      
                        INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON SD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID      
                        INNER JOIN dbo.T_Centre_Master CM ON IP.I_Centre_Id = CM.I_Centre_Id      
                        INNER JOIN dbo.T_Country_Master COU ON CM.I_Country_ID = COU.I_Country_ID      
                WHERE   IP.I_Centre_Id IN ( SELECT  I_Center_ID      
                                            FROM    @TempCenter )      
                        AND CAST(SUBSTRING(CAST(IP.Dt_Invoice_Date AS VARCHAR),      
                                           1, 11) as datetime) BETWEEN @dtDateFrom      
                                                               AND     @dtDateTo        
 --AND DATEDIFF(dd, @dtDateFrom,IP.Dt_Invoice_Date) >= 0       
                        AND DATEDIFF(dd, @dtDateTo, IP.Dt_Invoice_Date) <= 0      
                        AND ISNULL(SD.S_First_Name, '') LIKE ISNULL(@sFName, '')      
                        + '%'      
                        AND ISNULL(SD.S_Middle_Name, '') LIKE ISNULL(@sMName, '')      
                        + '%'      
                        AND ISNULL(SD.S_Last_Name, '') LIKE ISNULL(@sLName, '')      
                        + '%'          
                        --AND TERD.I_Corporate_Plan_ID IS NULL       
                        AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )             
      AND IP.S_Invoice_No LIKE ISNULL(@sInvoiceNo,IP.S_Invoice_No)+'%'             
	  AND IP.I_Status <> 0 
	  -- order by IP.Dt_Invoice_Date DESC         
                UNION ALL      
                SELECT  IP.S_Invoice_No,      
                        IP.I_Invoice_Header_ID,      
                        IP.N_Invoice_Amount,      
                        IP.Dt_Invoice_Date,      
                        IP.I_Student_Detail_ID,      
                        SD.S_Student_ID,      
                        SD.S_First_Name,      
                        SD.S_Middle_Name,      
                        SD.S_Last_Name,      
                        0,      
                        IP.I_Centre_Id,      
                        COU.I_Currency_ID,      
                        ISNULL(IP.N_Tax_Amount, 0) AS N_Tax_Amount,      
                        CM.S_Center_Code,      
                        CM.S_Center_Short_Name      
                FROM    dbo.T_Invoice_Parent IP      
                        INNER JOIN dbo.T_Student_Detail SD ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID      
                        INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON SD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID      
                        INNER JOIN dbo.T_Centre_Master CM ON IP.I_Centre_Id = CM.I_Centre_Id      
                        INNER JOIN dbo.T_Country_Master COU ON CM.I_Country_ID = COU.I_Country_ID      
                WHERE   IP.I_Centre_Id IN ( SELECT  I_Center_ID      
                                            FROM    @TempCenter )      
                        AND DATEDIFF(dd, @dtDateFrom, IP.Dt_Upd_On) >= 0     
                        AND DATEDIFF(dd, @dtDateTo, IP.Dt_Upd_On) <= 0         
  --AND DATEDIFF(dd, @dtDateFrom,IP.Dt_Invoice_Date) <= 0         
  --AND DATEDIFF(dd, @dtDateFrom, IP.Dt_Invoice_Date) >= 0         
                        AND ISNULL(SD.S_First_Name, '') LIKE ISNULL(@sFName, '')      
                        + '%'      
                        AND ISNULL(SD.S_Middle_Name, '') LIKE ISNULL(@sMName, '')      
                        + '%'      
                        AND ISNULL(SD.S_Last_Name, '') LIKE ISNULL(@sLName, '')      
                        + '%'       
                        --AND TERD.I_Corporate_Plan_ID IS NULL      
                        AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )             
      AND IP.S_Invoice_No LIKE ISNULL(@sInvoiceNo,IP.S_Invoice_No)+'%'             
      AND IP.I_Status <> 0
-- AND SD.I_Status <> 0       
-- order by IP.Dt_Invoice_Date DESC         
        SELECT  *      
        FROM    @InvoiceDetail      
        ORDER BY I_Invoice_Header_ID DESC      
    END
