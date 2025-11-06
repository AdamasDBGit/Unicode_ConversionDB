CREATE PROCEDURE [dbo].[uspGetTimeTableData]
(
@iBatchID INT,
@dtSchDate DATE
)

AS

BEGIN
 SELECT TTTM.I_TimeTable_ID AS I_Session_ID ,
        TTTM.S_Session_Name ,
        TTTM.S_Session_Topic ,
        ISNULL(TESM.I_Skill_ID, 0) AS I_Skill_ID ,
        ISNULL(TESM.S_Skill_Desc, 'Extra Session') AS S_Skill_Desc,
        ROW_NUMBER() OVER (ORDER BY TTTM.I_TimeTable_ID) AS I_Sequence
 FROM   dbo.T_TimeTable_Master TTTM
        LEFT JOIN dbo.T_Session_Master TSM ON TTTM.I_Session_ID = TSM.I_Session_ID
        LEFT JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
 WHERE  TTTM.I_Batch_ID = @iBatchID
        AND DATEDIFF(d, @dtSchDate, TTTM.Dt_Schedule_Date) = 0
        AND TTTM.I_Status = 1
        AND TTTM.I_Is_Complete = 1
        AND TTTM.I_TimeTable_ID NOT IN
        (
        SELECT TCTM.I_TimeTable_ID FROM EXAMINATION.T_ClassTest_Master TCTM WHERE TCTM.I_Batch_ID=@iBatchID AND TCTM.I_Status=1
        )
 ORDER BY TTTM.I_TimeTable_ID
END
