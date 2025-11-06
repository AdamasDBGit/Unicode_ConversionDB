
CREATE PROCEDURE [dbo].[usp_ERP_Get_Discount_Scheme_List_BKP_June_2025]
	-- Add the parameters for the stored procedure here
	@iERPFeeScheduleID int,
	@FeeComponents NVARCHAR(max)=NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   IF @FeeComponents IS NOT NULL
   BEGIN
					WITH 
					SchemeComponents AS (
						SELECT 
							DSD.I_Discount_Scheme_ID,
							COUNT(DISTINCT CAST(LTRIM(RTRIM(Value)) AS INT)) AS ComponentCount
						FROM 
							T_Discount_Scheme_Details DSD
						CROSS APPLY 
							dbo.fn_Split_comma_String(ISNULL(DSD.S_FeeComponents, '0'), ',')
						WHERE 
							DSD.I_Status_ID = 1
						GROUP BY 
							DSD.I_Discount_Scheme_ID
					),
					MatchingComponents AS (
						SELECT 
							DSD.I_Discount_Scheme_ID,
							COUNT(DISTINCT CAST(LTRIM(RTRIM(fcs.Value)) AS INT)) AS MatchingCount
						FROM 
							T_Discount_Scheme_Details DSD
						CROSS APPLY 
							dbo.fn_Split_comma_String(ISNULL(DSD.S_FeeComponents, '0'), ',') fcs
						INNER JOIN 
							dbo.fn_Split_comma_String(ISNULL(@FeeComponents, '0'), ',') fcm 
							ON CAST(LTRIM(RTRIM(fcs.Value)) AS INT) = CAST(LTRIM(RTRIM(fcm.Value)) AS INT)
						WHERE 
							DSD.I_Status_ID = 1
						GROUP BY 
							DSD.I_Discount_Scheme_ID
					),
					ValidSchemes AS (
						SELECT 
							sc.I_Discount_Scheme_ID
						FROM 
							SchemeComponents sc
						INNER JOIN 
							MatchingComponents mc 
							ON sc.I_Discount_Scheme_ID = mc.I_Discount_Scheme_ID
						WHERE 
							sc.ComponentCount = mc.MatchingCount
					)
				SELECT DISTINCT
					DSM.I_Discount_Scheme_ID AS DiscountSchemeID,
					DSM.S_Discount_Scheme_Name AS DiscountSchemeName
				FROM 
					T_Discount_Scheme_Master DSM
				INNER JOIN 
					T_Discount_Brand_Map DBM 
					ON DSM.I_Discount_Scheme_ID = DBM.I_Discount_Scheme_ID
				INNER JOIN 
					T_Discount_Fee_Schedule_Detail DFSD 
					ON DBM.I_Discount_Brand_ID = DFSD.I_Discount_Brand_ID
				INNER JOIN 
					ValidSchemes VS 
					ON VS.I_Discount_Scheme_ID = DSM.I_Discount_Scheme_ID
				WHERE 
					DFSD.I_ERP_Fee_Structure_ID = @iERPFeeScheduleID
					AND DFSD.I_Status_ID = 1 
					AND DBM.I_Status_ID = 1 
					AND DSM.I_Status = 1
					AND GETDATE() BETWEEN DSM.Dt_Valid_From AND DSM.Dt_Valid_To;


	END
	ELSE
	BEGIN

		 SELECT DISTINCT
					DSM.I_Discount_Scheme_ID AS DiscountSchemeID,
					DSM.S_Discount_Scheme_Name AS DiscountSchemeName
				FROM 
					T_Discount_Scheme_Master AS DSM
				INNER JOIN 
					T_Discount_Brand_Map AS DBM 
					ON DSM.I_Discount_Scheme_ID = DBM.I_Discount_Scheme_ID
				INNER JOIN 
					T_Discount_Fee_Schedule_Detail AS DFSD 
					ON DBM.I_Discount_Brand_ID = DFSD.I_Discount_Brand_ID
				
				WHERE 
					DFSD.I_ERP_Fee_Structure_ID = @iERPFeeScheduleID
					AND DFSD.I_Status_ID = 1 
					AND DBM.I_Status_ID = 1 
					AND DSM.I_Status = 1
					AND GETDATE() BETWEEN DSM.Dt_Valid_From AND DSM.Dt_Valid_To;

	END



END


