-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <30th Jan 2024>
-- Description:	<to get the student Detail for on Account>
--exec [usp_ERP_GetStudentDetail_OnAccount_New] 237218,null,107
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetStudentDetail_OnAccount_New]
	@EnquiryID int = null,
	@StudentID NVARCHAR(MAX) = null,
	@BrandID int =null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IsProspectusPaid int=0
	DECLARE @ProspectusId int
	IF(@EnquiryID is null)
	BEGIN
	SET @EnquiryID = (SELECT I_Enquiry_Regn_ID FROM T_Student_Detail WHERE S_Student_ID=@StudentID)
	END
	SET @ProspectusId = (select I_Status_Value from T_Status_Master where Status_Type=1 and I_Brand_ID=@BrandID)
	IF EXISTS(select * from T_Receipt_Header where I_Enquiry_Regn_ID=@EnquiryID and I_Receipt_Type=@ProspectusId)
	BEGIN
	set @IsProspectusPaid =1
	END
	SELECT 
    TSD.I_Student_Detail_ID AS StudentDetailID,
    ISNULL(TSD.S_Student_ID, 'NA') AS StudentID,
    ISNULL(ERD.S_First_Name, '') + ' ' + ISNULL(ERD.S_Middle_Name, '') + ' ' + ISNULL(ERD.S_Last_Name, '') AS StudentName,
    ERD.I_Enquiry_Regn_ID AS EnquiryID,
    ERD.S_Form_No AS FormNo,
    @IsProspectusPaid AS IsProspectusPaid,
    ISNULL(TSG.S_School_Group_Name, 
        ISNULL((SELECT TSG2.S_School_Group_Name 
                FROM T_School_Group TSG2 
                WHERE TSG2.I_School_Group_ID = ERD.I_School_Group_ID), 'NA')) AS GroupName,
    ISNULL(TC.S_Class_Name, 
        ISNULL((SELECT TC2.S_Class_Name 
                FROM T_Class TC2 
                WHERE TC2.I_Class_ID = ERD.I_Class_ID), 'NA')) AS ClassName,
    ERD.S_Mobile_No AS MobileNo
FROM 
    [dbo].[T_Student_Detail] AS TSD
RIGHT JOIN 
    [dbo].[T_Enquiry_Regn_Detail] AS ERD
    ON TSD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
JOIN 
    [dbo].[T_Brand_Center_Details] AS BCD
    ON ERD.I_Centre_Id = BCD.I_Centre_Id
LEFT JOIN 
    T_Student_Class_Section TSCS 
    ON TSCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID
LEFT JOIN 
    T_School_Group_Class TSGS 
    ON TSGS.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID
LEFT JOIN 
    T_School_Group TSG 
    ON TSG.I_School_Group_ID = TSGS.I_School_Group_ID
LEFT JOIN 
    T_Class TC 
    ON TC.I_Class_ID = TSGS.I_Class_ID
WHERE 
    ERD.I_Enquiry_Regn_ID = @EnquiryID 
    AND BCD.I_Brand_ID = @BrandID 
    OR TSD.S_Student_ID = @StudentID;

	END

