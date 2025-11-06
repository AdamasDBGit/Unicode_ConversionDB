-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <17-11-2023>  
-- Description: <to get the list of session list>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetStreamusingClass]  
 -- Add the parameters for the stored procedure here  
 @iClassID int null  
 AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
   
  
   
    select CS.I_Stream_ID as StreamID,  
 S.S_Stream as StreamName  
 from [dbo].[T_ERP_Class_Stream] as CS join  [dbo].[T_Stream] as S  
  on CS.I_Stream_ID=S.I_Stream_ID  
  where CS.I_Class_ID=ISNULL(@iClassID,CS.I_Class_ID)  
  group by S.I_Stream_ID,S.S_Stream,CS.I_Stream_ID  
END
