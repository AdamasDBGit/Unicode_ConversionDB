/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspGetNotificationCategory] 

AS
BEGIN
SELECT  
		I_Event_Category_ID ID
      ,S_Event_Category CategoryName
      ,[I_Status] Status
     
  FROM [dbo].[T_Event_Category] where I_Status = 1
END
