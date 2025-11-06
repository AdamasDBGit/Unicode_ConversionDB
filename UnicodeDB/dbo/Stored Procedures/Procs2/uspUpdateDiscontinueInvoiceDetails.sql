CREATE PROCEDURE [dbo].[uspUpdateDiscontinueInvoiceDetails]
AS
BEGIN

DECLARE @sInvoiceNo nvarchar(max)
DECLARE @sStudentID nvarchar(max)
DECLARE @dtReviseInvoiceDate DATE


DECLARE @NewRevisedInvoiceID INT
DECLARE @ParentInvoiceID INT
DECLARE @iStudentDetailID INT
DECLARE @i INT=1
DECLARE @c INT=0
DECLARE @NewDate DATE ='2016-03-01'




CREATE TABLE #temp
(
ID INT,
StudentID nvarchar(max),
InvoiceNo nvarchar(max)
)

insert into #temp(ID,StudentID,InvoiceNo)values(1,'1516/RICE/332','83074')
insert into #temp(ID,StudentID,InvoiceNo)values(2,'1516/RICE/3844','82725')
insert into #temp(ID,StudentID,InvoiceNo)values(3,'1516/RICE/1777','82731')
insert into #temp(ID,StudentID,InvoiceNo)values(4,'1516/RICE/1675','82760')
insert into #temp(ID,StudentID,InvoiceNo)values(5,'1516/RICE/1656','82764')
insert into #temp(ID,StudentID,InvoiceNo)values(6,'1516/RICE/1596','82730')
insert into #temp(ID,StudentID,InvoiceNo)values(7,'1516/RICE/4715','83031')
insert into #temp(ID,StudentID,InvoiceNo)values(8,'1516/RICE/4670','83029')
insert into #temp(ID,StudentID,InvoiceNo)values(9,'1516/RICE/3533','83035')
insert into #temp(ID,StudentID,InvoiceNo)values(10,'1516/RICE/2973','82985')
insert into #temp(ID,StudentID,InvoiceNo)values(11,'1516/RICE/2829','83034')
insert into #temp(ID,StudentID,InvoiceNo)values(12,'1516/RICE/2759','83070')
insert into #temp(ID,StudentID,InvoiceNo)values(13,'1516/RICE/262','83038')
insert into #temp(ID,StudentID,InvoiceNo)values(14,'1516/RICE/2288','83033')
insert into #temp(ID,StudentID,InvoiceNo)values(15,'1516/RICE/2031','83030')
insert into #temp(ID,StudentID,InvoiceNo)values(16,'1516/RICE/1969','83028')
insert into #temp(ID,StudentID,InvoiceNo)values(17,'1516/RICE/1536','83032')
insert into #temp(ID,StudentID,InvoiceNo)values(18,'1516/RICE/1495','83027')
insert into #temp(ID,StudentID,InvoiceNo)values(19,'1516/RICE/048','82986')
insert into #temp(ID,StudentID,InvoiceNo)values(20,'1516/RICE/045','83036')
insert into #temp(ID,StudentID,InvoiceNo)values(21,'1516/RICE/002','83039')
insert into #temp(ID,StudentID,InvoiceNo)values(22,'1516/RICE/4042','83101')
insert into #temp(ID,StudentID,InvoiceNo)values(23,'1516/RICE/012','83046')
insert into #temp(ID,StudentID,InvoiceNo)values(24,'1516/RICE/1510','83041')
insert into #temp(ID,StudentID,InvoiceNo)values(25,'1516/RICE/1517','83047')
insert into #temp(ID,StudentID,InvoiceNo)values(26,'1516/RICE/2899','83055')
insert into #temp(ID,StudentID,InvoiceNo)values(27,'1516/RICE/3406','83051')
insert into #temp(ID,StudentID,InvoiceNo)values(28,'1516/RICE/3726','83048')
insert into #temp(ID,StudentID,InvoiceNo)values(29,'1516/RICE/3959','83044')
insert into #temp(ID,StudentID,InvoiceNo)values(30,'1516/RICE/4165','83054')
insert into #temp(ID,StudentID,InvoiceNo)values(31,'1516/RICE/5632','83045')
insert into #temp(ID,StudentID,InvoiceNo)values(32,'1516/RICE/490','82911')
insert into #temp(ID,StudentID,InvoiceNo)values(33,'1516/RICE/090','82918')
insert into #temp(ID,StudentID,InvoiceNo)values(34,'1516/RICE/175','82987')
insert into #temp(ID,StudentID,InvoiceNo)values(35,'1516/RICE/1786','82988')
insert into #temp(ID,StudentID,InvoiceNo)values(36,'1516/RICE/2287','82922')
insert into #temp(ID,StudentID,InvoiceNo)values(37,'1516/RICE/185','82845')
insert into #temp(ID,StudentID,InvoiceNo)values(38,'1516/RICE/891','82828')
insert into #temp(ID,StudentID,InvoiceNo)values(39,'1516/RICE/1597','82846')
insert into #temp(ID,StudentID,InvoiceNo)values(40,'1516/RICE/1870','82842')
insert into #temp(ID,StudentID,InvoiceNo)values(41,'1516/RICE/1871','82843')
insert into #temp(ID,StudentID,InvoiceNo)values(42,'1516/RICE/2323','82861')
insert into #temp(ID,StudentID,InvoiceNo)values(43,'1516/RICE/2325','82856')
insert into #temp(ID,StudentID,InvoiceNo)values(44,'1516/RICE/2190','82834')
insert into #temp(ID,StudentID,InvoiceNo)values(45,'1516/RICE/1958','82811')
insert into #temp(ID,StudentID,InvoiceNo)values(46,'1516/RICE/4302','82807')
insert into #temp(ID,StudentID,InvoiceNo)values(47,'1516/RICE/5124','82798')
insert into #temp(ID,StudentID,InvoiceNo)values(48,'1516/RICE/1828','82780')
insert into #temp(ID,StudentID,InvoiceNo)values(49,'1516/RICE/1877','82716')
insert into #temp(ID,StudentID,InvoiceNo)values(50,'1516/RICE/4205','82717')
insert into #temp(ID,StudentID,InvoiceNo)values(51,'1516/RICE/4207','82718')
insert into #temp(ID,StudentID,InvoiceNo)values(52,'1516/RICE/4161','82719')
insert into #temp(ID,StudentID,InvoiceNo)values(53,'1516/RICE/2281','82722')
insert into #temp(ID,StudentID,InvoiceNo)values(54,'1516/RICE/2803','82723')
insert into #temp(ID,StudentID,InvoiceNo)values(55,'1516/RICE/2843','82748')
insert into #temp(ID,StudentID,InvoiceNo)values(56,'1516/RICE/3807','82761')
insert into #temp(ID,StudentID,InvoiceNo)values(57,'1516/RICE/4750','82770')
insert into #temp(ID,StudentID,InvoiceNo)values(58,'1516/RICE/1199','82795')
insert into #temp(ID,StudentID,InvoiceNo)values(59,'1516/RICE/1487','82797')
insert into #temp(ID,StudentID,InvoiceNo)values(60,'1516/RICE/1589','82801')
insert into #temp(ID,StudentID,InvoiceNo)values(61,'1516/RICE/1724','82802')
insert into #temp(ID,StudentID,InvoiceNo)values(62,'1516/RICE/2094','82809')
insert into #temp(ID,StudentID,InvoiceNo)values(63,'1516/RICE/2220','82810')
insert into #temp(ID,StudentID,InvoiceNo)values(64,'1516/RICE/2235','82816')
insert into #temp(ID,StudentID,InvoiceNo)values(65,'1516/RICE/2494','82819')
insert into #temp(ID,StudentID,InvoiceNo)values(66,'1516/RICE/253','82820')
insert into #temp(ID,StudentID,InvoiceNo)values(67,'1516/RICE/2619','82821')
insert into #temp(ID,StudentID,InvoiceNo)values(68,'1516/RICE/3067','82823')
insert into #temp(ID,StudentID,InvoiceNo)values(69,'1516/RICE/320','82824')
insert into #temp(ID,StudentID,InvoiceNo)values(70,'1516/RICE/3656','82829')
insert into #temp(ID,StudentID,InvoiceNo)values(71,'1516/RICE/3964','82830')
insert into #temp(ID,StudentID,InvoiceNo)values(72,'1516/RICE/414','82831')
insert into #temp(ID,StudentID,InvoiceNo)values(73,'1516/RICE/4948','82833')
insert into #temp(ID,StudentID,InvoiceNo)values(74,'1516/RICE/5030','82836')
insert into #temp(ID,StudentID,InvoiceNo)values(75,'1516/RICE/680','82841')
insert into #temp(ID,StudentID,InvoiceNo)values(76,'1516/RICE/1583','83501')
insert into #temp(ID,StudentID,InvoiceNo)values(77,'1516/RICE/1858','83503')
insert into #temp(ID,StudentID,InvoiceNo)values(78,'1516/RICE/1891','83506')
insert into #temp(ID,StudentID,InvoiceNo)values(79,'1516/RICE/2335','83507')
insert into #temp(ID,StudentID,InvoiceNo)values(80,'1516/RICE/2360','83509')
insert into #temp(ID,StudentID,InvoiceNo)values(81,'1516/RICE/2522','83511')
insert into #temp(ID,StudentID,InvoiceNo)values(82,'1516/RICE/2650','83519')
insert into #temp(ID,StudentID,InvoiceNo)values(83,'1516/RICE/293','83524')
insert into #temp(ID,StudentID,InvoiceNo)values(84,'1516/RICE/3471','83527')
insert into #temp(ID,StudentID,InvoiceNo)values(85,'1516/RICE/3516','83528')
insert into #temp(ID,StudentID,InvoiceNo)values(86,'1516/RICE/3737','83529')
insert into #temp(ID,StudentID,InvoiceNo)values(87,'1516/RICE/383','83530')
insert into #temp(ID,StudentID,InvoiceNo)values(88,'1516/RICE/4224','83532')
insert into #temp(ID,StudentID,InvoiceNo)values(89,'1516/RICE/650','83538')
insert into #temp(ID,StudentID,InvoiceNo)values(90,'1516/RICE/951','83539')
insert into #temp(ID,StudentID,InvoiceNo)values(91,'1516/RICE/028','83548')
insert into #temp(ID,StudentID,InvoiceNo)values(92,'1516/RICE/2496','83551')
insert into #temp(ID,StudentID,InvoiceNo)values(93,'1516/RICE/2845','83552')
insert into #temp(ID,StudentID,InvoiceNo)values(94,'1516/RICE/2887','83553')
insert into #temp(ID,StudentID,InvoiceNo)values(95,'1516/RICE/664','83554')
insert into #temp(ID,StudentID,InvoiceNo)values(96,'1516/RICE/698','83643')
insert into #temp(ID,StudentID,InvoiceNo)values(97,'1516/RICE/1481','83542')
insert into #temp(ID,StudentID,InvoiceNo)values(98,'1516/RICE/386','83544')
insert into #temp(ID,StudentID,InvoiceNo)values(99,'1516/RICE/4009','83546')
insert into #temp(ID,StudentID,InvoiceNo)values(100,'1516/RICE/053','83591')
insert into #temp(ID,StudentID,InvoiceNo)values(101,'1516/RICE/1663','83614')
insert into #temp(ID,StudentID,InvoiceNo)values(102,'1516/RICE/171','83616')
insert into #temp(ID,StudentID,InvoiceNo)values(103,'1516/RICE/2346','83618')
insert into #temp(ID,StudentID,InvoiceNo)values(104,'1516/RICE/2637','83619')
insert into #temp(ID,StudentID,InvoiceNo)values(105,'1516/RICE/325','83629')
insert into #temp(ID,StudentID,InvoiceNo)values(106,'1516/RICE/3436','83630')
insert into #temp(ID,StudentID,InvoiceNo)values(107,'1516/RICE/388','83631')
insert into #temp(ID,StudentID,InvoiceNo)values(108,'1516/RICE/3929','83632')
insert into #temp(ID,StudentID,InvoiceNo)values(109,'1516/RICE/437','83634')
insert into #temp(ID,StudentID,InvoiceNo)values(110,'1516/RICE/441','83636')
insert into #temp(ID,StudentID,InvoiceNo)values(111,'1516/RICE/4984','83637')
insert into #temp(ID,StudentID,InvoiceNo)values(112,'1516/RICE/505','83638')
insert into #temp(ID,StudentID,InvoiceNo)values(113,'1516/RICE/566','83640')
insert into #temp(ID,StudentID,InvoiceNo)values(114,'1516/RICE/806','83641')
insert into #temp(ID,StudentID,InvoiceNo)values(115,'1516/RICE/974','83642')


SELECT @c=MAX(ID) FROM #temp TT


WHILE @i<=@c
BEGIN

SELECT @sStudentID=TT.StudentID,@sInvoiceNo=TT.InvoiceNo FROM #temp TT WHERE TT.ID=@i

--SET @sInvoiceNo='82990'
--SET @sStudentID='1415/RICE/8645'

IF ( SELECT COUNT(*)
     FROM   dbo.T_Invoice_Parent TIP
            INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
     WHERE  TSD.S_Student_ID = @sStudentID
            --AND CONVERT(DATE, TIP.Dt_Crtd_On) = CONVERT(DATE, @dtReviseInvoiceDate)
            AND TIP.I_Status = 1
            AND TIP.S_Invoice_No=@sInvoiceNo
   ) = 1 
    BEGIN
        SELECT  @NewRevisedInvoiceID = TIP.I_Invoice_Header_ID ,
                @ParentInvoiceID = TIP.I_Parent_Invoice_ID ,
                @iStudentDetailID = TSD.I_Student_Detail_ID
        FROM    dbo.T_Invoice_Parent TIP
                INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TSD.S_Student_ID = @sStudentID
                --AND CONVERT(DATE, TIP.Dt_Crtd_On) = CONVERT(DATE, @dtReviseInvoiceDate)
                AND TIP.I_Status = 1
                AND TIP.S_Invoice_No=@sInvoiceNo
                
                
        UPDATE  T1
        SET     T1.Dt_Installment_Date = @NewDate
        FROM    dbo.T_Invoice_Child_Detail T1
                INNER JOIN ( SELECT TICD.I_Invoice_Detail_ID ,
                                    TICD.Dt_Installment_Date
                             FROM   dbo.T_Invoice_Child_Header TICH
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                             WHERE  TICH.I_Invoice_Header_ID = @NewRevisedInvoiceID
                                    --AND CONVERT(DATE, TICD.Dt_Installment_Date) = CONVERT(DATE, @dtReviseInvoiceDate)
                                    AND TICD.I_Installment_No=1
                           ) T2 ON T1.I_Invoice_Detail_ID = T2.I_Invoice_Detail_ID
                                   AND T1.Dt_Installment_Date = T2.Dt_Installment_Date
        
        UPDATE  dbo.T_Receipt_Header
        SET     Dt_Upd_On = @NewDate
        WHERE   I_Invoice_Header_ID = @NewRevisedInvoiceID
                AND I_Status = 1
                AND I_Student_Detail_ID = @iStudentDetailID 
                
               UPDATE dbo.T_Invoice_Parent SET Dt_Invoice_Date=@NewDate,Dt_Crtd_On=@NewDate WHERE I_Invoice_Header_ID=@NewRevisedInvoiceID AND I_Student_Detail_ID=@iStudentDetailID
               UPDATE dbo.T_Invoice_Parent SET Dt_Upd_On=@NewDate WHERE I_Invoice_Header_ID=@ParentInvoiceID AND I_Student_Detail_ID=@iStudentDetailID      
    END
    
    SET @i=@i+1
    
    END
    END
