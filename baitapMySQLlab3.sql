-- yeu cau 1+2
CREATE TABLE Class(
classID int NOT NULL AUTO_INCREMENT ,
className varchar(254) not null,
startDate date not null,
status bit,
Primary key (classID)
);
create table student(
studentID int not null,
studentName varchar(30) not null,
address varchar(50) ,
phone varchar(20),
status bit,
classID int not null,
primary key (studentID)
);
create table subject(
subID int NOT NULL AUTO_INCREMENT ,
subName varchar(30) not null,
credit tinyint not null default 1,
status bit default 1,
check (credit > 1),
primary key (subID)
);
create table mark(
markID int not null AUTO_INCREMENT,
subID int not null,
studentID int not null,
mark float default 0 ,
examTimes tinyint default 1,
check (mark between 0 and 100),
Unique(SubID,StudentID),
primary key (markID)
);
-- yeu cau 3
-- a. Thêm ràng buộc khóa ngoại trên cột ClassID của bảng Student, tham chiếu đến cột ClassID trên bảng Class.
alter table student
add  foreign key (classID) REFERENCES class(classID);
-- b. Thêm ràng buộc cho cột StartDate của bảng Class là ngày hiện hành
  alter table Class alter startDate set default(current_date());
-- c. Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
alter table student alter status set default 1;
-- d Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
-- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
-- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.
alter table mark
add foreign key (subID) references subject(subID),
add foreign key (studentID) references student(studentID);
-- 4. Thêm dữ liệu vào các bảng.
insert into class Values
 (1,'A1','2008/12/20',1),
 (2,'A2','2008/12/22',1),
 (3,'B3', CURRENT_DATE,0);
insert into student VALUES
(1,'Hung','Ha Noi','0912113113',1,1),
(2,'Hoa','Hai Phong','',1,1),
(3,'Manh','HCM','0123123123',0,2);
insert into subject values
(1,'CF',5,1),
(2,'C',6,1),
(3,'HDJ',5,1),
(4,'RBDMS',10,1);
insert into mark values
(1,1,1,8,1),
(2,1,2,10,2),
(3,2,1,12,1);
-- 5. Cập nhật dữ liệu.
-- a. Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update student
set classID=2
where studentName = 'Hung';
-- b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên
-- chưa có số điện thoại.
update student
set phone ='No phone'
where phone ='' or phone is null ;
-- c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
-- (Chú ý: phải sử dụng phương thức write).
Update Class
set className = concat('New',className)
Where Status =0;
-- d.Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
-- (Chú ý: phải sử dụng phương thức write)
update class
set className = replace(className,'New','Old')
where status = 1 and className like 'New%';
-- e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
update class
set status = 0
where classID is null;
-- f.Cập nhật trạng thái của lop học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
update subject
set status = 0
where subID is null ;
-- 6.	Hiện thị thông tin.
-- a.	Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select *
from student
where studentName like 'h%';
-- b.Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select *
from Class
where month(startDate)=12;
-- c.Hiển thị giá trị lớn nhất của credit trong bảng subject.
select max(credit) as max_of_credit
from subject;
-- d.Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select *
from subject
where credit between 3 and 5;
-- f. Hiển thị các thông tin bao gồm: classid, className, studentname, Address
-- từ hai bảng Class, student
SELECT   Class.ClassID, Class.ClassName, Student.StudentName, Student.Address
from  Class INNER JOIN
Student ON Class.ClassID = Student.ClassID;
-- g.Hiển thị các thông tin môn học chưa có sinh viên dự thi.
select *
from subject
where subID is null ;
-- h. Hiển thị các thông tin môn học có điểm thi lớn nhất.
select  Subject.*
from Subject INNER JOIN  Mark ON Subject.SubID = Mark.SubID
Where Mark = (Select Max(Mark.mark) from mark );
-- i. Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
select student.studentID, studentname,address,status,phone,classID, avg(mark) as diemTB
 from student left join mark
 on student.studentID=mark.studentId
 group by student.studentID;
-- j. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp
-- hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
 select student.studentID, studentname,address,phone,status,classID, avg(mark) as diemTB,
 rank() over ( order by avg(mark )  DESC  ) as Hang
 from student left join mark
 on student.studentID=mark.studentId
 group by student.studentID;
-- k. Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh
-- viên có điểm trung bình lớn hơn 10.
select student.studentID, studentname,address,status,phone,classID, avg(mark) as diemTB
 from student left join mark
 on student.studentID=mark.studentId
 group by student.studentID
having avg(mark) > 10;
-- l. Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp
-- theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
 select student.studentname, subname,mark
 from student join mark
 on student.studentID= mark.studentID
 join subject on mark.subID =subject.subID
 order by mark.mark DESC, student.studentname asc;
-- 7. Xóa dữ liệu.
-- a. Xóa tất cả các lớp có trạng thái là 0.
 delete from class
 where status=0;
-- b. Xóa tất cả các môn học chưa có sinh viên dự thi.
 delete from subject
 where subID is null ;
-- 8. Thay đổi.
-- a. Xóa bỏ cột ExamTimes trên bảng Mark.
alter table mark
 drop column examtimes;
-- b. Sửa đổi cột status trên bảng class thành tên ClassStatus.
 alter table class
 change status ClassStatus bit;
-- c. Đổi tên bảng Mark thành SubjectTest.
 rename table mark to SubjectTest;
-- d. Chuyển cơ sở dữ liệu hiện hành sang cơ sở dữ liệu Master.
use Master;
-- e. Xóa bỏ cơ sở dữ liệu vùa tạo.( &lt;Họ tên học viên&gt;_&lt;Tên máy&gt;)
 drop database lap3;