CREATE PROCEDURE [dbo].[uspGetDeliveryPattern]      
(    
@iCenterID int,        
@iCourseID int   
)         
AS    
BEGIN    
  SELECT      
  DISTINCT DPM.I_Delivery_Pattern_ID,DPM.S_Pattern_Name,DPM.I_Status,DPM.I_No_Of_Session,      
  DPM.N_Session_Day_Gap,DPM.S_Crtd_By,DPM.S_Upd_By,DPM.Dt_Crtd_On,DPM.Dt_Upd_On,DPM.S_DaysOfWeek  
  FROM dbo.T_Delivery_Pattern_Master DPM      
  INNER JOIN dbo.T_Course_Delivery_Map CDM      
  ON DPM.I_Delivery_Pattern_ID = CDM.I_Delivery_Pattern_ID  
  INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF  
  ON CDM.I_Course_Delivery_ID = CCDF.I_Course_Delivery_ID     
  INNER JOIN dbo.T_Course_Center_Detail CCD  
  ON ccdf.I_Course_Center_ID = CCD.I_Course_Center_ID  
  AND CDM.I_Course_ID = @iCourseID       
  AND DPM.I_Status=1      
  AND CDM.I_Status=1     
  AND CCDF.I_Status=1  
  AND ccd.I_Centre_Id = @iCenterID  
  AND CCD.I_Status =1  
  AND GETDATE() >= ISNULL(CCDF.Dt_Valid_From,GETDATE()) AND GETDATE() <= ISNULL(CCDF.Dt_Valid_To,GETDATE())    
  END
