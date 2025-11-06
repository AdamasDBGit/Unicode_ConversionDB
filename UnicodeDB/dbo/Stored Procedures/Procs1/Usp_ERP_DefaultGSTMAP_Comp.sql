--EXEC Usp_ERP_DefaultGSTMAP_Comp 1149,107
CREATE Proc [dbo].[Usp_ERP_DefaultGSTMAP_Comp](
@feeCompId int,
@brandID int,
@Type int
)
As
Begin
Declare @FeecompName Varchar(100)
--SET @feeCompId=1149
--SET @brandID=107
SET @FeecompName=(select Top 1 S_Component_Name from T_Fee_Component_Master 
where I_Fee_Component_ID=@feeCompId and I_Brand_ID=@brandID )
Declare @GSTCategoryType varchar(255),@GSTCATID int
SET @GSTCategoryType= (select CONCAT('Default_ZERO','_',@FeecompName))
If Not Exists(select 1 from T_ERP_GST_Item_Category where I_Fee_Component_ID=@feeCompId
and Is_Active=1)
Begin
Insert Into T_ERP_GST_Item_Category(

 S_GST_FeeComponent_Category_Type
,I_Fee_Component_ID
,S_GST_FeeComponent_Description
,Is_Active
,I_Created_By
,Dt_Created_At
,I_Brand_Id
, [Type]
)
Values(
@GSTCategoryType,
@feeCompId,
@GSTCategoryType,
1,
1,
GETDATE(),
@brandID,
@Type
)
SET @GSTCATID =SCOPE_IDENTITY()

Insert Into T_ERP_GST_Configuration_Details(

 I_GST_FeeComponent_Catagory_ID
,N_Start_Amount
,N_End_Amount
,N_SGST
,N_CGST
,N_IGST
,Is_Active
)
values
(
@GSTCATID,0,2000000000,0,0,0,1
)
IF(@Type=1)
BEGIN
Insert into T_Tax_Country_Fee_Component      
      (I_Tax_ID, I_Country_ID, I_Fee_Component_ID, N_Tax_Rate, Dt_Valid_From, Dt_Valid_To, I_Status, S_Crtd_By, Dt_Crtd_On)      
      
      select I_Tax_ID,      
       1,      
       @FeeCompID,      
       0,      
       '2000-01-01',      
       '2050-01-01',      
       1,      
       1,      
       GETDATE()  from T_Tax_Master where S_Tax_Code in ('CGST', 'SGST', 'IGST')  
END
 
End
Else
Begin
SET @GSTCATID=(
select  top 1 I_GST_FeeComponent_Catagory_ID from T_ERP_GST_Item_Category 
where I_Fee_Component_ID=@feeCompId
and Is_Active=1
)
End
--Select @GSTCATID,@feeCompId
End