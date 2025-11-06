  
--exec [dbo].[uspGetGatePass]   
CREATE PROCEDURE [dbo].[uspGetApprovedGatePass]  
(  
 @sToken nvarchar(max)  
)  
AS  
BEGIN   
  
DECLARE @ErrMessage NVARCHAR(4000)  
DECLARE @BufferTime INT = 60  
  
IF EXISTS(select * from T_Gate_Pass_Guard where S_Token=@sToken)  
  
BEGIN  
  
SELECT DISTINCT TGPR.[I_Gate_Pass_Request_ID] GatePassRequestID  
   ,SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name StudentName  
      ,TPM.S_First_Name+' '+ISNULL(TPM.S_Middile_Name,'')+' '+ISNULL(TPM.S_Last_Name,'') PickUpPerson  
   ,TRM.S_Relation_Type pickupPersonrealtionType  
   ,TGPR.Dt_Request_Date IssuedDate  
   ,CAST(CONVERT(TIme,TGPR.Dt_Request_Date) as varchar(max)) PickUpTime  
   ,CASE   
   WHEN GP.I_Gate_Pass_Scanned_ID IS NOT NULL AND TGPR.I_Is_Completed = 1  THEN 'Completed'  
   WHEN   
   GP.I_Gate_Pass_Scanned_ID IS NULL   
   AND TGPR.Dt_Request_Date BETWEEN (select DATEADD(MINUTE,-@BufferTime,GETDATE())) AND (select DATEADD(MINUTE,@BufferTime,GETDATE()))   
   THEN 'Remaining'  
   --CONVERT(DATE,TGPR.Dt_Request_Date) >= CONVERT(DATE,GETDATE()) THEN 'Remaining'  
   WHEN GP.I_Gate_Pass_Scanned_ID IS NULL AND TGPR.Dt_Request_Date < (select DATEADD(MINUTE,-@BufferTime,GETDATE()))   
   THEN 'Expire'  
   --CONVERT(DATE,TGPR.Dt_Request_Date) < CONVERT(DATE,GETDATE()) THEN 'Expire'  
   WHEN GP.I_Gate_Pass_Scanned_ID IS NULL AND (select DATEADD(MINUTE,@BufferTime,GETDATE())) < TGPR.Dt_Request_Date  
   THEN 'Remaining'  
   END RequestStatus   
   ,ERD.S_Student_Photo studentImage --2023July07 :  student Image  
   ,TPM.S_Profile_Picture pickupPersonImage --2023July07 : Pickup Person Image  
     
FROM [dbo].[T_Gate_Pass_Request] TGPR   
left join T_Student_Detail SD ON TGPR.S_Student_ID = SD.S_Student_ID  
left join T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID --2023July07 : Enquiry student Image  
left join T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TGPR.I_Parent_Master_ID  
left join T_Relation_Master TRM ON TPM.I_Relation_ID = TRM.I_Relation_Master_ID  
left join T_Student_Parent_Maps TSPM on TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID and SD.S_Student_ID = TSPM.S_Student_ID  
left join (  
select TSPM.S_Student_ID,TPM.I_Parent_Master_ID   
from T_Parent_Master TPM   
join  T_Student_Parent_Maps TSPM  
ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID  
) as TS on TS.S_Student_ID =TSPM.S_Student_ID  
left join  
(  
select GPSD.I_Gate_Pass_Scanned_ID,GPSD.I_Gate_Pass_Guard_ID,GPSD.I_Gate_Pass_Request_ID   
from dbo.[T_Gate_Pass_Scanned_Details] as GPSD  
inner join  
dbo.T_Gate_Pass_Guard as GPG on GPSD.I_Gate_Pass_Guard_ID=GPG.I_Gate_Pass_Guard_ID  
) as GP on GP.I_Gate_Pass_Request_ID=TGPR.I_Gate_Pass_Request_ID  
  
where TGPR.I_Status=1 --and CONVERT(DATE,TGPR.Dt_Request_Date) = CONVERT(DATE,GETDATE())  
  
END  
ELSE  
BEGIN  
  
  
SELECT @ErrMessage='Invalid Guard token'  
  
RAISERROR(@ErrMessage,11,1)  
  
END  
  
END  