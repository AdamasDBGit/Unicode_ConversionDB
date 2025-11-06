CREATE PROCEDURE [dbo].[uspUpdateCTProcess]  
    (  
      @sLoginId Nnvarchar(max) ,  
      @iSourceCenterID INT = NULL ,  
      @iDestinationCenterID INT = NULL ,  
      @iStudentDetailId INT = NULL ,  
      @sRemarks Nnvarchar(max) ,  
      @iCTStatus INT ,  
      @iTransferRequestId INT = NULL ,  
      @iCourseDuration INT = NULL ,  
      @iDurationSpent INT = NULL ,  
      @dDCCourseValue NUMERIC(18, 2) = NULL ,  
      @iTaskIdCompleted INT = NULL                   
    )  
AS   
    BEGIN                      
        DECLARE @ID INT            
        DECLARE @iTaskDetailId INT              
        DECLARE @info nvarchar(max)                    
        DECLARE @USERID TABLE ( I_User_Id INT )                      
                      
        DECLARE @iTaskMasterId INT                      
        DECLARE @iAssignedUserId INT                      
        DECLARE @updTskMstr INT         
        
        IF @iTaskIdCompleted IS NULL   
            BEGIN        
                SET @iTaskIdCompleted = 0        
            END                   
              
        IF @iCTStatus <> 1   
            BEGIN                      
                SELECT  @iSourceCenterID = I_Source_Centre_Id ,  
                        @iDestinationCenterID = I_Destination_Centre_Id  
                FROM    dbo.T_Student_Transfer_Request  
                WHERE   I_Transfer_Request_Id = @iTransferRequestId                      
            END               
-----------------  approval -------------------------------------------------------                            
        IF @iCTStatus = 1   
            BEGIN                      
                SET @iTaskMasterId = 7                                       
                      
                INSERT  INTO @USERID  
                        ( I_User_Id  
                        )  
                        SELECT  I_User_Id  
                        FROM    dbo.fnGetCHandHOA(@iDestinationCenterID, 8)                      
                        
            END               
        ELSE   
            IF @iCTStatus = 2   
                BEGIN                  
                    SET @iTaskMasterId = 133                     
                    SET @updTskMstr = 9    
                  
                    --INSERT  INTO @USERID  
                    --        ( I_User_Id )  
                    --VALUES  ( 300571 )                   
    INSERT INTO @USERID(I_User_Id)     --commented on   07092012                
    SELECT I_User_Id FROM dbo.fnGetCHandHOA(@iDestinationCenterID,1)                    
                END                    
            ELSE   
                IF @iCTStatus = 3   
                    BEGIN                  
                        SET @iTaskMasterId = 142                     
                        SET @updTskMstr = 133                  
                    
                        INSERT  INTO @USERID  
                                ( I_User_Id  
                                )  
                                SELECT  I_User_Id  
                                FROM    dbo.fnGetCHandHOA(@iSourceCenterID, 8)                    
                    END                    
                
----------------- Reject ------------------------------------                     
                    ELSE   
                        IF @iCTStatus = 4   
                            BEGIN                      
                                SET @iTaskMasterId = 138                      
                                SET @updTskMstr = 7                      
                        
                                INSERT  INTO @USERID  
                                        ( I_User_Id  
                                        )  
                                        SELECT  I_User_Id  
                                        FROM    dbo.fnGetCHandHOA(@iSourceCenterID,  
                                                              1)                      
                            END                      
           ELSE   
                            IF @iCTStatus = 5   
                                BEGIN                      
                                    SET @iTaskMasterId = 132                     
                                    SET @updTskMstr = 8                      
                
                                    INSERT  INTO @USERID  
                                            ( I_User_Id  
                                            )  
                                            SELECT  I_User_Id  
                                            FROM    dbo.fnGetCHandHOA(@iSourceCenterID,  
                                                              1)                      
                                END                      
                            ELSE   
                                IF @iCTStatus = 6   
                                    BEGIN                      
                                        SET @iTaskMasterId = 143                      
                                        SET @updTskMstr = 9                   
                  
                                        INSERT  INTO @USERID  
                                                ( I_User_Id  
                                                )  
                                                SELECT  I_User_Id  
                                                FROM    dbo.fnGetCHandHOA(@iSourceCenterID,  
                                                              8)                      
                                    END               
                                         
------------------                      
                      
        IF @iCTStatus = 1  
            AND @iTransferRequestId = 0   
            BEGIN                      
                INSERT  INTO dbo.T_Student_Transfer_Request  
                        ( I_Source_Centre_Id ,  
                          I_Destination_Centre_Id ,  
                          I_Student_Detail_ID ,  
                          S_Remarks ,  
                          Dt_Request_Date ,  
                          I_Status ,  
                          S_Crtd_By ,  
                          Dt_Crtd_On ,  
                          I_Course_Duration ,  
                          I_Course_Completed ,  
                          N_DCCourse_Amount                   
                        )  
                VALUES  ( @iSourceCenterID ,  
                          @iDestinationCenterID ,  
                          @iStudentDetailId ,  
                          @sRemarks ,  
                          GETDATE() ,  
                          @iCTStatus ,  
                          @sLoginId ,  
                          GETDATE() ,  
                          @iCourseDuration ,  
                          @iDurationSpent ,  
                          @dDCCourseValue                  
                        )                      
                SET @ID = SCOPE_IDENTITY()             
                SET @iTransferRequestId = @ID                  
                INSERT  INTO dbo.T_Student_Transfer_History  
                        ( I_Transfer_Request_ID ,  
                          S_Remarks ,  
                          I_Status_ID ,  
                          S_Crtd_By ,  
                          Dt_Crtd_On                      
                        )  
                VALUES  ( @ID ,  
                          @sRemarks ,  
                          @iCTStatus ,  
                          @sLoginId ,  
                          GETDATE()  
                        )                      
------------ message ---------------            
                SELECT  @info = ' [' + SD.S_Student_Id + ' , '  
                        + ISNULL(SD.S_First_Name, '') + ' '  
                        + ISNULL(SD.S_Middle_Name, '') + ' '  
                        + ISNULL(SD.S_Last_Name, '') + '] [OC:'  
                        + CM1.S_Center_Name + '] [DC:' + CM2.S_Center_Name  
                        + ']'  
                FROM    T_Centre_Master CM1  
                        INNER JOIN T_Student_Transfer_Request TR ON CM1.I_Centre_Id = TR.I_Source_Centre_Id  
                        INNER JOIN T_Centre_Master CM2 ON CM2.I_Centre_Id = TR.I_Destination_Centre_Id  
                        INNER JOIN T_Student_Detail SD ON TR.I_Student_Detail_Id = SD.I_Student_Detail_Id  
                WHERE   tr.I_transfer_request_id = @iTransferRequestId            
                IF @info IS NULL   
                    BEGIN        
                        SET @info = 'Center Transfer Pending for Approval'        
                    END        
---------------------------------------                     
                INSERT  INTO dbo.T_Task_Details  
                        ( I_Task_Master_Id ,  
                          S_Task_Description ,  
                          S_Querystring ,  
                          I_Hierarchy_Master_ID ,  
                          S_Hierarchy_Chain ,  
                          I_Status ,  
                          Dt_Due_date ,  
                          Dt_Created_Date                      
                        )  
                VALUES  ( @iTaskMasterId ,  
                          'Center Transfer Pending for Approval' + @info ,  
                          '' ,  
                          2 ,  
                          @ID ,  
                          1 ,  
                          GETDATE() ,  
                          GETDATE()  
                        )                      
                      
                SET @ID = SCOPE_IDENTITY()            
            
                SET @iTaskDetailId = @ID                   
                      
                INSERT  INTO dbo.T_Task_Assignment  
                        ( I_Task_ID ,  
                          I_To_User_ID ,  
                          S_From_User  
                        )  
                        SELECT  @ID ,  
                                I_User_Id ,  
                                @sLoginId  
                        FROM    @USERID                      
                      
            END                      
        ELSE   
            IF @iCTStatus = 0   
                BEGIN                      
---------------------------------------------                      
                    UPDATE  dbo.T_Student_Transfer_Request  
                    SET     S_Remarks = @sRemarks ,  
                            I_Status = @iCTStatus ,  
                            S_Upd_By = @sLoginId ,  
                            Dt_Upd_On = GETDATE() ,  
                            N_DCCourse_Amount = @dDCCourseValue  
                    WHERE   I_Transfer_Request_Id = @iTransferRequestId                      
----------------------------------------------------                      
                      
                    INSERT  INTO dbo.T_Student_Transfer_History  
                            ( I_Transfer_Request_ID ,  
                              S_Remarks ,  
                              I_Status_ID ,  
                              S_Crtd_By ,  
                              Dt_Crtd_On                      
                            )  
                    VALUES  ( @iTransferRequestId ,  
                              @sRemarks ,  
                              @iCTStatus ,  
                              @sLoginId ,  
                              GETDATE()  
                            )                      
                      
--UPDATE dbo.T_Task_Details                       
--SET I_Status = 0                       
--WHERE S_Hierarchy_Chain = CAST(@iTransferRequestId AS VARCHAR)                      
--AND I_Task_Master_Id = @updTskMstr         
        
                    UPDATE  dbo.T_Task_Details  
                    SET     I_Status = 0  
                    WHERE   I_Task_Details_Id = @iTaskIdCompleted        
                     
                     
                END                      
            ELSE   
                BEGIN                      
---------------------------------------------   
                    IF ( @dDCCourseValue IS NOT NULL  
                         AND @dDCCourseValue != 0  
                       )   
                        BEGIN  
                            UPDATE  dbo.T_Student_Transfer_Request  
                            SET     S_Remarks = @sRemarks ,  
                                    I_Status = @iCTStatus ,  
                                    S_Upd_By = @sLoginId ,  
                                    Dt_Upd_On = GETDATE() ,  
                                    N_DCCourse_Amount = @dDCCourseValue  
                            WHERE   I_Transfer_Request_Id = @iTransferRequestId  
                        END  
                    ELSE   
                        BEGIN  
                            UPDATE  dbo.T_Student_Transfer_Request  
                            SET     S_Remarks = @sRemarks ,  
                                    I_Status = @iCTStatus ,  
                                    S_Upd_By = @sLoginId ,  
                                    Dt_Upd_On = GETDATE()  
                            WHERE   I_Transfer_Request_Id = @iTransferRequestId  
                        END         
----------------------------------------------------                      
                      
                    INSERT  INTO dbo.T_Student_Transfer_History  
                            ( I_Transfer_Request_ID ,  
                              S_Remarks ,  
                              I_Status_ID ,  
                              S_Crtd_By ,  
                              Dt_Crtd_On                      
                            )  
                    VALUES  ( @iTransferRequestId ,  
                              @sRemarks ,  
                              @iCTStatus ,  
                              @sLoginId ,  
                              GETDATE()  
                            )            
------------ message ---------------            
                    SELECT  @info = ' [' + SD.S_Student_Id + ' , '  
                            + ISNULL(SD.S_First_Name, '') + ' '  
                            + ISNULL(SD.S_Middle_Name, '') + ' '  
                            + ISNULL(SD.S_Last_Name, '') + '] [OC:'  
                            + CM1.S_Center_Name + '] [DC:' + CM2.S_Center_Name  
                            + ']'  
                    FROM    T_Centre_Master CM1  
                            INNER JOIN T_Student_Transfer_Request TR ON CM1.I_Centre_Id = TR.I_Source_Centre_Id  
                            INNER JOIN T_Centre_Master CM2 ON CM2.I_Centre_Id = TR.I_Destination_Centre_Id  
                            INNER JOIN T_Student_Detail SD ON TR.I_Student_Detail_Id = SD.I_Student_Detail_Id  
                    WHERE   tr.I_transfer_request_id = @iTransferRequestId            
                    IF @info IS NULL   
                        BEGIN        
                            SET @info = 'Center Transfer Pending for Approval'        
                        END           
---------------------------------------       
                    --IF ( @iCTStatus <> 3 )   
                       -- BEGIN                      
                            INSERT  INTO dbo.T_Task_Details  
                                    ( I_Task_Master_Id ,  
                                      S_Task_Description ,  
                                      S_Querystring ,  
                                      I_Hierarchy_Master_ID ,  
                                      S_Hierarchy_Chain ,  
                                      I_Status ,  
                                      Dt_Due_date ,  
                                      Dt_Created_Date                      
                                    )  
                            VALUES  ( @iTaskMasterId ,  
                                      'Center Transfer Pending for Approval'  
                                      + @info ,  
                                      '' ,  
                                      2 ,  
                                      @iTransferRequestId ,  
                                      1 ,  
                                      GETDATE() ,  
                                      GETDATE()  
                                    )                      
                        
                            SET @ID = SCOPE_IDENTITY()                      
                            SET @iTaskDetailId = @ID                       
                            INSERT  INTO dbo.T_Task_Assignment  
                                    ( I_Task_ID ,  
                                      I_To_User_ID ,  
                                      S_From_User  
                                    )  
                                    SELECT  @ID ,  
                                            I_User_Id ,  
                                            @sLoginId  
                                    FROM    @USERID      
                       -- END                      
                      
                END                      
                      
--UPDATE dbo.T_Task_Details                       
--SET I_Status = 0                       
--WHERE S_Hierarchy_Chain = CAST(@iTransferRequestId AS VARCHAR)                      
--AND I_Task_Master_Id = @updTskMstr         
        UPDATE  dbo.T_Task_Details  
        SET     I_Status = 0  
        WHERE   I_Task_Details_Id = @iTaskIdCompleted            
            
        UPDATE  T_Student_Transfer_History  
        SET     I_Task_Details_Id = @iTaskDetailId  
        WHERE   I_Transfer_Request_ID = @iTransferRequestId  
                AND I_Status_ID = @iCTStatus                    
                      
        SELECT  1                      
                      
    END

