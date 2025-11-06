-- =============================================
-- Author:		Aritra Saha
-- Create date: 10/04/2007
-- Description:	Get the Enquiry detail by EnquirID or StudentName
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEnquiryDetailsbyIDorSName] 
(
	-- Add the parameters for the stored procedure here
	@sFirstName varchar(50),
	@sMiddleName varchar(50),
	@sLastName varchar(50),
	@sEnquiryNo varchar(20),
	@sCentreID int
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Table[0]  Enquiry Details
	SELECT	
		A.I_Enquiry_Regn_ID,
		A.S_First_Name,
		A.S_Middle_Name,
		A.S_Last_Name,
		A.Dt_Crtd_On,
		A.S_Enquiry_No
	FROM 
		dbo.T_Enquiry_Regn_Detail A
	WHERE
	A.S_Enquiry_No = ISNULL(@sEnquiryNo,A.S_Enquiry_No)
	AND
	A.I_Centre_ID = @sCentreID
	AND
	A.S_First_Name LIKE ISNULL(@sFirstName,A.S_First_Name)+'%'
	AND A.S_Middle_Name LIKE ISNULL(@sMiddleName,A.S_Middle_Name)+'%'
	AND A.S_Last_Name LIKE ISNULL(@sLastName,A.S_Last_Name)+'%'
	AND A.I_Enquiry_Status_Code  <> 2
	
	 
		
		-- Table[1] Enquiry Course Details		
	SELECT  
		A.I_Course_ID,C.S_Course_Name,B.I_Enquiry_Regn_ID
	FROM 
		dbo.T_Enquiry_Course A,
		dbo.T_Enquiry_Regn_Detail B,
		dbo.T_Course_Master C
	WHERE
	B.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID  
	AND
	A.I_Course_ID = C.I_Course_ID
	AND 
	A.I_Enquiry_Regn_ID 
	IN 
	(
	SELECT	I_Enquiry_Regn_ID
	FROM 
		dbo.T_Enquiry_Regn_Detail A
	WHERE 
	A.S_First_Name LIKE ISNULL(@sFirstName,A.S_First_Name)+'%'
	AND A.S_Middle_Name LIKE ISNULL(@sMiddleName,A.S_Middle_Name)+'%'
	AND A.S_Last_Name LIKE ISNULL(@sLastName,A.S_Last_Name)+'%' 
	AND A.S_Enquiry_No = ISNULL(@sEnquiryNo,A.S_Enquiry_No) AND A.I_Enquiry_Status_Code  <> 2
	)	
			 
	
END
