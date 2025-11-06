    
CREATE PROCEDURE [dbo].[usp_ERP_AddSchoolProgram]    
    @iGroupid INT = NULL,    
    @sGroupCode NVARCHAR(MAX),    
    @sGroupName NVARCHAR(MAX),    
    @iGroupStatus INT,    
    @tStartTime TIME(0) = NULL,    
    @tEndTime TIME(0) = NULL,    
    @UTRecipient UT_Recipient READONLY,    
    @iBrandid INT,    
    @sUpdatedBy NVARCHAR(MAX),    
    @iSessionID INT,    
    @ClassStreamSectionList UT_ClassStreamSection READONLY  -- Add the new parameter    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    BEGIN TRY    
        BEGIN TRANSACTION;    
    
        DECLARE @iLsatID INT;    
    
        -- Create temporary table    
        CREATE TABLE #ClassSection (    
            id INT IDENTITY(1,1),    
            ClassID INT,    
            SchoolGroupID INT    
        );    
    
        -- Check if this is an update operation    
        IF (@iGroupid > 0)    
        BEGIN   
		-- Set @iLsatID to @iGroupid for consistency in further queries
            SET @iLsatID = @iGroupid;
            -- Insert classes from UTRecipient into temporary table    
            INSERT INTO #ClassSection (ClassID, SchoolGroupID)    
            SELECT Recipient, @iGroupid    
            FROM @UTRecipient;    
    
            -- Insert class if it doesn't already exist    
            INSERT INTO T_School_Group_Class (I_Status, I_School_Group_ID, I_Class_ID)    
            SELECT 1, @iGroupid, ClassID    
            FROM #ClassSection    
            WHERE NOT EXISTS (SELECT 1 FROM T_School_Group_Class     
                              WHERE I_School_Group_ID = @iGroupid AND I_Class_ID = ClassID);    
    
            -- Insert class timings if they don't already exist    
            INSERT INTO T_School_Group_Class_Timing (I_School_Session_ID, I_School_Group_ID, Start_Time, End_Time, I_Status, Dt_UpdatedBy, Dt_UpdatedAt, I_Class_ID)    
            SELECT @iSessionID, @iGroupid, @tStartTime, @tEndTime, 1, @sUpdatedBy, GETDATE(), ClassID    
            FROM #ClassSection    
            WHERE NOT EXISTS (    
                SELECT 1 FROM T_School_Group_Class_Timing    
                WHERE I_School_Session_ID = @iSessionID    
                  AND I_School_Group_ID = @iGroupid    
                  AND I_Class_ID = ClassID    
                  AND Start_Time = @tStartTime    
                  AND End_Time = @tEndTime    
            );    
    
            -- Delete records from T_ERP_Class_Section that are not in the provided @ClassStreamSectionList    
  
          
    
            -- Update the school group details    
            UPDATE T_School_Group    
            SET     
                S_School_Group_Name = @sGroupName,    
                S_School_Group_Code = @sGroupCode,    
                I_Brand_Id = @iBrandid,    
                I_Status = @iGroupStatus,    
                Dt_UpdatedBy = @sUpdatedBy,    
                Dt_UpdatedAt = GETDATE()    
            WHERE I_School_Group_ID = @iGroupid;    
    
            -- Return success message    
            SELECT 1 AS StatusFlag, 'School Program updated' AS Message;    
        END    
        ELSE    
        BEGIN    
            -- Insert new school group    
            INSERT INTO [T_School_Group] (I_Brand_Id, S_School_Group_Code, S_School_Group_Name, I_Status, Dt_CreatedBy, Dt_CreatedAt)    
            VALUES (@iBrandid, @sGroupCode, @sGroupName, @iGroupStatus, @sUpdatedBy, GETDATE());    
    
            -- Get the last inserted ID for the new school group    
            SET @iLsatID = SCOPE_IDENTITY();    
    
            -- Insert class and timing details for the new school group    
            INSERT INTO T_School_Group_Class (I_School_Group_ID, I_Status, I_Class_ID)    
            SELECT @iLsatID, 1, Recipient FROM @UTRecipient;    
    
            -- Insert class timings if they don't already exist    
            INSERT INTO T_School_Group_Class_Timing (I_School_Session_ID, I_School_Group_ID, Start_Time, End_Time, I_Status, Dt_CreatedBy, Dt_CreatedAt, I_Class_ID)    
            SELECT @iSessionID, @iLsatID, @tStartTime, @tEndTime, 1, @sUpdatedBy, GETDATE(), Recipient    
            FROM @UTRecipient    
            WHERE NOT EXISTS (    
                SELECT 1 FROM T_School_Group_Class_Timing    
                WHERE I_School_Session_ID = @iSessionID    
                  AND I_School_Group_ID = @iLsatID    
                  AND I_Class_ID = Recipient    
                  AND Start_Time = @tStartTime    
                  AND End_Time = @tEndTime    
            );    
    
            -- Delete records from T_ERP_Class_Section that are not in the provided @ClassStreamSectionList    
        
  
    
            -- Return success message    
            SELECT 1 AS StatusFlag, 'School Program added Successfully' AS Message;    
        End 
		insert into tEst(Test,Cr_Dt)values('add',GETDATE())
		delete from  T_ERP_Class_Section Where I_School_Session_ID=@iSessionID  
         and I_School_Group_ID=@iLsatID  
    
    
    
            -- Insert into T_ERP_Class_Section from ClassStreamSectionList    
            INSERT INTO T_ERP_Class_Section (I_School_Session_ID, I_School_Group_ID, I_Class_ID, I_Stream_ID, I_Section_ID)    
            SELECT    
                @iSessionID,     -- I_School_Session_ID    
                @iLsatID,        -- I_School_Group_ID    
                ClassID,         -- I_Class_ID    
                StreamID,        -- I_Stream_ID    
                SectionID        -- I_Section_ID    
            FROM @ClassStreamSectionList    
            --WHERE IsSelected = 1    
              --AND NOT EXISTS (    
              --    SELECT 1 FROM T_ERP_Class_Section_Copy    
              --    WHERE I_School_Session_ID = @iSessionID    
              --      AND I_School_Group_ID = @iLsatID    
              --      AND I_Class_ID = ClassID    
              --      AND (I_Stream_ID = StreamID  OR StreamID is null  ) 
              --      AND I_Section_ID = SectionID    
              --);  
    
        -- Commit transaction    
        COMMIT TRANSACTION;    
    END TRY    
    BEGIN CATCH    
        -- Rollback transaction if any error occurs    
        IF @@TRANCOUNT > 0    
            ROLLBACK TRANSACTION;    
    
        -- Return error message    
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;    
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();    
        SELECT 0 AS StatusFlag, @ErrMsg AS Message;    
    END CATCH    
END; 

