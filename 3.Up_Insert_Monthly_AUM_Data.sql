USE BlockStone_Capital
GO

CREATE OR
ALTER PROCEDURE [dbo].[Up_Insert_Monthly_AUM_Data]
( @TableName nvarchar(150))
AS

DECLARE @ErrorMessage NVARCHAR(4000);  
DECLARE @ErrorSeverity INT;  
DECLARE @ErrorState INT;

BEGIN TRY

DROP TABLE IF EXISTS tbl_tmp_AUM
DROP TABLE IF EXISTS tbl_AUM_Data

DECLARE @Column VARCHAR(MAX)
DECLARE @RowSQL VARCHAR(MAX)
DECLARE @UpdateValue VARCHAR(MAX)
DECLARE @Row VARCHAR(MAX)

SELECT @Column = COALESCE(@Column + ',' + CONCAT('[' , COLUMN_NAME, ']') , CONCAT('[' , COLUMN_NAME, ']')) 
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = @TABLENAME
	AND COLUMN_NAME LIKE '%Monthly_AUM%'
ORDER BY COLUMN_NAME

DECLARE @SQL VARCHAR(Max)
SET @SQL =
			'SELECT Fund_Id, Key_Value, Data_Value INTO tbl_tmp_AUM
			FROM 
			   (SELECT Fund_Id,' + @Column +
			   'FROM dbo.[' + @TABLENAME + ']) p UNPIVOT
			   (Data_Value FOR Key_Value IN 
				  (' + @Column + ')
			)AS unpvt'

EXEC (@SQL)

UPDATE A
SET A.Data_Value = T.Data_Value
FROM tbl_Monthly_AUM A
INNER JOIN tbl_tmp_AUM T
ON T.Fund_Id = A.FundId
	AND T.Data_Value <> A.Data_Value
	AND T.Key_Value = A.key_Value

INSERT INTO tbl_Monthly_AUM(FundId, Key_Value, Data_Value)
SELECT * 
FROM tbl_tmp_AUM A
WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM dbo.tbl_Monthly_AUM T
					WHERE T.FundId = A.Fund_Id
						AND T.Key_Value = A.key_Value
				  )


SELECT @Row = COALESCE(@Row + ',' + CONCAT('[' , key_value, ']') , CONCAT('[' , key_value, ']')) 
FROM tbl_Monthly_AUM
GROUP BY key_Value

SET @RowSQL =
				'SELECT * INTO tbl_AUM_Data FROM   
				(SELECT FundId, key_Value, Data_Value  
				FROM tbl_Monthly_AUM) p  
				PIVOT  
				(  
				MAX(Data_Value) 
				FOR key_Value IN  
				(' + @Row +  ')  
				) AS pvt
				ORDER BY pvt.FundId'

EXEC (@RowSQL)

SELECT @UpdateValue = COALESCE(@UpdateValue + ('UPDATE ' + table_name + ' SET [' + column_name + '] = '''' WHERE [' + column_name + '] IS NULL '),('UPDATE ' + table_name + ' SET [' + column_name + '] = '''' WHERE [' + column_name + '] IS NULL '))
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'tbl_AUM_Data'
	AND COLUMN_NAME <> 'FundId'

EXEC (@UpdateValue)

CREATE NONCLUSTERED INDEX [IX_tbl_AUM_Data]
ON tbl_AUM_Data (FundId ASC)

END TRY

BEGIN CATCH 

	    SET @ErrorMessage = 'The SP Up_Insert_Monthly_AUM_Data errored out due to ' + ERROR_MESSAGE()
        SET @ErrorSeverity = ERROR_SEVERITY();  
        SET @ErrorState = ERROR_STATE();  
  
    RAISERROR (@ErrorMessage,   
               @ErrorSeverity, 
               @ErrorState 
               );  
END CATCH