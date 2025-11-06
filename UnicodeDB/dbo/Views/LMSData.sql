CREATE VIEW dbo.LMSData
AS
SELECT     A.S_Student_ID, A.S_First_Name, ISNULL(A.S_Middle_Name, '') AS MiddleName, A.S_Last_Name, A.S_Curr_Address1, A.S_Curr_Address2, TCM.S_City_Name, 
                      A.S_Perm_Pincode, 'India' AS Country, A.S_Email_ID, A.S_Mobile_No, A.S_Phone_No, A.Dt_Birth_Date, D.I_Centre_Id, A.Dt_Crtd_On, F.S_Student_Photo, 
                      1 AS categorycode
FROM         dbo.T_Student_Detail AS A INNER JOIN
                      dbo.T_Student_Batch_Details AS B ON A.I_Student_Detail_ID = B.I_Student_ID INNER JOIN
                      dbo.T_Student_Batch_Master AS C ON C.I_Batch_ID = B.I_Batch_ID INNER JOIN
                      dbo.T_Center_Batch_Details AS D ON D.I_Batch_ID = C.I_Batch_ID INNER JOIN
                      dbo.T_Center_Hierarchy_Name_Details AS E ON E.I_Center_ID = D.I_Centre_Id INNER JOIN
                      dbo.T_Enquiry_Regn_Detail AS F ON F.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID INNER JOIN
                      dbo.T_Course_Master AS G ON G.I_Course_ID = C.I_Course_ID INNER JOIN
                      dbo.T_City_Master AS TCM ON A.I_Curr_City_ID = TCM.I_City_ID
WHERE     (B.I_Status = 1) AND (E.I_Brand_ID = 109) AND (A.Dt_Crtd_On <= GETDATE())