CREATE PROCEDURE [dbo].[uspStudentSubBatchDetails]   --19,NULL,'CE',NULL,NULL         
(            
     @I_Batch_ID INT =NULL ,
     @CenterId INT =NULL,
     @Flag Varchar(100) =NULL,
     @S_Student_ID Varchar(50) =NULL 
            
           
)            
            
AS            
            
BEGIN            
      SET NOCOUNT ON;               
   IF @Flag='ParticularBatchDtls'     
   BEGIN          
   SELECT I_Sub_Batch_ID,[S_Sub_Batch_Code],[S_Sub_Batch_Name] FROM   T_Student_Sub_Batch_Master     WHERE [I_Batch_ID] = @I_Batch_ID    
      AND I_Status=1
      END
       ELSE IF @Flag='StudentSubBachMap'     
   BEGIN  
  SELECT  I_Sub_Batch_ID FROM  T_Student_Sub_Batch_Student_Mapping  TSB WHERE  TSB.I_Student_Detail_ID=CONVERT(INT,ISNULL(@S_Student_ID,0))   AND TSB.I_Status = 1         
 
     -- AND I_Status=1
      END
      ELSE IF  @Flag='ViewDetails'  
      BEGIN
         SELECT S_Batch_Name as BatchName,I_Sub_Batch_ID,[S_Sub_Batch_Code],[S_Sub_Batch_Name]
          FROM   T_Student_Sub_Batch_Master  TSB 
          INNER JOIN T_Student_Batch_Master TB ON TSB.I_Batch_ID=TB.I_Batch_ID
          INNER JOIN dbo.T_Center_Batch_Details B ON B.I_Batch_ID = TB.I_Batch_ID
          WHERE B.I_Centre_Id= @CenterId AND TSB.I_Status=1
          ORDER BY S_Batch_Code 
      END        
END
