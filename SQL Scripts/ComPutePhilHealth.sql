CREATE FUNCTION dbo.ComputePhilHealth(@MonthlySalary float, @AverageWorkDaysAMonth float, @TotalDays float)
RETURNS FLOAT
AS
BEGIN
IF @MonthlySalary < 10000
	SET @MonthlySalary = 10000
ELSE 
BEGIN 
	IF @MonthlySalary > 40000
		SET @MonthlySalary = 40000
END
declare @PhilHealthRate float;
set @PhilHealthRate = (select PercentageRate from ContributionType where Name='PhilHealth')
return round(@MonthlySalary*@PhilHealthRate/2/@AverageWorkDaysAMonth*@TotalDays,2)
END
