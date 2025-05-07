CREATE PROCEDURE dbo.UpdateDimProductCategory 
    @CategoryID INT, 
    @CategoryName NVARCHAR(100)
AS 
BEGIN 
    -- If not exists, insert new record
    IF NOT EXISTS (
        SELECT ProduckCategorySK 
        FROM dbo.DimProductCategory 
        WHERE CategoryID = @CategoryID
    ) 
    BEGIN 
        INSERT INTO dbo.DimProductCategory 
        (CategoryID, CategoryName, SrcModifiedDate, InsertDate, ModifiedDate) 
        VALUES 
        (@CategoryID, @CategoryName, GETDATE(), GETDATE(), GETDATE()) 
    END 
    ELSE
    BEGIN
        -- Always update SrcModifiedDate
        UPDATE dbo.DimProductCategory
        SET SrcModifiedDate = GETDATE()
        WHERE CategoryID = @CategoryID;

        -- Only update if data has changed
        IF EXISTS (
            SELECT 1 
            FROM dbo.DimProductCategory 
            WHERE CategoryID = @CategoryID
              AND CategoryName <> @CategoryName
        )
        BEGIN
            UPDATE dbo.DimProductCategory 
            SET 
                CategoryName = @CategoryName,
                ModifiedDate = GETDATE()
            WHERE CategoryID = @CategoryID 
        END
    END 
END
