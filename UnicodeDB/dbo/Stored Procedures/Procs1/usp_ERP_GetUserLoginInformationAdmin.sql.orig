CREATE PROCEDURE [dbo].[usp_ERP_GetUserLoginInformationAdmin]
    (
      @vLoginID VARCHAR(200) ,
      @vPassword NVARCHAR(200)
    )
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
                SELECT 
				TEU.I_User_ID UserID,
				TEU.S_Username LoginID,
				ISNULL(TEU.S_First_Name,'')+ISNULL(TEU.S_Middle_Name,'')+ISNULL(TEU.S_Last_Name,'') Name,
				107 BrandID,
				'Adamas' BrandName
                FROM    dbo.T_ERP_User as TEU
				where S_Username = @vLoginID and S_Password = @vPassword
    END
