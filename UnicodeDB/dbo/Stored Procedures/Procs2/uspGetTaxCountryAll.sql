CREATE PROCEDURE [dbo].[uspGetTaxCountryAll]
(
	@iBrandID INT = NULL
)
AS 
    BEGIN  
        DECLARE @dtCurrentFinYearEnd DATETIME  
        SET @dtCurrentFinYearEnd = CONVERT(DATETIME, '03/31/'
            + CONVERT(VARCHAR(4), DATEPART(yyyy, GETDATE())))  
        IF ( DATEDIFF(dd, GETDATE(), @dtCurrentFinYearEnd) < 0 ) 
            SET @dtCurrentFinYearEnd = CONVERT(DATETIME, '03/31/'
                + CONVERT(VARCHAR(4), DATEPART(yyyy, GETDATE()) + 1))  
  
        SELECT  I_Country_FeeComponent_Tax_ID ,
                I_Tax_ID ,
                I_Country_ID ,
                TCFM.I_Fee_Component_ID ,
                N_Tax_Rate ,
                Dt_Valid_From ,
                ISNULL(Dt_Valid_To, @dtCurrentFinYearEnd) AS Dt_Valid_To ,
                TCFM.I_Status
        FROM    dbo.T_Tax_Country_Fee_Component  TCFM
        INNER JOIN dbo.T_Fee_Component_Master AS TFCM
        ON TCFM.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
        WHERE I_Brand_ID = ISNULL(@iBrandID,I_Brand_ID)
    
    END
