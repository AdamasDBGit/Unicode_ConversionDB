--[DBO].[USPISROLEPRESENTFORCENTRE] 13,3
CREATE PROCEDURE [dbo].[USPISROLEPRESENTFORCENTRE]
    (
      @ICENTREID INT,
      @IROLEID INT
    )
AS 
    BEGIN
	
        DECLARE @IHIERARCHYDETAILID INT       
        DECLARE @CONTINUE INT   
		DECLARE @USERCOUNT INT
		SET @USERCOUNT = 0;
		
        SET @CONTINUE = 1      

        DECLARE @USERIDTABLE TABLE
            (
              I_USER_ID INT,
              S_EMAIL_ID VARCHAR(200)
            )


        SELECT  @IHIERARCHYDETAILID = I_HIERARCHY_DETAIL_ID
        FROM    DBO.T_CENTER_HIERARCHY_DETAILS WITH(NOLOCK)
        WHERE   I_CENTER_ID = @ICENTREID
                AND I_STATUS = 1      

		IF (@IHIERARCHYDETAILID IS NOT NULL)
		BEGIN
			
		 WHILE ( @CONTINUE = 1 )      
            BEGIN      
                IF EXISTS ( SELECT  UHD.I_USER_ID
                            FROM    DBO.T_USER_HIERARCHY_DETAILS UHD WITH(NOLOCK)
                                    INNER JOIN DBO.T_USER_ROLE_DETAILS URD WITH(NOLOCK) ON UHD.I_USER_ID = URD.I_USER_ID
                            WHERE   UHD.I_HIERARCHY_DETAIL_ID = @IHIERARCHYDETAILID
                                    AND URD.I_ROLE_ID = @IROLEID
                                    AND UHD.I_STATUS = 1
                                    AND URD.I_STATUS = 1 ) 
                    BEGIN                        
                        SET @USERCOUNT = 1
                        SET @CONTINUE = 0
                    END   
                ELSE 
                    BEGIN      
                        SELECT  @IHIERARCHYDETAILID = I_PARENT_ID
                        FROM    DBO.T_HIERARCHY_MAPPING_DETAILS WITH(NOLOCK)
                        WHERE   I_HIERARCHY_DETAIL_ID = @IHIERARCHYDETAILID
                                AND I_STATUS = 1
                                
                        IF  (@IHIERARCHYDETAILID IS NULL)
							SET @CONTINUE = 0
                    END         
            END
            
		END

		
		SELECT @USERCOUNT
    END
