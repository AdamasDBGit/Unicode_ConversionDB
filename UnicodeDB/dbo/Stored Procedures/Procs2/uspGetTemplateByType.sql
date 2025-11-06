--exec [dbo].[uspActivityTimeValidation] 107,'CCB6CD278A3841E5A057ADEDEE2E9B0F'
CREATE PROCEDURE [dbo].[uspGetTemplateByType]
(
 @iTemplateID int
)
AS
BEGIN
SELECT 
I_NotificationTemplate_ID ID,
S_Title Title
from  T_NotificationTemplate where I_Type = @iTemplateID
END
