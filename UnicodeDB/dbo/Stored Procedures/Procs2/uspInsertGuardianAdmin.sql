/*******************************************************  
Description : Save E-Project Manual  
Author :     Arindam Roy  
Date :   05/22/2007  
*********************************************************/  
  
CREATE PROCEDURE [dbo].[uspInsertGuardianAdmin]   
(  
 @sStudentID nvarchar(200) = null,  
 @sFirstName nvarchar(200)=null,  
 @sMiddleName nvarchar(200)=null,  
 @sLastName nvarchar(200)=null,  
 @sMobile nvarchar(200) = null,  
 @sEmail nvarchar(200) = null,  
 @iRelationshipId int = null,  
 @iIsPrimary int = null,  
 @iBrandID int = null,  
 @iParentMasterID int = null,
 --below field added by Koushik
 @iIsIncludeinIDCard int = null
)  
AS  
begin transaction  
BEGIN TRY   
DECLARE @iParentID int   
DECLARE @iLastParentID int  
DECLARE @iStudentID int
SET @iStudentID = (select top 1 I_Student_Detail_ID from T_Student_Class_Section where S_Student_ID=@sStudentID and I_Brand_ID=@iBrandID and I_Status=1 )
IF EXISTS (select * from T_Student_Detail where S_Student_ID=@sStudentID)  
BEGIN  
IF(@iParentMasterID>0)  
BEGIN  
IF EXISTS  
(select top 1 TSPM.I_Parent_Master_ID from T_Student_Parent_Maps TSPM   
inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID=TSPM.I_Parent_Master_ID  
where   
TPM.I_Relation_ID = @iRelationshipId   
and TPM.I_Relation_ID in (1,2,7)   
and TSPM.S_Student_ID = @sStudentID    
and TPM.I_Parent_Master_ID !=@iParentMasterID  
and TPM.I_Status = 1  
)  
BEGIN  
select 0 StatusFlag,'Same relation already exist' Message  
END  
ELSE  
BEGIN  
IF EXISTS  
(select top 1 TSPM.I_Parent_Master_ID from T_Student_Parent_Maps TSPM   
inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID=TSPM.I_Parent_Master_ID  
where --TPM.I_Relation_ID = @iRelationshipId and  
TSPM.S_Student_ID = @sStudentID AND TPM.S_Mobile_No=@sMobile and TPM.I_Parent_Master_ID !=@iParentMasterID and TPM.I_Status = 1)  
BEGIN  
select 0 StatusFlag,'Mobile number exists' Message  
END  
ELSE  
BEGIN  
update T_Parent_Master  
set   
 I_Parent_Parent_Master_ID  =  @iParentID  
,I_Relation_ID				=  @iRelationshipId  
,I_Brand_ID					=  @iBrandID  
,S_Mobile_No				=  @sMobile  
,S_First_Name				=  @sFirstName  
,S_Middile_Name				=  @sMiddleName  
,S_Last_Name				=  @sLastName  
,S_Guardian_Email			=  @sEmail  
,I_Status					=  1  
,I_IsPrimary				=  @iIsPrimary  
,I_IsIncludeinIDCard		=  @iIsIncludeinIDCard
where I_Parent_Master_ID = @iParentMasterID  
select 1 StatusFlag,'Guardian updated' Message  
END  
END  
END  
ELSE  
BEGIN  
--insert  
IF EXISTS  
(select top 1 TSPM.I_Parent_Master_ID from T_Student_Parent_Maps TSPM   
inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID=TSPM.I_Parent_Master_ID  
where TPM.I_Relation_ID = @iRelationshipId and TPM.I_Relation_ID in (1,2,7) and TSPM.S_Student_ID = @sStudentID and TPM.I_Status = 1)  
BEGIN  
select 0 StatusFlag,'Same relation already exist' Message  
END  
ELSE  
BEGIN  
IF EXISTS  
(select top 1 TSPM.I_Parent_Master_ID from T_Student_Parent_Maps TSPM   
inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID=TSPM.I_Parent_Master_ID  
where TPM.I_Relation_ID = @iRelationshipId and TSPM.S_Student_ID = @sStudentID AND TPM.S_Mobile_No=@sMobile)  
BEGIN  
select 0 StatusFlag,'Mobile number exists' Message  
END  
ELSE  
BEGIN  
SET @iParentID =(select top 1 TPM.I_Parent_Master_ID from T_Student_Parent_Maps TSPM inner join T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID  
where TSPM.S_Student_ID =@sStudentID AND TPM.I_Relation_ID in (1,2))  
INSERT INTO T_Parent_Master  
(  
 I_Parent_Parent_Master_ID  
,I_Relation_ID  
,I_Brand_ID  
,S_Mobile_No  
,S_First_Name  
,S_Middile_Name  
,S_Last_Name  
,S_Guardian_Email  
,I_Status  
,I_IsPrimary 
,Dt_CreatedAt
,I_IsIncludeinIDCard
)  
VALUES  
(  
 @iParentID  
,@iRelationshipId  
,@iBrandID  
,@sMobile  
,@sFirstName  
,@sMiddleName  
,@sLastName  
,@sEmail  
,1  
,@iIsPrimary  
,GETDATE()
,@iIsIncludeinIDCard
)  
set @iLastParentID  = SCOPE_IDENTITY()  
INSERT INTO T_Student_Parent_Maps  
(  
I_Brand_ID  
,S_Student_ID  
,I_Student_Detail_ID
,I_Parent_Master_ID  
,I_Status  
,Dt_CreatedAt
)  
VALUES  
(  
@iBrandID  
,@sStudentID 
,@iStudentID
,@iLastParentID  
,1  
,GETDATE()
)  
select 1 StatusFlag,'Guardian added' Message  
END  
END  
  
END  
END  
ELSE  
BEGIN  
select 0 StatusFlag,'Invalid StudentID' Message  
END  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  
commit transaction  