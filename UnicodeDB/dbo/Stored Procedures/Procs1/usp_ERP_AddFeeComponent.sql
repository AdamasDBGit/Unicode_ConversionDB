

CREATE PROCEDURE [dbo].[usp_ERP_AddFeeComponent]
    @FeeHeadID int NULL,
    @FeeComponentCode NVARCHAR(max),
    @FeeComponentName NVARCHAR(max),
    @Status int,
    @UpdatedBy NVARCHAR(max),
    @FeeComponentType int,
    @BrandID int,
    @TypeOfComponent NVARCHAR(max),
    @Is_GST_Applicable bit NULL,
    @I_GST_FeeComponent_Catagory_ID int NULL,
    @Valid_from datetime NULL,
    @Valid_to datetime NULL,
    @Is_Display_Others bit NULL,
    @BankID int = NULL,
    @BankEffectiveFrom datetime = NULL,
    @BankEffectiveTo datetime = NULL
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        SET NOCOUNT ON;

        DECLARE @DefaultGSTCATID int;
        DECLARE @FeeCompID int;

        -- Get default GST category if GST not applicable
        SET @DefaultGSTCATID = (
            SELECT TOP 1 GIC.I_GST_FeeComponent_Catagory_ID
            FROM T_ERP_GST_Configuration_Details GCD
            INNER JOIN T_ERP_GST_Item_Category GIC 
                ON GCD.I_GST_FeeComponent_Catagory_ID = GIC.I_GST_FeeComponent_Catagory_ID
            WHERE N_SGST = 0.00 AND N_CGST = 0.00 AND N_IGST = 0.00 AND GIC.Is_Active = 1
            ORDER BY GIC.I_GST_FeeComponent_Catagory_ID
        );

        IF (@FeeHeadID > 0)
        BEGIN
            -- Update Block
            UPDATE [dbo].[T_Fee_Component_Master]
            SET 
                [S_Component_Code] = @FeeComponentCode,
                [S_Component_Name] = @FeeComponentName,
                [I_Status] = @Status,
                [S_Upd_By] = @UpdatedBy,
                [Dt_Upd_On] = GETDATE(),
                [I_Fee_Component_Type_ID] = @FeeComponentType,
                [I_Brand_ID] = @BrandID,
                [S_Type_Of_Component] = @TypeOfComponent,
                [Is_GST_Applicable] = @Is_GST_Applicable,
                [Is_Display_Others] = @Is_Display_Others,
                [I_Bank_ID] = @BankID,
                [BankEffectiveFrom] = @BankEffectiveFrom,
                [BankEffectiveTo] = @BankEffectiveTo
            WHERE [I_Fee_Component_ID] = @FeeHeadID;

            -- GST Mapping Logic
            IF @Is_GST_Applicable = 0
            BEGIN
                UPDATE T_ERP_GST_Component_Mapping
                SET 
                    I_GST_FeeComponent_Catagory_ID = @DefaultGSTCATID,
                    dt_modify = GETDATE()
                WHERE 
                    I_Fee_Component_ID = @FeeHeadID 
                    AND I_GST_Component_Type = 1;

                UPDATE T_Fee_Component_Master
                SET Is_GST_Applicable = 0
                WHERE I_Fee_Component_ID = @FeeHeadID;
            END
            ELSE
            BEGIN
                UPDATE T_ERP_GST_Component_Mapping
                SET 
                    Is_Active = 1,
                    dt_modify = GETDATE(),
                    I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID
                WHERE 
                    I_Fee_Component_ID = @FeeHeadID 
                    AND I_GST_Component_Type = 1;
            END

            SELECT 1 AS StatusFlag, 'Fee Component updated' AS Message;
        END
        ELSE
        BEGIN
            -- Insert Block
            IF EXISTS (
                SELECT 1
                FROM [dbo].[T_Fee_Component_Master]
                WHERE 
                    (S_Component_Name = @FeeComponentName OR S_Component_Code = @FeeComponentCode)
                    AND I_Brand_ID = @BrandID
            )
            BEGIN
                SELECT 0 AS StatusFlag, 'Duplicate Fee Component Name' AS Message;
            END
            ELSE
            BEGIN
                INSERT INTO [dbo].[T_Fee_Component_Master]
                (
                    [S_Component_Code],
                    [S_Component_Name],
                    [I_Status],
                    [S_Crtd_By],
                    [Dt_Crtd_On],
                    [I_Fee_Component_Type_ID],
                    [I_Brand_ID],
                    [S_Type_Of_Component],
                    [Is_GST_Applicable],
                    [Is_Display_Others],
                    [I_Bank_ID],
                    [BankEffectiveFrom],
                    [BankEffectiveTo]
                )
                VALUES
                (
                    @FeeComponentCode,
                    @FeeComponentName,
                    @Status,
                    @UpdatedBy,
                    GETDATE(),
                    @FeeComponentType,
                    @BrandID,
                    @TypeOfComponent,
                    @Is_GST_Applicable,
                    @Is_Display_Others,
                    @BankID,
                    @BankEffectiveFrom,
                    @BankEffectiveTo
                );

                SET @FeeCompID = SCOPE_IDENTITY();

                IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL
                BEGIN
                    INSERT INTO T_ERP_GST_Component_Mapping
                    (
                        I_GST_FeeComponent_Catagory_ID,
                        I_Fee_Component_ID,
                        Is_Active,
                        dt_create,
                        I_GST_Component_Type
                    )
                    SELECT 
                        @I_GST_FeeComponent_Catagory_ID, @FeeCompID, 1, GETDATE(), 1
                    WHERE NOT EXISTS (
                        SELECT 1 
                        FROM T_ERP_GST_Component_Mapping cm 
                        WHERE 
                            cm.I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID
                            AND cm.I_Fee_Component_ID = @FeeCompID
                            AND cm.Is_Active = 1 
                            AND cm.I_GST_Component_Type = 1
                    );

                    IF @Valid_from IS NOT NULL AND @Valid_to IS NOT NULL
                    BEGIN
                        INSERT INTO T_Tax_Country_Fee_Component
                        (
                            I_Tax_ID, I_Country_ID, I_Fee_Component_ID, N_Tax_Rate,
                            Dt_Valid_From, Dt_Valid_To, I_Status, S_Crtd_By, Dt_Crtd_On
                        )
                        SELECT 
                            I_Tax_ID, 1, @FeeCompID, 0, @Valid_from, @Valid_to, 1, 1, GETDATE()
                        FROM T_Tax_Master 
                        WHERE S_Tax_Code IN ('CGST', 'SGST', 'IGST');
                    END
                END
                ELSE
                BEGIN
                    INSERT INTO T_ERP_GST_Component_Mapping
                    (
                        I_GST_FeeComponent_Catagory_ID,
                        I_Fee_Component_ID,
                        Is_Active,
                        dt_create,
                        I_GST_Component_Type
                    )
                    SELECT 
                        @DefaultGSTCATID, @FeeCompID, 1, GETDATE(), 1
                    WHERE NOT EXISTS (
                        SELECT 1 
                        FROM T_ERP_GST_Component_Mapping cm 
                        WHERE 
                            cm.I_GST_FeeComponent_Catagory_ID = @DefaultGSTCATID
                            AND cm.I_Fee_Component_ID = @FeeCompID
                            AND cm.Is_Active = 1 
                            AND cm.I_GST_Component_Type = 1
                    );

                    UPDATE T_Fee_Component_Master
                    SET Is_GST_Applicable = 0
                    WHERE I_Fee_Component_ID = @FeeCompID;
                END

                SELECT 1 AS StatusFlag, 'Fee Component added' AS Message;
            END
        END

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
        SELECT 0 AS StatusFlag, @ErrMsg AS Message;
    END CATCH
END


