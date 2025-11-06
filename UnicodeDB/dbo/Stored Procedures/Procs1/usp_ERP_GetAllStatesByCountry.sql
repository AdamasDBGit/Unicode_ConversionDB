-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAllStatesByCountry]   
(  
 @iCountryID int = NULL  
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT   
 I_State_ID,  
 S_State_Name  
 FROM T_State_Master  
 WHERE (I_Country_ID = @iCountryID OR @iCountryID IS NULL)  
 and I_Status=1  
 order by S_State_Name Asc
END
