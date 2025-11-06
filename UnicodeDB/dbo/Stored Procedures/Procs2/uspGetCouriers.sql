CREATE PROCEDURE [dbo].[uspGetCouriers] 

AS
BEGIN

	SELECT  A.I_Courier_ID, A.S_Courier_Code, A.S_Courier_Name, A.Dt_Start_Date, A.Dt_End_Date, 
	A.S_Address_Line1, A.S_Address_Line2, A.I_Country_ID, A.I_State_ID, A.I_City_ID, A.S_Pincode, 
	A.S_Telephone_No, A.S_Contact_Person, A.I_Status,
	A.S_Crtd_By, A.S_Upd_By, A.Dt_Crtd_On, A.Dt_Upd_On,
	B.S_Country_Code, B.S_Country_Name
	FROM dbo.T_Courier_Master A, dbo.T_Country_Master B
	WHERE A.I_Status <> 0
	AND B.I_Country_ID = A.I_Country_ID
END
