CREATE PROCEDURE [dbo].[uspGetLastFiveMinuteStudentAdmission]
AS
BEGIN
SELECT TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name AS StdName,TSD.S_Student_ID,TSD.Dt_Birth_Date,TCHND.S_Center_Name,TCM.S_Course_Name FROM dbo.T_Student_Detail AS TSD 
INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSCD.I_Centre_Id
WHERE TSD.Dt_Crtd_On>=DATEADD(MINUTE,-5,GETDATE()) AND TCHND.I_Brand_ID=109 AND TSCD.I_Status=1 AND TSBD.I_Status=1
END
