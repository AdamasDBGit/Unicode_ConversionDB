CREATE VIEW dbo.V_Exam_Grade_Sub
AS
SELECT        t1.I_Exam_Grade_Master_Header_ID, t1.I_School_Group_ID, t1.I_School_Session_ID, t1.I_Class_ID, t2.I_Exam_Grade_Master_ID, t2.S_Symbol, t2.S_Name, t2.I_Lower_Limit, t2.I_Upper_Limit
FROM            dbo.T_Exam_Grade_Master_Header AS t1 INNER JOIN
                         dbo.T_Exam_Grade_Master AS t2 ON t1.I_Exam_Grade_Master_Header_ID = t2.I_Exam_Grade_Master_Header_ID