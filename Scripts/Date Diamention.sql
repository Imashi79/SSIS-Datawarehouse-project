-- Step 1: Create the DimDate table
CREATE TABLE [dbo].[DimDate] (
    DateKey INT PRIMARY KEY,                -- YYYYMMDD format
    [Date] DATETIME NOT NULL,               -- The actual date
    [Day] TINYINT,                          -- Day of the month (1-31)
    [Month] TINYINT,                        -- Month (1-12)
    [MonthName] VARCHAR(20),                -- Full month name (January, February, etc.)
    [Year] SMALLINT,                        -- Year (e.g., 2025)
    [Quarter] TINYINT,                      -- Quarter (1-4)
    [DayOfWeek] TINYINT,                    -- Day of the week (1 = Sunday, 7 = Saturday)
    [WeekdayName] VARCHAR(20),              -- Day name (Monday, Tuesday, etc.)
    [IsWeekend] BIT,                        -- Flag indicating if the date is a weekend (1 = Weekend, 0 = Weekday)
    [WeekOfYear] TINYINT,                   -- Week number within the year (1-53)
    [DayOfYear] SMALLINT,                   -- Day of the year (1-365 or 366)
    [WeekOfMonth] TINYINT,                  -- Week number within the month (1-5)
    [IsHoliday] BIT,                        -- Flag indicating if the date is a holiday
    [IsWorkday] BIT                         -- Flag indicating if the date is a workday (1 = workday, 0 = weekend/holiday)
);
GO


-- Step 2: Populate the table with your required date range

DECLARE @StartDate DATETIME = '2024-01-01';  -- Starting date
DECLARE @EndDate DATETIME = '2025-12-31';    -- Ending date
DECLARE @CurrentDate DATETIME = @StartDate;  -- Initialize current date

-- Loop through each date from StartDate to EndDate
WHILE @CurrentDate <= @EndDate
BEGIN
    -- Insert a new record for each date
    INSERT INTO [dbo].[DimDate] (
        DateKey, 
        [Date], 
        [Day], 
        [Month], 
        [MonthName], 
        [Year], 
        [Quarter], 
        [DayOfWeek], 
        [WeekdayName], 
        [IsWeekend], 
        [WeekOfYear], 
        [DayOfYear], 
        [WeekOfMonth], 
        [IsHoliday], 
        [IsWorkday]
    )
    VALUES (
        CONVERT(INT, CONVERT(VARCHAR, YEAR(@CurrentDate)) + 
            RIGHT('00' + CONVERT(VARCHAR, MONTH(@CurrentDate)), 2) + 
            RIGHT('00' + CONVERT(VARCHAR, DAY(@CurrentDate)), 2)),  -- DateKey in YYYYMMDD format
        @CurrentDate,  -- Actual date
        DAY(@CurrentDate),  -- Day of the month (1-31)
        MONTH(@CurrentDate),  -- Month (1-12)
        DATENAME(MONTH, @CurrentDate),  -- Full month name (e.g., January)
        YEAR(@CurrentDate),  -- Year (e.g., 2025)
        DATEPART(QUARTER, @CurrentDate),  -- Quarter (1-4)
        DATEPART(WEEKDAY, @CurrentDate),  -- Day of the week (1 = Sunday)
        DATENAME(WEEKDAY, @CurrentDate),  -- Weekday name (e.g., Monday)
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 1 ELSE 0 END,  -- IsWeekend (1 = Weekend, 0 = Weekday)
        DATEPART(WEEK, @CurrentDate),  -- Week of the year (1-53)
        DATEPART(DAYOFYEAR, @CurrentDate),  -- Day of the year (1-365/366)
        (DATEPART(WEEK, @CurrentDate) - ((DATEPART(DAY, @CurrentDate) - 1) / 7)),  -- Week of the month (1-5)
        0,  -- IsHoliday (set to 0, can be updated with custom logic or holiday calendar)
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) OR 0 = 1 THEN 0 ELSE 1 END  -- IsWorkday (1 = workday, 0 = weekend/holiday)
    );

    -- Move to the next day
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;
GO



select * from [dbo].[DimDate]