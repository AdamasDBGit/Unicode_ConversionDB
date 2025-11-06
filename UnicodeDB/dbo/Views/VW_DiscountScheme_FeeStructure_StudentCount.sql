
CREATE VIEW dbo.VW_DiscountScheme_FeeStructure_StudentCount
AS
WITH FeeStructureData AS (
    SELECT
        dcm.I_Discount_Scheme_ID,
        fs.I_Fee_Structure_ID,
        fs.S_Fee_Structure_Name,
        COUNT(DISTINCT ivp.I_Student_Detail_ID) AS StudentCount
    FROM T_Invoice_Child_Header ICH
    INNER JOIN T_Discount_Scheme_Master DCM 
        ON dcm.I_Discount_Scheme_ID = ICH.I_Discount_Scheme_ID
    INNER JOIN T_Course_Fee_Plan cfp 
        ON cfp.I_Course_Fee_Plan_ID = ich.I_Course_FeePlan_ID
    INNER JOIN T_ERP_Fee_Structure fs 
        ON fs.I_Fee_Structure_ID = cfp.I_New_I_Fee_Structure_ID
    INNER JOIN T_Invoice_Parent ivp 
        ON ivp.I_Invoice_Header_ID = ich.I_Invoice_Header_ID
    WHERE ISNULL(ich.I_Discount_Scheme_ID, 0) <> 0
     -- AND dcm.I_Discount_Scheme_ID IN (3, 2, 6)
    GROUP BY 
        dcm.I_Discount_Scheme_ID,
        fs.I_Fee_Structure_ID,
        fs.S_Fee_Structure_Name
)
SELECT
    d.I_Discount_Scheme_ID,

    -- Concatenated Fee Structure Names with (StudentCount)
    STUFF((
        SELECT ', ' + fd_inner.S_Fee_Structure_Name + ' [' + CAST(fd_inner.StudentCount AS VARCHAR(10)) + ']'
        FROM FeeStructureData fd_inner
        WHERE fd_inner.I_Discount_Scheme_ID = d.I_Discount_Scheme_ID
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS S_Fee_Structure_Name,

    -- Total Fee Structure Count per I_Discount_Scheme_ID
    COUNT(DISTINCT d.I_Fee_Structure_ID) AS Total_Fee_Structure_Count,

    -- Total Student Count across all fee structures for I_Discount_Scheme_ID
    SUM(d.StudentCount) AS Total_StudentCount

FROM 
    FeeStructureData d
GROUP BY 
    d.I_Discount_Scheme_ID;
