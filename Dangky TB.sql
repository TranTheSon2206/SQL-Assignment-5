use master
go
if EXISTS (select * from sys.databases where name='DKThueBao')
drop database DKThueBao
go
create database DKThueBao
go
use DKThueBao
create table ThongtinKH(
	MaKH int primary key,
	Socmt int,
	Ten nvarchar(20) not null,
	Diachi nvarchar(40) null,
	);
create table ThuebaoKH(
	MaTB int,
	MaKH int,
	LoaiTB nvarchar(10) check (LoaiTB='tra truoc' or LoaiTB='tra sau') default 'tra truoc',
	NgayDK datetime default getdate(),
	Sothuebao int ,
	constraint FK_MaKH foreign key (MaKH) references ThongtinKH(MaKH) on delete cascade,
	constraint pk_ThuebaoKH primary key (MaKH,MaTB)
	);

	--Chèn thêm dữ liệu tương tự như đề bài
	insert into ThongtinKH values('001','123456789','Nguyen Nguyet Nga','Hanoi');
	insert into ThongtinKH values('002','984123567','Tran The Son','Hanoi');
	insert into ThongtinKH values('003','752365419','Vu Hai Linh','QuangNinh');
	insert into ThongtinKH values('004','564713388','Le Van Tho','NamDinh');

	insert into ThuebaoKH values('110','001','tra truoc','2002-12-12','123456789');
	insert into ThuebaoKH values('111','001','tra sau','2002-12-12','233567799');
	insert into ThuebaoKH values('112','002','tra truoc','2003-02-23','456621411');
	insert into ThuebaoKH values('113','003','tra truoc','2003-02-23','456621136');
	insert into ThuebaoKH values('114','003','tra sau','2004-02-23','454421411');
	insert into ThuebaoKH values('115','004','tra sau','2003-02-23','091247723');
	insert into ThuebaoKH values('116','003','tra sau','2003-06-06','556621411');

	--4. Viết các câu lênh truy vấn để
	--a) Hiển thị toàn bộ thông tin của các khách hàng của công ty.
	select * from ThongtinKH

	--b) Hiển thị toàn bộ thông tin của các số thuê bao của công ty.
	select * from ThuebaoKH

	--5. Viết các câu lệnh truy vấn để lấy
	--a) Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
	select * from ThuebaoKH full join ThongtinKH on ThuebaoKH.MaKH=ThongtinKH.MaKH 
	where ThuebaoKH.Sothuebao='123456789'

	--b) Hiển thị thông tin về khách hàng có số CMTND: 123456789
	select * from ThongtinKH 
	where ThongtinKH.Socmt='123456789'

	--c) Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
	select ThuebaoKH.Sothuebao, ThongtinKH.Socmt from ThuebaoKH full join ThongtinKH on ThuebaoKH.MaKH=ThongtinKH.MaKH 
	where ThongtinKH.Socmt='123456789'

	--d) Liệt kê các thuê bao đăng ký vào ngày 03/02/23
	select * from ThuebaoKH where ThuebaoKH.NgayDK='2003-02-23'

	--e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
	select * from ThuebaoKH full join ThongtinKH on ThongtinKH.MaKH=ThuebaoKH.MaKH
	where ThongtinKH.Diachi='Hanoi'

	--6. Viết các câu lệnh truy vấn để lấy
	--a) Tổng số khách hàng của công ty.
	select count(ThongtinKH.MaKH) as 'TongSoKH' from ThongtinKH 

	--b) Tổng số thuê bao của công ty.
	select count(ThuebaoKH.MaTB) as 'TongSoTB' from ThuebaoKH

	--c) Tổng số thuê bào đăng ký ngày 03/02/23.
	select count(ThuebaoKH.MaTB) as 'SoTB Dang ky trong ngay 23-2-2003' from ThuebaoKH where ThuebaoKH.NgayDK='2003-02-23'

	--d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
	select distinct * from ThongtinKH join ThuebaoKH on ThongtinKH.MaKH=ThuebaoKH.MaKH

	--7. Thay đổi những thay đổi sau trên cơ sở dữ liệu
	--a) Viết câu lệnh để thay đổi trường ngày đăng ký là not null.
	alter table ThueBaoKh alter column NgayDK datetime NOT NULL

	--b) Viết câu lệnh để thay đổi trường ngày đăng ký là trước hoặc bằng ngày hiện tại.
	alter table ThueBaoKH add constraint CK_checkdate check (NgayDK < getdate())

	--c) Viết câu lệnh để thay đổi số điện thoại phải bắt đầu 09
	alter table ThueBaoKH add constraint CK_number check (Sothuebao like '09%')

	--d) Viết câu lệnh để thêm trường số điểm thưởng cho mỗi số thuê bao.
	alter table ThueBaoKH add DiemThuong int

	--8. Thực hiện các yêu cầu sau
	--◦ View_KhachHang: Hiển thị các thông tin Mã khách hàng, Tên khách hàng, địa chỉ
	create view View_KhachHang
	as
	select MaKH,Ten,Diachi from ThongtinKH;

	--◦ View_KhachHang_ThueBao: Hiển thị thông tin Mã khách hàng, Tên khách hàng, Số thuê bao
	create view View_KhachHang_ThueBao
	as
	select ThongtinKH.MaKH,Ten,ThuebaoKH.Sothuebao from ThongtinKH inner join ThuebaoKH on ThongtinKH.MaKH=ThuebaoKH.MaKH