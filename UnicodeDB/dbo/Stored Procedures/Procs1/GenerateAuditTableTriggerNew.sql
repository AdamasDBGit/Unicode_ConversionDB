CREATE PROCEDURE [dbo].[GenerateAuditTableTriggerNew]
AS 
    BEGIN

        DECLARE @TableName VARCHAR(64)
        DECLARE @ColumnName VARCHAR(64)
        DECLARE @SQLString VARCHAR(MAX)
        DECLARE @SQLTrigger VARCHAR(MAX)
        DECLARE @SQLColumn VARCHAR(MAX)
        DECLARE @IsUpdateAuditReqd BIT
        DECLARE @IsInsertAuditReqd BIT
        DECLARE @IsDeleteAuditReqd BIT
        DECLARE @IsActiveAvailable BIT
        DECLARE @CreateOrAlterChk VARCHAR(20)
	
        CREATE TABLE #AuditColumn
            (
              AuditedOn DATETIME NOT NULL
                                 DEFAULT GETDATE() ,
              AuditType CHAR(1) NOT NULL
            )

        DECLARE curGenerateTable CURSOR FOR
        SELECT	B.TableName, B.IsUpdateAuditReqd, B.IsInsertAuditReqd, B.IsDeleteAuditReqd
        FROM    AuditTable B 
        WHERE   B.IsDeleted = 0 ;

        OPEN curGenerateTable ;
        FETCH NEXT FROM curGenerateTable
	INTO	@TableName, @IsUpdateAuditReqd, @IsInsertAuditReqd, @IsDeleteAuditReqd ;

        WHILE ( @@FETCH_STATUS = 0 ) 
            BEGIN
                SET @SQLString = 'IF EXISTS (SELECT 1 FROM sysobjects where type= ''U'' and name  = '
                    + '''' + @TableName + '_A' + '''' + ')' + CHAR(13)
                SET @SQLString = @SQLString + 'DROP TABLE ' + @TableName
                    + '_A' + CHAR(13) 
                SET @SQLString = @SQLString + ' SELECT A1.*, A2.* INTO '
                    + @TableName + '_A  From [' + @TableName
                    + '] A1 INNER JOIN #AuditColumn A2 ON 1 = 2'

                EXEC(@SQLString) ;
                EXEC ('ALTER TABLE ' + @TableName + '_A ADD AuditId INT NOT NULL IDENTITY(1,1) SET IDENTITY_INSERT ' + @TableName + '_A ON') ;
                EXEC ('ALTER TABLE ' + @TableName + '_A ADD CONSTRAINT PK_' + @TableName + '_A PRIMARY KEY CLUSTERED (AuditId)') ;

                SELECT  @SQLColumn = SUBSTRING(( SELECT ',' + C.Name
                                                 FROM   sys.tables T
                                                        INNER JOIN sys.columns C ON T.object_id = C.object_id
                                                 WHERE  T.name = @TableName
                                               FOR
                                                 XML PATH('')
                                               ), 2, 200000)
                                   
		--INSERT SCRIPT: BEGIN
                IF @IsInsertAuditReqd = 1 
                    BEGIN
                        IF EXISTS ( SELECT  1
                                    FROM    sysobjects
                                    WHERE   type = 'TR'
                                            AND OBJECT_NAME(parent_obj) = @TableName
                                            AND name = 'TINSERT_' + @TableName ) 
                            SET @CreateOrAlterChk = 'ALTER' -- Trigger Exists
                        ELSE 
                            SET @CreateOrAlterChk = 'CREATE' -- Trigger Does not Exists
			
						
                        SET @SQLTrigger = @CreateOrAlterChk
                        SET @SQLTrigger = @SQLTrigger
                            + ' TRIGGER [dbo].[TINSERT_' + @TableName
                            + '] ON [dbo].[' + @TableName + ']'
                        SET @SQLTrigger = @SQLTrigger + ' FOR INSERT '
                        SET @SQLTrigger = @SQLTrigger + 'AS' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'BEGIN' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'INSERT INTO '
                            + @TableName + '_A' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + '(' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + @SQLColumn
                            + ',AuditedOn,AuditType)' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'SELECT ' + @SQLColumn
                            + ', GETDATE(), ''I''' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'FROM INSERTED I'
                            + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'END' + CHAR(13)
			
                        EXEC(@SQLTrigger) ;
                    END
		--INSERT SCRIPT: END
                SET @SQLTrigger = ''
			--UPDATE SCRIPT: START
				IF @IsUpdateAuditReqd = 1 
                    BEGIN
                        IF EXISTS ( SELECT  1
                                    FROM    sysobjects
                                    WHERE   type = 'TR'
                                            AND OBJECT_NAME(parent_obj) = @TableName
                                            AND name = 'TUPDATE_' + @TableName ) 
                            SET @CreateOrAlterChk = 'ALTER' -- Trigger Exists
                        ELSE 
                            SET @CreateOrAlterChk = 'CREATE' -- Trigger Does not Exists
			
						
                        SET @SQLTrigger = @CreateOrAlterChk
                        SET @SQLTrigger = @SQLTrigger
                            + ' TRIGGER [dbo].[TUPDATE_' + @TableName
                            + '] ON [dbo].[' + @TableName + ']'
                        SET @SQLTrigger = @SQLTrigger + ' AFTER UPDATE '
                        SET @SQLTrigger = @SQLTrigger + 'AS' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'BEGIN' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'INSERT INTO '
                            + @TableName + '_A' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + '(' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + @SQLColumn
                            + ',AuditedOn,AuditType)' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'SELECT ' + @SQLColumn
                            + ', GETDATE(), ''U''' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'FROM DELETED I'
                            + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'END' + CHAR(13)
			
                        EXEC(@SQLTrigger) ;
                    END
               
            
		--UPDATE SCRIPT: END
                SET @SQLTrigger = ''
		--DELETE SCRIPT: START
				IF @IsDeleteAuditReqd = 1 
                    BEGIN
                        IF EXISTS ( SELECT  1
                                    FROM    sysobjects
                                    WHERE   type = 'TR'
                                            AND OBJECT_NAME(parent_obj) = @TableName
                                            AND name = 'TDELETE_' + @TableName ) 
                            SET @CreateOrAlterChk = 'ALTER' -- Trigger Exists
                        ELSE 
                            SET @CreateOrAlterChk = 'CREATE' -- Trigger Does not Exists
			
						
                        SET @SQLTrigger = @CreateOrAlterChk
                        SET @SQLTrigger = @SQLTrigger
                            + ' TRIGGER [dbo].[TDELETE_' + @TableName
                            + '] ON [dbo].[' + @TableName + ']'
                        SET @SQLTrigger = @SQLTrigger + ' AFTER DELETE '
                        SET @SQLTrigger = @SQLTrigger + 'AS' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'BEGIN' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'INSERT INTO '
                            + @TableName + '_A' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + '(' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + @SQLColumn
                            + ',AuditedOn,AuditType)' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'SELECT ' + @SQLColumn
                            + ', GETDATE(), ''D''' + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'FROM DELETED I'
                            + CHAR(13)
                        SET @SQLTrigger = @SQLTrigger + 'END' + CHAR(13)
			
                        EXEC(@SQLTrigger) ;
                    END
		
		--DELETE SCRIPT: END
                SET @SQLString = ''
                SET @SQLTrigger = ''
                SET @SQLColumn = ''
                FETCH NEXT FROM curGenerateTable INTO	@TableName,@IsUpdateAuditReqd, @IsInsertAuditReqd, @IsDeleteAuditReqd ;
            END
        CLOSE curGenerateTable ;
        DEALLOCATE curGenerateTable ;

        DROP TABLE #AuditColumn

    END
