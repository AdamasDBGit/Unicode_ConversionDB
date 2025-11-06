CREATE PROCEDURE [REPORT].[uspGetIDTConversionDetails]
(
@BrandID INT,
@HierarchyListID VARCHAR(MAX),
@StartDate DATETIME,
@EndDate DATETIME
)
AS
BEGIN


/* OLD CODE
select TSD.S_Student_ID,TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name as StudentName,
IDTBATCH.S_Center_Name,IDTBATCH.S_Course_Name as SourceCourse,IDTBATCH.S_Batch_Name as Sourcebatch,IDTBATCH.Dt_Valid_From as SourceValidFrom,
NONIDT.S_Course_Name as DestCourse,NONIDT.S_Batch_Name as DestBatch,NONIDT.Dt_Valid_From as DestValidFrom,
TSD.Dt_Crtd_On as AdmissionDate
from T_Student_Detail TSD
inner join
(
	select T1.I_Student_ID,T6.I_Center_ID,T6.S_Center_Name,T4.I_Course_ID,T4.S_Course_Name,T3.I_Batch_ID,T3.S_Batch_Name,T2.Dt_Valid_From 
	from
	(
		select A.I_Student_ID,MIN(A.I_Student_Batch_ID) as MinBatchID from T_Student_Batch_Details A
		where A.I_Status in (0,1,2)
		group by A.I_Student_ID
	) T1
	inner join T_Student_Batch_Details T2 on T1.MinBatchID=T2.I_Student_Batch_ID
	inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
	inner join T_Course_Master T4 on T3.I_Course_ID=T4.I_Course_ID
	inner join T_Center_Batch_Details T5 on T5.I_Batch_ID=T2.I_Batch_ID
	inner join T_Center_Hierarchy_Name_Details T6 on T6.I_Center_ID=T5.I_Centre_Id
	where
	T3.I_Course_ID=363
) IDTBATCH on TSD.I_Student_Detail_ID=IDTBATCH.I_Student_ID
LEFT JOIN
(
	select T1.I_Student_ID,T4.I_Course_ID,T4.S_Course_Name,T3.I_Batch_ID,T3.S_Batch_Name,T2.Dt_Valid_From from
	(
		select A.I_Student_ID,MIN(A.I_Student_Batch_ID) as MinBatchID from T_Student_Batch_Details A
		inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
		where A.I_Status in (0,1,2) and B.I_Course_ID!=363 and A.Dt_Valid_From IS NOT NULL
		group by A.I_Student_ID
	) T1
	inner join T_Student_Batch_Details T2 on T1.MinBatchID=T2.I_Student_Batch_ID
	inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
	inner join T_Course_Master T4 on T3.I_Course_ID=T4.I_Course_ID
) NONIDT on TSD.I_Student_Detail_ID=NONIDT.I_Student_ID
inner join T_Student_Center_Detail TSCD on TSCD.I_Student_Detail_ID=TSD.I_Student_Detail_ID 
											and CONVERT(DATE,TSCD.Dt_Valid_From)=CONVERT(DATE,TSD.Dt_Crtd_On)
where
(TSD.Dt_Crtd_On>=@StartDate and TSD.Dt_Crtd_On<DATEADD(d,1,@EndDate)) 
and TSCD.I_Centre_Id in (18,19)
and TSCD.I_Centre_Id in (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyListID,@BrandID) FGCFR)
*/

--NEW CODE ADDED ON 11.3.2022
select TSD.S_Student_ID,TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name as StudentName,
IDTBATCH.S_Center_Name,IDTBATCH.S_Course_Name as SourceCourse,IDTBATCH.S_Batch_Name as Sourcebatch,IDTBATCH.Dt_Valid_From as SourceValidFrom,
NONIDT.S_Course_Name as DestCourse,NONIDT.S_Batch_Name as DestBatch,NONIDT.Dt_Valid_From as DestValidFrom,
TSD.Dt_Crtd_On as AdmissionDate
from T_Student_Detail TSD
inner join
(
	select T1.I_Student_ID,T6.I_Center_ID,T6.S_Center_Name,T4.I_Course_ID,T4.S_Course_Name,T3.I_Batch_ID,T3.S_Batch_Name,T2.Dt_Valid_From 
	from
	(
		select A.I_Student_ID,MIN(A.I_Student_Batch_ID) as MinBatchID from T_Student_Batch_Details A
		inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
		where A.I_Status in (0,1,2) and B.I_Course_ID=363
		group by A.I_Student_ID
	) T1
	inner join T_Student_Batch_Details T2 on T1.MinBatchID=T2.I_Student_Batch_ID
	inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
	inner join T_Course_Master T4 on T3.I_Course_ID=T4.I_Course_ID
	inner join T_Center_Batch_Details T5 on T5.I_Batch_ID=T2.I_Batch_ID
	inner join T_Center_Hierarchy_Name_Details T6 on T6.I_Center_ID=T5.I_Centre_Id
	where
	T3.I_Course_ID=363
) IDTBATCH on TSD.I_Student_Detail_ID=IDTBATCH.I_Student_ID
LEFT JOIN
(
	select T1.I_Student_ID,T4.I_Course_ID,T4.S_Course_Name,T3.I_Batch_ID,T3.S_Batch_Name,T2.Dt_Valid_From from
	(
		select T.I_Student_ID,MIN(T.I_Student_Batch_ID) as MinBatchID from
		(
			select A.I_Student_ID,A.I_Student_Batch_ID from T_Student_Batch_Details A
			inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
			inner join T_Center_Batch_Details C on B.I_Batch_ID=C.I_Batch_ID
			where A.I_Status in (0,1,2) and B.I_Course_ID!=363 and A.Dt_Valid_From IS NOT NULL and I_Centre_Id in (18,19)
		) T
		group by T.I_Student_ID
	) T1
	inner join T_Student_Batch_Details T2 on T1.MinBatchID=T2.I_Student_Batch_ID
	inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
	inner join T_Course_Master T4 on T3.I_Course_ID=T4.I_Course_ID
) NONIDT on TSD.I_Student_Detail_ID=NONIDT.I_Student_ID and NONIDT.Dt_Valid_From>=IDTBATCH.Dt_Valid_From
inner join T_Student_Center_Detail TSCD on TSCD.I_Student_Detail_ID=TSD.I_Student_Detail_ID 
											--and CONVERT(DATE,TSCD.Dt_Valid_From)=CONVERT(DATE,TSD.Dt_Crtd_On)
where
(IDTBATCH.Dt_Valid_From>=@StartDate and IDTBATCH.Dt_Valid_From<DATEADD(d,1,@EndDate)) 
--and TSD.S_Student_ID='2122/RICE/1721'
and TSCD.I_Centre_Id in (18,19)
and TSCD.I_Centre_Id in (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@HierarchyListID,@BrandID) FGCFR)


END
