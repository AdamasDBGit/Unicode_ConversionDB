-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--declare @dt datetime
--set @dt = GETDATE()

--exec uspInsertLoginPageAccessTrail 21434,@dt,'Home'
CREATE PROCEDURE [dbo].[uspInsertLoginPageAccessTrail] 
(
	@iLoginTrailID INT,    
	@dCurrentDate DATETIME,    
	@sPageName varchar(100)    

)
AS
BEGIN
	BEGIN TRY    
		SET NOCOUNT ON; 
		
		
	INSERT INTO dbo.T_Login_PageAccess_Trail (I_Login_Trail_ID,S_Page_Name,Dt_Starttime) VALUES
	(@iLoginTrailID,@sPageName,@dCurrentDate)
	
	END TRY    
	BEGIN CATCH    
 --Error occurred:      
    
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
		SELECT @ErrMsg = ERROR_MESSAGE(),    
		 @ErrSeverity = ERROR_SEVERITY()    
    
		RAISERROR(@ErrMsg, @ErrSeverity, 1)    
	END CATCH 
END
