  
--EXEC [uspGetStudentAfterLogin] 'B7107ED53E344E63AC42E2149620A355'  
CREATE PROCEDURE [dbo].[uspGetStudentAfterLogin]          
(       
--Declare     
 @sToken nvarchar(MAX) ='B7107ED53E344E63AC42E2149620A355'         
)          
AS          
BEGIN          
    Declare @currentyear varchar(4)      
 set @currentyear =(select YEAR(GETDATE()))    
select distinct TPM.S_Mobile_No MobileNo          
,TSD.S_Student_ID as student_erp_id          
,TSD.I_Student_Detail_ID StudentID          
,TSCS.I_Brand_ID brandid          
,BM.S_Brand_Name AS client_name          
,CONCAT(LTRIM(RTRIM(TSD.S_First_Name)),case when TSD.S_Middle_Name         
is not null AND TSD.S_Middle_Name !='' then concat(' ',LTRIM(RTRIM(TSD.S_Middle_Name))) else '' end ,          
        ' ',LTRIM(RTRIM(TSD.S_Last_Name))) AS student_name          
,ERD.S_Student_Photo as profile_picture           
--,TCM.S_Course_Code as class_name          
,cls.S_Class_Name as class_name          
--,TSBM.S_Batch_Name as section_name         
,sec.S_Section_Name as section_name        
,TSGS.I_Class_ID as classid          
,CASE WHEN TPM.I_IsBusTravel = 1  THEN 1 ELSE 0 end IsTransport          
--,CASE WHEN TSD.I_Transport_ID IS NOT NULL AND TSD.Dt_Transport_Deactivation IS NULL           
--        THEN 'Transport Availed'          
--    WHEN TSD.I_Transport_ID IS NOT NULL AND TSD.Dt_Transport_Deactivation IS NOT NULL AND TSD.Dt_Transport_Deactivation<CURRENT_TIMESTAMP          
--        THEN  'Transport Deactivated'          
--    ELSE           
--        'Transport not Availed'          
--END Is_Transport          
 ,ISNULL(FORMAT(Convert(date, TSD.Dt_Birth_Date), 'dd/MM/yyyy'), '01/01/1900') as DateOfBirth      
 ,Concat(TSD.S_Curr_Address1,' ',TSd.S_Curr_Address2,' ',TSM.S_State_Name,' ',TCMM.S_City_Name,' ',TSd.S_Curr_Pincode) as [Address]      
,SG.S_School_Group_Name as School_Group      
,TBG.S_Blood_Group as Blood_Group     
,TSASM.Dt_Session_Start_Date SessionStart    
,TSASM.Dt_Session_End_Date SessionEnd    
from T_Parent_Master TPM           
JOIN T_Student_Parent_Maps TSPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID          
JOIN dbo.T_Student_Detail as TSD ON TSD.S_Student_ID = TSPM.S_Student_ID          
--join [dbo].[T_Student_Batch_Details] as TSBD on TSD.I_Student_Detail_ID = TSBD.I_Student_ID          
--join [dbo].[T_Student_Batch_Master] as TSBM on TSBM.I_Batch_ID = TSBD.I_Batch_ID          
--join [dbo].[T_Course_Master] as TCM on TCM.I_Course_ID = TSBM.I_Course_ID     
--Inner Join T_Student_Class_Section sCS ON sCS.I_Student_Detail_ID=TSD.I_Student_Detail_ID    
--and sCS.I_Status=1    
JOIN dbo.T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID          
join T_Student_Class_Section TSCS ON TSCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID         
AND TSCS.I_Status=1          
Left Join T_Section Sec On sec.I_Section_ID=TSCS.I_Section_ID         
Left Join T_School_Group_Class SGC on SGC.I_School_Group_Class_ID=TSCS.I_School_Group_Class_ID        
        
Left Join T_Class Cls on cls.I_Class_ID=SGC.I_Class_ID and cls.I_Brand_ID=TSCS.I_Brand_ID        
and cls.I_Status=1        
Left Join T_School_Group SG on sg.I_School_Group_ID=SGC.I_School_Group_ID and         
sg.I_Brand_ID=TSCS.I_Brand_ID and SG.I_Status=1        
join T_School_Group_Class TSGS ON TSGS.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID          
JOIN T_Brand_Master BM ON BM.I_Brand_ID = TSCS.I_Brand_ID AND TPM.I_Brand_ID = BM.I_Brand_ID AND TSPM.I_Brand_ID = BM.I_Brand_ID          
Left Join T_State_Master TSM on TSM.I_State_ID=TSD.I_Curr_State_ID and TSM.I_Status=1      
Left Join T_City_Master TCMM on TCMM.I_City_ID=TSD.I_Curr_City_ID and TCMM.I_Status=1      
Left Join T_Blood_Group TBG on Tbg.I_Blood_Group_ID=ERD.I_Blood_Group_ID     
Inner join T_School_Academic_Session_Master TSASM on TSASM.I_Brand_ID = BM.I_Brand_ID and BM.I_Status=1
and TSASM.I_Current_Session=1
--and YEAR(TSASM.Dt_Session_Start_Date)=@currentyear    
where           
--TCM.I_Brand_ID=107           
--and           
--TSBD.I_Status=1    
--and          
TPM.S_Token=@sToken            
END    
--select * from T_Student_Class_Section where S_Student_ID='19-0134'    
--select * from T_Student_Parent_Maps where S_Student_ID='19-0134'    
--select * from T_Student_Batch_Details where I_Student_ID=87362 