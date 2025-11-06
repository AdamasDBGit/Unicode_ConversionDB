--exec uspGetEmployee 1

-- =============================================
-- Author:		partha de
-- Create date: 03/1/2007
-- Description:	Selects one  Employee's role and skills
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeRoleSkill] 
(
	@iEmployeeId int
)

AS
BEGIN
	
	select  B.I_ESD_Skill_ID, C.S_TSM_Skill_Desc FROM
	T_Employee_Dtls A , T_Employee_Skill_Dtls B , T_EOS_Skill_Master C
	WHERE A.I_EMP_Pros_Employee_ID = B.I_ESD_Pros_Employee_ID AND 
		  B.I_ESD_Skill_ID = C.I_TSM_Skill_ID AND B.C_ESD_Status <>'D'
		  AND A.I_EMP_Pros_Employee_ID =@iEmployeeId

	SELECT B.I_ERD_Role_ID , C.S_TRM_Role_Desc FROM
	T_Employee_Dtls A ,T_Employee_Role_Dtls B , T_Role_Master C
	WHERE A.I_EMP_Pros_Employee_ID = I_ERD_Pros_Employee_ID AND
		  B.I_ERD_Role_ID = C.I_TRM_Role_ID AND B.C_ERD_Status <>'D'
		  AND A.I_EMP_Pros_Employee_ID =@iEmployeeId
		
END
