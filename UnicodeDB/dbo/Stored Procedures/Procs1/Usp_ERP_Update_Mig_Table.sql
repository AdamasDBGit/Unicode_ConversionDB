CREATE Proc [dbo].[Usp_ERP_Update_Mig_Table](@id int )
As
Begin
Update Mig_Admission set Is_FullProcessed=1 where ID =@id
End
