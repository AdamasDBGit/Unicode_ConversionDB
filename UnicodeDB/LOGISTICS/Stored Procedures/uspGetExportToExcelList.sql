CREATE PROCEDURE [LOGISTICS].[uspGetExportToExcelList] 
(
	@sI_Logistic_Order_Id Varchar(4000)
)
AS
BEGIN
	DECLARE @Index Int,@Count Int,@Last_I_Logistics_Order_ID Int,@Current_I_Logistics_Order_ID Int

	Set @Index = 1
	Declare @tb_ExportList Table
	(
		 Export_List_Id INT IDENTITY(1,1)
		,PO_Date DateTime
		,S_Center_Code Varchar(100)
		,S_Transportation_Mode Varchar(100)
		,I_Logistics_Order_ID INT
		,I_Logistics_ID INT
		,I_Item_Qty INT
		,S_Item_Code Varchar(100)
		,S_Item_Desc Varchar(100)
		,I_Total_Amount INT
		,S_DD_Cheque_No Varchar(100)
		,I_Payment_Amount_INR Float
		,Dt_Issue_Date DateTime
		,S_Bank_Name Varchar(100)
		,S_Branch_Name Varchar(100)
	)

INSERT INTO @tb_ExportList
	EXEC ('SELECT
		 Order_Date AS PO_Date
		,CM.S_Center_Code AS S_Center_Code
		,LO.S_Transportation_Mode AS S_Transportation_Mode
		,LOI.I_Logistics_Order_ID AS I_Logistics_Order_ID
		,LOI.I_Logistics_ID AS I_Logistics_ID
		,LOI.I_Item_Qty AS I_Item_Qty
		,LM.S_Item_Code AS S_Item_Code
		,LM.S_Item_Desc AS S_Item_Desc
		,LO.I_Total_Amount AS I_Total_Amount
		,LP.S_DD_Cheque_No AS S_DD_Cheque_No
		,LP.I_Payment_Amount_INR AS I_Payment_Amount_INR
		,LP.Dt_Issue_Date AS Dt_Issue_Date
		,LP.S_Bank_Name AS S_Bank_Name
		,LP.S_Branch_Name AS S_Branch_Name

		FROM LOGISTICS.T_Logistics_Order LO
		INNER JOIN T_Centre_Master CM on CM.I_Centre_Id = LO.I_Center_Id
		INNER JOIN LOGISTICS.T_Logistics_Order_Line LOI on LOI.I_Logistics_Order_Id = LO.I_Logistic_Order_Id
		INNER JOIN LOGISTICS.T_Logistics_Master LM ON LM.I_Logistics_ID = LOI.I_Logistics_ID 
		INNER JOIN LOGISTICS.T_Logistics_Payment LP ON LP.I_Logistics_Order_ID =  LO.I_Logistic_Order_Id

		Where LO.I_Logistic_Order_Id in ( ' +  @sI_Logistic_Order_Id + ')  Order By LO.I_Logistic_Order_Id Desc')

		SET @Last_I_Logistics_Order_ID = 0
		Select @Count = Count(*) From @tb_ExportList
		While(@Index<=@Count)
			BEGIN
				Print '@Last = ' + Convert(varchar(10),@Last_I_Logistics_Order_ID)		
				Print '@Index = ' + Convert(varchar(10),@Index)	
				Print '@Count = ' + Convert(varchar(10),@Count)		
				SELECT @Current_I_Logistics_Order_ID = I_Logistics_Order_ID 
						FROM @tb_ExportList WHERE Export_List_Id = @Index
				IF (@Current_I_Logistics_Order_ID = @Last_I_Logistics_Order_ID)
					BEGIN
						UPDATE @tb_ExportList
								SET PO_Date = NULL
									,S_Center_Code = NULL
									,S_Transportation_Mode = NULL
									,I_Logistics_Order_ID = NULL
									,I_Logistics_ID = NULL
									,I_Total_Amount = NULL
									,S_DD_Cheque_No = NULL
									,I_Payment_Amount_INR = NULL
									,Dt_Issue_Date = NULL
									,S_Bank_Name = NULL
									,S_Branch_Name = NULL
								WHERE Export_List_Id = @Index 
						
					END

				 SET @Last_I_Logistics_Order_ID = @Current_I_Logistics_Order_ID 
				
				SET @Index = @Index + 1
			END
	
	SELECT S_Center_Code AS Centre_SAP_Code ,I_Logistics_Order_ID AS Purchase_Order_No , convert(varchar, PO_Date ,106) AS PO_DATE ,S_Item_Code AS Item_Code,S_Item_Desc AS Item_Description,I_Item_Qty AS Qty,S_Transportation_Mode AS Inco_Term,	I_Total_Amount AS Total_Value
		,S_DD_Cheque_No AS Cheque_DD_EFT_No,I_Payment_Amount_INR AS Amount,convert(char,Dt_Issue_Date,106) AS Date,S_Bank_Name AS Bank_Name ,S_Branch_Name AS Branch_Name
	FROM @tb_ExportList 
	Order By Export_List_Id Desc
END
