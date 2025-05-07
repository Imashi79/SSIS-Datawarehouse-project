CREATE PROCEDURE dbo.CleanStgProductForDimLoad
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the StgProduct table with empty spaces replaced by 'NULL' for specific columns
    UPDATE dbo.StgProduct
    SET 
        SubCategoryID = ISNULL(NULLIF(SubCategoryID, ''), -1),  -- Replace NULL with default value (-1)
        Color = CASE 
                    WHEN LTRIM(RTRIM(Color)) = '' THEN 'NULL' 
                    ELSE Color 
                END,  -- Replace empty space with 'NULL'
        Sizes = CASE 
                    WHEN LTRIM(RTRIM(Sizes)) = '' THEN 'NULL' 
                    ELSE Sizes 
                END,  -- Replace empty space with 'NULL'
        DescriptionPT = CASE 
                            WHEN LTRIM(RTRIM(DescriptionPT)) = '' THEN 'NULL' 
                            ELSE DescriptionPT 
                        END,  -- Replace empty space with 'NULL'
        DescriptionDE = CASE 
                            WHEN LTRIM(RTRIM(DescriptionDE)) = '' THEN 'NULL' 
                            ELSE DescriptionDE 
                        END,  -- Replace empty space with 'NULL'
        DescriptionFR = CASE 
                            WHEN LTRIM(RTRIM(DescriptionFR)) = '' THEN 'NULL' 
                            ELSE DescriptionFR 
                        END,  -- Replace empty space with 'NULL'
        DescriptionES = CASE 
                            WHEN LTRIM(RTRIM(DescriptionES)) = '' THEN 'NULL' 
                            ELSE DescriptionES 
                        END,  -- Replace empty space with 'NULL'
        DescriptionEN = CASE 
                            WHEN LTRIM(RTRIM(DescriptionEN)) = '' THEN 'NULL' 
                            ELSE DescriptionEN 
                        END,  -- Replace empty space with 'NULL'
        DescriptionZH = CASE 
                            WHEN LTRIM(RTRIM(DescriptionZH)) = '' THEN 'NULL' 
                            ELSE DescriptionZH 
                        END   -- Replace empty space with 'NULL'
    WHERE 
        -- Add a condition if needed (e.g., check for rows with empty spaces)
        LTRIM(RTRIM(Color)) = '' 
        OR LTRIM(RTRIM(Sizes)) = '' 
        OR LTRIM(RTRIM(DescriptionPT)) = '' 
        OR LTRIM(RTRIM(DescriptionDE)) = '' 
        OR LTRIM(RTRIM(DescriptionFR)) = '' 
        OR LTRIM(RTRIM(DescriptionES)) = '' 
        OR LTRIM(RTRIM(DescriptionEN)) = '' 
        OR LTRIM(RTRIM(DescriptionZH)) = '';
END;


drop PROCEDURE dbo.CleanStgProductForDimLoad

select * 
from StgProduct