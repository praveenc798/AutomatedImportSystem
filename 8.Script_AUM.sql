DROP TABLE IF EXISTS tbl_import_Data

DECLARE @Column VARCHAR(MAX)
SELECT @Column = COALESCE(@Column + ',' + CONCAT('[' , COLUMN_NAME, ']') , CONCAT('[' , COLUMN_NAME, ']')) 
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = 'tbl_AUM_Data'
	AND COLUMN_NAME NOT LIKE '%FUND%'
ORDER BY CAST(REPLACE(RIGHT(COLUMN_NAME,8),'_',' ') AS DATE)

DECLARE @SQL VARCHAR(MAX)
DECLARE @SQL1 VARCHAR(MAX)

SET @SQL = 
'SELECT F.FundName,' + @Column + 
' into tbl_import_Data FROM tbl_AUM_Data D
INNER JOIN tbl_Funds F ON D.FundId = F.FundId'

EXEC (@SQL)

SELECT * FROM tbl_import_Data
