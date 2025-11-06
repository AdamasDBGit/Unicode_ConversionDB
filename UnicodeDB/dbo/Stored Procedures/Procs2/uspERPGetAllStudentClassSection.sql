CREATE PROCEDURE [dbo].[uspERPGetAllStudentClassSection]
(
 @iBrandID int = null
 ,@iClassID int = null
)
AS
BEGIN
SELECT 
TSD.S_First_Name+' '+TSD.S_Middle_Name+' '+TSD.S_Last_Name StudentName
,TSD.I_Student_Detail_ID StudentDetailID
,TSASM.S_Label SessionName
,TSASM.I_School_Session_ID SchoolSessionID
,TS.I_Section_ID SectionID 
,TS.S_Section_Name SectionName 
,TSE.I_Stream_ID StreamID
,TSE.S_Stream Stream
,TC.I_Class_ID ClassID
,TC.S_Class_Name ClassName
from 
T_Student_Class_Section TSCS 
inner join 
T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
inner join 
T_School_Academic_Session_Master TSASM ON TSASM.I_School_Session_ID = TSCS.I_School_Session_ID
inner join 
T_School_Group_Class TSGS ON TSGS.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID
inner join 
T_Class TC ON TC.I_Class_ID = TSGS.I_Class_ID
inner join 
T_School_Group TSG ON TSG.I_School_Group_ID = TSGS.I_School_Group_ID
inner join 
T_Section TS ON TS.I_Section_ID = TSCS.I_Section_ID
left join 
T_Stream TSE ON TSE.I_Stream_ID = TSCS.I_Stream_ID
where TC.I_Class_ID = ISNULL(@iClassID,TC.I_Class_ID) and TSG.I_Brand_Id = ISNULL(@iBrandID,TSG.I_Brand_Id)


END
