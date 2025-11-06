


CREATE PROCEDURE [dbo].[Usp_ERP_Class_RoleMapping]
@iSessionID int,
@iBrandID int=null,
@iSchoolGroupID int=null,
@iClassID int=null,
@iStreamID int=null,
@iSectionID int=Null
as
SET NOCOUNT ON;  

select 
TSCS.I_School_Session_ID SchoolSessionID,
TSCS.I_School_Group_Class_ID SchoolGroupClassID	, 
TSCS.I_Section_ID SectionID,
TSCS.I_Stream_ID StreamID,
TC.S_Class_Name ClassName,
TSG.S_School_Group_Name SchoolGroupName,
ISNULL(TS.S_Section_Name,'NA') SectionName,
ISNULL(TST.S_Stream,'NA') Stream,
TSG.I_School_Group_ID SchoolGroupID,
TC.I_Class_ID ClassID,
TSASM.S_Label Label

from T_Student_Class_Section TSCS 
inner join T_School_Group_Class TSGS ON TSGS.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID
inner join T_School_Group TSG ON TSG.I_School_Group_ID = TSGS.I_School_Group_ID
inner join T_School_Academic_Session_Master TSASM ON TSASM.I_School_Session_ID = TSCS.I_School_Session_ID
inner join T_Class TC ON TC.I_Class_ID = TSGS.I_Class_ID
left join T_Section TS ON TS.I_Section_ID = TSCS.I_Section_ID
left join T_Stream TST ON TST.I_Stream_ID = TSCS.I_Stream_ID
where TSCS.I_School_Session_ID=@iSessionID
and TSG.I_School_Group_ID=ISNULL(@iSchoolGroupID,TSG.I_School_Group_ID)
and --TSCS.I_Section_ID = ISNULL(@iSectionID,TSCS.I_Section_ID)
(TSCS.I_Section_ID = @iSectionID OR @iSectionID IS NULL)
and TSG.I_Brand_Id = @iBrandID
and TC.I_Class_ID = ISNULL(@iClassID,TC.I_Class_ID)
and --TSCS.I_Stream_ID = ISNULL(@iStreamID,TSCS.I_Stream_ID)
(TSCS.I_Stream_ID = @iStreamID OR  @iStreamID IS NULL)

group by 
TSCS.I_School_Session_ID,
TSCS.I_School_Group_Class_ID,
TSCS.I_Section_ID,
TSCS.I_Stream_ID,
TC.S_Class_Name,
TSG.S_School_Group_Name,
TS.S_Section_Name,
TST.S_Stream,
TSG.I_School_Group_ID,
TC.I_Class_ID,
TSASM.S_Label


