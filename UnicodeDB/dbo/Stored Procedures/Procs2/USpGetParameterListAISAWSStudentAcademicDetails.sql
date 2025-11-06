CREATE PROCEDURE [dbo].[USpGetParameterListAISAWSStudentAcademicDetails] 
AS
BEGIN
	SET NOCOUNT ON;
	select

distinct

TSASM.I_School_Session_ID,
TSASM.S_Label As Session,

TSASM.I_Brand_ID As Brand_ID,
TBM.S_Brand_Name As Brand,

isnull (TSG.I_School_Group_ID,'0') As School_Group_ID ,
isnull (TSG.S_School_Group_Name,'NA') As School_Group,
TC.I_Class_ID,
TC.S_Class_Name as Class ,
isnull (TS.I_Stream_ID,'0') as Stream_ID,
isnull (TS.S_Stream,'NA') as Stream, 
isnull (TSS.I_Section_ID,'0') as Section_ID ,
isnull(TSS.S_Section_Name,'NA') As Section
Into #tmp

from 
T_Student_Class_Section TSCS
left join T_School_Academic_Session_Master TSASM on 
TSCS.I_School_Session_ID=TSASM.I_School_Session_ID
left join T_Student_Detail TSD on 
TSD.I_Student_Detail_ID=TSCS.I_Student_Detail_ID
left join T_School_Group_Class TSGC on 
TSGC.I_School_Group_Class_ID=TSCS.I_School_Group_Class_ID
left join T_School_Group TSG on 
TSG.I_School_Group_ID=TSGC.I_School_Group_ID
and TSG.I_Brand_Id=TSASM.I_Brand_ID
left Join T_Class TC on TC.I_Class_ID=TSGC.I_Class_ID
left Join T_Stream TS on TS.I_Stream_ID=TSCS.I_Stream_ID 
left Join T_Section TSS on TSS.I_Section_ID=TSCS.I_Section_ID
left Join T_Brand_Master TBM on TBM.I_Brand_ID=TSASM.I_Brand_ID 

group by 

TBM.S_Brand_Name,
TSASM.I_Brand_ID,
TSASM.I_School_Session_ID,
TSASM.S_Label,
isnull (TSG.I_School_Group_ID,'0'),
isnull (TSG.S_School_Group_Name,'NA'),
TC.I_Class_ID,
TC.S_Class_Name,
isnull (TS.I_Stream_ID,'0'),
isnull (TS.S_Stream,'NA'), 
isnull (TSS.I_Section_ID,'0')  ,
isnull(TSS.S_Section_Name,'NA')
select * from #tmp

order by I_Class_ID,School_Group;


END
