CREATE VIEW dbo.V_Brand_Center_Master
AS
SELECT        dbo.T_Brand_Master.I_Brand_ID AS BrandID, dbo.T_Brand_Master.S_Brand_Name AS BrandName, dbo.T_Centre_Master.I_Centre_Id AS CenterID, dbo.T_Centre_Master.S_Center_Name AS CenterName
FROM            dbo.T_Brand_Master INNER JOIN
                         dbo.T_Brand_Center_Details ON dbo.T_Brand_Master.I_Brand_ID = dbo.T_Brand_Center_Details.I_Brand_ID INNER JOIN
                         dbo.T_Brand_Center_Details AS T_Brand_Center_Details_1 ON dbo.T_Brand_Master.I_Brand_ID = T_Brand_Center_Details_1.I_Brand_ID INNER JOIN
                         dbo.T_Brand_Master AS T_Brand_Master_1 ON dbo.T_Brand_Center_Details.I_Brand_ID = T_Brand_Master_1.I_Brand_ID AND T_Brand_Center_Details_1.I_Brand_ID = T_Brand_Master_1.I_Brand_ID INNER JOIN
                         dbo.T_Centre_Master ON dbo.T_Brand_Center_Details.I_Centre_Id = dbo.T_Centre_Master.I_Centre_Id AND T_Brand_Center_Details_1.I_Centre_Id = dbo.T_Centre_Master.I_Centre_Id
WHERE        (dbo.T_Centre_Master.I_Status = 1) AND (dbo.T_Brand_Master.I_Status = 1) AND (dbo.T_Brand_Master.I_Brand_ID IN (107, 110))