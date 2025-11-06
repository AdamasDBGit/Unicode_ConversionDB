CREATE Proc [dbo].[usp_ERP_get_MigrationStudentDataSet]
as
begin
Declare @currYear Varchar(10)
Set @currYear =YEAR(Getdate())
 select Branch
,Source_From
,Enquiry_Type
,[Enquiry_No(Unique No_System Generated)]
,Title
,S_First_Name
,S_Middle_Name
,S_Last_Name
,Dt_Birth_Date
,Age
,S_Email_ID
,Student_Mobile_No
,Current_City
,Curr_State
,Curr_Country
,S_Guardian_Name
,S_Guardian_Email_ID
,Curr_Address1
,Curr_Address2
,Curr_Pincode
,S_Curr_Area
,Perm_Address1
,Perm_Address2
,Perm_Pincode
,Perm_City
,Perm_State
,Perm_Country
,S_Perm_Area
,S_Father_Name
,Mother_Name
,Student_Gender
,Nationality
,I_Religion_ID
,Father_Phone
,Mother_Phone
,Father_Email
,Mother_Email
,[School Programme]
,[Class Name]
,[Student_ID(Unique System Generated )]
,Stream
,Section
,[Roll No]
,[Map_Fee Structure Name]
,[Registration Fee]
,[1st  Payment Amount] as PayAmount
,[Payment Date] AS paymentdt
,EnquiryID as EnquiryID
,FeeStructureID
,Mig_date
,Is_Processed
,Is_FullProcessed
,BM.I_Brand_ID as BrandId
,bcd.I_Centre_Id as CentreId
,asm.I_School_Session_ID as AcademicSessionId
,ID from Mig_Admission adm with (nolock) 
Inner Join T_Brand_Master BM with (nolock) on BM.S_Brand_Name=adm.Branch and BM.I_Status=1
Inner Join T_Brand_Center_Details bcd with (nolock) on bcd.I_Brand_ID=BM.I_Brand_ID and bcd.I_Status=1
Inner Join T_School_Academic_Session_Master asm with (nolock) on asm.I_Brand_ID=BM.I_Brand_ID 
and asm.I_Status=1 and year(asm.Dt_Session_Start_Date)=@currYear


where Is_Processed=1 and isnull(Is_FullProcessed,0)=0
--and EnquiryID<>61
 End
