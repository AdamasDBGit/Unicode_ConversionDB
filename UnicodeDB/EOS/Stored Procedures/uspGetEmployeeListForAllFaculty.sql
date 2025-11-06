CREATE PROCEDURE [EOS].[uspGetEmployeeListForAllFaculty]  
(   
 @iBrandID INT  
)   
AS  
BEGIN  
 SELECT  TED.I_Employee_ID,  
   TED.I_Centre_Id,  
   TED.S_Title,  
   TED.S_First_Name,  
   TED.S_Middle_Name,  
   TED.S_Last_Name,  
   TUM.I_User_ID,  
   TUM.S_Login_ID,  
   TUM.S_User_Type,  
   TUM.S_Email_ID,  
   TED.I_Status  
 FROM   
   dbo.T_Employee_Dtls TED WITH(NOLOCK)   
  INNER JOIN dbo.T_User_Master TUM WITH(NOLOCK)  
   ON TED.I_Employee_ID=TUM.I_Reference_ID  
 WHERE TED.I_Centre_Id in (   
select I_Center_ID   
from T_Center_Hierarchy_Name_Details   
where I_Brand_ID=@iBrandID)   
  
   AND TED.I_Status <> 0  
   AND TUM.I_Status = 1  
   AND TUM.S_User_Type <> 'ST' AND TUM.S_User_Type <> 'EM'  
   AND TED.S_First_Name<>'DUMMY'  
   ORDER BY TED.S_First_Name, ISNULL(TED.S_Middle_Name,''), TED.S_Last_Name  
END
