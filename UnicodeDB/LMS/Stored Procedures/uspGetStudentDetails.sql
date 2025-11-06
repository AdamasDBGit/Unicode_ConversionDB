CREATE PROCEDURE [LMS].[uspGetStudentDetails](@BrandID int,@CentreID int=NULL,@CourseID int=NULL, @BatchID int=NULL, @StudentID varchar(max)=NULL)
as
begin

select DISTINCT TSD.I_Student_Detail_ID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') as S_Middle_Name,
TSD.S_Last_Name,TSD.S_Mobile_No,ISNULL(TSD.S_Email_ID,'') as S_Email_ID,
ISNULL(TSD.S_Curr_Address1,'') as S_Curr_Address1,ISNULL(TCM3.S_Country_Name,'') as S_Country_Name,
ISNULL(TSM.S_State_Name,'') as S_State_Name,ISNULL(TCM4.S_City_Name,'') as S_City_Name,
ISNULL(TSD.S_Curr_Pincode,'') as S_Curr_Pincode,
TERD.S_Student_Photo,
CASE WHEN TSD.I_Status=1 Then 0 ELSE 1 END as IsDiscontinued
from T_Student_Detail TSD
inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID and TSBD.I_Status=1
inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID and TCM.I_Brand_ID=@BrandID
inner join T_Centre_Master TCM2 on TSCD.I_Centre_Id=TCM2.I_Centre_Id and TCM2.I_Status=1
inner join T_Country_Master TCM3 on TSD.I_Curr_Country_ID=TCM3.I_Country_ID
left join T_State_Master TSM on TSD.I_Curr_State_ID=TSM.I_State_ID
left join T_City_Master TCM4 on TCM4.I_City_ID=TSD.I_Curr_City_ID
where
TSD.S_Student_ID=ISNULL(@StudentID,TSD.S_Student_ID)
and TSCD.I_Centre_Id=ISNULL(@CentreID,TCM2.I_Centre_ID)
and TSBD.I_Batch_ID=ISNULL(@BatchID,TSBM.I_Batch_ID)
and TSBM.I_Course_ID=ISNULL(@CourseID,TCM.I_Course_ID)


select TSD.I_Student_Detail_ID,TSD.S_Student_ID,TCM2.I_Centre_Id,TCM2.S_Center_Name,
TSBM.I_Batch_ID,TSBM.S_Batch_Name,TCM.S_Course_Name,TSBM.S_Batch_Code,TSBM.Dt_BatchStartDate,
TSBM.Dt_Course_Expected_End_Date as BatchEndDate
from T_Student_Detail TSD
inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID and TSBD.I_Status=1
inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID and TCM.I_Brand_ID=@BrandID
inner join T_Centre_Master TCM2 on TSCD.I_Centre_Id=TCM2.I_Centre_Id and TCM2.I_Status=1
inner join T_Country_Master TCM3 on TSD.I_Curr_Country_ID=TCM3.I_Country_ID
left join T_State_Master TSM on TSD.I_Curr_State_ID=TSM.I_State_ID
left join T_City_Master TCM4 on TCM4.I_City_ID=TSD.I_Curr_City_ID
where
TSD.S_Student_ID=ISNULL(@StudentID,TSD.S_Student_ID)
and TSCD.I_Centre_Id=ISNULL(@CentreID,TCM2.I_Centre_ID)
and TSBD.I_Batch_ID=ISNULL(@BatchID,TSBM.I_Batch_ID)
and TSBM.I_Course_ID=ISNULL(@CourseID,TCM.I_Course_ID)

end
