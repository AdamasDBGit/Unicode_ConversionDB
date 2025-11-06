--exec [usp_Get_SessionStartDateByEnquiry] 237210
CREATE PROCEDURE [dbo].[usp_Get_SessionStartDateByEnquiry]    
(  
    @EnquiryID INT    
)    
AS    
BEGIN    
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.    
    SET NOCOUNT ON;    
	SELECT T2.Dt_Session_Start_Date SessionStartDate FROM T_Enquiry_Regn_Detail T1 INNER JOIN T_School_Academic_Session_Master T2 
	ON T2.I_School_Session_ID=T1.R_I_School_Session_ID where I_Enquiry_Regn_ID=@EnquiryID
    
       
END;
