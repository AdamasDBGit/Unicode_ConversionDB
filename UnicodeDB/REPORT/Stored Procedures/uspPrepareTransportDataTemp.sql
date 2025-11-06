CREATE PROCEDURE [REPORT].[uspPrepareTransportDataTemp]
AS
BEGIN

DECLARE @stdid int
DECLARE @cid int
DECLARE @cname varchar(50)
DECLARE @stdate date
DECLARE @tempstdid int
DECLARE @i int=1
DECLARE @enddate date


create table #temptable
(
centerid int,
centername varchar(50),
studentid int
)

create table #temptable2
(
centerid int,
centername varchar(50),
studentid int,
routeid int,
pickuppointid int,
routename varchar(50),
dtcrtd date,
rankid int,
dtStart date,
dtEnd date,
Collectable numeric(18,2)
)




insert into #temptable
(
centerid,
centername,
studentid
)
select distinct D.I_Centre_Id,E.S_Center_Name,A.I_Student_Detail_ID from T_Student_Detail A
inner join T_Student_Batch_Details B on A.I_Student_Detail_ID=B.I_Student_ID
inner join T_Student_Batch_Master C on B.I_Batch_ID=C.I_Batch_ID
inner join T_Center_Batch_Details D on C.I_Batch_ID=D.I_Batch_ID
inner join T_Center_Hierarchy_Name_Details E on D.I_Centre_Id=E.I_Center_ID
where
A.I_Status=1
and
B.I_Status=1
and
(C.Dt_BatchStartDate>'2013-01-01' AND C.Dt_BatchStartDate<'2014-01-01')
and
D.I_Centre_Id in (1,36)
order by D.I_Centre_Id,A.I_Student_Detail_ID


insert into #temptable2
(centerid,centername,studentid,routeid,routename,pickuppointid,dtcrtd,rankid,dtStart)
select A.centerid,A.centername,A.studentid,B.I_Route_ID,C.S_Route_No,B.I_PickupPoint_ID,B.Dt_Crtd_On,
DENSE_RANK() over (partition by A.studentid order by B.Dt_Crtd_On desc ),B.Dt_Crtd_On
from #temptable A
inner join T_Student_Transport_History B on A.studentid=B.I_Student_Detail_ID
inner join T_BusRoute_Master C on B.I_Route_ID=C.I_Route_ID
where
(B.Dt_Crtd_On>'2012-09-01' AND B.Dt_Crtd_On<'2013-09-01')
order by A.centerid,A.centername,A.studentid

UPDATE #temptable2 set dtEnd=GETDATE() where rankid=1

DECLARE @n int=(select distinct top 1 rankid from #temptable2 order by rankid desc)

WHILE @i<@n
BEGIN

DECLARE StudentSurfer CURSOR
FOR
SELECT studentid FROM #temptable

OPEN StudentSurfer
FETCH NEXT FROM StudentSurfer
INTO @stdid

WHILE @@FETCH_STATUS=0
BEGIN

UPDATE #temptable2 set dtEnd=(select #temptable2.dtStart from #temptable2 where #temptable2.studentid=@stdid and #temptable2.rankid=@i)
where
rankid=@i+1
and
studentid=@stdid

FETCH NEXT FROM StudentSurfer
INTO @stdid

END

CLOSE StudentSurfer
DEALLOCATE StudentSurfer;

SET @i=@i+1;

END

DECLARE CollectionPopulator CURSOR
FOR
SELECT studentid,centerid,dtStart,dtEnd FROM #temptable2

OPEN CollectionPopulator
FETCH NEXT FROM CollectionPopulator
INTO @stdid,@cid,@stdate,@enddate

WHILE @@FETCH_STATUS=0
BEGIN

DECLARE @tempcollection table
(
studentid int,
centerid int,
dtStart date,
Collectible numeric(18,2)
)



INSERT INTO @tempcollection(centerid,studentid,dtStart,Collectible)
(
select B.I_Centre_Id,B.I_Student_Detail_ID,B.Dt_Invoice_Date,SUM(D.N_Amount_Due) from T_Invoice_Parent B
inner join T_Invoice_Child_Header C on B.I_Invoice_Header_ID=C.I_Invoice_Header_ID
inner join T_Invoice_Child_Detail D on C.I_Invoice_Child_Header_ID=D.I_Invoice_Child_Header_ID
where
B.I_Student_Detail_ID=@stdid
and
B.I_Centre_Id=@cid
and
(B.Dt_Invoice_Date>=@stdate and B.Dt_Invoice_Date<DATEADD(dd,1,@stdate))
and
(D.Dt_Installment_Date>=@stdate and D.Dt_Installment_Date<@enddate)
and
D.I_Fee_Component_ID in (31,44,45)
group by B.I_Centre_Id,B.I_Student_Detail_ID,B.Dt_Invoice_Date
)

/*

UPDATE #tempcollection SET centerid=@cid,dtStart=@stdate,dtEnd=@enddate where studentid=@stdid and centerid=null and dtStart=null and dtEnd=null
*/
UPDATE #temptable2 set Collectable=(select sum(Collectible) from @tempcollection)
where studentid=@stdid and centerid=@cid and dtStart=@stdate and dtEnd=@enddate

UPDATE @tempcollection SET studentid=NULL,centerid=NULL,dtStart=NULL,Collectible=NULL;


FETCH NEXT FROM CollectionPopulator
INTO @stdid,@cid,@stdate,@enddate

END

CLOSE CollectionPopulator
DEALLOCATE CollectionPopulator;




/*
DECLARE @n int=(select distinct top 1 rankid from #temptable2 order by rankid desc) 

WHILE @i<@n
BEGIN

DECLARE StudentOuter CURSOR
FOR
SELECT studentid,dtStart from #temptable2 where rankid=@i


OPEN StudentOuter
FETCH NEXT FROM StudentOuter
INTO @tempstdid,@stdate

WHILE @@FETCH_STATUS=0

			DECLARE StudentInner CURSOR
			FOR
			SELECT studentid from #temptable2 where rankid=@i+1 and studentid=@tempstdid


			OPEN StudentInner
			FETCH NEXT FROM StudentInner
			INTO @stdid

			IF @stdid<>@tempstdid
			BREAK;

			WHILE @@FETCH_STATUS=0 and @stdid=@tempstdid
			BEGIN
			UPDATE #temptable2 set dtEnd=@stdate where studentid=@stdid and rankid=@i+1;
			END

			FETCH NEXT FROM StudentInner
			INTO @stdid

			CLOSE StudentInner
			DEALLOCATE StudentInner;

FETCH NEXT FROM StudentOuter
INTO @tempstdid,@stdate

CLOSE StudentOuter
DEALLOCATE StudentOuter;

SET @i=@i+1;

END

DECLARE TablePopulator CURSOR
FOR
SELECT centerid,studentid,routeid,routename,dtcrtd,dtStart,dtEnd FROM #temptable2
*/
--DELETE FROM dbo.T_TransportDataForOracle;

--INSERT INTO dbo.T_TransportDataForOracle
--(
--I_Center_ID,
--S_Center_Name,
--I_Student_Detail_ID,
--I_Route_ID,
--I_PickUpPoint_ID,
--S_Route_Name,
--Dt_Crtd_On,
--I_Rank_ID,
--Dt_StartDate,
--Dt_EndDate,
--N_Collectable
--)
select * from #temptable2;

END
