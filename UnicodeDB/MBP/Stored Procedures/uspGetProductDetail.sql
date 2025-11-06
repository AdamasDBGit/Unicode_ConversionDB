-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp return the detail of product
-- =============================================
CREATE PROCEDURE [MBP].[uspGetProductDetail]
(  
@iProductID INT = NULL,	
@iBrandID INT = NULL	
)
AS
	BEGIN TRY  
	
	SELECT 
	DISTINCT PM.I_Product_ID AS I_Product_ID ,
	PM.S_Product_Description AS S_Product_Description,	
	PM.S_Product_Name AS S_Product_Name	
	FROM
	MBP.T_Product_Master PM
	INNER JOIN MBP.T_Product_Component PC
	ON PM.I_Product_ID=PC.I_Product_ID 
	LEFT OUTER JOIN dbo.T_Course_Master CM
	ON CM.I_Course_ID = PC.I_Course_ID
	LEFT OUTER JOIN dbo.T_CourseFamily_Master CFM
	ON CFM.I_CourseFamily_ID = PC.I_Course_Family_ID
	WHERE PM.I_Product_ID = COALESCE(@iProductID,PM.I_Product_ID)
	AND PM.I_Brand_ID  =COALESCE(@iBrandID,PM.I_Brand_ID)
--	AND PM.S_Product_Name != 'MBP_DUMMY_PRODUCT_FOR_ENQUIRY'
		
	
	SELECT 
	PC.I_Product_Component_ID AS I_Product_Component_ID,
	PC.I_Product_ID AS I_Product_ID,
	ISNULL(CM.I_Course_ID ,0) AS I_Course_ID,
	ISNULL(CM.S_Course_Code,'C0') AS S_Course_Code,
	ISNULL(CM.S_Course_Name,'') AS S_Course_Name,
	ISNULL(CFM.I_CourseFamily_ID,0) AS I_CourseFamily_ID,
	ISNULL(CFM.S_CourseFamily_Name,'') AS S_CourseFamily_Name,
	ISNULL(CM.I_Brand_ID ,0) AS Course_I_Brand_ID,
	ISNULL(CFM.I_Brand_ID ,0) AS CrsFamily_I_Brand_ID
	
	FROM MBP.T_Product_Component PC
	LEFT OUTER JOIN dbo.T_Course_Master CM
	ON CM.I_Course_ID = PC.I_Course_ID
	LEFT OUTER JOIN dbo.T_CourseFamily_Master CFM
	ON CFM.I_CourseFamily_ID = PC.I_Course_Family_ID
	WHERE I_Product_ID = COALESCE(@iProductID,I_Product_ID)
		  AND PC.I_Status_ID=1


	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
