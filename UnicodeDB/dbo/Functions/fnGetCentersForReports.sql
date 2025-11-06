-- =============================================  
-- Author:  Abhisek Bhattacharya  
-- Create date: '06/06/2007'  
-- Description: This Function return a table   
-- consisting of brand, hierarchy Detail ID, center ID, center Code, center Name  
-- Return: Table  
-- =============================================  
CREATE FUNCTION [dbo].[fnGetCentersForReports]  
(  
 @sHierarchyChain VARCHAR(max),  
 @iBrandID INT  
)  
RETURNS  @rtnTable TABLE  
(  
 brandID INT,  
 hierarchyDetailID INT,  
 centerID INT,  
 centerCode VARCHAR(20),  
 centerName VARCHAR(100)  
)  
  
AS   
-- Returns the Table containing the center details.  
BEGIN  
  
 DECLARE @iHierarchyDetailID INT  
 DECLARE @iGetIndexHierarchy INT  
 DECLARE @sHierarchyDetailID VARCHAR(20)  
 DECLARE @iLengthHierarchy INT  
 DECLARE @sTempHierarchyChain VARCHAR(100)  
  
 -- Append a comma after the Hierarchy Chain  
 SET @sHierarchyChain = @sHierarchyChain + ','  
  
 -- Get the start index for Hierarchy  
 SET @iGetIndexHierarchy = CHARINDEX(',',LTRIM(RTRIM(@sHierarchyChain)),1)  
  
 -- If start index for Hierarchy is greater than 1  
 IF @iGetIndexHierarchy > 1  
 BEGIN  
  WHILE LEN(@sHierarchyChain) > 0  
  BEGIN  
   SET @iGetIndexHierarchy = CHARINDEX(',',@sHierarchyChain,1)  
   SET @iLengthHierarchy = LEN(@sHierarchyChain)  
   SET @iHierarchyDetailID = CAST(LTRIM(RTRIM(LEFT(@sHierarchyChain,@iGetIndexHierarchy-1))) AS int)  
  
   -- Get the hierarchy chain for the above Hierarchy Detail ID  
   SELECT @sTempHierarchyChain = S_Hierarchy_Chain   
   FROM dbo.T_Hierarchy_Mapping_Details  
   WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailID  
   AND I_Status = 1  
   AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())  
   AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())  
  
   -- Append the chain with %  
   SET @sTempHierarchyChain = '%'+@sTempHierarchyChain + '%'  
  
   -- Insert the center wchich falls under the selected Hierarchy and Brand  
   INSERT INTO @rtnTable  
   SELECT @iBrandID,   
     @iHierarchyDetailID,  
     CM.I_Centre_Id,  
     CM.S_Center_Code,  
     CM.S_Center_Name  
   FROM dbo.T_Centre_Master CM  
   INNER JOIN dbo.T_Center_Hierarchy_Details CHD  
   ON CM.I_Centre_Id = CHD.I_Center_Id  
   AND CHD.I_Status = 1  
   AND GETDATE() >= ISNULL(CHD.Dt_Valid_From, GETDATE())  
   AND GETDATE() <= ISNULL(CHD.Dt_Valid_To, GETDATE())  
   INNER JOIN dbo.T_Brand_Center_Details BCD  
   ON CM.I_Centre_Id = BCD.I_Centre_Id  
   AND BCD.I_Brand_ID = @iBrandID  
   INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD  
   ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID  
   AND HMD.S_Hierarchy_Chain LIKE @sTempHierarchyChain  
   AND HMD.I_Status = 1  
   AND GETDATE() >= ISNULL(HMD.Dt_Valid_From, GETDATE())  
   AND GETDATE() <= ISNULL(HMD.Dt_Valid_To, GETDATE())  
  
  
   SELECT @sHierarchyChain = SUBSTRING(@sHierarchyChain,@iGetIndexHierarchy + 1, @iLengthHierarchy - @iGetIndexHierarchy)  
   SELECT @sHierarchyChain = LTRIM(RTRIM(@sHierarchyChain))  
  END  
 END  
   
 RETURN;  
  
END