CREATE PROCEDURE [LOGISTICS].[uspKitsDispatch]
(
		@dtFromDate		DATETIME	= NULL		,
		@dtToDate		DATETIME	= NULL		
)
WITH 
EXECUTE AS CALLER
AS
BEGIN
	

    DECLARE @tmp Table
	(
		CenterCode   varchar(100),
		CenterName   varchar(200),
		MaterialCode varchar(100),
		Quantity     int
	)

	INSERT INTO @tmp
	SELECT 		
		ISNULL(CM.S_Center_Code,'') AS CenterCode
  	   ,ISNULL(CM.S_Center_Name,'') AS CenterName		
	   ,ISNULL(KM.S_Kit_Code, '') AS MaterialCode
       ,Count(ISNULL(SDD.I_Kit_ID, 0)) Quantity
	  
		FROM  LOGISTICS.T_Student_Despatch_Detailed SDD
		LEFT OUTER JOIN dbo.T_Centre_Master CM
		ON  CM.I_Centre_Id = SDD.I_Center_ID
		LEFT OUTER JOIN LOGISTICS.T_Kit_Master KM
		ON KM.I_Kit_ID = SDD.I_Kit_ID		
		Where ISNULL(S_Kit_Code,'')!= ''
		AND
		SDD.[Dt_Crtd_On] >= COALESCE(@dtFromDate,SDD.[Dt_Crtd_On])
		AND 
		SDD.[Dt_Crtd_On] <=	COALESCE(@dtToDate,SDD.[Dt_Crtd_On])		
    Group By CM.S_Center_Name,CM.S_Center_Code,KM.S_Kit_Code
	
DECLARE @Qty_Sum int
   SELECT @Qty_Sum = SUM(Quantity) FROM @tmp

	INSERT INTO @tmp (MaterialCode, Quantity) VALUES ('Total',(@Qty_Sum))
	--INSERT INTO @tmp(MaterialCode) VALUES ('Total')

   SELECT * FROM @tmp
END
