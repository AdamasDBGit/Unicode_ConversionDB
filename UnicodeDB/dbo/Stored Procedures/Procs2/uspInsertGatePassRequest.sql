/*******************************************************  
Description : Save E-Project Manual  
Author :     Arindam Roy  
Date :   05/22/2007  
*********************************************************/  
  
CREATE PROCEDURE [dbo].[uspInsertGatePassRequest]   
(  
 @sGuardianName nvarchar(200),  
 @sRequestType nvarchar(200),  
 @sRequestReason nvarchar(200),  
 @sStudents nvarchar(200)  ,  
 @dtRequestDate datetime   
)  
AS  
begin transaction  
BEGIN TRY   
  
while len(@sStudents) > 0  
begin  
  --print left(@S, charindex(',', @S+',')-1)  
  select left(@sStudents, charindex(',', @sStudents+',')-1)  
  INSERT INTO T_Gate_Pass_Request   
(S_Student_ID  
--,S_Guardian_Name  
,S_Request_Type  
,S_Request_Reason  
,S_CreatedBy  
,Dt_CreatedOn  
,Dt_Request_Date  
)  
VALUES  
(left(@sStudents, charindex(',', @sStudents+',')-1)  
--,@sGuardianName  
,@sRequestType  
,@sRequestReason  
,@sGuardianName  
,GETDATE()  
,@dtRequestDate  
)  
 set @sStudents = stuff(@sStudents, 1, charindex(',', @sStudents+','), '')  
  --select @S  
end  
  
select 1 StatusFlag,'Gate pass request created succesfully' Message  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  
commit transaction  
