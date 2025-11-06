
CREATE PROCEDURE [dbo].[uspAPAISettlementDetails] --  [dbo].[uspAPAISettlementDetails] 8
(
	@iStudentDetailID  int
) 
AS  
BEGIN  
 SET NOCOUNT ON 
	 SELECT	S_Agent_Name ,
	 Dt_Settled_On,
	 N_Amount			
	FROM		
	dbo.T_APAI_Information
	WHERE 
	 I_Student_Detail_ID =  @iStudentDetailID
	 AND I_Status = 1
END
