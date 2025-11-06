--exec [dbo].[uspGetGatePass] null,'0345F0A6158340FA8C08AB35893BB815'    
CREATE PROCEDURE [dbo].[uspGetGatePass]    
(    
 @iGatePassRequestID int= null,    
 @sToken nvarchar(200) =null    
)    
AS    
BEGIN    
SELECT DISTINCT TGPR.[I_Gate_Pass_Request_ID] GatePassRequestID    
      ,TGPR.[S_Student_ID] StudentID    
      ,TGPR.[S_Qr_Code] QrCode    
      ,ISNULL(TPM.S_First_Name,'')+' '+ISNULL(TPM.S_Last_Name,'')  GuardianName    
   ,TGPR.[S_Request_Type] RequestType    
   ,TGPR.I_Parent_Master_ID GuardianID    
   ,TPM.I_Relation_ID RelationID    
   ,TRM.S_Relation_Type Relation    
      ,ISNULL(TGPR.[S_Request_Reason],'') RequestReason    
      ,TGPR.[Dt_Request_Date] RequestDate    
      ,ISNULL(TGPR.[S_Approved_By],'') ApprovedBy    
      ,TGPR.[Dt_Approved_Date] ApprovedDate    
      ,ISNULL(TGPR.[S_Approved_Remarks],'') ApprovedRemarks    
      ,ISNULL(TGPR.[S_Rejected_By],'') RejectedBy    
      ,TGPR.[Dt_Rejected_Date] RejectedDate    
      ,ISNULL(TGPR.[S_Rejected_Reason],'') RejectedReason    
      ,ISNULL(TGPR.[S_CancelReason],'') CancelReason    
      ,TGPR.[Dt_CanceledOn] CanceledOn    
      ,TGPR.[I_Status] Status    
   ,SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name StudentName    
   ,I_IsScheduleActivity IsScheduleActivity    
   ,'http://3.111.180.191/SMSAPI/app-images/'+TPM.S_Profile_Picture guardianProfileImage    
   ,'https://sms-staging.arivoo.in/Upload/EnquiryCandidatePhoto/'+TERD.S_Student_Photo studentProfileImage    
   ,ISNULL(I_Is_Completed,0) IsCompleted    
FROM [dbo].[T_Gate_Pass_Request] TGPR inner join T_Student_Detail SD ON TGPR.S_Student_ID = SD.S_Student_ID    
left join T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TGPR.I_Parent_Master_ID    
left join T_Relation_Master TRM ON TPM.I_Relation_ID = TRM.I_Relation_Master_ID    
left join T_Enquiry_Regn_Detail TERD ON SD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID    
left join T_Student_Parent_Maps TSPM on TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID and SD.S_Student_ID = TSPM.S_Student_ID    
join (    
select TSPM.S_Student_ID,TPM.I_Parent_Master_ID     
from T_Parent_Master TPM     
join  T_Student_Parent_Maps TSPM    
ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID    
where TPM.S_Token = @sToken    
)   
as TS on TS.S_Student_ID =TSPM.S_Student_ID    
    
--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])    
END