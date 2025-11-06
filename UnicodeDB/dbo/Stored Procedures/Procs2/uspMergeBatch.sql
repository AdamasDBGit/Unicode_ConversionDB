CREATE PROCEDURE [dbo].[uspMergeBatch] --[dbo].[uspMergeBatch] '<Root><MergeBatch I_Student_ID="963" I_Batch_ID="48" /><MergeBatch I_Student_ID="1213" I_Batch_ID="47" /></Root>', 149    
    (
      @SMergeBatchXML XML = NULL ,
      @IdesBatchID INT ,
      @SCrtdby NVARCHAR(max) ,  
      @DtCrtdOn DATETIME                 
    )
AS 
    BEGIN TRY                        
        BEGIN TRANSACTION  
          
        -- Create Temporary Table To TimeTable source Information              
        CREATE TABLE #tempMergeBatch
            (
              I_Student_ID INT ,
              I_Batch_ID INT
            )    
     
   -- Insert Values into Temporary Table              
        INSERT  INTO #tempMergeBatch
                SELECT  T.c.value('@I_Student_ID', 'int') ,
                        T.c.value('@I_Batch_ID', 'int')
                FROM    @SMergeBatchXML.nodes('/Root/MergeBatch') T ( c )                    
         
                  
        UPDATE  dbo.T_Student_Batch_Details
        SET     I_Status = 0
        FROM    #tempMergeBatch AS TMB
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TMB.I_Batch_ID = TSBD.I_Batch_ID
                                                              AND TMB.I_Student_ID = TSBD.I_Student_ID    
          
        INSERT  INTO dbo.T_Student_Batch_Details
                ( I_Student_ID ,
                  I_Batch_ID ,
                  I_Status  
                )
                SELECT  TMB.I_Student_ID ,
                        @IdesBatchID ,
                        1
                FROM    #tempMergeBatch AS TMB    
          
        
        UPDATE  dbo.T_Invoice_Batch_Map
        SET     I_Status = 0,
				S_Updt_By = @SCrtdby ,  
				Dt_Updt_On = @DtCrtdOn
        FROM    #tempMergeBatch AS TMB
                INNER JOIN dbo.T_Invoice_Parent AS TIP ON TMB.I_Student_ID = TIP.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                INNER JOIN dbo.T_Invoice_Batch_Map AS TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                                                              AND TMB.I_Batch_ID = TIBM.I_Batch_ID
        INSERT  INTO dbo.T_Invoice_Batch_Map
                ( I_Invoice_Child_Header_ID ,
                  I_Batch_ID ,
                  I_Status,
                  S_Crtd_by ,  
				  Dt_Crtd_On  
                )
                SELECT  I_Invoice_Child_Header_ID ,
                        @IdesBatchID ,
                        1 ,
                        @SCrtdby ,
                        @DtCrtdOn
                FROM    dbo.T_Invoice_Child_Header
                WHERE   I_Invoice_Header_ID IN (
                        SELECT  I_Invoice_Header_ID
                        FROM    dbo.T_Invoice_Parent
                        WHERE   I_Student_Detail_ID IN (
                                SELECT  TMB.I_Student_ID
                                FROM    #tempMergeBatch AS TMB ) )
                                
        COMMIT TRANSACTION        
    END TRY                        
    BEGIN CATCH                        
        ROLLBACK TRANSACTION                       
        DECLARE @ErrMsg NVARCHAR(max) ,
            @ErrSeverity INT                        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                        
                        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                        
    END CATCH


