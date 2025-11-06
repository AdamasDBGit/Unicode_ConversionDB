-- =============================================
-- Author:		Parichoy Nandi
-- Create date: 4th Jan 2024
-- Description:	to get the details of student info list
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_getStudentDetailsView]
	-- Add the parameters for the stored procedure here
	@brandid int,
	@studentid int,
	@studentdetailsid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 select distinct SD.I_Student_Detail_ID as StudentDetailID,
SD.S_Student_ID as StudentID,
ERD.S_Student_Photo as StudentPhoto,
ERD.I_Enquiry_Regn_ID as EnquiryID,
SD.S_First_Name as StudentFirstName,
SD.S_Middle_Name as StudentMiddleName,
SD.S_Last_Name as StudentLastName,
COALESCE(SD.S_Title + ' ', '') + COALESCE(SD.S_First_Name + ' ', '') +COALESCE(SD.S_Middle_Name + ' ', '') + COALESCE(SD.S_Last_Name, '') AS StudentName,
SD.Dt_Birth_Date as BirthDate,
SD.S_Age as Age,
SD.S_Email_ID as EmailID,
SD.S_Mobile_No as MobileNo,
BG.S_Blood_Group as BloodGroup,
BG.I_Blood_Group_ID as BloodGroupID,
G.S_Gender_Name as Gender,
G.I_Gender_ID as GenderID,
NL.S_Native_Language_Name as NativeLanguage,
NL.I_Native_Language_ID as NativeLanguageID,
ECAS.S_Caste_Name as Caste,
ECAS.I_Caste_ID as CasteID,
UN.S_Nationality as Nationality,
UN.I_Nationality_ID as NationalityID,
R.S_Religion_Name as Religion,
R.I_Religion_ID as ReligionID,
CONCAT(SG.S_School_Group_Name, ' (', SG.S_School_Group_Code, ')') as SchoolGroup,
CONCAT(C.S_Class_Name, ' (', C.S_Class_Code, ')') as Class,
Sec.S_Section_Name as Section,
St.S_Stream as StreamName,
SCS.S_Class_Roll_No as RollNo,
SD.S_Perm_Address1 as Address1,
SD.S_Perm_Address2 as Address2,
SD.S_Perm_Pincode as Pincode,
SD.Student_Status as StudentStatus,
CONCAT(CM.S_Country_Name, ' (', CM.S_Country_Code, ')') as Country,
CM.I_Country_ID as CountryID,
CONCAT(ESM.S_State_Name, ' (', ESM.S_State_Code, ')') as StateName,
ESM.I_State_ID as StateID,
CONCAT(ECM.S_City_Name, ' (', ECM.S_City_Code, ')') as City,
ECM.I_City_ID as CityID,
ERD.Is_Sibling as Sibling,
ERD.Is_Prev_Academy as PrevAcademy,
EPD.S_School_Name as PrevSchool,
EPD.S_School_Board as PrevBoard,
EPD.S_Address as PrevAddress,
PS.S_StudentID as SibID,
PS.S_Stud_Name as SibName,
PS.Is_Running_Stud as SibRunning,
PS.S_Passout_Year as SibPassYear
from T_ERP_Student_Detail as SD
Left join T_ERP_Country_Master as CM on SD.I_Curr_Country_ID =CM.I_Country_ID
Left join T_ERP_State_Master as ESM on ESM.I_State_ID =SD.I_Curr_State_ID
Left join T_ERP_City_Master as ECM on ECM.I_City_ID = SD.I_Curr_City_ID
LEFT Join T_ERP_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID =SD.R_I_Enquiry_Regn_ID
left join T_ERP_Blood_Group as BG on BG.I_Blood_Group_ID =ERD.I_Blood_Group_ID
left join T_ERP_Gender as G on G.I_Gender_ID= ERD.I_Gender_ID
left join T_ERP_User_Nationality as UN on UN.I_Nationality_ID = ERD.I_Nationality_ID
left join T_ERP_Native_Language as NL on NL.I_Native_Language_ID =ERD.I_Native_Language_ID
left join T_ERP_Caste_Master as ECAS on ECAS.I_Caste_ID =ERD.I_Caste_ID
left join T_ERP_Religion as R on R.I_Religion_ID = ERD.I_Religion_ID
inner JOIN T_Student_Class_Section as SCS on SCS.I_Student_Detail_ID=SD.I_Student_Detail_ID 
inner join T_School_Group_Class as SGS on SGS.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID
inner join T_Class as C on C.I_Class_ID=SGS.I_Class_ID
left join T_Section as Sec on Sec.I_Section_ID = SCS.I_Section_ID
left join T_Stream as St on St.I_Stream_ID =SCS.I_Stream_ID
left join T_ERP_AdmissionStageType as AST on ERD.R_I_AdmStgTypeID=AST.I_AdmStgTypeID
inner Join T_School_Group as SG on SG.I_School_Group_ID = SGS.I_School_Group_Class_ID
left join T_ERP_EnquiryReg_Prev_Details as EPD on EPD.R_I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
left join T_ERP_PreEnq_Siblings as PS on PS.R_I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
where SCS.I_Status=1 and SD.Is_Active=1
and SD.S_Student_ID=@studentid and SD.I_Student_Detail_ID=@studentdetailsid and ERD.I_Brand_ID=@brandid


select 
RM.S_Relation_Type as Relation,
RM.I_Relation_Master_ID as RelationID,
GM.S_First_Name as GuardianFirstName,
GM.S_Middile_Name as GuardianMiddleName,
GM.S_Last_Name as GuardianLastName,
COALESCE(GM.S_First_Name + ' ', '') + COALESCE(GM.S_Middile_Name + ' ', '') + COALESCE(GM.S_Last_Name, '') AS GuardianName,
GM.S_Mobile_No as GuardianMobile,
GM.S_Guardian_Email as GuardianEmail,
GM.I_Qualification_ID as QualificationID,
QNM.S_Qualification_Name as GuardianQualification,
GM.I_Income_Group_ID as IncomeID,
IGM.S_Income_Group_Name as Income,
GM.S_Profile_Picture as GuardianPicture,
GM.S_Company_Name as GuardianCompanyName,
GM.I_Occupation_ID as OccupationID,
OM.S_Occupation_Name as OccupationName,
GM.S_Designation as GuardianDesignation
from
T_ERP_Student_Detail as SD
left join T_ERP_Enquiry_Regn_Guardian_Master as GM on SD.R_I_Enquiry_Regn_ID = GM.I_Enquiry_Regn_ID
left join T_ERP_Relation_Master as RM on GM.I_Relation_ID = RM.I_Relation_Master_ID
left join T_ERP_Qualification_Name_Master as QNM on GM.I_Qualification_ID = QNM.I_Qualification_Name_ID
left join T_ERP_Occupation_Master as OM on GM.I_Occupation_ID=OM.I_Occupation_ID
left join T_ERP_Income_Group_Master as IGM on GM.I_Income_Group_ID = IGM.I_Income_Group_ID
LEFT Join T_ERP_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID =SD.R_I_Enquiry_Regn_ID
where GM.I_Status=1 and SD.S_Student_ID=@studentid and SD.I_Student_Detail_ID=@studentdetailsid and ERD.I_Brand_ID=@brandid


END
