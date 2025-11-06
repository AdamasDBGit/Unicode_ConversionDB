CREATE PROCEDURE [dbo].[uspGetRoomDetails]   
(  
 @SBuildingName NVARCHAR(MAX) ,
 @iBrandId INT = NULL,  
 @SBlockName NVARCHAR(MAX) ,  
 @SFloorName NVARCHAR(MAX),  
 @iCenterID INT  = null  
)   
AS    
BEGIN    
 SET NOCOUNT ON     
  
IF @iCenterID IS NULL  
BEGIN  
 SELECT A.I_Room_ID ,  
   A.I_Brand_ID,  
   A.I_Centre_ID,  
   A.S_Building_Name,  
   A.S_Block_Name,  
   A.S_Floor_Name,  
   
   A.S_Room_No,  
   A.I_Room_Type,  
   A.N_Room_Rate,  
   A.I_No_Of_Beds,  
   A.I_Status,  
   A.S_Crtd_by,  
   A.Dt_Crtd_On   
 FROM    
 dbo.T_Room_Master A  
 WHERE   
  A.I_Status = 1  AND   
  A.S_Building_Name like ISNULL(@SBuildingName,'')+'%' AND   
  A.S_Block_Name like ISNULL(@SBlockName,'')+'%' AND   
  A.S_Floor_Name like ISNULL(@SFloorName,'')+'%' AND
  A.I_Brand_ID = ISNULL(@iBrandId,A.I_Brand_ID) AND  
  A.I_Centre_ID is NULL  
 END  
 ELSE  
 BEGIN  
  SELECT A.I_Room_ID ,  
   A.I_Brand_ID,  
   A.I_Centre_ID,  
   A.S_Building_Name,  
   A.S_Block_Name,  
   A.S_Floor_Name,  
   A.S_Room_No,  
   A.I_Room_Type,  
   A.N_Room_Rate,  
   A.I_No_Of_Beds,  
   A.I_Status,  
   A.S_Crtd_by,  
   A.Dt_Crtd_On   
 FROM    
 dbo.T_Room_Master A  
 WHERE   
  A.I_Status = 1  AND   
  A.S_Building_Name like ISNULL(@SBuildingName,'')+'%' AND   
  A.S_Block_Name like ISNULL(@SBlockName,'')+'%' AND   
  A.S_Floor_Name like ISNULL(@SFloorName,'')+'%' AND  
  A.I_Brand_ID = ISNULL(@iBrandId,A.I_Brand_ID) AND
  A.I_Centre_ID = @iCenterID  
 END  
END

