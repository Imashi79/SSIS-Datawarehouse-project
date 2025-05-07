CREATE PROCEDURE dbo.UpdateDimCountry 
    @CountryID INT, 
    @CountryName NVARCHAR(50)
AS 
BEGIN 
    -- If not exists, insert new record
    IF NOT EXISTS (
        SELECT CountrySk 
        FROM dbo.DimCountry 
        WHERE CountryID = @CountryID
    ) 
    BEGIN 
        INSERT INTO dbo.DimCountry 
        (CountryID, CountryName, SrcModifiedDate, InsertDate, ModifiedDate) 
        VALUES 
        (@CountryID, @CountryName, GETDATE(), GETDATE(), GETDATE()) 
    END 
    ELSE
    BEGIN
        -- Always update SrcModifiedDate
        UPDATE dbo.DimCountry
        SET SrcModifiedDate = GETDATE()
        WHERE CountryID = @CountryID;

        -- Only update if data has changed
        IF EXISTS (
            SELECT 1 
            FROM dbo.DimCountry 
            WHERE CountryID = @CountryID
              AND CountryName <> @CountryName
        )
        BEGIN
            UPDATE dbo.DimCountry 
            SET 
                CountryName = @CountryName,
                ModifiedDate = GETDATE()
            WHERE CountryID = @CountryID 
        END
    END 
END
