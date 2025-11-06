CREATE PROCEDURE [dbo].[AddSubjectAndStructure] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 03-10-2023
-- Description:	To Map Subject & Structure
-- =============================================
-- Add the parameters for the stored procedure here
@SubjectTemplateHeaderID int,
@SubjectID int,
@CreatedBy int


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	declare @SH int, @S int,@A int
	set @SH=(select DISTINCT count(*) from T_ERP_Subject_Template_Header 
	                   where I_Subject_Template_Header_ID=@SubjectTemplateHeaderID);
    set @S=(Select  DISTINCT count(*) from T_Subject_Master where I_Subject_ID=@SubjectID);
	set @A=(select DISTINCT COUNT(*)
	         --CONCAT( I_Subject_Template_Header_ID,I_Subject_ID) 
	        From T_ERP_Subject_Structure_Header 
	        where CONCAT( I_Subject_Template_Header_ID,I_Subject_ID) 
			=CONCAT(@SubjectTemplateHeaderID,@SubjectID) );
 
	if @SH>0 and @S>0
	IF @A<=0


	---CONCAT(@SubjectTemplateHeaderID,@SubjectID)
	insert into T_ERP_Subject_Structure_Header
	            (I_Subject_Template_Header_ID,I_Subject_ID,I_CreatedBy,Dt_CreatedAt)
				values (@SubjectTemplateHeaderID,@SubjectID,@CreatedBy,SYSDATETIME())
      
	  IF @@ROWCOUNT!=0
	  Select 1 Index_no,'Data Inserted Successfully' Message;
      IF @A>0
      BEGIN
       Select 1 Index_no,'Data Already Mapped' Message;
      END   
      
	  IF @SH=0
      BEGIN 
       Select 1 Index_no,'Subject Template not Valid' Message;
      END
    
	  IF @S=0
      BEGIN
       Select 1 Index_no,'Subject not Valid' Message;
      END
   

END
