CREATE VIEW [dbo].[T_Student_Course_Detail]
AS
SELECT     A.I_Student_Batch_ID, A.I_Student_ID AS I_Student_Detail_ID, A.I_Batch_ID, A.I_Student_Certificate_ID, A.I_Total_Attendance_Count, A.Dt_Valid_To, 
                      A.Dt_Valid_From, B.S_Batch_Code, B.I_Course_ID, B.I_Delivery_Pattern_ID, B.I_TimeSlot_ID, B.Dt_BatchStartDate AS Dt_Course_Start_Date, 
                      CAST(CASE ISNULL(C.I_Status, B.I_Status) WHEN 5 THEN 1 ELSE 0 END AS BIT) AS I_Is_Completed, B.Dt_Course_Expected_End_Date, 
                      B.Dt_Course_Actual_End_Date, B.S_Crtd_By, B.S_Updt_By, B.Dt_Crtd_On, B.Dt_Upd_On, C.I_Centre_Id, C.Max_Strength, 
                      F.I_Course_Center_Delivery_ID, A.I_Status, A.C_Is_LumpSum
FROM         dbo.T_Student_Batch_Details AS A INNER JOIN
                      dbo.T_Student_Batch_Master AS B ON A.I_Batch_ID = B.I_Batch_ID INNER JOIN
                      dbo.T_Center_Batch_Details AS C ON B.I_Batch_ID = C.I_Batch_ID INNER JOIN
                      dbo.T_Course_Center_Detail AS D ON C.I_Centre_Id = D.I_Centre_Id AND B.I_Course_ID = D.I_Course_ID AND D.I_Status = 1 INNER JOIN
                      dbo.T_Student_Center_Detail AS G ON G.I_Student_Detail_ID = A.I_Student_ID AND G.I_Centre_Id = C.I_Centre_Id INNER JOIN
                      dbo.T_Course_Delivery_Map AS E ON D.I_Course_ID = E.I_Course_ID AND B.I_Delivery_Pattern_ID = E.I_Delivery_Pattern_ID AND 
                      E.I_Status <> 0 LEFT OUTER JOIN
                      dbo.T_Course_Center_Delivery_FeePlan AS F ON E.I_Course_Delivery_ID = F.I_Course_Delivery_ID AND 
                      D.I_Course_Center_ID = F.I_Course_Center_ID AND C.I_Course_Fee_Plan_ID = F.I_Course_Fee_Plan_ID AND F.I_Status = 1
WHERE     (A.I_Status = 1)