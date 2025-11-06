--exec [uspERPGetAllFaculty]  107    
CREATE PROCEDURE [dbo].[uspERPGetAllFaculty]      
(      
@iBrandID int = null      
 ,@iFacultyID int =null      
       
)      
AS      
BEGIN      
SELECT        
 I_Faculty_Master_ID FacultyMasterID      
,S_Faculty_Code FacultyCode       
,S_Faculty_Name+' ('+isnull(S_Faculty_Code,0)+')' FacultyName      
,S_Faculty_Type FacultyType      
,Dt_DOJ DOJ      
,Dt_DOB DOB      
,S_Gender Gender      
,I_Religion_ID ReligionID      
,I_Maritial_ID MaritalID      
,S_Photo Photo      
,S_Signature Signature      
,S_PAN PAN      
,S_Aadhaar Aadhaar      
,FM.S_Email Email      
,S_Mobile_No MobileNo      
,S_Present_Address PresentAddress      
,S_Permanent_Address PermanentAddress      
,FM.I_Status Status      
,FM.I_Brand_ID BrandID      
FROM [dbo].[T_Faculty_Master] FM     
inner join    
T_ERP_User as EU on EU.I_User_ID=FM.I_User_ID    
inner join T_ERP_User_Brand EUB on EUB.I_User_ID = FM.I_User_ID  
where I_Faculty_Master_ID = ISNULL(@iFacultyID, I_Faculty_Master_ID) and EUB.I_Brand_ID = ISNULL(@iBrandID,EUB.I_Brand_ID)      
and EU.Is_Teaching_Staff = 1  and EUB.Is_Active=1 and FM.I_Status=1  
END