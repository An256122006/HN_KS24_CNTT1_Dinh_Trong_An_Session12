CREATE DATABASE if not exists StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department
(
    DeptID   CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student
(
    StudentID CHAR(6) PRIMARY KEY,
    FullName  VARCHAR(50),
    Gender    VARCHAR(10),
    BirthDate DATE,
    DeptID    CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department (DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course
(
    CourseID   CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits    INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment
(
    StudentID CHAR(6),
    CourseID  CHAR(6),
    Score     FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student (StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course (CourseID)
);
INSERT INTO Department
VALUES ('IT', 'Information Technology'),
       ('BA', 'Business Administration'),
       ('ACC', 'Accounting');

INSERT INTO Student
VALUES ('S00001', 'Nguyen An', 'Male', '2003-05-10', 'IT'),
       ('S00002', 'Tran Binh', 'Male', '2003-06-15', 'IT'),
       ('S00003', 'Le Hoa', 'Female', '2003-08-20', 'BA'),
       ('S00004', 'Pham Minh', 'Male', '2002-12-12', 'ACC'),
       ('S00005', 'Vo Lan', 'Female', '2003-03-01', 'IT'),
       ('S00006', 'Do Hung', 'Male', '2002-11-11', 'BA'),
       ('S00007', 'Nguyen Mai', 'Female', '2003-07-07', 'ACC'),
       ('S00008', 'Tran Phuc', 'Male', '2003-09-09', 'IT');

INSERT INTO Course
VALUES ('C00001', 'Database Systems', 3),
       ('C00002', 'C Programming', 3),
       ('C00003', 'Microeconomics', 2),
       ('C00004', 'Financial Accounting', 3);

INSERT INTO Enrollment
VALUES ('S00001', 'C00001', 8.5),
       ('S00001', 'C00002', 7.0),
       ('S00002', 'C00001', 6.5),
       ('S00003', 'C00003', 7.5),
       ('S00004', 'C00004', 8.0),
       ('S00005', 'C00001', 9.0),
       ('S00006', 'C00003', 6.0),
       ('S00007', 'C00004', 7.0),
       ('S00008', 'C00001', 5.5),
       ('S00008', 'C00002', 6.5);
create view StudentBasic as
select s.StudentID,
       s.FullName,
       d.DeptName
from student s
join Department d on d.DeptID=s.DeptID;
select * from StudentBasic;
create index Regularindex on student(FullName);
drop procedure if exists  GetStudentsIT;
delimiter $$
create procedure GetStudentsIT()
begin
select *  from student s
    join Department d on d.DeptID=s.DeptID
    where d.DeptID='IT';
end $$;
call GetStudentsIT();
drop view if exists  View_StudentCountByDept;
create view View_StudentCountByDept as
    select d.DeptName,count(S.DeptID) as total_student  from department d
join Student join Student S on d.DeptID = S.DeptID
group by d.DeptName;
select * from View_StudentCountByDept;
select * from View_StudentCountByDept
order by total_student desc
limit 1;
drop procedure if exists GetTopScoreStudent;
delimiter $$
create procedure GetTopScoreStudent (in p_CourseID char(6),out Student_name varchar(255))
begin
    declare topscore int default 0;
    select MAX(e.Score) into topscore from enrollment e
    join course c on e.CourseID=p_CourseID;

    select s.FullName into Student_name from Student s
    join enrollment e on e.StudentID=s.StudentID
    where e.Score=topscore;
end $$;
set @fullname='';
call GetTopScoreStudent('C00001',@fullname);
select @fullname;


