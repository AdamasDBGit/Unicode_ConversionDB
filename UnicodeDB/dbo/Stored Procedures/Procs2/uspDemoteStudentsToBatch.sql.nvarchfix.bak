CREATE PROCEDURE [dbo].[uspDemoteStudentsToBatch]  
-- Add the parameters for the stored procedure here  
    @iTobatchId INT ,  
    @iFrombatchId INT ,  
    @istudentIdsStr Nnvarchar(max)  
AS   
    BEGIN TRY  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 -- 2 stands for promoted out / 3 stands for promoted in  
        SET NOCOUNT ON  
   
        IF EXISTS (SELECT  *  
                    FROM    dbo.T_Student_Batch_Details  
                    WHERE   I_Batch_ID = @iFrombatchId  
                            AND I_Student_ID IN ( SELECT  Val  
        FROM    fnString2Rows(@istudentIdsStr, ','))  
                            AND I_Status = 3 AND I_FromBatch_ID=@iTobatchId )   
            BEGIN  
                UPDATE  dbo.T_Student_Batch_Details  
                SET     I_Status = 0,I_FromBatch_ID=NULL 
                WHERE   I_Batch_ID = @iFrombatchId  
                        AND I_Student_ID IN (SELECT  Val  
       FROM    fnString2Rows(@istudentIdsStr, ','))  
                        AND I_Status = 3 
                        
       END                  
   
    IF EXISTS (SELECT  *  
                    FROM    dbo.T_Student_Batch_Details  
                    WHERE   I_Batch_ID = @iTobatchId  
                            AND I_Student_ID IN ( SELECT  Val  
        FROM    fnString2Rows(@istudentIdsStr, ','))  
                            AND I_Status = 2 AND I_ToBatch_ID=@iFrombatchId )  
   BEGIN 
   
            UPDATE  dbo.T_Student_Batch_Details  
                SET     I_Status = 1,I_ToBatch_ID=NULL 
                WHERE   I_Batch_ID = @iTobatchId  
                        AND I_Student_ID IN (SELECT  Val  
       FROM    fnString2Rows(@istudentIdsStr, ','))  
                        AND I_Status = 2  
   END
   ELSE
   RAISERROR('Wrong Destination Batch',11,1)
    END TRY  
    BEGIN CATCH  
 --Error occurred:    
  
        DECLARE @ErrMsg Nnvarchar(max) ,  
            @ErrSeverity INT  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH

