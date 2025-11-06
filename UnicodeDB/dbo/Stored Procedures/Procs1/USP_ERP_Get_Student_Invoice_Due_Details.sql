CREATE Procedure [dbo].[USP_ERP_Get_Student_Invoice_Due_Details](  
@SessionID int,@BrandID int  
)  
As Begin  
Create Table #temp_Stud_Invoice(  
InvID Int Identity(1,1),  
I_School_Session_ID int,  
I_Brand_ID int,  
I_centre_ID int,  
I_Student_Detail_ID INT,  
I_Invoice_Header_ID int,  
N_Invoice_Amount Numeric(12,2),  
N_Tax_Amount Numeric(12,2),  
Dt_Invoice_Date date  
)  
declare @CentreID int   
Declare @Sessionst_dt date,@SessionEnddt date  
  
Select @Sessionst_dt=convert(date,Dt_Session_Start_Date)  
,@SessionEnddt=convert(date,Dt_Session_End_Date)  
from T_School_Academic_Session_Master where I_School_Session_ID=@SessionID  
  
Select top 1 @CentreID=I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@BrandID  
Insert Into #temp_Stud_Invoice(  
I_School_Session_ID,  
I_Brand_ID  
,I_centre_ID  
,I_Student_Detail_ID  
,I_Invoice_Header_ID  
,N_Invoice_Amount  
,N_Tax_Amount  
,Dt_Invoice_Date  
)  
Select @SessionID,@BrandID,@CentreID,I_Student_Detail_ID,I_Invoice_Header_ID  
,ISNULL(N_Invoice_Amount,0) as N_Invoice_Amount  
,ISNULL(N_Tax_Amount,0) as N_Tax_Amount ,Convert(date,Dt_Invoice_Date)  
from T_Invoice_Parent where convert(date,Dt_Invoice_Date) Between   
@Sessionst_dt and @SessionEnddt and I_Centre_Id=@CentreID and I_Status=1  
  
order by I_Student_Detail_ID  
------------------------------------------------------------  
  
SELECT    StudInv.I_School_Session_ID As SessionID  
,StudInv.I_Brand_ID as BrandID  
,StudInv.I_centre_ID as CenterID  
,StudInv.I_Student_Detail_ID as Student_Detail_ID  
,ISNULL(StudInv.Total_Inv_Amount ,0) as Total_Inv_Amount
,ISNULL(StudRecpt.Total_Recpt_Amount,0) as Total_Recpt_Amount  
--,(StudInv.Total_Inv_Amount-StudRecpt.Total_Recpt_Amount) As Stud_Due_Amount  
--,Case When ISNULL((StudInv.Total_Inv_Amount-StudRecpt.Total_Recpt_Amount),0) >0 Then 'Due'  
--When ISNULL((StudInv.Total_Inv_Amount-StudRecpt.Total_Recpt_Amount),0)<0 Then 'Payment Issue'  
--Else 'Paid' End as Due_Status  
INTO #Stud_Invdetail
FROM (  
    -- Calculate total invoice amount per student, brand, and centre  
    SELECT   
     I_School_Session_ID,  
        I_Brand_ID,   
        I_Centre_ID,   
        I_Student_Detail_ID,   
        SUM(COALESCE(N_Invoice_Amount, 0) + COALESCE(N_Tax_Amount, 0)) AS Total_Inv_Amount   
    FROM #temp_Stud_Invoice   
    GROUP BY I_Brand_ID, I_Centre_ID, I_Student_Detail_ID,I_School_Session_ID  
) AS StudInv  
LEFT JOIN (  
    -- Calculate total receipt amount per student  
    SELECT    
        @BrandID AS I_Brand_ID,  -- Keeping Brand ID for consistency  
        @CentreID AS I_Centre_ID,  
        RH.I_Student_Detail_ID,  
        SUM(COALESCE(N_Receipt_Amount, 0) + COALESCE(N_Receipt_Tax_Rff, 0)) AS Total_Recpt_Amount  
    FROM T_Receipt_Header RH    
    INNER JOIN #temp_Stud_Invoice tinv  
        ON RH.I_Invoice_Header_ID = tinv.I_Invoice_Header_ID  
        AND RH.I_Student_Detail_ID = tinv.I_Student_Detail_ID  
    WHERE RH.I_Centre_Id = @CentreID    
    GROUP BY RH.I_Student_Detail_ID  
) AS StudRecpt   
ON StudRecpt.I_Student_Detail_ID = StudInv.I_Student_Detail_ID;  

Select SessionID
,BrandID
,CenterID
,Student_Detail_ID
,Total_Inv_Amount
,Total_Recpt_Amount
,ISNULL((Total_Inv_Amount-Total_Recpt_Amount),0) as Stud_Due_Amount
,Case When ISNULL((Total_Inv_Amount-Total_Recpt_Amount),0) >0 Then 'Due'  
When ISNULL((Total_Inv_Amount-Total_Recpt_Amount),0)<0 Then 'Payment Issue'  
Else 'Paid' End as Due_Status  
from #Stud_Invdetail
Drop table #temp_Stud_Invoice;  
End