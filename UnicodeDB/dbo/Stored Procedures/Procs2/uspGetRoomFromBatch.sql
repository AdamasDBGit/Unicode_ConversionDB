-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRoomFromBatch]
	-- Add the parameters for the stored procedure here
      @ICenterID INT , --Center ID                
      @IBatchID INT  --Batch ID    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    SELECT TOP 1 TRM. I_Room_ID ,      
               TRM.S_Building_Name ,      
               TRM. S_Block_Name ,      
               TRM. S_Floor_Name ,      
               TRM. S_Room_No,
               TBM.I_Batch_ID      
        FROM    dbo.T_Room_Master AS TRM  
                INNER JOIN dbo.T_Batch_Room_Map TBM
                ON TBM.I_Room_ID= TRM.I_Room_ID  
                INNER JOIN dbo.T_Student_Batch_Master SBM
                ON TBM.I_Batch_ID=SBM.I_Batch_ID  
        WHERE   I_Centre_Id = @ICenterID      
                AND TBM.I_Status = 1 
                AND TBM.I_Batch_ID=@IBatchID
                
END
