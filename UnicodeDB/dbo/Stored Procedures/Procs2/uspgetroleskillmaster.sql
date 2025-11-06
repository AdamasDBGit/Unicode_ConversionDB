-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspgetroleskillmaster]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT pr.I_RST_Role_Skill_Test_ID,p.S_ETM_Test_Name,
	pr.I_RST_Test_ID,pr.I_RST_Role_ID,I_RST_Skill_ID,pr.S_RST_PassFail,
	pr.I_RST_Cut_Off,pr.S_RST_Test_Type
	FROM T_EOS_Test_Master p
	LEFT OUTER JOIN T_Role_Skill_Test_Dtls pr
	ON p.I_ETM_Test_ID = pr.I_RST_Test_ID where pr.C_RST_Status<>'D'
END
