CREATE PROCEDURE [dbo].[usp_ERP_Get_Discounted_Revised_Installments]  
 -- Add the parameters for the stored procedure here  
 @iDiscountSchemeID int,  
 @iBrandID int,  
 @iERPFeeStructure int,  
 --@InstallmentComponentDetails UT_Installments_Component_Details_For_Discount readonly  
 @InstallmentComponentDetails UT_Installments_Component_Details  readonly  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
 Create table #EligibleComponentDetails  
 (  
 ID int IDENTITY(1,1),  
 FeeComponentID int,  
 InstallmentNo int,  
 DtInstallmentDate datetime,  
 ActualBaseAmount decimal(8,2),  
 ActualSGST decimal(8,2),  
 ActualCGST decimal(8,2),  
 ActualIGST decimal(8,2),  
 DiscountedBaseAmount decimal(8,2),  
 DiscountedSGST decimal(8,2),  
 DiscountedCGST decimal(8,2),  
 DiscountedIGST decimal(8,2),  
 DiscountedRate int,  
 DiscountedAmount int  
 )  
  
 Create table #DiscountDetails  
 (  
 ID INT IDENTITY(1,1),  
 FeeComponentID int,  
 IsfromStart bit,  
 IsfromEnd bit,  
 NoInstallment int,  
 Rate int,  
 Amount int  
 )  
  
 Create table #DiscountInstallmentSchedule  
 (  
 ID INT IDENTITY(1,1),  
 FeeComponentID int,  
 InstallmentNo int,  
 Rate int,  
 Amount int   
 )  
  
  
 INSERT INTO #DiscountDetails  
SELECT   
DSD.I_FeeComponentID AS FeeComponentID,  
 CASE WHEN DSD.I_FromInstalment = 0 THEN 1 ELSE 0 END AS IsfromStart,  
 CASE WHEN DSD.I_FromInstalment = -1 THEN 1 ELSE 0 END AS IsfromEnd,  
 DSD.I_NoofInstallments,  
 DSD.N_Discount_Rate,  
 DSD.N_Discount_Amount  
FROM T_Discount_Scheme_Master AS DSM  
--INNER JOIN T_Discount_Brand_Map AS DBM   
-- ON DSM.I_Discount_Scheme_ID = DBM.I_Discount_Scheme_ID  
--INNER JOIN T_Discount_Scheme_Details AS DSD  
INNER JOIN T_ERP_Discount_Scheme_Details as DSD ON DSM.I_Discount_Scheme_ID = DSD.I_Discount_Scheme_ID 
WHERE   
 DSM.I_Discount_Scheme_ID = @iDiscountSchemeID  
 AND DSM.I_Brand_ID = @iBrandID  
 AND DSD.I_Status_ID = 1   
 AND DSM.I_Status = 1   
  
  
 print '#DiscountDetails done'  
   
-- select * from #DiscountDetails  
   
 insert into #EligibleComponentDetails  
 select distinct   
 ICD.I_Component_ID,  
 ICD.I_InstallmentNo,  
 ICD.Dt_Installment_Date,  
 ICD.BaseAmount,  
 ICD.CGST,  
 ICD.SGST,  
 ICD.IGST,  
 NULL,  
 NULL,  
 NULL,  
 NULL,  
 NULL,  
 NULL  
 from  
 @InstallmentComponentDetails as ICD  
 inner join  
 #DiscountDetails as DD on ICD.I_Component_ID=DD.FeeComponentID  
  OPTION (RECOMPILE);
 print '#DiscountDetails done'  
 --select * from #EligibleComponentDetails  
  
  
 declare @maxID int =0,@ID int =1;  
  
 set @maxID = (select max(ID) from #DiscountDetails)  
  
 declare @ComponentID int=0;  
 declare @noOfInstallment int=0;  
 declare @DiscountRate int=null;  
 declare @DiscountAmount int=null;  
 DECLARE @EligibleCount int=0;  
 DECLARE @CompoName nvarchar(max)=NULL;  
  
 while(@ID <= @maxID )  
 begin  
  
  set @ComponentID = (select FeeComponentID from #DiscountDetails where ID=@ID)  
  set @noOfInstallment = (select NoInstallment from #DiscountDetails where ID=@ID)  
  set @DiscountRate= (select Rate from #DiscountDetails where ID=@ID)  
  set @DiscountAmount= (select Amount from #DiscountDetails where ID=@ID)  
      
  
  --select *  from #DiscountDetails where ID=@ID  
  
   -- select @DiscountRate  
  
  if ((select ISNULL(IsfromEnd,0) from #DiscountDetails where ID=@ID) = 0)  
  AND ((select ISNULL(IsfromStart,0) from #DiscountDetails where ID=@ID) = 0)  
  BEGIN  
  
   if exists (  
   select * from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment)  
   BEGIN  
  
    if exists (  
     select * from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL)  
      BEGIN  
  
      insert into #DiscountInstallmentSchedule  
      select   
      FeeComponentID,  
      InstallmentNo,  
      @DiscountRate,  
      @DiscountAmount  
      from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL   
        
      print '##DiscountInstallmentSchedule done'  
      print  'for feecomponent'  
      print @ComponentID  
      IF ISNULL(@DiscountRate,0) > 0  
      begin  
       update  #EligibleComponentDetails set DiscountedBaseAmount = (-1)*(ActualBaseAmount * (@DiscountRate / 100.0))  
       ,DiscountedCGST = (-1)*(ActualCGST * (@DiscountRate / 100.0))  
       ,DiscountedSGST = (-1)*(ActualSGST * (@DiscountRate / 100.0))  
       ,DiscountedIGST = (-1)*(ActualIGST * (@DiscountRate / 100.0))  
       ,DiscountedRate=@DiscountRate  
       ,DiscountedAmount=@DiscountAmount  
       where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL   
      end   
  
  
     END  
  
      ELSE  
  
      BEGIN  
       RAISERROR('Invalid Discount For this Fee Structure:Double Discount For Single Component Not Valid', 16, 1)  
       RETURN  
  
       --select 0 as flag , 'Discount already provided' as msg  
  
      END  
   END  
   else   
   BEGIN  
     set @CompoName=(select top 1 S_Component_Name  from T_Fee_Component_Master where I_Fee_Component_ID=@ComponentID);  
     RAISERROR('Invalid Discount For this Fee Structure :%d Installment not exists for %s Component ', 16, 1,@noOfInstallment,@CompoName)  
     RETURN  
  
   END  
  
  
  END  
  
  if ((select ISNULL(IsfromStart,0) from #DiscountDetails where ID=@ID) = 1)  
  BEGIN  
     ;WITH OrderedInstallments AS (  
     SELECT TOP (@noOfInstallment) *  
     FROM #EligibleComponentDetails  
     WHERE FeeComponentID = @ComponentID  
     ORDER BY InstallmentNo  
    )  
  
      
    -- Step 2: Count eligible installments  
    SELECT @EligibleCount = COUNT(*) FROM OrderedInstallments  
  
    -- Step 3: Error if not enough installments exist  
    IF (@EligibleCount < @noOfInstallment)  
    BEGIN  
         set @CompoName=(select top 1 S_Component_Name  from T_Fee_Component_Master where I_Fee_Component_ID=@ComponentID);  
  
     RAISERROR('Only %d eligible installments found for component %s. Required: %d.', 16, 1, @EligibleCount, @CompoName, @noOfInstallment)  
     RETURN  
    END  
      
      
  
    -- Step 4: Check if any in the range already have a discount applied  
    IF EXISTS (  
     SELECT 1   
     FROM (  
      SELECT TOP (@noOfInstallment) *  
      FROM #EligibleComponentDetails  
      WHERE FeeComponentID = @ComponentID  
      ORDER BY InstallmentNo  
     ) AS CheckRange  
     WHERE DiscountedBaseAmount IS NOT NULL  
    )  
    BEGIN  
     set @CompoName=(select top 1 S_Component_Name  from T_Fee_Component_Master where I_Fee_Component_ID=@ComponentID);  
  
     RAISERROR('Discount already applied in eligible range for component %s.', 16, 1, @CompoName)  
     RETURN  
    END  
    -- Step 5: Insert the eligible installments into DiscountInstallmentSchedule  
     INSERT INTO #DiscountInstallmentSchedule (FeeComponentID, InstallmentNo, Rate, Amount)  
     SELECT   
      FeeComponentID,  
      InstallmentNo,  
      @DiscountRate,  
      @DiscountAmount  
     FROM (  
      SELECT TOP (@noOfInstallment) *  
      FROM #EligibleComponentDetails  
      WHERE FeeComponentID = @ComponentID  
      ORDER BY InstallmentNo  
     ) AS FinalRange  
  
     IF ISNULL(@DiscountRate, 0) > 0  
      BEGIN  
       UPDATE E  
       SET E.DiscountedBaseAmount =(-1)*(E.ActualBaseAmount * (@DiscountRate / 100.0))  
       ,E.DiscountedCGST = (-1)*(E.ActualCGST * (@DiscountRate / 100.0))  
       ,E.DiscountedSGST = (-1)*(E.ActualSGST * (@DiscountRate / 100.0))  
       ,E.DiscountedIGST = (-1)*(E.ActualIGST * (@DiscountRate / 100.0))  
       ,E.DiscountedRate=@DiscountRate  
       ,E.DiscountedAmount=@DiscountAmount  
       FROM #EligibleComponentDetails E  
       INNER JOIN #DiscountInstallmentSchedule DIS  
        ON E.FeeComponentID = DIS.FeeComponentID  
        AND E.InstallmentNo = DIS.InstallmentNo  
       WHERE E.DiscountedBaseAmount IS NULL  
      END  
  
  
  
  END  
  
  
  if ((select ISNULL(IsfromEnd,0) from #DiscountDetails where ID=@ID) = 1)  
  BEGIN  
     ;WITH OrderedInstallments AS (  
     SELECT TOP (@noOfInstallment) *  
     FROM #EligibleComponentDetails  
     WHERE FeeComponentID = @ComponentID  
     ORDER BY InstallmentNo desc  
    )  
  
      
    -- Step 2: Count eligible installments  
    SELECT @EligibleCount = COUNT(*) FROM OrderedInstallments  
  
    -- Step 3: Error if not enough installments exist  
    IF (@EligibleCount < @noOfInstallment)  
    BEGIN  
     set @CompoName=(select top 1 S_Component_Name  from T_Fee_Component_Master where I_Fee_Component_ID=@ComponentID);  
  
     RAISERROR('Only %d eligible installments found for component %s. Required: %d.', 16, 1, @EligibleCount, @CompoName, @noOfInstallment)  
     RETURN  
    END  
      
      
  
    -- Step 4: Check if any in the range already have a discount applied  
    IF EXISTS (  
     SELECT 1   
     FROM (  
      SELECT TOP (@noOfInstallment) *  
      FROM #EligibleComponentDetails  
      WHERE FeeComponentID = @ComponentID  
      ORDER BY InstallmentNo desc  
     ) AS CheckRange  
     WHERE DiscountedBaseAmount IS NOT NULL  
    )  
    BEGIN  
     set @CompoName=(select top 1 S_Component_Name  from T_Fee_Component_Master where I_Fee_Component_ID=@ComponentID);  
  
     RAISERROR('Discount already applied in eligible range for component %s.', 16, 1, @CompoName)  
     RETURN  
    END  
    -- Step 5: Insert the eligible installments into DiscountInstallmentSchedule  
     INSERT INTO #DiscountInstallmentSchedule (FeeComponentID, InstallmentNo, Rate, Amount)  
     SELECT   
      FeeComponentID,  
      InstallmentNo,  
      @DiscountRate,  
      @DiscountAmount  
     FROM (  
      SELECT TOP (@noOfInstallment) *  
      FROM #EligibleComponentDetails  
      WHERE FeeComponentID = @ComponentID  
      ORDER BY InstallmentNo desc  
     ) AS FinalRange  
  
     IF ISNULL(@DiscountRate, 0) > 0  
      BEGIN  
       UPDATE E  
       SET E.DiscountedBaseAmount = (-1)* (E.ActualBaseAmount * (@DiscountRate / 100.0))  
       ,E.DiscountedCGST = (-1)*(E.ActualCGST * (@DiscountRate / 100.0))  
       ,E.DiscountedSGST = (-1)*(E.ActualSGST * (@DiscountRate / 100.0))  
       ,E.DiscountedIGST = (-1)* (E.ActualIGST * (@DiscountRate / 100.0))  
       ,E.DiscountedRate=@DiscountRate  
       ,E.DiscountedAmount=@DiscountAmount  
       FROM #EligibleComponentDetails E  
       INNER JOIN #DiscountInstallmentSchedule DIS  
        ON E.FeeComponentID = DIS.FeeComponentID  
        AND E.InstallmentNo = DIS.InstallmentNo  
       WHERE E.DiscountedBaseAmount IS NULL  
      END  
  
  
  
  END  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  --select * from #EligibleComponentDetails  
  
  set @ID=@ID+1  
  
  
 end  
  
  
  update #EligibleComponentDetails set   
  DiscountedBaseAmount = CASE            
               WHEN DiscountedBaseAmount - FLOOR(DiscountedBaseAmount) >= 0.5 THEN            
                   CEILING(DiscountedBaseAmount)            
               ELSE            
                   FLOOR(DiscountedBaseAmount)            
           END,  
     DiscountedCGST = CASE            
               WHEN DiscountedCGST - FLOOR(DiscountedCGST) >= 0.5 THEN            
                   CEILING(DiscountedCGST)            
               ELSE            
                   FLOOR(DiscountedCGST)            
           END,  
      DiscountedSGST = CASE            
               WHEN DiscountedSGST - FLOOR(DiscountedSGST) >= 0.5 THEN            
                   CEILING(DiscountedSGST)            
               ELSE            
                   FLOOR(DiscountedSGST)            
           END,  
      DiscountedIGST = CASE            
               WHEN DiscountedIGST - FLOOR(DiscountedIGST) >= 0.5 THEN            
                   CEILING(DiscountedIGST)            
               ELSE            
                   FLOOR(DiscountedIGST)            
           END  
  where DiscountedBaseAmount IS NOT NULL  
  
 select * from #EligibleComponentDetails  
  
  
  
 drop table #DiscountInstallmentSchedule  
  
  
  
  
 drop table #DiscountDetails  
 drop table #EligibleComponentDetails  
  
  
  
  
END