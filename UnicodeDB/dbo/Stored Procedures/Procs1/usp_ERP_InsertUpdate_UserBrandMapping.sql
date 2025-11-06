--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[usp_ERP_InsertUpdate_UserBrandMapping]
(
 @UserID int ,
 @CreatedBy int,
 @UTBrand UT_Recipient readonly
)
AS
BEGIN
delete from [dbo].[T_ERP_User_Brand] where I_User_ID = @UserID
INSERT INTO [dbo].[T_ERP_User_Brand]
(
[I_User_ID]   
,[I_Brand_ID]  
,[I_CreatedBy]
,[Dt_CreatedAt]
)
select @UserID,Recipient,@CreatedBy,GETDATE() from @UTBrand
END
