CREATE PROCEDURE [LOGISTICS].[uspGetDespatchList] 
(
	@iStudentDetailID INT 
)
AS
BEGIN
	SELECT	ISNULL(SDD.I_Despatch_ID, '') AS I_Despatch_ID,
			ISNULL(SDD.I_Student_Detail_ID, ' ') AS I_Student_Detail_ID,
			ISNULL(KM.I_Kit_ID, '') AS I_Kit_ID,
			ISNULL(KM.S_Kit_Code, '') AS S_Kit_Code,
			ISNULL(KM.S_Kit_Desc, '') AS S_Kit_Desc,	
			ISNULL(SDD.Dt_Dispatch_Date, '') AS Dt_Dispatch_Date,
			ISNULL(SDD.S_Docket_No, '') AS S_Docket_No,
			ISNULL(SDD.S_Transporter_Name, '') AS S_Transporter_Name
      
			FROM LOGISTICS.T_Kit_Master KM			
			LEFT OUTER JOIN LOGISTICS.T_Student_Despatch_Detailed SDD
			ON KM.I_Kit_ID=SDD.I_Kit_ID AND SDD.I_Student_Detail_ID = @iStudentDetailID
			ORDER BY SDD.Dt_Crtd_On 
				
END
