CREATE PROCEDURE [EXAMINATION].[uspGetQuestion]  
(  
	@iFlag INT = NULL,  
	@iSlNumber INT = NULL,
	@iPoolId INT = NULL 
)  
  
AS  
BEGIN 
	if @iFlag = 2
		begin
			select  rowid = row_number() over (order by I_Question_Id asc)
					,I_Question_Id
					,I_Pool_ID
					,S_Question
					,S_Question_Options
			From EXAMINATION.T_Question_Pool
			where I_Question_Id = @iSlNumber

			select S_Answer_Desc from EXAMINATION.T_Question_Choices
			where I_Question_Id = @iSlNumber

		end
	else
		begin
			declare @i_question_id int

			select * from 
			(
			select  rowid = row_number() over (order by I_Question_Id asc)
					,I_Question_Id
					,I_Pool_ID
					,S_Question
					,S_Question_Options
			From EXAMINATION.T_Question_Pool
			WHERE I_Pool_Id = isnull(@iPoolId,I_Pool_Id) 
			)A
			where A.rowid = @iSlNumber

			select @i_question_id = I_Question_Id from
			(
			select  rowid = row_number() over (order by I_Question_Id asc)
					,I_Question_Id
					,I_Pool_ID
					,S_Question
					,S_Question_Options
			From EXAMINATION.T_Question_Pool
			WHERE I_Pool_Id = isnull(@iPoolId,I_Pool_Id) 
			)A
			where A.rowid = @iSlNumber
			
			select S_Answer_Desc from EXAMINATION.T_Question_Choices
			where I_Question_Id = @i_question_id
		end

END
