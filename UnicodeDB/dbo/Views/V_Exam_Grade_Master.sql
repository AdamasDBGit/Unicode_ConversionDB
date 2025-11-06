CREATE VIEW dbo.V_Exam_Grade_Master
AS
SELECT        gm.I_School_Session_ID, t1.I_School_Group_ID, t1.I_Class_ID, gm.I_Exam_Grade_Master_ID, gm.S_Symbol, gm.I_Lower_Limit, gm.I_Upper_Limit
FROM            (SELECT        I_School_Group_Class_ID, I_School_Group_ID, I_Class_ID, Dt_StartedAt, I_Status, CASE WHEN EXISTS
                                                        (SELECT        TOP 1 '1'
                                                          FROM            [dbo].[V_Exam_Grade_Sub]
                                                          WHERE        I_Class_ID = sgc.I_Class_ID AND I_School_Group_ID = sgc.I_School_Group_ID) THEN 1 WHEN EXISTS
                                                        (SELECT        TOP 1 '1'
                                                          FROM            [dbo].[V_Exam_Grade_Sub]
                                                          WHERE        I_Class_ID IS NULL AND I_School_Group_ID = sgc.I_School_Group_ID) THEN 2 ELSE 3 END AS chk_val
                          FROM            dbo.T_School_Group_Class AS sgc) AS t1 INNER JOIN
                         dbo.V_Exam_Grade_Sub AS gm ON t1.I_School_Group_ID = gm.I_School_Group_ID AND t1.I_Class_ID = CASE WHEN t1.chk_val = 1 THEN gm.I_Class_ID WHEN t1.chk_val = 2 THEN t1.I_Class_ID ELSE - 1 END