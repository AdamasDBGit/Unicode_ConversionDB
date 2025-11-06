
CREATE PROCEDURE [dbo].[KPMG_uspInsertProjection]
(
@Month INT,
@Year INT,
@projection int,
@bufferstock int,
@branchid int,
@course_Id int = 0
)
AS   
DECLARE @idmaster INT

    BEGIN TRY 
        
        IF EXISTS(SELECT 1 FROM Tbl_KPMG_Projection WHERE Fld_KPMG_Branch_Id = @branchid AND Fld_KPMG_Course_Id = @course_Id AND Fld_KPMG_Month = @Month AND Fld_KPMG_Year = @Year)
        BEGIN
			DELETE FROM Tbl_KPMG_Projection WHERE Fld_KPMG_Branch_Id = @branchid AND Fld_KPMG_Course_Id = @course_Id AND Fld_KPMG_Month = @Month AND Fld_KPMG_Year = @Year
        END
		Insert into dbo.Tbl_KPMG_Projection (Fld_KPMG_Month,Fld_KPMG_Year,Fld_KPMG_Projection,Fld_KPMG_BufferStock,Fld_KPMG_Branch_Id,Fld_KPMG_Course_Id) 
		values (@Month,@Year,@projection,@bufferstock,@branchid,@course_Id)
		Select 1   as Result             
        
    END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

