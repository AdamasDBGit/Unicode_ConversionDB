
-- =============================================
-- Author:		<Swadesh Bhattacharya>
-- Create date: <08-10-2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Insert_T_ERP_User_School_Group_Class]
	-- Add the parameters for the stored procedure here
  @User_ID INT
 ,@Brand_ID INT
 ,@School_Group_ID INT
 ,@Class_IDs VARCHAR(MAX) 
 ,@Stream_ID INT
 ,@Section_ID INT
AS
BEGIN
	
	DECLARE @Class_ID INT

    BEGIN TRY    
  BEGIN TRAN   	   
	   
   WHILE(LEN(@Class_IDs) > 0)    
   BEGIN    
         IF (LEN(@Class_IDs) > 0)    
          BEGIN    
                SET @Class_ID = CAST(SUBSTRING(@Class_IDs ,1,PATINDEX('%$%',@Class_IDs)-1) AS int)    
                SET @Class_IDs = SUBSTRING(@Class_IDs,PATINDEX('%$%',@Class_IDs)+1,LEN(@Class_IDs)-PATINDEX('%$%',@Class_IDs))    
           END  
           
           INSERT INTO [dbo].[T_ERP_User_School_Group_Class]
           ([I_User_ID]
           ,[I_Brand_ID]
           ,[I_School_Group_ID]
           ,[I_Class_ID]
           ,[I_Stream_ID]
           ,[I_Section_ID])
     VALUES
           (@User_ID
           ,@Brand_ID
           ,@School_Group_ID
           ,@Class_ID
           ,@Stream_ID
           ,@Section_ID)
   END
  
   COMMIT TRAN    
 END TRY    
 BEGIN CATCH 
    
    ROLLBACK   
 END CATCH  
END
