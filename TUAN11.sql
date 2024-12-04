USE master
IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'NHOM4_TCSDL206')
BEGIN
    ALTER DATABASE NHOM4_TCSDL206 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE NHOM4_TCSDL206;
END
CREATE DATABASE NHOM4_TCSDL206;
GO
USE NHOM4_TCSDL206;
GO
--BẢNG KHACHHANG
CREATE TABLE KHACHHANG (
    MAKHACHHANG CHAR(10) PRIMARY KEY,
    TENCONGTY NVARCHAR(100) NOT NULL,
    TENGIAODICH NVARCHAR(100) NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    EMAIL VARCHAR(50)  UNIQUE,
    DIENTHOAI VARCHAR(10) UNIQUE,
    FAX NVARCHAR(25)
);
--BẢNG NHANVIEN
CREATE TABLE NHANVIEN (
    MANHANVIEN CHAR(10) PRIMARY KEY,
    TEN NVARCHAR(20) NOT NULL,
    HO NVARCHAR(20) NOT NULL,
    NGAYSINH DATE NOT NULL,
    NGAYLAMVIEC DATE NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    DIENTHOAI VARCHAR(10) UNIQUE,
    LUONGCOBAN DECIMAL(15, 2) NOT NULL,
    PHUCAP DECIMAL(10, 2)
);
--BẢNG NHACUNGCAP
CREATE TABLE NHACUNGCAP (
    MACONGTY CHAR(10) PRIMARY KEY,
    TENCONGTY NVARCHAR(100) NOT NULL,
    TENGIAODICH NVARCHAR(50) NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    DIENTHOAI VARCHAR(10) UNIQUE,
    FAX NVARCHAR(25),
    EMAIL VARCHAR(50) UNIQUE
);
--BẢNG LOAIHANG
CREATE TABLE LOAIHANG (
    MALOAIHANG CHAR(10) PRIMARY KEY,
    TENLOAIHANG NVARCHAR(40) NOT NULL
);
--BẢNG MATHANG
CREATE TABLE MATHANG (
    MAHANG CHAR(10) PRIMARY KEY,
    TENHANG NVARCHAR(100) NOT NULL,
    MALOAIHANG CHAR(10) NOT NULL,
    MACONGTY CHAR(10) NOT NULL,
    SOLUONG FLOAT NOT NULL,
    DVTINH NVARCHAR(20) NOT NULL,
    GIAHANG MONEY NOT NULL,
    FOREIGN KEY (MALOAIHANG) REFERENCES LOAIHANG(MALOAIHANG)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE,
    FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE
);
--BẢNG DONDATHANG
CREATE TABLE DONDATHANG (
    SOHOADON CHAR(10) PRIMARY KEY,
    MAKHACHHANG CHAR(10) NOT NULL,
    MANHANVIEN CHAR(10) NOT NULL,
    NGAYDATHANG DATE NOT NULL,
    NGAYGIAOHANG DATE,
    NGAYCHUYENHANG DATE,
    NOIGIAOHANG NVARCHAR(100),
    FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE,
    FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN(MANHANVIEN)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE
);
--BẢNG CHITIETDATHANG
CREATE TABLE CHITIETDATHANG (
    SOHOADON CHAR(10) NOT NULL,
    MAHANG CHAR(10) NOT NULL,
    GIABAN MONEY NOT NULL,
    SOLUONG FLOAT NOT NULL,
    MUCGIAMGIA MONEY,
	PRIMARY KEY(SOHOADON,MAHANG),
    FOREIGN KEY (SOHOADON) REFERENCES DONDATHANG(SOHOADON)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE,
    FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
		ON DELETE
			CASCADE
		ON UPDATE
			CASCADE
);
--SOLUONG MẶC ĐỊNH LÀ 1, MUCGIAMGIA MẶC ĐỊNH LÀ 0
ALTER TABLE CHITIETDATHANG 
	ADD CONSTRAINT DF_SOLUONG DEFAULT 1 FOR SOLUONG,
		CONSTRAINT DF_MUCGIAMGIA DEFAULT 0 FOR MUCGIAMGIA;
--RÀNG BUỘC NGAYGIAOHANG,NGAYDATHANG,NGAYCHUYENHANG
ALTER TABLE DONDATHANG
	ADD CONSTRAINT CK_NGAYGIAOHANG
	CHECK (NGAYGIAOHANG >= NGAYDATHANG),
	CONSTRAINT CK_NGAYCHUYENHANG
	CHECK (NGAYCHUYENHANG >= NGAYDATHANG);
-- NHÂN VIÊN TỪ 18N ĐẾN 60 TUỔI
ALTER TABLE NHANVIEN
	ADD CONSTRAINT CK_TUOI_NHANVIEN 
	CHECK (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 18 AND DATEDIFF(YEAR, NGAYSINH, GETDATE()) <= 60);
--RÀNG BUỘC EMAIL
ALTER TABLE KHACHHANG
    ADD CONSTRAINT CK_KhachHang_Email
    CHECK (EMAIL LIKE '%@%.%');

ALTER TABLE NhaCungCap
	ADD CONSTRAINT CK_NhaCungCap_Email
		CHECK (Email LIKE '[a-z][A-Z]%@%_')
--DIENTHOAI PHẢI LÀ SỐ TỪ 0 ĐẾN 9
ALTER TABLE KhachHang
	ADD CONSTRAINT CK_KhachHang_SDT
		CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_NhanVien_SDT
		CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
ALTER TABLE NhaCungCap
	ADD CONSTRAINT CK_NhaCungCap_SDT
		CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--MẶC ĐỊNH LUONGCOBAN LÀ 5000000 VÀ LUONGCOBAN >0
ALTER TABLE NhanVien
	ADD CONSTRAINT CK_NhanVien_LUONGCOBAN
		DEFAULT '5000000' FOR LUONGCOBAN,
		CHECK(LUONGCOBAN>0)
SET DATEFORMAT dmy;
USE NHOM4_TCSDL206;
-- Thêm dữ liệu vào bảng LOAIHANG
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES ('LH00000001', N'Thực phẩm'), 
       ('LH00000002', N'Đồ gia dụng');

-- Thêm dữ liệu vào bảng NHACUNGCAP
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL) 
VALUES ('NC00000001', N'Việt Tiến', N'GIAO DỊCH 1', N'HẢI CHÂU', '0901234567', '0281234567', 'abc@company.com'),
       ('NC00000002', N'Công ty XYZ', N'GIAO DỊCH 2', N'LIÊN CHIỂU', '0907654321', '0287654321', 'xyz@company.com'),
	   ('NC00000003', N'Công ty MYLE', 'VINAMILK', N'LIÊN CHIỂU', '0907654322', '0287654322', 'MYL@company.com');
-- Thêm dữ liệu vào bảng KHACHHANG
INSERT INTO KHACHHANG (MAKHACHHANG, TENCONGTY, TENGIAODICH, DIACHI, EMAIL, DIENTHOAI, FAX) 
VALUES ('KH00000001', N'Khách hàng A', 'VINAMILK ', N'HÒA KHÁNH', 'a@customer.com', '0912345678', '0281234789'),
       ('KH00000002', N'Khách hàng B', N'CÔNG TY B', N'THANH KHÊ', 'b@customer.com', '0918765432', '0289876543'),
	   ('KH00000003', N'Khách hàng C', N'CÔNG TY C', N'234 Đường F', 'b@cusstomer.com', '0917765432', '0389876543');

-- Thêm dữ liệu vào bảng NHANVIEN
INSERT INTO NHANVIEN (MANHANVIEN, TEN, HO, NGAYSINH, NGAYLAMVIEC, DIACHI, DIENTHOAI, LUONGCOBAN, PHUCAP) 
VALUES ('NV00000001', 'Nam', N'Nguyễn', '1990-01-01', '2020-05-15', N'123 Đường E', '0901239876', '6000000', NULL),
       ('NV00000002', 'Lan', N'Lê', '1985-03-22', '2019-10-10', N'456 Đường F', '0906543210', default, '600000'),
	   ('NV00000003', 'Minh', N'Tran', '1995-04-15', '2023-02-10', N'789 Đường K', '0901234569', '7000000', '500000'),
	   ('NV00000004', 'Vinh', N'Ngô', '1965-12-30', '1980-01-01', N'234 Đường M', '0909871234', '9000000', '700000'),
	   ('NV00000005', 'Linh', N'Ngô', '1965-12-30', '1970-01-01', N'234 Đường M', '0909871235', '9000000', '700000');

-- Thêm dữ liệu vào bảng MATHANG
INSERT INTO MATHANG (MAHANG, TENHANG, MALOAIHANG, MACONGTY, SOLUONG, DVTINH, GIAHANG) 
VALUES ('MH00000001', N'Sữa hộp XYZ', 'LH00000001', 'NC00000001', 100, N'Cái', 15000000),
       ('MH00000002', N'Máy giặt LG', 'LH00000002', 'NC00000002', 50, N'Cái', 10000000),
	    ('MH00000003', N'Tủ lạnh Toshiba', 'LH00000002', 'NC00000001', 0, N'Cái', 12000000);

-- Thêm dữ liệu vào bảng DONDATHANG
INSERT INTO DONDATHANG (SOHOADON, MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, NOIGIAOHANG) 
VALUES ('HD00000001', 'KH00000001', 'NV00000001', '2022-10-10', '2023-10-12', '2023-10-15', N'123 Đường G'),
       ('HD00000002', 'KH00000002', 'NV00000002', '2023-09-20', '2023-09-25', '2023-09-28', N'456 Đường H'),
	   ('HD00000003', 'KH00000001', 'NV00000001', '2009-05-10', '2009-05-15', '2009-05-18', N'123 Đường I'),
	   ('HD00000004', 'KH00000003', 'NV00000001', '2009-05-10', '2009-05-15', '2009-05-18', N'234 Đường F');


-- Thêm dữ liệu vào bảng CHITIETDATHANG
INSERT INTO CHITIETDATHANG (SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES ('HD00000001', 'MH00000001', 15000000, 2, 50000),
       ('HD00000002', 'MH00000002', 10000000, 1, DEFAULT),
	   ('HD00000003', 'MH00000001', 15000000, 1, 50000),
	   ('HD00000004', 'MH00000002', 5000000, 1, 30000);

---------------------------------------------------------------------------TUẦN 9-------------------------------------------------------------------------
--1.Cho biết danh sách các đối tác cung cấp hàng cho công ty
select MACONGTY, TENCONGTY
FROM NHACUNGCAP
--2.Mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty
SELECT MAHANG, TENHANG, SOLUONG 
FROM MATHANG
--3.Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên trong công ty
SELECT MANHANVIEN, HO, TEN, NGAYLAMVIEC, DIACHI
FROM NHANVIEN
--4.Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINAMILK] là gì?
SELECT MACONGTY, DIACHI, DIENTHOAI, TENGIAODICH
FROM NHACUNGCAP
WHERE TENGIAODICH= 'VINAMILK'
--5.Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50.
SELECT MAHANG, TENHANG, SOLUONG, GIAHANG
FROM MATHANG
WHERE SOLUONG<50 AND GIAHANG>100000
--6.Cho biết mỗi mặt hàng trong công ty do ai cung cấp
SELECT MAHANG, TENHANG , MATHANG.MACONGTY, TENCONGTY
FROM MATHANG, NHACUNGCAP
WHERE MATHANG.MACONGTY= NHACUNGCAP.MACONGTY
--7.Công ty [Việt Tiến] đã cung cấp những mặt hàng nào?
SELECT NHACUNGCAP.MACONGTY, TENCONGTY, MAHANG, TENHANG
FROM NHACUNGCAP, MATHANG
WHERE NHACUNGCAP.MACONGTY= MATHANG.MACONGTY AND TENCONGTY= N'Việt Tiến'
--8.Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?
SELECT LOAIHANG.MALOAIHANG, TENLOAIHANG, NHACUNGCAP.MACONGTY, TENCONGTY, DIACHI
FROM LOAIHANG, NHACUNGCAP, MATHANG
WHERE NHACUNGCAP.MACONGTY=MATHANG.MACONGTY AND MATHANG.MALOAIHANG=LOAIHANG.MALOAIHANG AND TENLOAIHANG=  N'Thực phẩm'
--9.Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?
SELECT DISTINCT KHACHHANG.MAKHACHHANG, TENCONGTY,KHACHHANG.TENGIAODICH
FROM KHACHHANG
JOIN DONDATHANG ON KHACHHANG.MAKHACHHANG = DONDATHANG.MAKHACHHANG
JOIN CHITIETDATHANG ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
JOIN MATHANG ON CHITIETDATHANG.MAHANG = MATHANG.MAHANG
WHERE MATHANG.TENHANG = N'Sữa hộp XYZ';
--10.Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao hàng là ở đâu?
SELECT DONDATHANG.SOHOADON,
       KHACHHANG.TENGIAODICH AS TenKhachHang,
       NHANVIEN.HO + ' ' + NHANVIEN.TEN AS TenNhanVien,
       DONDATHANG.NGAYDATHANG,
       DONDATHANG.NGAYGIAOHANG,
       DONDATHANG.NOIGIAOHANG
FROM DONDATHANG
JOIN KHACHHANG ON DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
JOIN NHANVIEN ON DONDATHANG.MANHANVIEN = NHANVIEN.MANHANVIEN
WHERE DONDATHANG.SOHOADON = 'HD00000001';
---------------------------------------------------------------------------TUẦN 10-------------------------------------------------------------------------
--11.Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu (lương = lương cơ bản + phụ cấp).
SELECT 
    MANHANVIEN,
    HO + ' ' + TEN AS HO_TEN,
    LUONGCOBAN,
    ISNULL(PHUCAP, 0) AS PHUCAP,
    (LUONGCOBAN + ISNULL(PHUCAP, 0)) AS TONG_LUONG
FROM 
    NHANVIEN;
--12.Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
SELECT 
    KH.MAKHACHHANG AS MaKhachHang,
    KH.TENCONGTY AS TenCongTyKhachHang,
    KH.TENGIAODICH AS TenGiaoDich,
    NCC.MACONGTY AS MaNhaCungCap,
    NCC.TENCONGTY AS TenCongTyNhaCungCap
FROM 
    KHACHHANG KH, NHACUNGCAP NCC
WHERE KH.TENGIAODICH = NCC.TENGIAODICH;
--13.Trong công ty có những nhân viên nào có cùng ngày sinh?
SELECT 
    NGAYSINH,
    MANHANVIEN,
    HO + ' ' + TEN AS HoTen
FROM 
    NHANVIEN
WHERE 
    NGAYSINH IN (
        SELECT 
            NGAYSINH
        FROM 
            NHANVIEN
        GROUP BY 
            NGAYSINH
        HAVING 
            COUNT(*) > 1
    )
ORDER BY 
    NGAYSINH, MANHANVIEN;
--14. Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào?
SELECT 
    D.SOHOADON,
    D.MAKHACHHANG,
    D.NGAYDATHANG,
    D.NOIGIAOHANG,
	K.DIACHI,
    K.TENCONGTY
FROM 
    DONDATHANG D, KHACHHANG K
WHERE 
    D.NOIGIAOHANG = K.DIACHI AND D.MAKHACHHANG = K.MAKHACHHANG
--15.Cho biết tên công ty, tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
SELECT 
    TENCONGTY, 
    TENGIAODICH, 
    DIACHI, 
    DIENTHOAI
FROM 
    KHACHHANG
UNION
SELECT 
    TENCONGTY, 
    TENGIAODICH, 
    DIACHI, 
    DIENTHOAI
FROM 
    NHACUNGCAP;
--16. Những mặt hàng nào chưa từng được khách hàng đặt mua?
SELECT 
    MH.MAHANG, 
    MH.TENHANG
FROM 
    MATHANG MH
LEFT JOIN 
    CHITIETDATHANG CTDH ON MH.MAHANG = CTDH.MAHANG
WHERE 
    CTDH.MAHANG IS NULL;
--17.Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
SELECT 
    NV.MANHANVIEN, 
    NV.HO, 
    NV.TEN
FROM 
    NHANVIEN NV
LEFT JOIN 
    DONDATHANG DDH ON NV.MANHANVIEN = DDH.MANHANVIEN
WHERE 
    DDH.SOHOADON IS NULL;
--18.Những nhân viên nào của công ty có lương cơ bản cao nhất?
SELECT 
    MANHANVIEN, 
    HO, 
    TEN, 
    LUONGCOBAN
FROM 
    NHANVIEN
WHERE 
    LUONGCOBAN = (SELECT MAX(LUONGCOBAN) FROM NHANVIEN);
	
---------------------------------------------------------------------------TUẦN 11-------------------------------------------------------------------------
--1.Tạo thủ tục lưu trữ để thông qua thủ tục này có thể bổ sung thêm một bản ghi mới cho bảng MATHANG (thủ tục phải thực hiện kiểm tra tính hợp lệ của dữ liệu cn bố sung: khng trg khoachnh và đảm bảo toàn vẹn tham chiếu)
GO
CREATE PROCEDURE ThemMatHang
    @MaHang CHAR(10),
    @TenHang NVARCHAR(100),
    @MaLoaiHang CHAR(10),
    @MaCongTy CHAR(10),
    @SoLuong FLOAT,
    @DonViTinh NVARCHAR(20),
    @GiaHang MONEY
AS
BEGIN
    -- Kiểm tra tính hợp lệ của khóa chính (Mã Hàng)
    IF EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG = @MaHang)
    BEGIN
        PRINT N'Mã hàng đã tồn tại.';
        RETURN;
    END;

    -- Kiểm tra toàn vẹn tham chiếu: MALOAIHANG phải tồn tại trong LOAIHANG
    IF NOT EXISTS (SELECT 1 FROM LOAIHANG WHERE MALOAIHANG = @MaLoaiHang)
    BEGIN
        PRINT N'Mã loại hàng không tồn tại.';
        RETURN;
    END;

    -- Kiểm tra toàn vẹn tham chiếu: MACONGTY phải tồn tại trong NHACUNGCAP
    IF NOT EXISTS (SELECT 1 FROM NHACUNGCAP WHERE MACONGTY = @MaCongTy)
    BEGIN
        PRINT N'Mã công ty không tồn tại.';
        RETURN;
    END;

    -- Thêm bản ghi mới vào bảng MATHANG
    INSERT INTO MATHANG (MAHANG, TENHANG, MALOAIHANG, MACONGTY, SOLUONG, DVTINH, GIAHANG)
    VALUES (@MaHang, @TenHang, @MaLoaiHang, @MaCongTy, @SoLuong, @DonViTinh, @GiaHang);

    PRINT N'Bản ghi mới đã được thêm thành công.';
END;
EXEC ThemMatHang 
    @MaHang = 'MH00000004',
    @TenHang = N'TiVi Samsung',
    @MaLoaiHang = 'LH00000002',
    @MaCongTy = 'NC00000002',
    @SoLuong = 30,
    @DonViTinh = N'Cái',
    @GiaHang = 15000000;

--2.Tạo thủ tục lưu trữ có chức năng thống kê tổng số lượng hàng bán được của một mặt hàng có mã bất kỳ (mã mặt hàng cần thống kê là tham số của thủ tục).​10:15/-strong/-heart:>:o:-((:-hĐã gửi Xem trước khi gửiThả Files vào đây để xem lại trước khi gửi
GO
CREATE PROCEDURE ThongKeSoLuongHangBan
    @MaHang CHAR(10) -- Tham số đầu vào: Mã mặt hàng cần thống kê
AS
BEGIN
    -- Kiểm tra xem mã mặt hàng có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG = @MaHang)
    BEGIN
        PRINT N'Mã mặt hàng không tồn tại.';
        RETURN;
    END;

    -- Thống kê tổng số lượng hàng đã bán
    DECLARE @TongSoLuong FLOAT;

    SELECT @TongSoLuong = SUM(SOLUONG)
    FROM CHITIETHOADON
    WHERE MAHANG = @MaHang;

    -- Kiểm tra nếu không có bản ghi nào
    IF @TongSoLuong IS NULL
    BEGIN
        PRINT N'Mặt hàng này chưa bán được sản phẩm nào.';
        RETURN;
    END;

    -- Trả về kết quả
    PRINT N'Tổng số lượng hàng bán được của mặt hàng có mã ' + @MaHang + N' là: ' + CAST(@TongSoLuong AS NVARCHAR(50));
END;
GO
-- Gọi thủ tục với mã mặt hàng cần thống kê
EXEC ThongKeSoLuongHangBan @MaHang = 'MH001';
--3.Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của mỗi mặt hàng. Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán) của mỗi mặt hàng là bao nhiêu.
GO
CREATE FUNCTION ThongKeSoLuongDaBan()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        MAHANG,
        SUM(SOLUONG) AS TongSoLuongDaBan
    FROM CHITIETDATHANG
    GROUP BY MAHANG
);
GO
SELECT 
    MH.MAHANG,
    MH.TENHANG,
    MH.SOLUONG AS SoLuongHienCo,
    ISNULL(TK.TongSoLuongDaBan, 0) AS SoLuongDaBan,
    MH.SOLUONG + ISNULL(TK.TongSoLuongDaBan, 0) AS TongSoLuong
FROM 
    MATHANG MH
LEFT JOIN 
    ThongKeSoLuongDaBan() TK
ON 
    MH.MAHANG = TK.MAHANG;
GO
--4.Viết trigger cho bảng CHITIETDATHANG theo các yêu cầu sau:
		--Khi một bản ghi mới được bổ sung vào bảng này thì giảm số lượng hàng hiện có nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. Ngược lại, hủy bỏ thao tác bổ sung.
		--Khi cập nhật lại số lượng hàng được bán, kiểm tra số lượng hàng được cập nhật lại có phù hợp hay không (số lượng hàng bán ra không được vượt quá số lượng hàng hiện có và không được nhỏ hơn 1). Nếu dữ liệu hợp lệ thì giảm (hoặc tăng) số lượng hàng hiện có trong công ty; ngược lại, hủy bỏ thao tác cập nhật.
-- Trigger xử lý khi thêm hoặc cập nhật bản ghi trong bảng CHITIETDATHANG
CREATE TRIGGER TRG_CHITIETDATHANG
ON CHITIETDATHANG
AFTER INSERT, UPDATE
AS
BEGIN
    -- Phần kiểm tra khi thêm bản ghi mới
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN MATHANG MH ON I.MAHANG = MH.MAHANG
        WHERE MH.SOLUONG < I.SOLUONG -- Kiểm tra nếu số lượng tồn kho không đủ
    )
    BEGIN
        PRINT N'Số lượng hàng trong kho không đủ để thực hiện giao dịch.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Phần kiểm tra khi cập nhật bản ghi
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN DELETED D ON I.MAHANG = D.MAHANG
        JOIN MATHANG MH ON I.MAHANG = MH.MAHANG
        WHERE I.SOLUONG > MH.SOLUONG + D.SOLUONG -- Số lượng sau khi cập nhật vượt quá tồn kho
              OR I.SOLUONG < 1 -- Số lượng không hợp lệ (dưới 1)
    )
    BEGIN
        PRINT N'Dữ liệu cập nhật không hợp lệ.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Cập nhật số lượng hàng tồn kho trong bảng MATHANG
    UPDATE MH
    SET MH.SOLUONG = MH.SOLUONG - (I.SOLUONG - ISNULL(D.SOLUONG, 0)) -- Trừ số lượng đã đặt
    FROM MATHANG MH
    JOIN INSERTED I ON MH.MAHANG = I.MAHANG
    LEFT JOIN DELETED D ON MH.MAHANG = D.MAHANG;
END;
GO

select *
from MATHANG;
-- Nếu vượt quá tồn kho

INSERT INTO MATHANG
VALUES ('MH00000004', N'NOKIA', 'LH00000002', 'NC00000001', 100, N'Cái', 1000000);
INSERT INTO DONDATHANG 
VALUES ('HD00000005', 'KH00000003', 'NV00000001', '2009-05-10', '2009-05-15', '2009-05-18', N'234 Đường F');

INSERT INTO CHITIETDATHANG
VALUES ('HD00000005', 'MH00000004', 2000000, 2,  20000);
SELECT * FROM CHITIETDATHANG;
UPDATE CHITIETDATHANG
SET SOLUONG = 3
WHERE MAHANG = 'MH00000005'; -- Nếu tổng tồn kho cho phép
UPDATE CHITIETDATHANG
SET SOLUONG = 200
WHERE MAHANG = 'MH00000001';
GO


