/********************************************************************************************
Created by: Swagata De
Date: 20/06/2007
Description: Retrieves the details of registered employees
Parameters: None
*********************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetRegisteredEmployeesList]
AS
BEGIN

	select I_Employee_ID,S_Emp_ID,S_Title,S_First_Name,S_Middle_Name,S_Last_Name,S_Email_ID,Dt_Upd_On
from dbo.T_Employee_Dtls
where I_Status=2 -- Registered status

END
