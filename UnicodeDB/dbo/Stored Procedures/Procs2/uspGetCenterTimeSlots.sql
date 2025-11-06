-- =============================================
-- Author:		Swagata De
-- Create date: 28/03/2007
-- Description:	This SP retrieves all Time Slots for a particular center id
--Parameters:  CenterID
--Returns:     DatatSet
--Modified By:
--Comments   : Further details such as course details can be retrieved later
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCenterTimeSlots] 
(
	-- Add the parameters for the stored procedure here
	 @iCenterID int --Center ID
)

AS
BEGIN 
SELECT 
I_TimeSlot_ID,
I_Centre_Id,
S_TimeSlot_Code,
S_TimeSlot_Desc
FROM dbo.T_Center_TimeSlot WITH(NOLOCK)
WHERE I_Centre_Id=@iCenterID AND I_Status<>0

END
