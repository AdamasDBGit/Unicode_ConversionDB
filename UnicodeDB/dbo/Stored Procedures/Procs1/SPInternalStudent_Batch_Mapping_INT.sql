CREATE  Proc [dbo].[SPInternalStudent_Batch_Mapping_INT]
As
begin

select 
     
      SD.I_Student_Detail_ID,
	  SBD.I_Batch_ID 
	  FROM [T_Student_Detail] SD
LEFT JOIN [T_Student_Batch_Details] SBD 
ON SD.I_Student_Detail_ID=SBD.I_Student_ID


end
