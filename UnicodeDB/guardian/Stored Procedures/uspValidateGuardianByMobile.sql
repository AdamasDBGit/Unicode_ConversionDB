-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <21st August 2023>
-- Description:	<for validation using mobile number>
-- =============================================
CREATE PROCEDURE [guardian].[uspValidateGuardianByMobile]
	-- Add the parameters for the stored procedure here
	@mobileNo varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF EXISTS (select * from [T_Parent_Master] where S_Mobile_No=@mobileNo)
	BEGIN
select I_Parent_Master_ID as ParentID,I_Relation_ID as RelationID,I_Brand_ID as BrandID,[S_First_Name] as FirstName,[S_Middile_Name] as MiddleName,[S_Last_Name] as LastName,[I_IsPrimary]as IsPrimary
      ,[I_IsBusTravel]as IsBus,[I_Status] as IsStatus
	  from [T_Parent_Master] where [S_Mobile_No]=@mobileNo AND [I_Status]=1
END
else
select 1 StatusFlag, 'Mobile Number does not exist' Message
END
