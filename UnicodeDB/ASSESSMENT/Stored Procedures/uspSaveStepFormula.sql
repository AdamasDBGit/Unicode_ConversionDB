CREATE PROCEDURE [ASSESSMENT].[uspSaveStepFormula]            
(          
 @iRuleID int,          
 @iStepID1 INT = NULL,          
 @sStepName1 varchar(50) = NULL,          
 @iStepID2 INT,          
 @sStepName2 varchar(50) = NULL,          
 @sOperator VARCHAR(5),          
 @sOperator1 VARCHAR(5) = NULL,          
 @sLinkName varchar(20),          
 @slinkName1 VARCHAR(20) = NULL,          
 @LinkId INT =  NULL  ,        
 @sSCrtdBy VARCHAR(20),        
 @DtCrtdOn DATETIME          
)          
AS           
BEGIN          
 UPDATE ASSESSMENT.T_Rule_Step_Evaluation SET B_Is_LastNode = 0 WHERE I_Rule_ID = @iRuleID          
 DECLARE @iLinkID1 INT,@iLinkID2 INT          
 IF(@LinkId IS NULL)          
  BEGIN          
   SELECT @iLinkID1 = I_Link_ID FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Operand_ID1 = @iStepID1 AND S_Operator_Name IS NULL  AND I_Status = 1      
   SELECT @iLinkID2 = I_Link_ID FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Operand_ID2 = @iStepID2 AND S_Operator_Name IS NULL  AND I_Status = 1      
             
   IF(@iLinkID1 IS NULL)          
    BEGIN          
     INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
       ( I_Rule_ID ,          
         I_Operand_ID1,          
         S_Operand_Name1,          
         S_Link_Name  ,        
         I_Status ,        
         S_Crtd_By   ,        
         Dt_Crtd_On            
       )          
     VALUES  ( @iRuleID , -- I_Rule_ID - int          
         @iStepID1,  -- I_Operand_ID1 - int          
         @sStepName1,          
         @sStepName1 ,        
         1 ,        
         @sSCrtdBy ,        
         @DtCrtdOn          
       )          
     SELECT @iLinkID1 = @@IDENTITY          
    END          
   IF(@iLinkID2 IS NULL)          
    BEGIN          
     INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
       ( I_Rule_ID ,          
         I_Operand_ID1,          
         S_Operand_Name1,          
         S_Link_Name ,          
         I_Status ,        
         S_Crtd_By   ,        
         Dt_Crtd_On                   
       )          
     VALUES  (         
         @iRuleID , -- I_Rule_ID - int          
         @iStepID2,  -- I_Operand_ID1 - int          
         @sStepName2,          
         @sStepName2  ,        
         1 ,        
         @sSCrtdBy ,        
         @DtCrtdOn           
       )          
     SELECT @iLinkID2 = @@IDENTITY          
    END          
   INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
     ( S_Link_Name ,          
       I_Rule_ID ,          
       I_Operand_ID1 ,          
       S_Operand_Name1,          
       I_Operand_ID2 ,          
       S_Operand_Name2,          
       S_Operator_Name ,          
       B_Is_LastNode  ,        
       I_Status ,        
       S_Crtd_By   ,        
       Dt_Crtd_On                
     )          
   VALUES  ( @sLinkName , -- S_Link_Name - varchar(50)          
       @iRuleID , -- I_Rule_ID - int          
       @iLinkID1 , -- I_Operand_ID1 - int          
       @sStepName1,          
       @iLinkID2 , -- I_Operand_ID2 - int          
       @sStepName2,          
       @sOperator , -- S_Operator_Name - varchar(10)          
       1    ,  -- B_Is_LastNode - bit          
       1 ,        
       @sSCrtdBy ,        
       @DtCrtdOn           
     )          
  END          
 ELSE          
  BEGIN          
   IF(@iStepID1 IS NULL)          
     BEGIN          
      SELECT @iLinkID1 = @LinkId          
      SELECT @sStepName1 = S_Link_Name FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Link_ID = @LinkId AND I_Status = 1   
      SELECT @iLinkID2 = I_Link_ID FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Operand_ID2 = @iStepID2 AND S_Operator_Name IS NULL AND I_Status = 1          
      IF(@iLinkID2 IS NULL)          
       BEGIN          
        INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
          ( I_Rule_ID ,          
            I_Operand_ID1,          
            S_Operand_Name1,          
            S_Link_Name ,          
      I_Status,        
      S_Crtd_By,        
      Dt_Crtd_On                      
          )       
        VALUES  ( @iRuleID , -- I_Rule_ID - int          
            @iStepID2,  -- I_Operand_ID1 - int          
            @sStepName2,          
            @sStepName2  ,        
            1 ,        
   @sSCrtdBy ,        
   @DtCrtdOn          
          )          
        SELECT @iLinkID2 = @@IDENTITY          
        INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
          ( S_Link_Name ,          
            I_Rule_ID ,          
            I_Operand_ID1 ,          
            S_Operand_Name1,          
            I_Operand_ID2 ,          
            S_Operand_Name2,          
            S_Operator_Name ,          
            B_Is_LastNode  ,        
            I_Status ,        
   S_Crtd_By   ,        
   Dt_Crtd_On              
          )          
        VALUES  ( @sLinkName , -- S_Link_Name - varchar(50)          
            @iRuleID , -- I_Rule_ID - int          
            @iLinkID1 , -- I_Operand_ID1 - int          
   @sStepName1,          
            @iLinkID2 , -- I_Operand_ID2 - int          
            @sStepName2,          
            @sOperator , -- S_Operator_Name - varchar(10)          
            1  ,    -- B_Is_LastNode - bit          
            1 ,        
   @sSCrtdBy ,        
   @DtCrtdOn          
          )          
       END            
     END          
    ELSE          
     BEGIN          
      SELECT @iLinkID1 = I_Link_ID FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Operand_ID1 = @iStepID1  AND S_Operator_Name IS NULL  AND I_Status = 1      
      SELECT @iLinkID2 = I_Link_ID FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Operand_ID2 = @iStepID2  AND S_Operator_Name IS NULL  AND I_Status = 1      
                
      IF(@iLinkID1 IS NULL)          
       BEGIN          
        INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
          ( I_Rule_ID ,          
            I_Operand_ID1,          
            S_Operand_Name1,          
            S_Link_Name   ,        
            I_Status ,        
   S_Crtd_By   ,        
   Dt_Crtd_On                      
          )          
        VALUES  ( @iRuleID , -- I_Rule_ID - int          
            @iStepID1,  -- I_Operand_ID1 - int          
            @sStepName1,          
            @sStepName1  ,        
            1 ,        
   @sSCrtdBy ,        
   @DtCrtdOn          
          )          
        SELECT @iLinkID1 = @@IDENTITY          
       END          
      IF(@iLinkID2 IS NULL)          
       BEGIN          
        INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
          ( I_Rule_ID ,          
            I_Operand_ID1,          
            S_Operand_Name1,          
            S_Link_Name   ,        
            I_Status ,        
   S_Crtd_By   ,        
   Dt_Crtd_On                   
                            
          )          
        VALUES  ( @iRuleID , -- I_Rule_ID - int          
            @iStepID2,  -- I_Operand_ID1 - int          
            @sStepName2,          
            @sStepName2  ,        
            1 ,        
   @sSCrtdBy ,        
   @DtCrtdOn          
          )          
        SELECT @iLinkID2 = @@IDENTITY          
       END          
      INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
        ( S_Link_Name ,          
          I_Rule_ID ,          
          I_Operand_ID1 ,          
          S_Operand_Name1,          
          I_Operand_ID2 ,          
          S_Operand_Name2,          
          S_Operator_Name ,          
          B_Is_LastNode  ,        
          I_Status ,        
    S_Crtd_By   ,        
    Dt_Crtd_On            
        )          
      VALUES  ( @sLinkName , -- S_Link_Name - varchar(50)          
          @iRuleID , -- I_Rule_ID - int          
          @iLinkID1 , -- I_Operand_ID1 - int          
          @sStepName1,          
          @iLinkID2 , -- I_Operand_ID2 - int          
          @sStepName2,          
          @sOperator , -- S_Operator_Name - varchar(10)          
          0      ,-- B_Is_LastNode - bit          
          1 ,        
    @sSCrtdBy ,        
          @DtCrtdOn    
        )          
      SELECT @iLinkID1 = @LinkId          
                
      DECLARE @sJoinLink VARCHAR(20)          
      SELECT @sJoinLink = S_Link_Name FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Link_ID = @iLinkID1 AND I_Status = 1         
                
      SELECT @iLinkID2 = @@IDENTITY          
      INSERT INTO ASSESSMENT.T_Rule_Step_Evaluation          
        ( S_Link_Name ,          
          I_Rule_ID ,          
          I_Operand_ID1 ,          
          S_Operand_Name1,          
          I_Operand_ID2 ,          
          S_Operand_Name2,          
          S_Operator_Name ,          
          B_Is_LastNode  ,        
          I_Status ,        
    S_Crtd_By   ,        
    Dt_Crtd_On            
        )          
      VALUES  ( @slinkName1 , -- S_Link_Name - varchar(50)          
          @iRuleID , -- I_Rule_ID - int          
          @iLinkID1 , -- I_Operand_ID1 - int          
          @sJoinLink,          
          @iLinkID2 , -- I_Operand_ID2 - int          
          @sLinkName,          
          @sOperator1 , -- S_Operator_Name - varchar(10)          
          1    ,            -- B_Is_LastNode - bit          
          1 ,        
    @sSCrtdBy ,        
    @DtCrtdOn          
        )          
     END          
         
  END          
             
  SELECT @@IDENTITY          
END
