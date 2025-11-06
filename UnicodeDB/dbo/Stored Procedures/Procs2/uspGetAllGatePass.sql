--exec [dbo].[uspGetAllGatePass] null,107
CREATE PROCEDURE [dbo].[uspGetAllGatePass]
(
 @iGatePassRequestID int= null,
 @BrandID int =null
)
AS
BEGIN
SELECT distinct top 100  TGPR.[I_Gate_Pass_Request_ID] GatePassRequestID
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
FROM [dbo].[T_Gate_Pass_Request] TGPR inner join T_Student_Detail SD ON TGPR.S_Student_ID = SD.S_Student_ID
inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TGPR.I_Parent_Master_ID
right join T_Relation_Master TRM ON TPM.I_Relation_ID = TRM.I_Relation_Master_ID
join T_Student_Parent_Maps TSPM on TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID --and SD.S_Student_ID = TSPM.S_Student_ID
join [dbo].[T_Student_Batch_Details] as TSBD on SD.I_Student_Detail_ID = TSBD.I_Student_ID
join [dbo].[T_Student_Batch_Master] as TSBM on TSBM.I_Batch_ID = TSBD.I_Batch_ID
join [dbo].[T_Course_Master] as TCM on TCM.I_Course_ID = TSBM.I_Course_ID and TPM.I_Brand_ID=TCM.I_Brand_ID
Left Join T_Student_Class_Section SCS on SCS.S_Student_ID=TGPR.S_Student_ID

where TGPR.I_Gate_Pass_Request_ID = ISNULL(@iGatePassRequestID,TGPR.I_Gate_Pass_Request_ID)
and TSBD.I_Status=1 and SCS.I_Brand_ID=@BrandID
--join (
--select TSPM.S_Student_ID,TPM.I_Parent_Master_ID 
--from T_Parent_Master TPM 
--join  T_Student_Parent_Maps TSPM
--ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
--where TPM.S_Token = @sToken
--) as TS on TS.S_Student_ID =TSPM.S_Student_ID

--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])
order by  TGPR.[I_Gate_Pass_Request_ID] desc
END
