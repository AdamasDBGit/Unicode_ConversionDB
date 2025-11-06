CREATE PROCEDURE [dbo].[Teacher_Routine_View]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 15-09-2023
-- Description:	Teacher_Routine_View_Day_Wise
-- =============================================
-- Add the parameters for the stored procedure here
@TeacherID int
--@Day date


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		SET NOCOUNT ON;
		--declare @D int
	 --   Set @D=(
  --      select I_Day_ID from 
  --      T_Week_Day_Master where S_Day_Name =(SELECT DATENAME(dw,@Day)))


select 
TSASM.I_School_Session_ID,
TSASM.S_Label, 
TSASM.I_Brand_ID,
TERSH.I_School_Group_ID,
TERSD.I_Period_No,
TERSD.T_FromSlot,
TERSD.T_ToSlot,
TWDM.I_Day_ID,
TWDM.S_Day_Name,
TWOM.I_Weekly_Off_Day_ID,
(case when  TWOM.I_WeekOff=1 then 'YES'
      when  TWOM.I_WeekOff=7 then 'YES'
	  else 'NO'
end ) AS Week_Off,
TWOM.I_IsAlternative,
TERSH.I_Class_ID,
TC.S_Class_Name,
TERSH.I_Section_ID,
TS.S_Section_Name,
TERSH.I_Stream_ID,
STE.S_Stream,
TSM.I_Subject_ID,
TSM.S_Subject_Name,
TFM.I_Faculty_Master_ID,
TFM.S_Faculty_Name


from 

T_School_Academic_Session_Master TSASM

left join T_ERP_Routine_Structure_Header TERSH on 
TERSH.I_School_Session_ID=TSASM.I_School_Session_ID

left join T_ERP_Routine_Structure_Detail TERSD on 
TERSD.I_Routine_Structure_Header_ID=TERSH.I_Routine_Structure_Header_ID

left Join T_Week_Day_Master TWDM on TWDM.I_Day_ID=TERSD.I_Day_ID

left join T_Weekly_Off_Master TWOM on TWOM.I_Day_ID=TWDM.I_Day_ID and 
TERSD.I_Day_ID=TWOM.I_Day_ID 
--and 
--TWOM.I_School_session_ID=TERSH.I_School_Session_ID
--and 
---TWOM.I_School_session_ID=TSASM.I_School_Session_ID

left join T_Class TC on TC.I_Class_ID=TERSH.I_Class_ID

left join T_Section TS on TS.I_Section_ID=TERSH.I_Section_ID

left Join T_Stream STE on STE.I_Stream_ID=TERSH.I_Stream_ID

left join T_ERP_Student_Class_Routine TESCR on 
TESCR.I_Routine_Structure_Detail_ID=TERSD.I_Routine_Structure_Detail_ID

left join T_Subject_Master TSM  ON TESCR.I_Subject_ID=TSM.I_Subject_ID  

Left Join T_Faculty_Master TFM on TFM.I_Faculty_Master_ID=TESCR.I_Faculty_Master_ID

where 
--- Will Only find respective of Active Class,Strean, Academic_session------- 

TSASM.I_Status=1 
and 
TC.I_Status=1 
and 
STE.I_Status=1
and TFM.I_Faculty_Master_ID=@TeacherID --and TWDM.I_Day_ID=@D

order by TWDM.I_Day_ID, TERSD.I_Period_No,TERSD.T_FromSlot,TERSD.T_ToSlot;

    
END
