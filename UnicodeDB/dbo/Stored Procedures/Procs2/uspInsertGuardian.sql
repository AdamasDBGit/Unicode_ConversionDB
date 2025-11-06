--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[uspInsertGuardian]
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
where TPM.I_Parent_Master_ID = @iParentID
) as TS on TS.S_Student_ID =TSPM.S_Student_ID
where  TPM.S_Mobile_No = @sMobile and TPM.I_Status = 1)
BEGIN
select 0 statusFlag,'Phone number already exists' message 
END
ELSE
BEGIN
INSERT T_Parent_Master
(
I_Relation_ID
,I_Brand_ID
,S_Mobile_No
,S_First_Name
,S_Last_Name
,S_Profile_Picture
,S_Address
,I_Parent_Parent_Master_ID
,Dt_CreatedAt
)
VALUES
(
@iRelationID
,107
,@sMobile
,@sFirstName
,@sLastName
,@sImagePath
,@sAddress
,@iParentID
,GETDATE()
)
SET @iLastParentID = SCOPE_IDENTITY()
INSERT INTO T_Student_Parent_Maps
(
I_Brand_ID
,S_Student_ID
,I_Parent_Master_ID
,Dt_CreatedAt
,I_Status
)
SELECT 
TSPSM.I_Brand_ID
,TSPSM.S_Student_ID
,@iLastParentID as I_Parent_Master_ID
,GETDATE()
,1
from T_Parent_Master TPM 
inner join T_Student_Parent_Maps TSPSM on TPM.I_Parent_Master_ID = TSPSM.I_Parent_Master_ID
where TPM.I_Parent_Master_ID = @iParentID
select 1 statusFlag,'Guardian added succesfully' message ,@iLastParentID ParentID
END
END
