CREATE PROCEDURE [dbo].[uspSaveCourseBridgeMapping]
(
@iBridgeID INT,
@iPreviousCourseID INT,
@iNextCourseID INT,
@sCreatedBy VARCHAR(50)=NULL,
@dtCreatedOn DATETIME = NULL
)
AS
BEGIN TRY
	
INSERT INTO [T_Bridge_Course_Mapping] 
(
	[I_Bridge_ID],
	[I_Prev_Course_ID],
	[I_Next_Course_ID],
	[I_Status],
	[S_Crtd_By],
	[S_Upd_By],
	[Dt_Crtd_On],
	[Dt_Upd_On]
) 
VALUES 
( 
	@iBridgeID,
	@iPreviousCourseID ,
	@iNextCourseID,
	1,
	@sCreatedBy,
	NULL,
	@dtCreatedOn,
	NULL
) 	
END TRY


BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH 

--------------------------------------------------------------------------------------------------------------------------------------
