CREATE PROCEDURE [dbo].[ERP_uspSearchAdhocPaymentScheduleStudentDetails]  
(  
    @EnquiryNo INT = NULL,  
    @StudentID NVARCHAR(MAX) = NULL,  
    @StudentName NVARCHAR(MAX) = NULL,  
    @Limit INT,  
    @Offset INT,  
    @SortCol INT,  
    @SortDir NVARCHAR(MAX),  
    @Id INT = NULL,  
    @PaymentID INT = NULL,  
    @SearchValue NVARCHAR(MAX) = NULL  -- 🔍 New Parameter for Universal Search  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    WITH PaginatedData AS  
    (  
        SELECT   
            EAPSSD.inAdhocPaymentScheduleStudentDetailID AS Id,  
            SD.I_Student_Detail_ID AS StudentDetailID,  
            SD.S_Student_ID AS StudentID,  
            ERD.I_Enquiry_Regn_ID AS EnquiryNo,  
            SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name AS StudentName,  
            SG.S_School_Group_Name AS SchoolGroupName,  
            C.S_Class_Name + ' ' + ISNULL(S.S_Stream, '') + ' ' + Section.S_Section_Name AS Class,  
            SD.S_Mobile_No AS MobileNo,  
            EAPSD.dtEndDate AS DueDate,  
            EAPSD.sDescription AS Description,  
            EAPSSD.inPaymentStatus AS PaymentStatus,  
            EAPSSD.sInvoiceNo AS InvoiceNo,  
            EAPSSD.SRemarks AS Remarks,  
            EAPSD.inAdhocPaymentScheduleHeaderID AS PaymentID, 
            EAPSD.nAmount Amount,
            COUNT(*) OVER() AS TotalRecords,  
            ROW_NUMBER() OVER (  
                ORDER BY   
                    CASE WHEN @SortCol = 1 AND @SortDir = 'asc' THEN EAPSSD.sInvoiceNo END ASC,  
                    CASE WHEN @SortCol = 1 AND @SortDir = 'desc' THEN EAPSSD.sInvoiceNo END DESC,  
                    CASE WHEN @SortCol = 2 AND @SortDir = 'asc' THEN ERD.I_Enquiry_Regn_ID END ASC,  
                    CASE WHEN @SortCol = 2 AND @SortDir = 'desc' THEN ERD.I_Enquiry_Regn_ID END DESC,  
                    CASE WHEN @SortCol = 3 AND @SortDir = 'asc' THEN SD.S_Student_ID END ASC,  
                    CASE WHEN @SortCol = 3 AND @SortDir = 'desc' THEN SD.S_Student_ID END DESC,  
                    ERD.I_Enquiry_Regn_ID DESC  
            ) AS RowNum  
        FROM T_ERP_AdhocPaymentScheduleStudentDetail EAPSSD  
        INNER JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = EAPSSD.inStudentDetailID  
        INNER JOIN T_Enquiry_Regn_Detail ERD ON ERD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID  
        INNER JOIN T_ERP_AdhocPaymentScheduleHeaderDetail EAPSHD ON EAPSHD.inAdhocPaymentScheduleHeaderDetailID = EAPSSD.inAdhocPaymentScheduleHeaderDetailID  
        INNER JOIN T_ERP_AdhocPaymentScheduleHeader EAPSD ON EAPSD.inAdhocPaymentScheduleHeaderID = EAPSHD.inAdhocPaymentScheduleHeaderID  
        INNER JOIN T_School_Group SG ON SG.I_School_Group_ID = EAPSD.inSchoolProgramID  
        INNER JOIN T_Class C ON C.I_Class_ID = EAPSHD.inClassID  
        LEFT JOIN T_Stream S ON S.I_Stream_ID = EAPSHD.inStreamID  
        INNER JOIN T_Section Section ON Section.I_Section_ID = EAPSHD.inSectionID  
        WHERE   
            (@EnquiryNo IS NULL OR ERD.I_Enquiry_Regn_ID = @EnquiryNo)  
            AND (@StudentID IS NULL OR SD.S_Student_ID LIKE '%' + @StudentID + '%')  
            AND (@StudentName IS NULL OR (SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name) LIKE '%' + @StudentName + '%')  
            AND EAPSSD.inAdhocPaymentScheduleStudentDetailID = ISNULL(@Id, EAPSSD.inAdhocPaymentScheduleStudentDetailID)  
            AND EAPSD.inAdhocPaymentScheduleHeaderID = ISNULL(@PaymentID, EAPSD.inAdhocPaymentScheduleHeaderID)  
              
            -- 🔍 Universal Search (applied only if SearchValue is NOT NULL)  
            AND (  
                @SearchValue IS NULL OR  
                SD.S_Student_ID LIKE '%' + @SearchValue + '%' OR  
                ERD.I_Enquiry_Regn_ID LIKE '%' + @SearchValue + '%' OR  
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name LIKE '%' + @SearchValue + '%' OR  
                EAPSSD.sInvoiceNo LIKE '%' + @SearchValue + '%' OR  
                SD.S_Mobile_No LIKE '%' + @SearchValue + '%' OR  
                SG.S_School_Group_Name LIKE '%' + @SearchValue + '%' OR  
                C.S_Class_Name LIKE '%' + @SearchValue + '%' OR  
                EAPSD.sDescription LIKE '%' + @SearchValue + '%'  
            )  
    )  
    SELECT   
        Id,  
        StudentDetailID,  
        StudentID,  
        EnquiryNo,  
        StudentName,  
        SchoolGroupName,  
        Class,  
        MobileNo,  
        DueDate,  
        Description,  
        PaymentStatus,  
        TotalRecords,  
        InvoiceNo,  
        Remarks,  
        PaymentID  ,
        Amount
    FROM PaginatedData  
    WHERE RowNum BETWEEN @Offset + 1 AND @Offset + @Limit;  
END;  
