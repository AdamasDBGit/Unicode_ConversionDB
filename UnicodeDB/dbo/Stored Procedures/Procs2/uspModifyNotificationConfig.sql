CREATE PROCEDURE [dbo].[uspModifyNotificationConfig] 
(
@TaskName Nnvarchar(max),
@HierarchyName Nnvarchar(max)
)
AS
BEGIN

DECLARE @TaskId int 
SET @TaskId = (SELECT I_Task_Master_Id FROM T_Task_Master WHERE S_Name = @TaskName)

INSERT INTO T_Task_Hierarchy_Mapping_Audit (I_Task_Master_Id,I_Hierarchy_Detail_ID)
	SELECT I_Task_Master_Id, I_Hierarchy_Detail_ID FROM T_Task_Hierarchy_Mapping 
		WHERE I_Task_Master_Id = @TaskId

DELETE FROM T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id = @TaskId

INSERT INTO T_Task_Hierarchy_Mapping(I_Task_Master_Id,I_Hierarchy_Detail_ID)
	SELECT @TaskId,* from dbo.fnString2Rows(@HierarchyName,',')

END

