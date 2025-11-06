CREATE PROCEDURE [dbo].[uspGetGuardianListByStudentID]  
 (  
 @StudentID nvarchar(50) = null,  
 @ParentID int = null,  
 @BrandID int=null  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT   
 ISNULL(ISNULL(TPM.S_First_Name,'')+' '+ISNULL(TPM.S_Middile_Name,'')+' '+ISNULL(TPM.S_Last_Name,''),'') GuardianName,  
 ISNULL(TPM.S_First_Name,'') FirstName,  
 ISNULL(TPM.S_Middile_Name,'') MiddleName,  
 ISNULL(TPM.S_Last_Name,'')LastName,  
 TPM.S_Guardian_Email Email  
 ,TRM.S_Relation_Type Relation,  
 TSPM.S_Student_ID,  
 TPM.I_Relation_ID as RelationId,  
 ISNULL(TPM.S_Mobile_No,'') MobileNo  
 ,TPM.I_IsPrimary IsPrimary,  
 ISNULL(TPM.I_Parent_Master_ID,'') ParentID,  
 TPM.I_Brand_ID BrandID
 ,TPM.I_IsIncludeinIDCard as IsIncludeinIDCard
 FROM T_Student_Parent_Maps TSPM   
 inner join   
 T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID  
 inner join   
 T_Relation_Master TRM ON TRM.I_Relation_Master_ID = TPM.I_Relation_ID   
 where TSPM.S_Student_ID = @StudentID and TPM.I_Parent_Master_ID = ISNULL(@ParentID,TPM.I_Parent_Master_ID) and TPM.I_Status !=0  
 and TSPM.I_Brand_ID=@BrandID;  
END