
CREATE PROCEDURE [ACADEMICS].[uspInsertIntoStudentStatusArchive]
(
@StudentStatusID INT,
@StudentID INT
)

AS

BEGIN
	INSERT  INTO dbo.T_Student_Status_Details_Archive
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  S_Crtd_By ,
                                  IsEditable
			              )
                                SELECT  I_Student_Detail_ID ,
                                        I_Student_Status_ID ,
                                        I_Status ,
                                        N_Due ,
                                        Dt_Crtd_On ,
                                        S_Crtd_By ,
                                        IsEditable
                                FROM    dbo.T_Student_Status_Details TSSD WITH (NOLOCK)
                                WHERE   I_Student_Detail_ID = @StudentID
                                        AND I_Status = 1
                                        AND I_Student_Status_ID = @StudentStatusID
                                        AND TSSD.IsEditable  IN (1,0)
                                        AND CONVERT(DATE,GETDATE())>CONVERT(DATE,TSSD.Dt_Crtd_On)
END
