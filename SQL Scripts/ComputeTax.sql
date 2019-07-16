create function dbo.ComputeTax(@DeductedMonthlySalary float,@TotalDays float)
returns float
as
begin
declare @TaxPercentRate as float = 0;
declare @CLAmount as float = 0;
declare @Total as float = 0;

if @DeductedMonthlySalary <= 20833
	set @TaxPercentRate = 0;
if @DeductedMonthlySalary > 20833 and @DeductedMonthlySalary < 33333
	begin
	set @TaxPercentRate = 0.2;
	set @CLAmount = 20833;
	end
if @DeductedMonthlySalary >= 33333 and @DeductedMonthlySalary < 66667
	begin
	set @Total = 2500;
	set @TaxPercentRate = 0.25;
	set @CLAmount = 33333;
	end
if @DeductedMonthlySalary >= 66667 and @DeductedMonthlySalary < 166667
	begin
	set @Total = 10833.33;
	set @TaxPercentRate = 0.30;
	set @CLAmount = 66667;
	end
if @DeductedMonthlySalary >= 166667 and @DeductedMonthlySalary < 666667
	begin
	set @Total = 40833.33
	set @TaxPercentRate = 0.32;
	set @CLAmount = 166667;
	end
if @DeductedMonthlySalary >= 666667
	begin
	set @Total = 200833.33
	set @TaxPercentRate = 0.35;
	set @CLAmount = 666667;
	end

return ((@DeductedMonthlySalary-@CLAmount)*@TaxPercentRate+@Total)/30*@TotalDays;
end