CREATE PROCEDURE [dbo].[UpdateSubjectStructure]  
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 05-10-2023
-- Description:	Update Subject Structure table
-- =============================================
-- Add the parameters for the stored procedure here
@SubjectStructureHeaderID int,
@SubjectTemplateHeaderID int =null,
@SubjectID int =null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
SET NOCOUNT ON;
Declare @CH int,@A int
IF @SubjectStructureHeaderID is not null
set @CH=(select I_Subject_Structure_Header_ID from T_ERP_Subject_Structure_Header 
                  where I_Subject_Structure_Header_ID=@SubjectStructureHeaderID)
IF @CH=@SubjectStructureHeaderID
begin

IF @SubjectTemplateHeaderID is not null 
declare @S int
set @S=(select COUNT(I_Subject_Template_Header_ID) 
        from T_ERP_Subject_Template_Header
        where I_Subject_Template_Header_ID=@SubjectTemplateHeaderID);
IF @S!=0
BEGIN 
set @SubjectTemplateHeaderID=@SubjectTemplateHeaderID;
END

else 
set @SubjectTemplateHeaderID=(select I_Subject_Template_Header_ID
                              from T_ERP_Subject_Structure_Header
                              where I_Subject_Structure_Header_ID=@SubjectStructureHeaderID);



IF @SubjectID is not null

declare @T int
set @T =(select COUNT(I_Subject_ID) from T_Subject_Master where I_Subject_ID=@SubjectID);

IF @T!=0
BEGIN 
set @SubjectID=@SubjectID;
END

else
set @SubjectID=( select I_Subject_ID
                              from T_ERP_Subject_Structure_Header
                              where I_Subject_Structure_Header_ID=@SubjectStructureHeaderID);
end

Set @A=(select COUNT(*)
                              from T_ERP_Subject_Structure_Header
                              where Concat(I_Subject_Template_Header_ID,I_Subject_ID)=
							  concat(@SubjectTemplateHeaderID,@SubjectID))
 IF @A=0
 begin
update T_ERP_Subject_Structure_Header set I_Subject_Template_Header_ID=@SubjectTemplateHeaderID,
I_Subject_ID=@SubjectID where I_Subject_Structure_Header_ID=@SubjectStructureHeaderID

if @@rowcount!=0
select 1 Index_no, 'Update Successful' massage
end
 if @@rowcount=0
select 1 Index_no, 'Update UnSuccessful' massage



END
