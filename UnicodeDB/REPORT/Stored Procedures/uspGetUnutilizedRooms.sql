CREATE PROCEDURE [REPORT].[uspGetUnutilizedRooms]
(
@FromDate as date,
@ToDate as date,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX)
)

as 
begin


declare @index int
create table #datetable 
(
id int identity primary key,
s_Date date
);

create table #unutilizedrm
(
sc_date date,
I_TimeSlot_ID int,
I_Center_ID int,
Dt_Start_Time varchar(50),
Dt_End_Time varchar(50),
I_Room_ID int,
S_Building_Name varchar(50),
S_Block_Name varchar(50),
S_Floor_Name varchar(50),
S_Room_No varchar(50),
S_Center_Name varchar(50),
flag int,
instance_chain varchar(MAX)
)

set @index=(DATEDIFF(DAY,@FromDate,@ToDate));
 
		while(@index>=0)
		begin
			if(@index=0)
			begin
				insert into #datetable(s_Date)
					values(@FromDate);
			end
								
		else
			begin
				insert into #datetable(s_Date)
					values(DATEADD(DAY,@index,@FromDate))
			end	
		set @index=@index-1;
		if @index=-1
		break;
	end
			
			
insert into #unutilizedrm( sc_date,I_TimeSlot_ID,I_Room_ID,S_Building_Name,S_Block_Name,S_Floor_Name,S_Room_No,I_Center_ID,instance_chain)
select dt.s_Date,ctsm.I_TimeSlot_ID, rm.I_Room_ID,rm.S_Building_Name,rm.S_Block_Name,rm.S_Floor_Name,rm.S_Room_No,rm.I_Centre_Id,FN2.instanceChain 
from #datetable dt
cross join  T_Center_Timeslot_Master ctsm
cross join T_Room_Master rm
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON ctsm.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
where 
rm.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 

and ctsm.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 


/* initial query*/
--update un
--set un.flag=1
--from #unutilizedrm un 
--inner join T_TimeTable_Master ttm
--on un.sc_date=ttm.Dt_Schedule_Date
--or un.sc_date=ttm.Dt_Actual_Date
--and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
--and un.I_Room_ID=ttm.I_Room_ID
--where 
--un.sc_date=ttm.Dt_Schedule_Date
--or un.sc_date=ttm.Dt_Actual_Date
--and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
--and un.I_Room_ID=ttm.I_Room_ID

/*based on actual date*/
update un
set un.flag=1
from #unutilizedrm un 
inner join T_TimeTable_Master ttm
on un.sc_date=ttm.Dt_Actual_Date
and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
and un.I_Room_ID=ttm.I_Room_ID
where 
 un.sc_date=ttm.Dt_Actual_Date
and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
and un.I_Room_ID=ttm.I_Room_ID
and ttm.I_Is_Complete=1


/*based on schedule date*/
update un
set un.flag=1
from #unutilizedrm un 
inner join T_TimeTable_Master ttm
on un.sc_date=ttm.Dt_Schedule_Date
and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
and un.I_Room_ID=ttm.I_Room_ID
where 
un.sc_date=ttm.Dt_Schedule_Date
and un.I_TimeSlot_ID=ttm.I_TimeSlot_ID
and un.I_Room_ID=ttm.I_Room_ID
and ttm.I_Is_Complete=0

/*cout of utilized room and deleting them*/
--select COUNT(*) from #unutilizedrm where flag =1;
delete from #unutilizedrm where flag=1;


/*time slot update*/

update #unutilizedrm 
set Dt_Start_Time=
(select convert(varchar(5),Dt_Start_Time,108)
 from T_Center_Timeslot_Master ctsm
where #unutilizedrm.I_TimeSlot_ID=ctsm.I_TimeSlot_ID)

update #unutilizedrm 
set Dt_End_Time=
(select convert(varchar(5),Dt_End_Time,108)
 from T_Center_Timeslot_Master ctsm
where #unutilizedrm.I_TimeSlot_ID=ctsm.I_TimeSlot_ID)


update #unutilizedrm 
set S_Center_Name
=(select chnd.S_Center_Name from T_Center_Hierarchy_Name_Details chnd
where #unutilizedrm.I_Center_ID=chnd.I_Center_Id);

select u.sc_date,u.Dt_Start_Time+'-'+u.Dt_End_Time Time_Slot,u.I_TimeSlot_ID,
u.S_Building_Name,u.S_Block_Name,u.S_Floor_Name,u.S_Room_No,u.S_Center_Name,u.I_Center_ID,instance_chain
 from #unutilizedrm u
order by u.sc_date,u.I_TimeSlot_ID;

drop table #datetable;
drop table #unutilizedrm;


end
