USE BlockStone_Capital
GO

CREATE OR
	ALTER PROCEDURE [dbo].[Up_Insert_Additional_Column_Data]
( @TableName nvarchar(150))
AS

SET ANSI_WARNINGS OFF

DECLARE @ErrorMessage NVARCHAR(4000);  
DECLARE @ErrorSeverity INT;  
DECLARE @ErrorState INT;

BEGIN TRY

DROP TABLE IF EXISTS tbl_tmp_Additional_Column
DROP TABLE IF EXISTS tbl_Additional_Column_Data

DECLARE @ColumnSQL VARCHAR(MAX)
DECLARE @UpdateValue VARCHAR(MAX)
DECLARE @Column VARCHAR(MAX)
DECLARE @Row VARCHAR(MAX)

DECLARE @VALUE VARCHAR(MAX); 
SELECT @VALUE = COALESCE(@VALUE + ' ' + CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(1000);') , CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(1000);')) 
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = @TableName
	AND COLUMN_NAME NOT LIKE '%Monthly_Return%'
	AND COLUMN_NAME NOT LIKE '%Monthly_NAV%'
	AND COLUMN_NAME NOT LIKE '%Monthly_AUM%'
	AND COLUMN_NAME NOT IN (
							'Management_Company',
							'Fund_Name',
							'ISIN_or_Ref_Code',
							'Fund_Id',
							'Portfolio_manager',
							'CEO_or_COO',
							'Marketing_manager',
							'Head_Trader',
							'Primary_contact',
							'Telephone',
							'Contact_email_address',
							'Address_1',
							'Address_2',
							'City',
							'Zip_Post_Code',
							'Country',
							'General_Email_Address',
							'Website',
							'Administrator',
							'Prime_Broker',
							'Legal_Advisors',
							'Auditor',
							'Fund_Capacity_US_m',
							'Total_Group_Assets_US_m',
							'Fund_Type',
							'Fund_Duration',
							'Approaches',
							'Sectors',
							'Market_Caps',
							'Regions',
							'Countries',
							'AUM_US_m',
							'Currency',
							'Domicile',
							'Strategies',
							'Strategy_Description',
							'Hurdle_Rate',
							'High_Water_Mark',
							'Minimum_Investment',
							'Management_Fee',
							'Performance_Fee',
							'Subscription_Terms',
							'Redemption_Terms'
							)
ORDER BY COLUMN_NAME

EXEC (@VALUE)

SELECT @Column = COALESCE(@Column + ',' + CONCAT('[' , COLUMN_NAME, ']') , CONCAT('[' , COLUMN_NAME, ']')) 
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = @TABLENAME
AND COLUMN_NAME NOT LIKE '%Monthly_Return%'
	AND COLUMN_NAME NOT LIKE '%Monthly_NAV%'
	AND COLUMN_NAME NOT LIKE '%Monthly_AUM%'
	AND COLUMN_NAME NOT IN (
							'Management_Company',
							'Fund_Name',
							'ISIN_or_Ref_Code',
							'Fund_Id',
							'Portfolio_manager',
							'CEO_or_COO',
							'Marketing_manager',
							'Head_Trader',
							'Primary_contact',
							'Telephone',
							'Contact_email_address',
							'Address_1',
							'Address_2',
							'City',
							'Zip_Post_Code',
							'Country',
							'General_Email_Address',
							'Website',
							'Administrator',
							'Prime_Broker',
							'Legal_Advisors',
							'Auditor',
							'Fund_Capacity_US_m',
							'Total_Group_Assets_US_m',
							'Fund_Type',
							'Fund_Duration',
							'Approaches',
							'Sectors',
							'Market_Caps',
							'Regions',
							'Countries',
							'AUM_US_m',
							'Currency',
							'Domicile',
							'Strategies',
							'Strategy_Description',
							'Hurdle_Rate',
							'High_Water_Mark',
							'Minimum_Investment',
							'Management_Fee',
							'Performance_Fee',
							'Subscription_Terms',
							'Redemption_Terms'
							)
ORDER BY COLUMN_NAME

IF(@Column > '')
BEGIN
	DECLARE @SQL VARCHAR(Max)
	SET @SQL =
	'SELECT Fund_Id, Key_Value, Data_Value INTO tbl_tmp_Additional_Column
	FROM 
	   (SELECT Fund_Id,' + @Column +
	   'FROM dbo.[' + @TABLENAME + ']) p UNPIVOT
	   (Data_Value FOR Key_Value IN 
		  (' + @Column + ')
	)AS unpvt'

	EXEC (@SQL)

	UPDATE A
	SET A.Data_Value = T.Data_Value
	FROM tbl_Additional_Column A
	INNER JOIN tbl_tmp_Additional_Column T
	ON T.Fund_Id = A.FundId
		AND T.Data_Value <> A.Data_Value
		AND T.Key_Value = A.key_Value

	INSERT INTO tbl_Additional_Column(FundId, Key_Value, Data_Value)
	SELECT * 
	FROM tbl_tmp_Additional_Column A
	WHERE NOT EXISTS (
						SELECT TOP 1 1
						FROM dbo.tbl_Additional_Column T
						WHERE T.FundId = A.Fund_Id
							AND T.key_Value = A.key_Value
					  )

	SELECT @Row = COALESCE(@Row + ',' + CONCAT('[' , key_value, ']') , CONCAT('[' , key_value, ']')) 
	FROM tbl_Additional_Column
	GROUP BY key_Value

	SET @ColumnSQL =
					'SELECT * INTO tbl_Additional_Column_Data FROM   
					(SELECT FundId, key_Value, Data_Value  
					FROM tbl_Additional_Column) p  
					PIVOT  
					(  
					MAX(Data_Value) 
					FOR key_Value IN  
					(' + @Row +  ')  
					) AS pvt
					ORDER BY pvt.FundId'

	EXEC (@ColumnSQL)

	SELECT @UpdateValue = COALESCE(@UpdateValue+ ('UPDATE ' + table_name + ' SET [' + column_name + '] = '''' WHERE [' + column_name + '] IS NULL '),('UPDATE ' + table_name + ' SET [' + column_name + '] = '''' WHERE [' + column_name + '] IS NULL '))
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE table_name = 'tbl_Additional_Column_Data'
		AND COLUMN_NAME <> 'FundId'

	EXEC (@UpdateValue)

	CREATE NONCLUSTERED INDEX [IX_tbl_Additional_Column_Data_FundID]
	ON tbl_Additional_Column_Data (FundId ASC)

END
END TRY

BEGIN CATCH 

	    SET @ErrorMessage = 'The SP Up_Insert_Additional_Column_Data errored out due to ' + ERROR_MESSAGE()
        SET @ErrorSeverity = ERROR_SEVERITY();  
        SET @ErrorState = ERROR_STATE();  
  
    RAISERROR (@ErrorMessage,   
               @ErrorSeverity, 
               @ErrorState 
               );  
END CATCH