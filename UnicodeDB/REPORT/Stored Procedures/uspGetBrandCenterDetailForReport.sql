CREATE PROCEDURE [REPORT].[uspGetBrandCenterDetailForReport]
(
@iCenterID AS INT

)
AS
BEGIN

SELECT		A.S_Brand_Name,
			C.S_Center_Name,
			D.S_Center_Address1	
			

FROM T_Brand_Master A INNER JOIN T_Brand_Center_Details B
ON A.I_Brand_ID=B.I_Brand_ID INNER JOIN T_Center_Hierarchy_Name_Details C
ON C.I_Center_ID=B.I_Centre_Id
INNER JOIN NETWORK.T_Center_Address D
ON D.I_Centre_Id=C.I_Center_ID
WHERE 
C.I_Center_ID=@iCenterID
END
