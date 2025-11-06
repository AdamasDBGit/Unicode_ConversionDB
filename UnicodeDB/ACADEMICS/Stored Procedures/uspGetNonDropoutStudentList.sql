CREATE PROCEDURE [ACADEMICS].[uspGetNonDropoutStudentList]
(
      @iCenterID int,
      @sStudentCode varchar(500),
      @sFirstName varchar(50),
      @sMiddleName varchar(50),
      @sLastName varchar(50)

)
AS
BEGIN TRY 

      -- Select non-dropout students
      SELECT S.I_Student_Detail_ID,
               S.S_First_Name,
               S.S_Middle_Name,
               S.S_Last_Name, 
               S.S_Student_ID
      FROM dbo.T_Student_Detail S  WITH (NOLOCK)
      INNER JOIN dbo.T_Student_Center_Detail SCD
      ON S.I_Student_Detail_ID = SCD.I_Student_Detail_ID
    AND GETDATE() >= ISNULL(SCD.Dt_Valid_From, GETDATE())
    AND GETDATE() <= ISNULL(SCD.Dt_Valid_To, GETDATE())
    AND SCD.I_Status = 1
    AND SCD.I_Centre_Id = @iCenterID
      WHERE S.S_Student_ID LIKE ISNULL(@sStudentCode,'') + '%' 
      AND S.S_First_Name LIKE ISNULL(@sFirstName,'') + '%' 

--    AND S.S_Middle_Name LIKE ISNULL(@sMiddleName,'') + '%'
-- by KP on 26-Aug-2006 
-- ID middlename is having NULL Then no data is getting fetched. So, included IsNull function 
      AND ISNULL(S.S_Middle_Name, '') LIKE ISNULL(@sMiddleName,'') + '%'

      AND S.S_Last_Name LIKE ISNULL(@sLastName,'') + '%' 
      AND S.I_Student_Detail_ID NOT IN 
      ( 
            SELECT I_Student_Detail_ID 
      FROM ACADEMICS.T_Dropout_Details 
            WHERE I_Dropout_Status <> 0 ) 


END TRY

BEGIN CATCH
      --Error occurred:  

      DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
      SELECT      @ErrMsg = ERROR_MESSAGE(),
                  @ErrSeverity = ERROR_SEVERITY()

      RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
