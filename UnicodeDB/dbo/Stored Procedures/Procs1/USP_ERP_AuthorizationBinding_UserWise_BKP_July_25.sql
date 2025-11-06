
  
    
CREATE Proc [dbo].[USP_ERP_AuthorizationBinding_UserWise_BKP_July_25](    
@UserID int,    
@PermissionType NVARCHAR(MAX)=Null,    
@pageurl NVARCHAR(MAX) = null,  
@ibrandID INT=NULL  
)    
As Begin    
    
    
    
CREATE TABLE #USerPermission (    
    I_Permission_ID INT,    
    S_Name NVARCHAR(255),    
    Description NVARCHAR(MAX),    
    I_Parent_Menu_ID INT,    
    S_PageUrl NVARCHAR(255),    
    S_Icon NVARCHAR(255),    
    I_Is_Leaf_Node BIT,    
    i_pageseq INT,    
    S_User_GroupName NVARCHAR(255),    
    S_Role_Desc NVARCHAR(255),    
 S_Display_Component_Permissions VARCHAR(max),    
 S_Enable_Component_Permissions VARCHAR(max),    
 RequestType varchar(100)    
);    
    
IF @pageurl IS NOT NULL    
BEGIN    
SET @pageurl='/SMS2'+@pageurl    
print @pageurl    
END    
    
IF EXISTS  
(SELECT * FROM T_ERP_User as EU   
inner join  
T_ERP_User_Brand as EUB on EU.I_User_ID=EUB.I_User_ID and EUB.Is_Active=1 and EUB.I_Brand_ID=ISNULL(@ibrandID,EUB.I_Brand_ID)  
WHERE EU.I_User_ID = @UserID and EU.I_Status=1 AND ISNULL(IsAllAllowedEligible, 'false') = 'true')    
BEGIN    
    -- If user has all permissions allowed 
	

	IF EXISTS( SELECT * FROM T_ERP_User EU WHERE EU.I_User_ID = @UserID and EU.I_Status=1 AND ISNULL(EU.Is_Active_Ignore_Allowed, 'false') = 'true')
    
	BEGIN
			INSERT INTO #USerPermission    
			SELECT DISTINCT    
				c.I_Permission_ID,    
				c.S_Name,    
				c.Description,    
				c.I_Parent_Menu_ID,    
				c.S_PageUrl,    
				c.S_Icon,    
				c.I_Is_Leaf_Node,    
				c.i_pageseq,    
				NULL AS S_User_GroupName,    
				NULL as S_Role_Desc,    
		  S_Display_Component_Permissions as S_Display_Component_Permissions,    
		  S_Enable_Component_Permissions as S_Enable_Component_Permissions,    
		  c.RequestType as RequestType    
			FROM T_erp_Permission c     
			WHERE  c.I_Status = 1 AND c.Permission_Type = @PermissionType AND c.S_PageUrl=ISNULL(@pageurl,c.S_PageUrl);  
	END
	ELSE
	BEGIN

		INSERT INTO #USerPermission    
			SELECT DISTINCT    
				c.I_Permission_ID,    
				c.S_Name,    
				c.Description,    
				c.I_Parent_Menu_ID,    
				c.S_PageUrl,    
				c.S_Icon,    
				c.I_Is_Leaf_Node,    
				c.i_pageseq,    
				NULL AS S_User_GroupName,    
				NULL as S_Role_Desc,    
		  S_Display_Component_Permissions as S_Display_Component_Permissions,    
		  S_Enable_Component_Permissions as S_Enable_Component_Permissions,    
		  c.RequestType as RequestType    
			FROM T_erp_Permission c     
			WHERE  c.I_Status = 1 AND c.Permission_Type = @PermissionType AND c.S_PageUrl=ISNULL(@pageurl,c.S_PageUrl)
			AND Is_Active=1; 

	END

Print 1  
END    
ELSE    
BEGIN    
    -- If user does not have all permissions allowed    
    INSERT INTO #USerPermission    
    SELECT DISTINCT    
        c.I_Permission_ID,    
        c.S_Name,    
        c.Description,    
        c.I_Parent_Menu_ID,    
        c.S_PageUrl,    
        c.S_Icon,    
        c.I_Is_Leaf_Node,    
        c.i_pageseq,    
        d.S_User_GroupName,    
        b.S_Role_Desc,    
  S_Display_Component_Permissions as S_Display_Component_Permissions,    
  S_Enable_Component_Permissions as S_Enable_Component_Permissions    
  ,c.RequestType as RequestType    
    FROM T_ERP_Users_Role_Permission_Map a    
    INNER JOIN T_ERP_Role_Master b ON a.Role_Id = b.I_Role_ID    
    INNER JOIN T_erp_Permission c ON c.I_Permission_ID = a.Permission_ID    
    INNER JOIN T_ERP_User_Group_Master d ON d.I_User_Group_Master_ID = a.User_Group_ID    
    WHERE a.Is_Active = 1 AND b.I_Status = 1 AND c.I_Status = 1 AND d.Is_Active = 1    
    AND a.I_User_Id = @UserID AND c.Permission_Type = @PermissionType AND c.S_PageUrl=ISNULL(@pageurl,c.S_PageUrl)   
 and b.I_Brand_ID=ISNULL(@ibrandID,b.I_Brand_ID) and d.I_Brand_ID=ISNULL(@ibrandID,d.I_Brand_ID) and a.Brand_ID=ISNULL(@ibrandID,a.Brand_ID)  
 and c.Is_Active=1
 --select * from #USerPermission    
 --print @PermissionType    
END    
print @pageurl    
--select * from #USerPermission    
    
IF @PermissionType = 'menu'    
begin    
Print 'Menu'  
--select * from #USerPermission    
;WITH RecursiveCTE AS (    
    SELECT     
I_Permission_ID    
,Description    
,I_Parent_Menu_ID    
,S_PageUrl    
,S_Icon    
,I_Is_Leaf_Node    
,i_pageseq    
,1 AS Level    
--,ROW_NUMBER() OVER (ORDER BY I_Permission_ID) AS i_pageseq1    
    FROM #USerPermission    
    WHERE      
    I_Parent_Menu_ID is null    
     
    UNION ALL    
     
    SELECT     
 p.I_Permission_ID    
,p.Description    
,p.I_Parent_Menu_ID    
,p.S_PageUrl    
,p.S_Icon    
,p.I_Is_Leaf_Node    
,p.i_pageseq    
,Level + 1    
--,ROW_NUMBER() OVER (ORDER BY p.I_Permission_ID) AS i_pageseq1    
    FROM #USerPermission p    
    Inner JOIN RecursiveCTE cte ON p.I_Parent_Menu_ID = cte.I_Permission_ID    
 --where cte.I_Parent_Menu_ID is not null    
)    
SELECT  DISTINCT  
 a.I_Permission_ID as PermissionID    
 ,b.Description as Parent_PermissionName    
,a.Description as PermissionName    
,a.I_Parent_Menu_ID as ParentPermissionID    
,STUFF(a.S_PageUrl, 1, LEN('/SMS2'), '')as PageURL    
,a.S_Icon    
,a.I_Is_Leaf_Node as LeafNode_Seq    
,a.i_pageseq as ManuPageSeq    
,a.Level    
,b.i_pageseq    
--,a.i_pageseq1    
    
    
     
FROM RecursiveCTE a    
Left Join T_ERP_Permission b on a.I_Parent_Menu_ID=b.I_Permission_ID    
ORDER BY  b.i_pageseq    
end    
    
else    
begin    
 --select * from #USerPermission    
 select     
 UP.I_Permission_ID as PermissionID,    
    Parent.S_Name as Parent_PermissionName,    
 UP.S_Name as PermissionName,    
 UP.I_Parent_Menu_ID as ParentPermissionID    
 ,STUFF(UP.S_PageUrl, 1, LEN('/SMS2'), '')as PageURL    
 ,UP.S_Icon    
 ,UP.I_Is_Leaf_Node as LeafNode_Seq    
 ,UP.i_pageseq as ManuPageSeq    
 ,NULL Level    
 ,UP.i_pageseq    
 ,UP.S_Enable_Component_Permissions as EnableComponentPermissions    
 ,UP.S_Display_Component_Permissions as DisplayComponentPermissions    
 ,UP.RequestType     
 from #USerPermission UP    
 left join    
 T_ERP_Permission as Parent on UP.I_Parent_Menu_ID=Parent.I_Permission_ID     
    
end    
    
Drop table #USerPermission    
End

