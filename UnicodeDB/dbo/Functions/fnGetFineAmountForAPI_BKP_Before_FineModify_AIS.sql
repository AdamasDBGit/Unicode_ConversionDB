
CREATE FUNCTION [dbo].[fnGetFineAmountForAPI_BKP_Before_FineModify_AIS]
    (
      @iBrandID INT ,
      @InstalmentDate DATETIME = NULL
    )
RETURNS DECIMAL(14, 2)
AS
    BEGIN
    
        DECLARE @FineAmount DECIMAL(14, 2)= 0
    
        IF ( @InstalmentDate IS NOT NULL )
            BEGIN

                DECLARE @CurrDate DATETIME= GETDATE()

                DECLARE @lastdayofmonth DATETIME= DATEADD(d, -1,
                                                          DATEADD(m,
                                                              DATEDIFF(m, 0,
                                                              @InstalmentDate)
                                                              + 1, 0))


                DECLARE @firstdayofmonth DATETIME= DATEADD(MONTH,
                                                           DATEDIFF(MONTH, 0,
                                                              @InstalmentDate),
                                                           0)


                IF ( @iBrandID = 110 )
                    BEGIN

                        SET @FineAmount = DATEDIFF(d,
                                                   DATEADD(d, 9,
                                                           @firstdayofmonth),
                                                   @CurrDate) * 25.00

                    END

                ELSE
                    IF ( @iBrandID = 107 )
                        BEGIN

                            IF ( @CurrDate > DATEADD(d, 10, @firstdayofmonth)
                                 AND @CurrDate <= DATEADD(d, 20,
                                                          @firstdayofmonth)
                               )
                                SET @FineAmount = 500.00

                            ELSE
                                IF ( @CurrDate > DATEADD(d, 20,
                                                         @firstdayofmonth)
                                     AND @CurrDate <= @lastdayofmonth
                                   )
                                    SET @FineAmount = 750.00
	
                                ELSE
                                    IF ( @CurrDate > @lastdayofmonth )
                                        SET @FineAmount = 1500.00		

                            --RETURN @FineAmount

                        END
                    ELSE
                        IF ( @iBrandID = 109 )
                            BEGIN

                                SET @FineAmount = DATEDIFF(d,
                                                           DATEADD(d, 14,
                                                              @InstalmentDate),
                                                           @CurrDate) * 50.00

                            END
                
            END
            
            
		IF @FineAmount<0
		
		SET @FineAmount=0.00
		
		
        RETURN @FineAmount



    END
