CREATE PROCEDURE [dbo].[usp_ERP_Get_Discount_Scheme_List]
	-- Add the parameters for the stored procedure here
	@iERPFeeScheduleID int=NULL,
	@FeeComponents NVARCHAR(MAX)=NULL,
	@iBrandID int=null

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
							--COUNT(DISTINCT CAST(LTRIM(RTRIM(Value)) AS INT)) AS ComponentCount
							COUNT(DISTINCT DSD.I_FeeComponentID) AS ComponentCount
						FROM 
							--T_Discount_Scheme_Details DSD
						--CROSS APPLY 
						--	dbo.fn_Split_comma_String(ISNULL(DSD.S_FeeComponents, '0'), ',')
						T_ERP_Discount_Scheme_Details DSD
						inner join
						T_Discount_Scheme_Master as DSM on DSD.I_Discount_Scheme_ID=DSM.I_Discount_Scheme_ID
						WHERE 
							DSD.I_Status_ID = 1 and DSM.I_Brand_ID=ISNULL(@iBrandID,DSM.I_Brand_ID) and DSM.I_Status=1
						GROUP BY 
							DSD.I_Discount_Scheme_ID
					),
					MatchingComponents AS (
						SELECT 
							DSD.I_Discount_Scheme_ID,
							COUNT(DISTINCT DSD.I_FeeComponentID) AS MatchingCount
						FROM 
							--T_Discount_Scheme_Details DSD
						--CROSS APPLY 
						--	dbo.fn_Split_comma_String(ISNULL(DSD.S_FeeComponents, '0'), ',') fcs
						T_ERP_Discount_Scheme_Details DSD
						INNER JOIN 
							dbo.fn_Split_comma_String(ISNULL(@FeeComponents, '0'), ',') fcm 
							ON DSD.I_FeeComponentID = CAST(LTRIM(RTRIM(fcm.Value)) AS INT)
							inner join
						T_Discount_Scheme_Master as DSM on DSD.I_Discount_Scheme_ID=DSM.I_Discount_Scheme_ID
						WHERE 
							DSD.I_Status_ID = 1 and DSM.I_Brand_ID=ISNULL(@iBrandID,DSM.I_Brand_ID) and DSM.I_Status=1
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
					ValidSchemes VS 
					ON VS.I_Discount_Scheme_ID = DSM.I_Discount_Scheme_ID
				WHERE 
					 DSM.I_Status = 1
					AND DSM.I_Brand_ID=ISNULL(@iBrandID,DSM.I_Brand_ID)
					--AND GETDATE() BETWEEN DSM.Dt_Valid_From AND DSM.Dt_Valid_To;


	END
	ELSE
	BEGIN

		 SELECT DISTINCT
					DSM.I_Discount_Scheme_ID AS DiscountSchemeID,
					DSM.S_Discount_Scheme_Name AS DiscountSchemeName
				FROM 
					T_Discount_Scheme_Master DSM
				INNER JOIN 
					ValidSchemes VS 
					ON VS.I_Discount_Scheme_ID = DSM.I_Discount_Scheme_ID
				WHERE 
					 DSM.I_Status = 1
					AND DSM.I_Brand_ID=ISNULL(@iBrandID,DSM.I_Brand_ID)
					--AND GETDATE() BETWEEN DSM.Dt_Valid_From AND DSM.Dt_Valid_To;

	END



END
