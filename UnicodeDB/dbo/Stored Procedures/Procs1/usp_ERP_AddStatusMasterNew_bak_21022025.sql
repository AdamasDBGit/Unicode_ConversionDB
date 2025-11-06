CREATE PROCEDURE [dbo].[usp_ERP_AddStatusMasterNew_bak_21022025]   
    @StatusDesc NVARCHAR(max) NULL,  
    @StatusSMSDesc NVARCHAR(max) NULL,  
    @StatusID INT NULL,  
    @Amount NUMERIC(18,2) NULL,  
    @Brandid INT NULL,  
    @Is_GST_Applicable BIT NULL,  
 @Is_AllowAmountChange BIT NULL,  
    @I_GST_FeeComponent_Catagory_ID INT NULL,  
    @Valid_from DATETIME NULL,          
    @Valid_to DATETIME NULL      
AS  
BEGIN  
    BEGIN TRANSACTION;  
    BEGIN TRY  
        SET NOCOUNT ON;  
  
        DECLARE @createdStatusID INT;  
        DECLARE @StatusValue INT;  
        DECLARE @newID INT;  
  DECLARE @existinggstid int;  
  
        -- Check if updating an existing Status  
       IF (@StatusID > 0)  
BEGIN  
    IF EXISTS (  
        SELECT *   
        FROM T_Status_Master   
        WHERE S_Status_Desc = @StatusDesc   
          AND I_Status_Id != @StatusID   
          AND S_Status_Desc_SMS = @StatusDesc  
    )  
    BEGIN  
        SELECT 0 AS StatusFlag, 'Duplicate Status Master' AS Message;  
    END  
    ELSE  
    BEGIN  
        -- Update existing status  
        UPDATE [dbo].[T_Status_Master]  
        SET   
            [S_Status_Desc] = @StatusDesc,  
            [S_Status_Type] = 'ReceiptType',  
            [S_Status_Desc_SMS] = @StatusSMSDesc,  
            [N_Amount] = @Amount,  
   Is_AllowAmountChange = @Is_AllowAmountChange  
        WHERE   
            I_Status_Id = @StatusID;  
  
        -- Handle GST applicability for update  
        IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL          
        BEGIN  
            SET @StatusValue = (  
                SELECT TOP 1 I_Status_Value   
                FROM T_Status_Master   
                WHERE I_Status_Id = @StatusID  
            );  
  
            -- Check if there is an existing GST mapping and make it NULL if found  
            SET @existinggstid = (  
                SELECT I_GST_FeeComponent_Catagory_ID   
                FROM [T_ERP_GST_Item_Category]   
                WHERE I_Fee_Component_ID = @StatusValue and Type=2  
            );  
  
            IF @existinggstid IS NOT NULL  
            BEGIN  
                UPDATE [dbo].[T_ERP_GST_Item_Category]  
                SET I_Fee_Component_ID = NULL  
                WHERE I_GST_FeeComponent_Catagory_ID = @existinggstid;  
  
                UPDATE T_ERP_GST_Configuration_Details   
                SET dt_ValidFrom_dt = NULL, dt_ValidTo_dt = NULL   
                WHERE I_GST_FeeComponent_Catagory_ID = @existinggstid;  
            END  
  
            -- Update with new GST mapping  
            UPDATE [dbo].[T_ERP_GST_Item_Category]  
            SET   
                I_Fee_Component_ID = @StatusValue,  
                Type = 2  
            WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
  
            UPDATE T_ERP_GST_Configuration_Details   
            SET dt_ValidFrom_dt = @Valid_from, dt_ValidTo_dt = @Valid_to   
            WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
  
            UPDATE T_Status_Master   
            SET Is_GSTApplicable = 1   
            WHERE I_Status_Id = @StatusID;  
        END  
        ELSE IF @Is_GST_Applicable = 0   
        BEGIN  
            -- Check if a default zero GST is already mapped  
            IF NOT EXISTS (  
                SELECT 1   
                FROM [dbo].[T_ERP_GST_Configuration_Details]   
                WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID   
                  AND N_SGST = 0   
                  AND N_CGST = 0   
                  AND N_IGST = 0  
            )  
            BEGIN  
                -- Remove any existing GST mapping if present  
                UPDATE [dbo].[T_ERP_GST_Item_Category]  
                SET I_Fee_Component_ID = NULL  
                WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
  
                UPDATE T_ERP_GST_Configuration_Details   
                SET dt_ValidFrom_dt = NULL, dt_ValidTo_dt = NULL   
                WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
  
                -- Insert default zero GST configuration  
                INSERT INTO T_ERP_GST_Item_Category (  
                    S_GST_FeeComponent_Category_Type,  
                    I_Fee_Component_ID,  
                    S_GST_FeeComponent_Description,  
                    Is_Active,  
                    I_Created_By,  
                    Dt_Created_At,  
                    I_Brand_Id,  
                    [Type]  
                )  
                VALUES (  
                    @StatusDesc,  
                    @StatusValue,  
                    @StatusSMSDesc,  
                    1,  
                    1,  
                    GETDATE(),  
                    @Brandid,  
                    2  
                );  
  
                SET @newID = SCOPE_IDENTITY();  
  
                INSERT INTO [dbo].[T_ERP_GST_Configuration_Details] (  
                    I_GST_FeeComponent_Catagory_ID, N_Start_Amount, N_End_Amount,   
                    N_SGST, N_CGST, N_IGST, Is_Active, I_Created_By, Dt_Created_At,   
                    dt_ValidFrom_dt, dt_ValidTo_dt  
                )  
                VALUES (  
                    @newID, 0, 300000000, 0, 0, 0,   
                    1, @Brandid, GETDATE(), @Valid_from, @Valid_to  
                );  
            END  
  
            UPDATE T_Status_Master   
            SET Is_GSTApplicable = 0   
            WHERE I_Status_Id = @StatusID;  
        END;  
  
        SELECT 1 AS StatusFlag, 'Status Updated' AS Message;  
    END;  
END;  
  
        ELSE  
        BEGIN  
            -- Insert a new Status if not a duplicate  
            IF EXISTS (  
                SELECT *   
                FROM T_Status_Master   
                WHERE S_Status_Desc = @StatusDesc   
                  AND S_Status_Desc_SMS = @StatusDesc  
            )  
            BEGIN  
                SELECT 0 AS StatusFlag, 'Duplicate Status Master' AS Message;  
            END  
            ELSE  
            BEGIN  
                SET @StatusValue = (SELECT MAX(I_Status_Value) + 1 FROM T_Status_Master);  
  
                -- Insert new status  
                INSERT INTO [dbo].[T_Status_Master] (  
                    [S_Status_Desc], [S_Status_Type], [S_Status_Desc_SMS],   
                    [I_Status_Value], [N_Amount], [I_Brand_ID],Is_AllowAmountChange  
                )  
                VALUES (  
                    @StatusDesc, 'ReceiptType', @StatusSMSDesc,   
                    @StatusValue, @Amount, @Brandid,@Is_AllowAmountChange  
                );  
  
                SET @createdStatusID = SCOPE_IDENTITY();  
  
                -- Handle GST applicability for new insert  
                IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL          
                BEGIN    
    UPDATE T_Status_Master set Is_GSTApplicable=1 where I_Status_Id=@createdStatusID  
                    -- Update T_ERP_GST_Item_Category table to associate it with the new Status ID  
                    UPDATE [dbo].[T_ERP_GST_Item_Category]  
                    SET   
                        I_Fee_Component_ID = @StatusValue,  
                        Type = 2  
                    WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
     UPDATE T_ERP_GST_Configuration_Details set dt_ValidFrom_dt=@Valid_from,dt_ValidTo_dt=@Valid_to   
     WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID;  
                END  
                ELSE  
                BEGIN  
                    INSERT INTO T_ERP_GST_Item_Category (  
                        S_GST_FeeComponent_Category_Type,  
                        I_Fee_Component_ID,  
                        S_GST_FeeComponent_Description,  
                        Is_Active,  
                        I_Created_By,  
                        Dt_Created_At,  
                        I_Brand_Id,  
                        [Type]  
                    )  
                    VALUES (  
                        @StatusDesc,  
                   @StatusValue,  
                        @StatusSMSDesc,  
                        1,  
                        1,  
                        GETDATE(),  
                        @Brandid,  
                        2  
                    );  
  
                    SET @newID = SCOPE_IDENTITY();  
  
                    -- Insert default zero GST configuration for non-applicable GST  
                    INSERT INTO [dbo].[T_ERP_GST_Configuration_Details] (  
                        I_GST_FeeComponent_Catagory_ID, N_Start_Amount, N_End_Amount,   
                        N_SGST, N_CGST, N_IGST, Is_Active, I_Created_By, Dt_Created_At,   
                        dt_ValidFrom_dt, dt_ValidTo_dt  
                    )  
                    VALUES (  
                        @newID, 0, 300000000, 0, 0, 0,   
                        1, @Brandid, GETDATE(), @Valid_from, @Valid_to  
                    );  
     UPDATE T_Status_Master set Is_GSTApplicable=0 where I_Status_Id=@createdStatusID  
                END;  
  
                SELECT 1 AS StatusFlag, 'Status added' AS Message;  
            END;  
        END;  
  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
        DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity INT;  
  
        SELECT @ErrMsg = ERROR_MESSAGE(),  
               @ErrSeverity = ERROR_SEVERITY();  
        SELECT 0 AS StatusFlag, @ErrMsg AS Message;  
    END CATCH;  
  
    COMMIT TRANSACTION;  
END;

