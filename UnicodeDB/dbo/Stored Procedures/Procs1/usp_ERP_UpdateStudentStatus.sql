--exec [usp_Get_SessionStartDateByEnquiry] 237210
CREATE PROCEDURE [dbo].[usp_ERP_UpdateStudentStatus]    
(  
    @StudentDetailID INT 
	,@Status int
)    
AS    
BEGIN    
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.    
    SET NOCOUNT ON;    
	UPDATE T_Student_Class_Section set I_Status = @Status where I_Student_Detail_ID =@StudentDetailID
	--UPDATE T_Student_Detail  set I_Status = @Status  where I_Student_Detail_ID =@StudentDetailID
    SELECT 1 AS StatusFlag, 'Status updated' AS Message;
       
END;
