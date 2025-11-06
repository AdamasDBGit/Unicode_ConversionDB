-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
      
--exec [dbo].[uspGetExamComponent] NULL,107      
CREATE PROCEDURE [dbo].[uspGetExamComponent]       
 -- Add the parameters for the stored procedure here      
 (      
   @iBatchID INT= null,       
   @iBrandID int      
 )      
 AS      
BEGIN      
 Select  DISTINCT     
 TECM.I_Exam_Component_ID,      
 TECM.S_Component_Name,        
 ETM.S_Exam_Type_Name      
 FROM       
    T_Exam_Component_Master TECM       
    LEFT OUTER JOIN T_Exam_Type_Master ETM       
    on TECM.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID      
 and TECM.I_Status = 1       
 Inner join EXAMINATION.T_Batch_Exam_Map ETBEM      
 ON TECM .I_Exam_Component_ID=ETBEM.I_Exam_Component_ID      
 Inner join T_Student_Batch_Master TSBM      
 On ETBEM.I_Batch_ID=TSBM.I_Batch_ID      
 INNER JOIN T_Course_master TCM      
 ON TSBM.I_Course_ID = TCM.I_Course_ID      
 INNER JOIN T_Brand_Master TBM      
 ON TECM.I_Brand_ID=TBM.I_Brand_ID      
 where         
 TBM.I_Brand_ID=@iBrandID      
 AND      
TSBM.I_Batch_ID=  ISNULL(@iBatchID,TSBM.I_Batch_ID)--akash    
           
END
