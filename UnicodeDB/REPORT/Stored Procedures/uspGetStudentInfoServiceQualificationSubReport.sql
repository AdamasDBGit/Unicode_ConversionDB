--SELECT * FROM dbo.T_Student_Detail TSD WHERE I_Student_Detail_ID=48508


CREATE PROCEDURE [REPORT].[uspGetStudentInfoServiceQualificationSubReport]
(
@iStudentDetailID INT
)
AS
BEGIN

SELECT TEQD.S_Name_Of_Exam,TEQD.S_Institution,TEQD.N_Marks_Obtained,TEQD.S_Year_To,TECS.S_Education_CurrentStatus_Description,TES.S_Education_Stream_Description FROM dbo.T_Student_Detail TSD
LEFT JOIN dbo.T_Enquiry_Qualification_Details TEQD ON TSD.I_Enquiry_Regn_ID = TEQD.I_Enquiry_Regn_ID
LEFT JOIN dbo.T_Enquiry_Education_CurrentStatus TEECS ON TSD.I_Enquiry_Regn_ID=TEECS.I_Enquiry_Regn_ID
LEFT JOIN dbo.T_Education_CurrentStatus TECS ON TEECS.I_Education_CurrentStatus_ID = TECS.I_Education_CurrentStatus_ID
LEFT JOIN dbo.T_Enquiry_Education_Stream TEES ON TSD.I_Enquiry_Regn_ID=TEES.I_Enquiry_Regn_ID
LEFT JOIN dbo.T_Education_Stream TES ON TEES.I_Education_Stream_ID = TES.I_Education_Stream_ID
WHERE
TSD.I_Student_Detail_ID=@iStudentDetailID--48508

END
