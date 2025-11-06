CREATE VIEW dbo.LMS_Student_Data
AS
SELECT     A.S_Student_ID AS [Card Number], ISNULL(A.S_First_Name, '') AS [First Name], ISNULL(A.S_Middle_Name, '') AS [Middle Name], ISNULL(A.S_Last_Name, '') 
                      AS Surname, A.S_Curr_Address1 AS Address1, G.S_City_Name AS City, A.S_Curr_Pincode AS Zipcode, I.S_Country_Name AS Country, A.S_Email_ID AS Email, 
                      A.S_Mobile_No AS Mobile, A.S_Phone_No AS Phone, A.Dt_Birth_Date AS DateOfBirth, D.I_Centre_Id AS BranchCode, CONVERT(date, A.Dt_Crtd_On) AS DateEnrolled, 
                      '1' AS CATEGORY_CODE, A.S_Student_ID AS USER_ID
FROM         dbo.T_Student_Detail AS A INNER JOIN
                      dbo.T_Student_Batch_Details AS B ON A.I_Student_Detail_ID = B.I_Student_ID INNER JOIN
                      dbo.T_Student_Batch_Master AS C ON B.I_Batch_ID = C.I_Batch_ID INNER JOIN
                      dbo.T_Center_Batch_Details AS D ON C.I_Batch_ID = D.I_Batch_ID INNER JOIN
                      dbo.T_Center_Hierarchy_Name_Details AS E ON D.I_Centre_Id = E.I_Center_ID INNER JOIN
                      dbo.T_Enquiry_Regn_Detail AS F ON A.I_Enquiry_Regn_ID = F.I_Enquiry_Regn_ID FULL OUTER JOIN
                      dbo.T_City_Master AS G ON A.I_Curr_City_ID = G.I_City_ID FULL OUTER JOIN
                      dbo.T_State_Master AS H ON G.I_State_ID = H.I_State_ID FULL OUTER JOIN
                      dbo.T_Country_Master AS I ON H.I_Country_ID = I.I_Country_ID
WHERE     (B.I_Status = 1) AND (A.S_Student_ID LIKE '%RICE%')