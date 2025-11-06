
--exec [dbo].[uspActivityTimeValidation] 107,'828684E68FF54E219C4E39F9CD80389D'
CREATE PROCEDURE [dbo].[uspActivityTimeValidation]
(
 @iBrandID int = null
,@sToken nvarchar(200)
)
AS
BEGIN
select 
TSG.I_School_Group_ID , TCGCT.I_Class_ID,
 TSD.S_Student_ID StudentID
,TSG.S_School_Group_Code SchoolGroupName
,TC.S_Class_Name ClassName
,CONVERT(nvarchar,TCGCT.Start_Time) SchoolStartTime
,CONVERT(nvarchar,TCGCT.End_Time) SchoolEndTime
,TTVT.S_Module Module
,TTVT.S_Activity Activity
,TTVM.S_Time_Type TimeType
,CONVERT(nvarchar,TTVM.Hour_Val) HourVal
,SPCH.N_Value as BrandLogo 
,TSPM.I_Brand_ID BrandID
,TBM.S_Brand_Name BrandName

from 
T_Parent_Master TPM 
JOIN T_Student_Parent_Maps TSPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
join dbo.T_Student_Detail as TSD ON TSD.S_Student_ID = TSPM.S_Student_ID
inner join
T_Student_Batch_Details as SBD on TSD.I_Student_Detail_ID=SBD.I_Student_ID and SBD.I_Status=1
inner join
T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID
inner join
T_Course_Master as CM on CM.I_Course_ID=SBM.I_Course_ID and CM.I_Status=1 and CM.I_Brand_ID=TSPM.I_Brand_ID

join dbo.T_Student_Class_Section as TSBD  on TSD.I_Student_Detail_ID = TSBD.I_Student_Detail_ID 
join dbo.T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSBD.I_School_Group_Class_ID
join dbo.T_School_Group as TSG on TSG.I_School_Group_ID =TSGC.I_School_Group_ID
join dbo.T_Class as TC on TC.I_Class_ID = TSGC.I_Class_ID
join dbo.T_School_Group_Class_Timing as TCGCT on TCGCT.I_School_Group_ID = TSG.I_School_Group_ID and TCGCT.I_Class_ID = TC.I_Class_ID 
join dbo.T_Time_Validation_Type as TTVT on TTVT.I_Brand_ID = TSG.I_Brand_ID  
join dbo.T_Time_Validation_Master as TTVM on TTVT.I_Time_Validation_Type_ID = TTVM.I_Time_Validation_Type_ID  
Left Join T_ERP_Saas_Pattern_Header SPH on SPH.I_Brand_ID=TSPM.I_Brand_ID
And SPH.S_Property_Name='BRAND_LOGO'
Left Join T_ERP_Saas_Pattern_Child_Header SPCH on SPCH.I_Pattern_HeaderID=SPH.I_Pattern_HeaderID 
left join T_Brand_Master TBM ON TBM.I_Brand_ID=TSPM.I_Brand_ID
   where TSBD.I_Status=1  and TTVM.I_Status=1 and TCGCT.I_Status=1
   and TPM.S_Token=@sToken  
    --And SPH.S_Property_Name='BRAND_LOGO'  
   --and TTVT.I_Brand_ID=@iBrandID
END