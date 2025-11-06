CREATE PROCEDURE [dbo].[uspSaveSubBatchStudentMapping]
    (
      @sBatchStdTableXML XML = NULL       
    )
AS 
    BEGIN TRY                    
        SET NOCOUNT OFF ;                    
        BEGIN TRANSACTION                    
        
        CREATE TABLE #T_Student_Sub_Batch_Student_Mapping
            (
              srlno INT IDENTITY(1, 1) ,
              I_Sub_Batch_ID INT ,
              S_Student_ID VARCHAR(50) ,
              I_Batch_ID INT ,
              I_Status INT ,
              S_Crtd_By VARCHAR(20) ,
              S_Updt_By VARCHAR(20) ,
              Dt_Crtd_On DATETIME ,
              Dt_Upd_On DATETIME ,
              I_Student_Detail_ID INT
            )     
     
   -- Insert Values into Temporary Table              
        INSERT  INTO #T_Student_Sub_Batch_Student_Mapping
                SELECT  T.c.value('@I_Sub_Batch_ID', 'int') ,
                        T.c.value('@S_Student_ID', 'varchar(50)') ,
                        T.c.value('@I_Batch_ID', 'int') ,
                        T.c.value('@I_Status', 'int') ,
                        T.c.value('@S_Crtd_By', 'varchar(20)') ,
                        T.c.value('@S_Updt_By', 'varchar(20)') ,
                        T.c.value('@Dt_Crtd_On', 'datetime') ,
                        T.c.value('@Dt_Upd_On', 'datetime') ,
                        --CONVERT(DATETIME, T.c.value('@Dt_Crtd_On',
                        --                            'varchar(50)'), 103) ,
                        --CONVERT(DATETIME, T.c.value('@Dt_Upd_On',
                        --                            'varchar(50)'), 103) ,
                        T.c.value('@I_Student_Detail_ID', 'int')
                FROM    @sBatchStdTableXML.nodes('/Root/SubBatchStdTable') T ( c )
     
     
        UPDATE  M
        SET     I_Status = 0 ,
                Dt_Upd_On = T.Dt_Upd_On ,
                S_Updt_By = T.S_Updt_By
        FROM    dbo.T_Student_Sub_Batch_Student_Mapping M
                INNER JOIN #T_Student_Sub_Batch_Student_Mapping T ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
                                                              AND M.I_Batch_ID = T.I_Batch_ID
     
        INSERT  INTO dbo.T_Student_Sub_Batch_Student_Mapping
                ( I_Sub_Batch_ID ,
                  S_Student_ID ,
                  I_Batch_ID ,
                  I_Status ,
                  S_Crtd_By ,
                  S_Updt_By ,
                  Dt_Crtd_On ,
                  Dt_Upd_On ,
                  I_Student_Detail_ID
                )
                SELECT  I_Sub_Batch_ID ,
                        S_Student_ID ,
                        I_Batch_ID ,
                        I_Status ,
                        S_Crtd_By ,
                        S_Updt_By ,
                        Dt_Crtd_On ,
                        Dt_Upd_On ,
                        I_Student_Detail_ID
                FROM    #T_Student_Sub_Batch_Student_Mapping
                WHERE   I_Sub_Batch_ID <> 0
     
  -- select * from #T_Student_Sub_Batch_Student_Mapping
  -- -- defination of the variables of the TimeTable parent              
  --      DECLARE @I_Sub_Batch_ID INT= NULL
  --      DECLARE @I_Student_Detail_ID INT= NULL
  --      DECLARE @S_Student_ID VARCHAR(50)= NULL
  --      DECLARE @I_Batch_ID INT= NULL
  --      DECLARE @I_Status INT= NULL
  --      DECLARE @S_Crtd_By VARCHAR(20)= NULL
  --      DECLARE @S_Updt_By VARCHAR(20)= NULL
  --      DECLARE @Dt_Crtd_On DATETIME= NULL
  --      DECLARE @Dt_Upd_On DATETIME= NULL        
               
  --      DECLARE @rCnt AS INT 
  --      DECLARE @Cnt AS INT = 0
  --      DECLARE @CntSt AS INT= 0 
  --      SELECT  @rCnt = COUNT(*)
  --      FROM    #T_Student_Sub_Batch_Student_Mapping 
        
  --      SELECT  @I_Sub_Batch_ID = I_Sub_Batch_ID ,
  --              @S_Student_ID = S_Student_ID ,
  --              @I_Student_Detail_ID = I_Student_Detail_ID
  --      FROM    #T_Student_Sub_Batch_Student_Mapping
  --      WHERE   srlno = @Cnt + 1

  --      UPDATE  T_Student_Sub_Batch_Student_Mapping
  --      SET     I_Status = 0 ,
  --              Dt_Upd_On = @Dt_Upd_On
  --      WHERE   S_Student_ID = @S_Student_ID
  --              AND I_Status = 1

  --      WHILE ( @Cnt <> @rCnt ) 
  --          BEGIN
  --              SELECT  @I_Sub_Batch_ID = I_Sub_Batch_ID ,
  --                      @S_Student_ID = S_Student_ID
  --              FROM    #T_Student_Sub_Batch_Student_Mapping
  --              WHERE   srlno = @Cnt + 1
  --              SELECT  @CntSt = COUNT(*)
  --              FROM    T_Student_Sub_Batch_Student_Mapping
  --              WHERE   S_Student_ID = @S_Student_ID
  --                      AND I_Status = 1
		----IF @CntSt>0
		----BEGIN
		----UPDATE T_Student_Sub_Batch_Student_Mapping SET I_Status=0,Dt_Upd_On=@Dt_Upd_On WHERE S_Student_ID=@S_Student_ID AND I_Status=1
		----END
		----ELSE
		----BEGIN
  --              INSERT  INTO T_Student_Sub_Batch_Student_Mapping
  --                      ( [I_Sub_Batch_ID] ,
  --                        [S_Student_ID] ,
  --                        [I_Batch_ID] ,
  --                        [I_Status] ,
  --                        [S_Crtd_By] ,
  --                        [Dt_Crtd_On]
  --                      )
  --                      SELECT  [I_Sub_Batch_ID] ,
  --                              [S_Student_ID] ,
  --                              [I_Batch_ID] ,
  --                              [I_Status] ,
  --                              [S_Crtd_By] ,
  --                              [Dt_Crtd_On]
  --       -- ,[S_Updt_By]
  --       --  ,Convert(datetime,[Dt_Crtd_On],110)
  --       --  ,Convert(datetime,[Dt_Upd_On],110)
  --                      FROM    #T_Student_Sub_Batch_Student_Mapping
  --                      WHERE   srlno = @Cnt + 1
  --              SET @Cnt = @Cnt + 1
  --    --  END
   
  --          END

         
        COMMIT TRANSACTION    
          
    END TRY                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                     
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH
