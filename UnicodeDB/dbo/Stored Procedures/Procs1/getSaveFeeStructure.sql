-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
--exec getSaveFeeStructure 237102, 35, 107      
-- =============================================      
CREATE PROCEDURE [dbo].[getSaveFeeStructure]      
 -- Add the parameters for the stored procedure here      
 (      
  @R_I_Enquiry_Regn_ID INT NULL,      
  @R_I_School_Session_ID INT NULL,      
  @I_Brand_ID INT NULL      
 )      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
    --select * from T_ERP_Stud_Fee_Struct_Comp_Mapping where I_Stud_Fee_Struct_CompMap_ID = 87  
 Select     
 CMAP.I_Stud_Fee_Struct_CompMap_ID as StructCompMapID,      
 CMAP.R_I_Fee_Structure_ID as StructureID,      
 CMAP.Is_LumpSum as PaymentType,  
 TEFS.N_Total_Installment_Amount as StructureAmt  
 from T_ERP_Stud_Fee_Struct_Comp_Mapping CMAP    
 left join T_ERP_Fee_Structure as TEFS on CMAP.R_I_Fee_Structure_ID = TEFS.I_Fee_Structure_ID  
 where CMAP.R_I_Enquiry_Regn_ID = @R_I_Enquiry_Regn_ID and CMAP.I_Brand_ID = @I_Brand_ID and CMAP.R_I_School_Session_ID = @R_I_School_Session_ID      
        
	Create Table #TempComponent_GST (  
	 I_ID int Identity(1,1),  
	 StructCompMapID int,  
	 StructCompMapDetailID int,  
	 StructureID int,
	 ComponentID int,
	 ComponentAmount Numeric(18,2),
	 FeePayInstallmentID int,
	 InstallmentFreqName varchar(200),
	 ExtracomponentRefID int,
	 ExtracomponentRefType int,
	 RouteID int,
	 BuildingName varchar(200),
	 BlockName varchar(200),
	 FloorName varchar(200),
	 RoomName varchar(200),
	 RoomType int,
	 StartPeriod int,
	 SequenceNo int
	 ) 

	 Insert Into #TempComponent_GST(StructCompMapID, StructCompMapDetailID, StructureID, ComponentID, ComponentAmount, FeePayInstallmentID, InstallmentFreqName, ExtracomponentRefID, ExtracomponentRefType, RouteID, BuildingName, BlockName, FloorName, RoomName, RoomType,StartPeriod,SequenceNo)

 Select       
 CMAPD.R_I_Stud_Fee_Struct_CompMap_ID as StructCompMapID,      
 CMAPD.I_Stud_Fee_Struct_CompMap_Details_ID as StructCompMapDetailID,      
 CMAPD.R_I_Fee_Structure_ID as StructureID,      
 CMAPD.R_I_Fee_Component_ID as ComponentID,      
 CMAPD.N_Component_Actual_Amount as ComponentAmount,      
 CMAPD.R_I_Fee_Pay_Installment_ID as FeePayInstallmentID,      
 TEFPT.S_Installment_Frequency as InstallmentFreqName,      
 CMAPD.I_ExtracomponentRef_ID as ExtracomponentRefID,      
 CMAPD.I_ExtracomponentRef_Type as ExtracomponentRefType,      
 CASE    
  WHEN CMAPD.I_ExtracomponentRef_Type = 1 THEN TTM.I_PickupPoint_ID    
    ELSE NULL    
 END AS RouteID,    
 CASE    
  WHEN CMAPD.I_ExtracomponentRef_Type = 2 THEN TRM.S_Building_Name    
 ELSE NULL    
 END AS BuildingName,    
 CASE    
        WHEN CMAPD.I_ExtracomponentRef_Type = 2 THEN TRM.S_Block_Name    
        ELSE NULL    
    END AS BlockName,    
  CASE    
        WHEN CMAPD.I_ExtracomponentRef_Type = 2 THEN TRM.S_Floor_Name    
        ELSE NULL    
    END AS FloorName,    
 CASE    
        WHEN CMAPD.I_ExtracomponentRef_Type = 2 THEN TRM.S_Room_No    
        ELSE NULL    
    END AS RoomName,    
 CASE    
        WHEN CMAPD.I_ExtracomponentRef_Type = 2 THEN TRM.I_Room_Type    
        ELSE NULL    
    END AS RoomType
	,CMAPD.StartPeriod as StartPeriod
	,CMAPD.Seq as SequenceNo
 from T_ERP_Stud_Fee_Struct_Comp_Mapping CMAP      
 inner join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details AS CMAPD ON CMAP.I_Stud_Fee_Struct_CompMap_ID = CMAPD.R_I_Stud_Fee_Struct_CompMap_ID      
 left join T_ERP_Fee_PaymentInstallment_Type AS TEFPT ON CMAPD.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID      
 left join T_Transport_Master AS TTM on CMAPD.I_ExtracomponentRef_ID = TTM.I_PickupPoint_ID    
 left join T_room_master AS TRM on CMAPD.I_ExtracomponentRef_ID = TRM.I_Room_ID    
 Where CMAP.R_I_Enquiry_Regn_ID = @R_I_Enquiry_Regn_ID and CMAP.I_Brand_ID = @I_Brand_ID and CMAP.R_I_School_Session_ID = @R_I_School_Session_ID and CMAPD.R_I_Fee_Structure_ID = 0     


 --select * from #TempComponent_GST

 select a.*
	 ,ISNULL(c.N_CGST,0) as CGST_Per
	 ,ISNULL(c.N_SGST,0) as SGST_Per
	 ,ISNULL(c.N_IGST,0) as IGST_Per
	 ,ISNULL(Convert(numeric(18,2),(a.ComponentAmount * ISNULL(c.N_CGST,0) / 100)),0) as CGST_Amt
	 ,ISNULL(Convert(numeric(18,2),(a.ComponentAmount * ISNULL(c.N_SGST,0) / 100)),0) as SGST_Amt
	 ,ISNULL(Convert(numeric(18,2),(a.ComponentAmount * ISNULL(c.N_IGST,0) / 100)),0) as IGST_Amt
	 
	 from #TempComponent_GST a
	 left Join T_ERP_GST_Item_Category b on a.ComponentID=b.I_Fee_Component_ID and b.Is_Active=1
	 left Join T_ERP_GST_Configuration_Details c on a.ComponentAmount between c.N_Start_Amount and c.N_End_Amount
	 and c.I_GST_FeeComponent_Catagory_ID=b.I_GST_FeeComponent_Catagory_ID and a.ComponentID=b.I_Fee_Component_ID
    
 
END 
