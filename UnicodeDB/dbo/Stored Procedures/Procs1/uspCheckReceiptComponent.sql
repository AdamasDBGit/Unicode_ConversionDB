CREATE PROC [dbo].[uspCheckReceiptComponent]
(
@iCentreID INT
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @iReceiptID INT
DECLARE @iVar INT

IF NOT EXISTS(SELECT * FROM T_Centre_Master WHERE i_centre_id=@iCentreID
        AND ((S_SAP_Customer_Id IS NOT NULL) AND (LTRIM(RTRIM(S_SAP_Customer_Id)) <> '')))
    BEGIN
        SELECT 2
        RETURN;
    END


	DECLARE _CURSOR CURSOR FOR
	 SELECT DISTINCT T.I_Receipt_Header_ID FROM 
        (
            SELECT RH.I_Receipt_Header_ID FROM dbo.T_Receipt_Header RH WITH (NOLOCK)
            WHERE RH.I_Receipt_Type = 2
            AND RH.S_Fund_Transfer_Status = 'Y'
            AND RH.I_Status = 0
            AND RH.I_Centre_ID = @iCentreID            
            UNION
            SELECT RH.I_Receipt_Header_ID FROM dbo.T_Receipt_Header RH WITH (NOLOCK)            
            WHERE RH.I_Receipt_Type = 2
            AND RH.S_Fund_Transfer_Status = 'N'
            AND RH.I_Status = 1
            AND RH.I_Centre_ID = @iCentreID            
        ) T
        

		OPEN _CURSOR
		FETCH NEXT FROM _CURSOR INTO @iReceiptID

		WHILE @@FETCH_STATUS = 0
		BEGIN

		IF NOT EXISTS(SELECT 'True' FROM T_Receipt_Component_Detail WITH (NOLOCK) WHERE I_Receipt_Detail_ID = @iReceiptID)
        BEGIN   
            --PRINT @iReceiptID
            SET @iVar = 0
            SELECT 0            
            BREAK;
        END

			FETCH NEXT FROM _CURSOR INTO @iReceiptID
		END	
	
	CLOSE _CURSOR
	DEALLOCATE _CURSOR

IF @iVar = 0
BEGIN
    RETURN;
END

IF EXISTS
    (
        SELECT 'True' FROM 
        (
        SELECT ABS(T.N_Receipt_Amount - T.N_Comp_Receipt_Amount) Mismatch FROM 
        (
            SELECT RH.N_Receipt_Amount,RH.I_Receipt_Header_ID,RH.S_Receipt_No,SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Comp_Receipt_Amount FROM dbo.T_Receipt_Header RH WITH (NOLOCK)
            INNER JOIN dbo.T_Receipt_Component_Detail RCD WITH (NOLOCK)
            ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
            WHERE RH.I_Receipt_Type = 2
            AND RH.S_Fund_Transfer_Status = 'Y'
            AND RH.I_Status = 0
            AND RH.I_Centre_ID = @iCentreID
            GROUP BY RH.N_Receipt_Amount,RH.I_Receipt_Header_ID,RH.S_Receipt_No
            UNION
            SELECT RH.N_Receipt_Amount,RH.I_Receipt_Header_ID,RH.S_Receipt_No,SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Comp_Receipt_Amount FROM dbo.T_Receipt_Header RH WITH (NOLOCK)
            INNER JOIN dbo.T_Receipt_Component_Detail RCD WITH (NOLOCK)
            ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
            WHERE RH.I_Receipt_Type = 2
            AND RH.S_Fund_Transfer_Status = 'N'
            AND RH.I_Status = 1
            AND RH.I_Centre_ID = @iCentreID
            GROUP BY RH.N_Receipt_Amount,RH.I_Receipt_Header_ID,RH.S_Receipt_No
        ) T
        WHERE T.N_Receipt_Amount <> T.N_Comp_Receipt_Amount
        ) Z
        WHERE Z.Mismatch > 2
    )
BEGIN
    SELECT 0
    RETURN;
END
ELSE
BEGIN
    SELECT 1
    RETURN;
END

END
