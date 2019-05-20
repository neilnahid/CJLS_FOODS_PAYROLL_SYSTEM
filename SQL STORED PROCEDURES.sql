create procedure sp_checkLogin
@username varchar(50),
@password varchar(50)
AS
select * from tbl_Users where tbl_Users.Username = @username and tbl_Users.[Password] = @password

insert into tbl_Users(Username,[Password])


insert into tbl_Employees(FirstName,LastName,DateOfBirth,Gender,AvailableLeaves,EmployeeTypeID)
values('Nahid','Neil',null,'Male',5,100)

select * from tbl_EmployeeTypes

insert into tbl_EmployeeTypes
values('Payroll Officer',20000)