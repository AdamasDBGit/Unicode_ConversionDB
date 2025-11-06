CREATE PROCEDURE [dbo].[uspTCRemarksHistory]   --[dbo].[uspTCRemarksHistory]8822                 
    (        
        @sStudentId VARCHAR(500)        
            
    )        
AS         
BEGIN        
          
    --SELECT  TTCAT.I_Transfer_Req_Status,TTCAT.S_Remarks,TTCAT.Is_Released, TTCAT.S_Crtd_By,TUM.S_First_Name,TUM.S_Middle_Name,TUM.S_Last_Name      
  SELECT  TTCAT.I_Transfer_Req_Status,TTCAT.S_Remarks,TTCAT.Is_Released, TTCAT.S_Crtd_By,  
  TUM.S_First_Name+' '+isnull(TUM.S_Middle_Name,' ')+' '+TUM.S_Last_Name AS ActionTakenBy,  
  case when TTCAT.I_Transfer_Req_Status=1 then 'Initiated' else 'Approved' end as StatusName        
 FROM dbo.T_Transfer_Certificates AS TTC       
 INNER JOIN dbo.T_Transfer_Certificates_Audit_Trial AS TTCAT  ON TTC.I_Transfer_Cert_Req_ID = TTCAT.I_Transfer_Cert_Req_ID        
 INNER JOIN dbo.T_User_Master AS TUM ON TUM.S_Login_ID = TTCAT.S_Crtd_By   
   
      
      
 WHERE TTC.I_Student_Detail_ID =@sStudentId      
 AND TTCAT.I_Transfer_Cert_Req_ID = TTC.I_Transfer_Cert_Req_ID   
      
      
      
 --SELECT TUM.S_First_Name,TUM.S_Middle_Name,tum.S_Last_Name FROM dbo.T_User_Master AS TUM      
 --INNER JOIN dbo.T_Transfer_Certificates AS TTC ON TUM.S_Login_ID = TTC.S_Crtd_By      
 --WHERE TUM.S_Login_ID = TTC.S_Crtd_By      
      
          
END
