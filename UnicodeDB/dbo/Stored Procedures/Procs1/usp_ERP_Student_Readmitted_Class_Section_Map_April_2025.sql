-- =============================================    
-- Author:  <Susmita Paul>    
-- Create date: <2025-Mar-11>    
-- Description: <Mapping the student with Promoted/demoted class>    
-- =============================================    
create PROCEDURE [dbo].[usp_ERP_Student_Readmitted_Class_Section_Map_April_2025]     
 -- Add the parameters for the stored procedure here    
 @iReadmissionRequestID int=null    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    
     
 update T_ERP_Student_Promotion_History_Header set IsPromoted='true'     
 where I_Student_Promotion_History_Header_ID=@iReadmissionRequestID and     
 WillDemoted IS NULL and IsFeeMapped='true'     
    
 update T_ERP_Student_Promotion_History_Header set IsDemoted='true'     
 where I_Student_Promotion_History_Header_ID=@iReadmissionRequestID and     
 WillDemoted=1 and IsFeeMapped='true'    
    
    
 DECLARE @sStudentID varchar(max)=null,@StudentDetailID int,@StudentClassSectionID int=null,@SchoolGroupClassID int=null,@SchoolGroupID int,@BrandID int    
 DECLARE @DestinationAcademicSession int,@DestinationClassID int,@DestinationStreamID int,@DestinationSectionID int,@DestinationRollNo int,@StudentType int    
    
    
 select  top 1     
 @StudentClassSectionID=SCS.I_Student_Class_Section_ID,    
 @sStudentID=SCS.S_Student_ID,    
 @DestinationClassID=SPHH.I_Destination_Class_ID,    
 @DestinationStreamID=SPHH.I_Destination_Stream_ID,    
 @DestinationSectionID=SPHH.I_Destination_SectionID,    
 @DestinationRollNo=SPHH.RollNo,    
 @StudentType=SCS.I_Student_Type_ID,    
 @SchoolGroupID=SPHH.I_Destination_School_Group_ID,    
 @BrandID=SPHH.I_Brand_ID,    
 @StudentDetailID=SPHH.I_Student_DetailID,    
 @DestinationAcademicSession=SPHH.I_Destination_Academic_Session    
 from     
 T_Student_Class_Section as SCS    
 inner join    
 T_School_Group_class as SGC on SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID    
 inner join    
 T_ERP_Student_Promotion_History_Header as SPHH on SCS.I_Student_Detail_ID=SPHH.I_Student_DetailID    
 --and SCS.I_School_Session_ID=SPHH.I_Source_Academic_Session and SCS.I_Section_ID=SPHH.I_Source_SectionID    
 --and SGC.I_Class_ID=SPHH.I_Source_Class_ID     
 where SPHH.I_Student_Promotion_History_Header_ID=@iReadmissionRequestID    
    
    
 select top 1 @SchoolGroupClassID=I_School_Group_Class_ID from T_School_Group_class    
 where I_School_Group_ID=@SchoolGroupID and I_Class_ID=@DestinationClassID    
    
 update T_Student_Class_Section set I_Status=2 where I_Student_Class_Section_ID=@StudentClassSectionID    
    
 insert into T_Student_Class_Section  (  
  
I_Student_Detail_ID  
,S_Student_ID  
,I_Brand_ID  
,I_School_Session_ID  
,I_School_Group_Class_ID  
,I_Section_ID  
,I_Stream_ID  
,I_Student_Type_ID  
,S_Class_Roll_No  
,I_Status  
  
 )  
 select @StudentDetailID,@sStudentID,@BrandID,@DestinationAcademicSession  
 ,@SchoolGroupClassID,@DestinationSectionID  
 ,@DestinationStreamID,@StudentType,@DestinationRollNo,1   
    
     
    
    
    
    
    
    
    
    
END 