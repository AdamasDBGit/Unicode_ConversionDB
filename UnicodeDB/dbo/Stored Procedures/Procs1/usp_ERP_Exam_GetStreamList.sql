-- =============================================  
-- Author:        Qutub Haider  
-- Create date:   05 Aug 2024  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetStreamList]  
(  
    @iClassID dbo.IntArray READONLY  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
  TC.I_Class_ID AS ClassId,  
        CS.I_Stream_ID AS StreamID,  
        TC.S_Class_Name+' - '+ S.S_Stream AS StreamName  
    FROM   
  [dbo].[T_ERP_Class_Stream] AS CS  
  JOIN [dbo].[T_Stream] AS S ON CS.I_Stream_ID = S.I_Stream_ID  
  JOIN T_Class TC ON TC.I_Class_ID = CS.I_Class_ID  
    WHERE   
  CS.I_Class_ID IN (SELECT Value FROM @iClassID)  
    GROUP BY   
  S.I_Stream_ID, S.S_Stream, CS.I_Stream_ID,TC.S_Class_Name ,TC.I_Class_ID   
 ORDER BY TC.I_Class_ID  
END