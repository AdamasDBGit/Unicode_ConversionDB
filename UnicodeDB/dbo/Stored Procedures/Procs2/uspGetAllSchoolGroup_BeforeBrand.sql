
--exec [dbo].[uspGetGatePass] null,'9038325725'
CREATE PROCEDURE [dbo].[uspGetAllSchoolGroup_BeforeBrand]
AS
BEGIN
SELECT  [I_School_Group_ID] GroupID
      ,[I_Brand_Id]
      ,[S_School_Group_Code]
      ,[S_School_Group_Name] SchoolGroupName
      ,[I_Status]
    
  FROM [dbo].[T_School_Group]

--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])
END
