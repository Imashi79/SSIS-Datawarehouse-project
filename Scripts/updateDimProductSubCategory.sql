CREATE PROCEDURE dbo.UpdateDimProductSubCategory 
    @SubCategoryID INT,
    @SubCategoryName NVARCHAR(100),
    @CategoryID INT
AS
BEGIN
    -- If the subcategory doesn't exist, insert it
    IF NOT EXISTS (
        SELECT SubCategorySK 
        FROM dbo.DimProductSubCategory 
        WHERE SubCategoryID = @SubCategoryID
    )
    BEGIN
        INSERT INTO dbo.DimProductSubCategory 
        (SubCategoryID, SubCategoryName, CategoryID, 
         SrcModifiedDate, InsertDate, ModifiedDate)
        VALUES 
        (@SubCategoryID, @SubCategoryName, @CategoryID, GETDATE(), GETDATE(), GETDATE())
    END
    ELSE
    BEGIN
        -- Always update SrcModifiedDate
        UPDATE dbo.DimProductSubCategory
        SET SrcModifiedDate = GETDATE()
        WHERE SubCategoryID = @SubCategoryID;

        -- Update only if values changed, then also update ModifiedDate
        IF EXISTS (
            SELECT 1 
            FROM dbo.DimProductSubCategory 
            WHERE SubCategoryID = @SubCategoryID
              AND (
                    SubCategoryName <> @SubCategoryName OR 
                    CategoryID <> @CategoryID
                  )
        )
        BEGIN
            UPDATE dbo.DimProductSubCategory 
            SET 
                SubCategoryName = @SubCategoryName,
                CategoryID = @CategoryID,
                ModifiedDate = GETDATE()
            WHERE SubCategoryID = @SubCategoryID
        END
    END
END
