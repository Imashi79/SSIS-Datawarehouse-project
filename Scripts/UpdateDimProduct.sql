CREATE PROCEDURE dbo.UpdateDimProduct 
    @ProductID INT,
    @SubCategoryID INT,
    @Color NVARCHAR(100),
    @Sizes NVARCHAR(100),
    @DescriptionPT NVARCHAR(MAX),
    @DescriptionDE NVARCHAR(MAX),
    @DescriptionFR NVARCHAR(MAX),
    @DescriptionES NVARCHAR(MAX),
    @DescriptionEN NVARCHAR(MAX),
    @DescriptionZH NVARCHAR(MAX),
    @ProductionCost DECIMAL(18,2)
AS
BEGIN
    -- Insert if the product does not exist
    IF NOT EXISTS (
        SELECT ProductSk 
        FROM dbo.DimProducts 
        WHERE ProductID = @ProductID
    )
    BEGIN
        INSERT INTO dbo.DimProducts 
        (
            ProductID, SubCategoryID, Color, Sizes,
            DescriptionPT, DescriptionDE, DescriptionFR, DescriptionES,
            DescriptionEN, DescriptionZH, ProductionCost,
            SrcModifiedDate, InsertDate, ModifiedDate
        )
        VALUES 
        (
            @ProductID, @SubCategoryID, @Color, @Sizes,
            @DescriptionPT, @DescriptionDE, @DescriptionFR, @DescriptionES,
            @DescriptionEN, @DescriptionZH, @ProductionCost,
            GETDATE(), GETDATE(), GETDATE()
        )
    END
    ELSE
    BEGIN
        -- Check if any relevant data has changed
        IF EXISTS (
            SELECT 1
            FROM dbo.DimProducts
            WHERE ProductID = @ProductID
              AND (
                    SubCategoryID <> @SubCategoryID OR
                    Color <> @Color OR
                    Sizes <> @Sizes OR
                    DescriptionPT <> @DescriptionPT OR
                    DescriptionDE <> @DescriptionDE OR
                    DescriptionFR <> @DescriptionFR OR
                    DescriptionES <> @DescriptionES OR
                    DescriptionEN <> @DescriptionEN OR
                    DescriptionZH <> @DescriptionZH OR
                    ProductionCost <> @ProductionCost
                 )
        )
        BEGIN
            UPDATE dbo.DimProducts 
            SET 
                SubCategoryID = @SubCategoryID,
                Color = @Color,
                Sizes = @Sizes,
                DescriptionPT = @DescriptionPT,
                DescriptionDE = @DescriptionDE,
                DescriptionFR = @DescriptionFR,
                DescriptionES = @DescriptionES,
                DescriptionEN = @DescriptionEN,
                DescriptionZH = @DescriptionZH,
                ProductionCost = @ProductionCost,
                SrcModifiedDate = GETDATE(),
                ModifiedDate = GETDATE()
            WHERE ProductID = @ProductID
        END
        ELSE
        BEGIN
            -- No change in data → only update source modified date
            UPDATE dbo.DimProducts 
            SET SrcModifiedDate = GETDATE()
            WHERE ProductID = @ProductID
        END
    END
END

DROP PROCEDURE dbo.UpdateDimProduct;
