create function dbo.ComputeSSS(@MonthlySalary float, @AverageWorkDaysAMonth float,@TotalDays float)
returns float
as
BEGIN
declare @MSC as float
declare @SSSRate as float
set @SSSRate = (select ContributionType.PercentageRate from ContributionType where Name='SSS') -- get rate from contributionstypetable

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
return round(@MSC*@SSSRATE/@AverageWorkDaysAMonth*@TotalDays,2)
END

select dbo.ComputeSSS(30000,21.75,22)