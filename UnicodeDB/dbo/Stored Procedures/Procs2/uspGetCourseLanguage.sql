
CREATE PROCEDURE [dbo].[uspGetCourseLanguage]    
(    
@iCourseId int
)    
AS    
    
BEGIN    
     
SELECT ISNULL(C.I_Language_ID,0) as I_Language_ID FROM dbo.T_Course_Master as C
WHERE C.I_Course_ID= @iCourseId
     
END
