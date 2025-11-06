CREATE PROCEDURE [dbo].[UspSearchList]
@Session_ID NVARCHAR(max),
@Brand_ID NVARCHAR(max)=null,
@Student__Detail_ID NVARCHAR(max)=Null,
@School_Group_ID NVARCHAR(max)=null,
@Class_ID NVARCHAR(max)=null,
@Stream_ID NVARCHAR(max)=null,
@Section_ID NVARCHAR(max)=Null
as
SET NOCOUNT ON;  

select
TSASM.I_Brand_ID As Brand_ID,
TBM.S_Brand_Name As Brand,
TSD.I_Student_Detail_ID ,
TSD.S_Student_ID As Student_ID,
TSD.S_First_Name+' '+
isnull (TSD.S_Middle_Name,'')
+' '+TSD.S_Last_Name as Name,

TSASM.I_School_Session_ID,
TSASM.S_Label As Session,
isnull (TSG.I_School_Group_ID,'0') As School_Group_ID ,
isnull (TSG.S_School_Group_Name,'NA') As School_Group,
TC.I_Class_ID,
TC.S_Class_Name as Class ,
isnull (TS.I_Stream_ID,'0') as Stream_ID,
isnull (TS.S_Stream,'NA') as Stream, 
isnull (TSS.I_Section_ID,'0') as Section_ID ,
isnull(TSS.S_Section_Name,'NA') As Section


from T_Student_Class_Section TSCS
left join T_School_Academic_Session_Master TSASM on TSCS.I_School_Session_ID=TSASM.I_School_Session_ID
left join T_Student_Detail TSD on TSD.I_Student_Detail_ID=TSCS.I_Student_Detail_ID
left join T_School_Group_Class TSGC on TSGC.I_School_Group_Class_ID=TSCS.I_School_Group_Class_ID
left join T_School_Group TSG on TSG.I_School_Group_ID=TSGC.I_School_Group_ID
and TSG.I_Brand_Id=TSASM.I_Brand_ID
left Join T_Class TC on TC.I_Class_ID=TSGC.I_Class_ID
left Join T_Stream TS on TS.I_Stream_ID=TSCS.I_Stream_ID 
left Join T_Section TSS on TSS.I_Section_ID=TSCS.I_Section_ID
left Join T_Brand_Master TBM on TBM.I_Brand_ID=TSASM.I_Brand_ID 

where TSASM.I_School_Session_ID=@Session_ID 

and (TBM.I_Brand_ID=@Brand_ID or @Brand_ID is null)
and (TSD.I_Student_Detail_ID=@Student__Detail_ID or @Student__Detail_ID is null)
and (TSG.I_School_Group_ID=@School_Group_ID or @School_Group_ID is null) 
and (TC.I_Class_ID=@Class_ID or @Class_ID is null)
and (TS.I_Stream_ID=@Stream_ID or @Stream_ID is null)
and (TSS.I_Section_ID=@Section_ID or @Section_ID is null) ;



