CREATE PROCEDURE [ACADEMICS].[uspStudentStatusGenerator]
(
@dtExecutionDate DATETIME=NULL
)
AS 
    BEGIN
        IF @dtExecutionDate = NULL 
            SET @dtExecutionDate = GETDATE()
        
        EXEC ACADEMICS.uspInsertUpdateStudentStatusDefaulter @dtExecutionDate = @dtExecutionDate -- date.............1    
        EXEC ACADEMICS.uspInsertUpdateStudentStatusCompleted @dtExecutionDate = @dtExecutionDate -- date.............2
            
            
    END
