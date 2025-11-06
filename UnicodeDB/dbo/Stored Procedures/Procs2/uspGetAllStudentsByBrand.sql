CREATE PROCEDURE [dbo].[uspGetAllStudentsByBrand]
(
@iBrandID INT
)
AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

--SELECT  [I_Student_Detail_ID] StudentID
--      ,ISNULL([S_First_Name],'') +' '+ ISNULL([S_Middle_Name],'') +' '+ ISNULL([S_Last_Name],'')+' ('+S_Student_ID+')' AS StudentName
--  FROM T_Student_Detail where I_Status = 1
select t4.I_Student_Detail_ID StudentID
 ,ISNULL(t4.S_First_Name,'') +' '+ ISNULL(t4.[S_Middle_Name],'') +' '+ ISNULL(t4.[S_Last_Name],'')+' ('+t4.S_Student_ID+')' AS StudentName
from T_Student_Batch_Details as t1 
join T_Student_Batch_Master as t2 on t1.I_Batch_ID = t2.I_Batch_ID
join T_Student_Detail as t4 on t4.I_Student_Detail_ID = t1.I_Student_ID
join T_Course_Master as t5 on t5.I_Course_ID = t2.I_Course_ID
--added by susmita for include parent
left join T_Parent_Master TPM 
on t4.S_Guardian_Mobile_No = TPM.S_Mobile_No 
----------------------------------------
where t4.I_Status=1 and t5.I_Brand_ID=@iBrandID and t1.I_Status=1
group by t4.I_Student_Detail_ID,t4.S_Student_ID,t4.S_First_Name,t4.[S_Middle_Name],t4.[S_Last_Name]
;
	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
