create function dbo.ComputeSSS(@MonthlySalary float,@TotalDays float)
returns float
as
BEGIN
declare @MSC as float
declare @SSSRate as float
set @SSSRate = (select ContributionType.PercentageRate from ContributionType where Name='SSS')

IF @MonthlySalary < 2250
	set @MSC = 2000.00;
ELSE
	BEGIN
		IF @MonthlySalary >= 19750
		set @MSC = 20000.00;
		ELSE
			BEGIN			
				set @MSC = round(@MonthlySalary/500,0)*500 -- round off by 500 to get to nearest MSC
			END
	END
return @MSC*@SSSRATE/30*@TotalDays
END