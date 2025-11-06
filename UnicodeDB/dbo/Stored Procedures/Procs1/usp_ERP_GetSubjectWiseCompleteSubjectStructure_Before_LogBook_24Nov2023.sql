

-- =============================================
-- Author:		<susmita Paul>
-- Create date: <2023-Oct-05>
-- Description:	<Get Log Book Details>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectWiseCompleteSubjectStructure_Before_LogBook_24Nov2023]
	-- Add the parameters for the stored procedure here
	(
	@iBrandID INT,
	@iSubject INT=NULL
	)
AS
BEGIN TRY

SET NOCOUNT ON;

begin transaction


			Create Table #SubjectLeafNode
			(
			ClassID int,
			ClassName varchar(max),
			SubjectID int,
			SubjectName varchar(max),
			LeafSubjectStructureID int,
			LeafSubjectLevel varchar(max),
			LeafSubjectLevelDesc varchar(max),
			Methodology varchar(max),
			Objectives varchar(max)
			)

				insert into #SubjectLeafNode
				select 
				TC.I_Class_ID as ClassID
				,TC.S_Class_Name as ClassName
				,SM.I_Subject_ID as SubjectID
				,SM.S_Subject_Name as SubjectName
				,SS.I_Subject_Structure_ID as LeafSubjectStructureID
				,EST.S_Structure_Name as LeafSubjectLevel
				,SS.S_Name as LeafSubjectLevelDesc
				,SS.Methodology as Methodology
				,SS.Objective as Objectives
				from 
				T_Subject_Master as SM 
				inner join
				T_Class as TC on TC.I_Class_ID=SM.I_Class_ID and TC.I_Status=1
				inner join
				T_School_Group as SG on SG.I_School_Group_ID=SM.I_School_Group_ID and SG.I_Status=1
				inner join
				T_ERP_Subject_Structure_Header as SSH on SSH.I_Subject_ID=SM.I_Subject_ID
				inner join
				T_ERP_Subject_Structure as SS on SS.I_Subject_Structure_Header_ID=SSH.I_Subject_Structure_Header_ID
				inner join
				T_ERP_Subject_Template as EST on EST.I_Subject_Template_ID=SS.I_Subject_Template_ID
				inner join
				T_ERP_Subject_Template_Header as ESTH on ESTH.I_Subject_Template_Header_ID=EST.I_Subject_Template_Header_ID
				where SM.I_Brand_ID=@iBrandID
				and SM.I_Subject_ID=@iSubject
				and EST.I_IsLeaf_Node=1
				


				Declare  @CourseStructure Table
				(
				ID int identity,
				LeafSubjectStructureID INT,
				SubjectStructureID INT,
				SubjectStructureLabel varchar(max),
				SubjectStructureName varchar(max),
				SubjectStructureSequenceNo INT,
				Methodology varchar(max),
				Objectives varchar(max)
				)



				DECLARE 
				@LeafSubjectStructureID int,
				@CurrentSubjectStructureID int,
				@SequenceNo int=0,
				@SubjectStructureID INT,
				@SubjectStructureLabel varchar(max),
				@SubjectStructureName varchar(max),
				@ParentSubjectStructureID INT,
				@Methodology varchar(max),
				@Objectives varchar(max)

			DECLARE cursor_log CURSOR
			FOR SELECT 
					LeafSubjectStructureID
				FROM 
					#SubjectLeafNode;

			OPEN cursor_log;

			FETCH NEXT FROM cursor_log INTO 
			   @LeafSubjectStructureID

			WHILE @@FETCH_STATUS = 0
				BEGIN
					--PRINT @LeafSubjectStructureID;

					set @CurrentSubjectStructureID=@LeafSubjectStructureID

		
					while (ISNULL(@CurrentSubjectStructureID,0) > 0)

						BEGIN

						PRINT @CurrentSubjectStructureID

						select @SequenceNo=EST.I_Sequence_Number,@SubjectStructureID=ESS.I_Subject_Structure_ID,
						@SubjectStructureLabel=EST.S_Structure_Name,@SubjectStructureName=ESS.S_Name,
						@ParentSubjectStructureID=ESS.I_Parent_Subject_Structure_ID
						,@Methodology=ESS.Methodology,@Objectives=ESS.Objective
						from T_ERP_Subject_Structure as ESS
						inner join
						T_ERP_Subject_Template as EST on EST.I_Subject_Template_ID=ESS.I_Subject_Template_ID
						where ESS.I_Subject_Structure_ID=@CurrentSubjectStructureID

						--PRINT '77' 
						PRINT @ParentSubjectStructureID

						insert into @CourseStructure 
						(
						LeafSubjectStructureID,
						SubjectStructureID,
						SubjectStructureLabel,
						SubjectStructureName,
						SubjectStructureSequenceNo,
						Methodology,
						Objectives
						)
						values
						(
						@LeafSubjectStructureID,
						@SubjectStructureID,
						@SubjectStructureLabel,
						@SubjectStructureName,
						@SequenceNo,
						@Methodology,
						@Objectives
						)
		
						SET @CurrentSubjectStructureID= @ParentSubjectStructureID

						END

					FETCH NEXT FROM cursor_log INTO 
						@LeafSubjectStructureID

						; 
            
				END;

			CLOSE cursor_log;

			DEALLOCATE cursor_log;


			select DISTINCT
			ClassID,
			ClassName,
			SubjectID,
			SubjectName,
			LeafSubjectStructureID,
			LeafSubjectLevel,
			LeafSubjectLevelDesc,
			Methodology,
			Objectives
			from #SubjectLeafNode

			select 

   			LeafSubjectStructureID,
			SubjectStructureID,
			SubjectStructureLabel,
			SubjectStructureName,
			SubjectStructureSequenceNo,
			Methodology,
			Objectives

			from @CourseStructure





	commit transaction

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
