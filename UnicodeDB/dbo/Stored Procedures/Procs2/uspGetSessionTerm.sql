-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSessionTerm]
	-- Add the parameters for the stored procedure here
	@iTermid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    Select  B.I_Session_ID,
		        B.S_Session_Code,      
                B.S_Session_Name,
				C.I_Skill_ID,
				C.S_Skill_Desc,
				A.I_Sequence
				from  dbo.T_Session_Module_Map A      
                INNER JOIN dbo.T_Session_Master B ON A.I_Session_ID = B.I_Session_ID
				INNER JOIN dbo.T_EOS_Skill_Master C ON B.I_Skill_ID=C.I_Skill_ID
				INNER JOIN dbo.T_Module_Term_Map D ON A.I_Module_ID = D.I_Module_ID  
				where D.I_Term_ID = @iTermid and D.I_Status = 1 and C.I_Status = 1 and B.I_Status = 1 and A.I_Status = 1



End
