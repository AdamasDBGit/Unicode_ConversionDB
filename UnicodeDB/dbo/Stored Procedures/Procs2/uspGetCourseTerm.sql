CREATE PROCEDURE [dbo].[uspGetCourseTerm]   
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT OFF  
  
    -- Insert statements for procedure here  
 select I_Term_ID from dbo.T_Term_Course_Map as TCM where TCM.I_Course_ID = 2480 
 and I_Status <> 0  
   
END
