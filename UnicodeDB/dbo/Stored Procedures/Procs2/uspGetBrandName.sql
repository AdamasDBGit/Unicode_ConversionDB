CREATE PROC [dbo].[uspGetBrandName]
(
@iBrandID INT 
)
AS 
BEGIN

SELECT ISNULL(S_Brand_Name,'') FROM T_Brand_Master WHERE I_Brand_ID=@iBrandID AND I_Status <> 0

END
