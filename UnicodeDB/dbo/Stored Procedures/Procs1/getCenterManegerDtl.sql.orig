CREATE PROCEDURE [dbo].[getCenterManegerDtl]
(
	@iCenterID int,
	@srole varchar(50) = null
)
AS
BEGIN
	Select * from dbo.T_Employee_Dtls EMPDTL
inner join EOS.T_Employee_Role_Map EMPRM
on EMPDTL.I_Employee_ID=EMPRM.I_Employee_ID
inner join dbo.T_Role_Master RM
on EMPRM.I_Role_ID=RM.I_Role_ID 
where EMPDTL.I_Status=3 and EMPDTL.I_Centre_Id=@iCenterID and EMPRM.I_Status_ID=1 and RM.S_Role_Code=@srole

END

--exec getCenterManegerDtl 720,'CH'
