CREATE PROC [dbo].[uspGeTFeePlanName]
(
@iFeePlanID INT
)

AS 
BEGIN

SELECT S_Fee_Plan_Name
FROM T_Course_Fee_Plan 
WHERE I_Course_Fee_Plan_ID=@iFeePlanID
AND I_Status <> 0

END
