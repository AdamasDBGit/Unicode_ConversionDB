
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 Jan 01>
-- Description:	<Fetch All student Based on Batch>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspGetAllStudentDetailsForBatch]
(
	@iBatchID INT
)
AS
BEGIN
	
	SELECT TSD.S_Student_ID,TSD.I_Student_Detail_ID, TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,TSBD.I_Status,
	TCM.I_Course_ID,TCM.S_Course_Name,TSBD.I_Batch_ID,TSBM.S_Batch_Name,CM1.I_Centre_Id,CM1.S_Center_Name
    FROM dbo.T_Student_Detail AS TSD 
    INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID 
	INNER JOIN T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID=TSBD.I_Batch_ID
	INNER JOIN T_Course_Master AS TCM ON TCM.I_Course_ID=TSBM.I_Course_ID 
	INNER JOIN T_Center_Batch_Details as CBD ON CBD.I_Batch_ID=TSBD.I_Batch_ID
	INNER JOIN T_Centre_Master as CM1 ON CM1.I_Centre_Id=CBD.I_Centre_Id
    WHERE 
	TSBM.I_Batch_Id=@iBatchID
	AND
	TSBD.I_Status IN (1,2)
	--and TSD.S_Student_ID not in ('16-0188','14-0197','15-0072')

END
