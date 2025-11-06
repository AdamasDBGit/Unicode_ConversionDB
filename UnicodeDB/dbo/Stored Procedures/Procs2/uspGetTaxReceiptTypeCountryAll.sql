CREATE PROCEDURE [dbo].[uspGetTaxReceiptTypeCountryAll] -- [dbo].[uspGetTaxReceiptTypeCountryAll] 109
(
	@iBrandID INT = NULL
)
AS 
    BEGIN  
  
        SELECT  I_Country_ReceiptType_Tax_ID ,
                I_Tax_ID ,
                I_Country_ID ,
                I_Receipt_Type ,
                N_Tax_Rate ,
                Dt_Valid_From ,
                Dt_Valid_To ,
                I_Status
        FROM    dbo.T_Tax_Country_ReceiptType TCR
				INNER JOIN dbo.T_Status_Master AS TSM 
				ON TCR.I_Receipt_Type = TSM.I_Status_Value
				WHERE (I_Brand_ID = ISNULL(@iBrandID,I_Brand_ID) or I_Brand_ID IS NULL)
    END
