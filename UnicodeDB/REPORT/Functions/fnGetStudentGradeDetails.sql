CREATE FUNCTION [REPORT].[fnGetStudentGradeDetails]
( 
	@dMarksObtained NUMERIC(8, 2)
)
RETURNS	VARCHAR(2)
AS
BEGIN
	DECLARE @sGrade VARCHAR(2)


	DECLARE @tblGradeMst AS TABLE
        (                        
            FromMarks NUMERIC(8, 2) , 
            ToMarks NUMERIC(8, 2) , 
            Grade VARCHAR(2) 
        ) 
              
              
        INSERT INTO @tblGradeMst 
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 0, 40, 'F' ) 
        INSERT INTO @tblGradeMst 
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 40, 50, 'C' ) 
        INSERT INTO @tblGradeMst 
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 50, 60, 'C+' ) 
        INSERT INTO @tblGradeMst
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 60, 70, 'B' ) 
        INSERT INTO @tblGradeMst
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 70, 80, 'B+' ) 
        INSERT INTO @tblGradeMst
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 80, 90, 'A' ) 
        INSERT INTO @tblGradeMst
                ( FromMarks, ToMarks, Grade ) 
        VALUES ( 90, 101, 'A+' ) 

		SET @sGrade = ( SELECT Grade 
                        FROM @tblGradeMst
                        WHERE CAST(ROUND(@dMarksObtained, 0) AS INT) >= FromMarks 
                                AND CAST(ROUND(@dMarksObtained, 0) AS INT) < ToMarks 
                        ) 
	
	RETURN @sGrade
END