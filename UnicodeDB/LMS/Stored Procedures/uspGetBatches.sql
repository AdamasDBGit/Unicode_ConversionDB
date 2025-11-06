CREATE PROCEDURE [LMS].[uspGetBatches](@CentreID int, @CourseID int)
as
begin

select TCM.I_Centre_Id,TCM.S_Center_Name as S_Centre_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,
TSBM.Dt_Course_Expected_End_Date as BatchEndDate,ISNULL(COUNT(DISTINCT TSBD.I_Student_ID),0) as BatchStrength
from T_Student_Batch_Master TSBM
inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
inner join T_Centre_Master TCM on TCBD.I_Centre_Id=TCM.I_Centre_Id
left join T_Student_Batch_Details TSBD on TSBD.I_Batch_ID=TSBM.I_Batch_ID and TSBD.I_Status=1
where TCBD.I_Centre_Id=@CentreID and TSBM.I_Course_ID=@CourseID
group by TCM.I_Centre_Id,TCM.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,
TSBM.Dt_Course_Expected_End_Date

end

--exec LMS.uspGetCentres 109
