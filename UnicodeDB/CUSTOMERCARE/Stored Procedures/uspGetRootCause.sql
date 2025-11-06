CREATE PROCEDURE [CUSTOMERCARE].[uspGetRootCause]  
(  
@iComplaintCategoryID INT = null,  
@sRootCauseCode VARCHAR(20) = null ,
@iBrandID INT = null 
)  
AS  
BEGIN  
  
   SELECT ISNULL(RCM.I_Root_Cause_ID,0) AS I_Root_Cause_ID   ,  
          ISNULL(RCM.I_Complaint_Category_ID,0) AS I_Complaint_Category_ID  ,  
          ISNULL(RCM.S_Root_Cause_Code,'') AS S_Root_Cause_Code  ,  
    ISNULL(RCM.S_Root_Cause_Desc,'') AS S_Root_Cause_Desc,  
    ISNULL(RCM.S_Crtd_By,'') AS S_Crtd_By    ,  
          ISNULL(RCM.S_Upd_By, 0) AS S_Upd_By    ,  
          ISNULL(RCM.Dt_Crtd_On,'') AS Dt_Crtd_On    ,  
          ISNULL(RCM.Dt_Upd_On,'') AS Dt_Upd_On,  
    ISNULL(CCM.S_Complaint_Desc, '') AS S_Complaint_Desc  
         
     FROM [CUSTOMERCARE].T_Root_Cause_Master RCM  
  INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM  
  ON RCM.I_Complaint_Category_ID = CCM.I_Complaint_Category_ID 
  INNER JOIN dbo.T_Brand_Master AS TBM 
  ON RCM.I_Brand_ID = TBM.I_Brand_ID 
        WHERE RCM.I_Status_ID = 1
  AND RCM.I_Brand_ID = @iBrandID       
  AND CCM.I_Status_ID = 1  
  AND CCM.I_Complaint_Category_ID =COALESCE(@iComplaintCategoryID ,CCM.I_Complaint_Category_ID)  
  AND RCM.S_Root_Cause_Code LIKE COALESCE(@sRootCauseCode,RCM.S_Root_Cause_Code)+'%'  
  
END
