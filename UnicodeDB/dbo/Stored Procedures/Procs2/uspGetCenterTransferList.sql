CREATE PROCEDURE [dbo].[uspGetCenterTransferList]              
               
 @iUserID int,              
 @iStatusID INT = null,             
 @iStudentDetailID int = null               
                  
AS              
BEGIN              
              
IF (@iStudentDetailID IS NULL)               
 BEGIN              
SELECT TSTR.*,               
   TSD.S_First_Name + ' ' + ISNULL('',TSD.S_Middle_Name) + ' ' + TSD.S_Last_Name AS StudentName    
 , TSD.S_Student_ID+' , '+ISNULL(TSD.S_First_Name,'') + ' ' + ISNULL(TSD.S_Last_Name,'') AS S_Student_ID    
 , TCM1.S_Center_Name AS Source_Center, TCM2.S_Center_Name AS Destination_Center       
 , TD.I_Task_Details_Id      
FROM T_Student_Transfer_Request TSTR      
INNER JOIN dbo.T_Student_Transfer_History TH ON TSTR.I_Transfer_Request_Id = TH.I_Transfer_Request_Id      
INNER JOIN dbo.T_Task_Details TD ON TD.I_Task_Details_Id = TH.I_Task_Details_Id      
INNER JOIN dbo.T_Task_Assignment TA ON TD.I_Task_Details_Id = TA.I_Task_Id      
INNER JOIN dbo.T_Student_Detail TSD  ON TSD.I_Student_Detail_ID = TSTR.I_Student_Detail_ID              
INNER JOIN dbo.T_Centre_Master TCM1  ON TCM1.I_Centre_Id = TSTR.I_Source_Centre_Id              
INNER JOIN dbo.T_Centre_Master TCM2  ON TCM2.I_Centre_Id = TSTR.I_Destination_Centre_Id        
WHERE TD.I_Status = 1      
AND TA.I_To_User_ID = @iUserID      
AND TH.I_Status_Id = ISNULL(@iStatusID,TH.I_Status_Id)
AND TSTR.[I_Status] <> 0
           
            
 END              
 IF(@iStudentDetailID IS NOT NULL) -- List of Active Center Transfer Requests for a Student              
 BEGIN              
  SELECT TSTR.*,              
  TSD.S_First_Name + ' ' + ISNULL('',TSD.S_Middle_Name) + ' ' + TSD.S_Last_Name AS StudentName, TSD.S_Student_ID,               
  TCM1.S_Center_Name AS Source_Center, TCM2.S_Center_Name AS Destination_Center              
  FROM dbo.T_Student_Transfer_Request TSTR              
  INNER JOIN dbo.T_Student_Detail TSD              
  ON TSD.I_Student_Detail_ID = TSTR.I_Student_Detail_ID              
  INNER JOIN dbo.T_Centre_Master TCM1              
  ON TCM1.I_Centre_Id = TSTR.I_Source_Centre_Id              
  INNER JOIN dbo.T_Centre_Master TCM2              
  ON TCM2.I_Centre_Id = TSTR.I_Destination_Centre_Id              
  WHERE TSTR.I_Student_Detail_ID = @iStudentDetailID              
  AND TSTR.I_Source_Centre_Id in (select distinct I_Source_Centre_Id from dbo.T_Student_Transfer_Request )            
  AND TSTR.I_Status = ISNULL(@iStatusID,TSTR.I_Status)              
              
 END              
           
--SELECT TR.*          
--FROM dbo.T_Student_Transfer_Request TR          
--INNER JOIN dbo.T_Task_Details TD          
-- ON TR.I_Transfer_Request_Id = CAST(TD.S_Hierarchy_Chain AS INT)          
--INNER JOIN dbo.T_Task_Assignment TA          
-- ON TA.I_Task_Id = TD.I_Task_Details_Id          
--WHERE I_To_User_ID IN          
--(          
--SELECT I_User_Id FROM dbo.T_User_Master          
--WHERE S_Login_Id = 'nasavr'          
--)             
              
END
