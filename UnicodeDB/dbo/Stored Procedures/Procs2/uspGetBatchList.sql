CREATE PROCEDURE [dbo].[uspGetBatchList](@CentreID INT)
As
begin

select A.I_Batch_ID,A.S_Batch_Name+' ('+C.S_Course_Name+')' as S_Batch_Name from T_Student_Batch_Master A
inner join T_Center_Batch_Details B on A.I_Batch_ID=B.I_Batch_ID
inner join  T_Course_Master C on A.I_Course_ID=C.I_Course_ID
where B.I_Centre_Id=@CentreID and C.I_Status=1
and A.I_Batch_ID not in
(
	select DISTINCT BatchID from T_Student_Batch_TimeSlot_Details
)
order by C.I_Course_ID,A.Dt_BatchStartDate DESC

end


