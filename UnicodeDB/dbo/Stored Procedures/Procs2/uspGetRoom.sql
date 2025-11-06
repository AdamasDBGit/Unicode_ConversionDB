-- =============================================  
-- Author:  <Monalisa>  
-- Create date: <17-09-2012>  
-- Description: <To get all books from BookMaster>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetRoom]   
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT OFF  
  
    -- Insert statements for procedure here  
 SELECT A.I_Room_ID,  
   A.S_Building_Name,  
   A.S_Block_Name,  
   A.S_Floor_Name,  
   A.S_Room_No,  
   A.I_Room_Type,  
   A.I_Brand_ID,  
   A.I_Status,  
   ISNULL(A.N_Room_Rate,0) AS N_Room_Rate,  
   A.I_No_Of_Beds,  
   A.I_Centre_Id,  
   B.S_Brand_Code,  
   B.S_Brand_Name   
 FROM dbo.T_room_master A, dbo.T_Brand_Master B   
 WHERE A.I_Status <> 0  
 AND B.I_Brand_ID = A.I_Brand_ID  
END
