--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[uspUpdateGuardian]
(
 @iParentID int
,@sFirstName nvarchar(50)= null
,@sLastName nvarchar(50)= null
,@iRelationID int=null
,@sMobile nvarchar(12)
,@sAddress	nvarchar(200)
,@sToken nvarchar(200)
,@sImagePath nvarchar(400)
)
AS
BEGIN
--DECLARE @iParentID int
DECLARE @iLastParentID int
--SET @iParentID = (select I_Parent_Master_ID from T_Parent_Master where S_Token =@sToken  )
IF EXISTS(select * from T_Parent_Master TPM
join  T_Student_Parent_Maps TSPM
ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
join (
select TSPM.S_Student_ID,TPM.I_Parent_Master_ID 
from T_Parent_Master TPM 
join  T_Student_Parent_Maps TSPM
ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
where TPM.I_Parent_Master_ID = @iParentID and TPM.I_Parent_Master_ID != @iParentID and TPM.I_Status =1
) as TS on TS.S_Student_ID =TSPM.S_Student_ID
where  TPM.S_Mobile_No = @sMobile )
BEGIN
select 0 statusFlag,'Phone number already exists' message 
END
ELSE
BEGIN
UPDATE T_Parent_Master
SET 
I_Relation_ID = @iRelationID
,S_Mobile_No = @sMobile
,S_First_Name = @sFirstName
,S_Last_Name = @sLastName
,S_Profile_Picture = @sImagePath
,S_Address = @sAddress
,Dt_UpdatedAt = GETDATE()
where I_Parent_Master_ID = @iParentID
select 1 statusFlag,'Guardian updated succesfully' message ,@iLastParentID ParentID
END
END
