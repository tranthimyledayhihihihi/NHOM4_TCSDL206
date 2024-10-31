﻿USE master
IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'NGUYEN_THI_THU')
BEGIN
    ALTER DATABASE NGUYEN_THI_THU SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE NGUYEN_THI_THU;
END
CREATE DATABASE NGUYEN_THI_THU;
GO
USE NGUYEN_THI_THU;
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
    LUONGCOBAN VARCHAR(15) NOT NULL,
    PHUCAP VARCHAR(10)
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
-- Thêm dữ liệu vào bảng LOAIHANG
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES ('LH00000001', N'Đồ điện tử'), 
       ('LH00000002', N'Đồ gia dụng');

-- Thêm dữ liệu vào bảng NHACUNGCAP
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL) 
VALUES ('NC00000001', N'Công ty ABC', N'GIAO DỊCH 1', N'HẢI CHÂU', '0901234567', '0281234567', 'abc@company.com'),
       ('NC00000002', N'Công ty XYZ', N'GIAO DỊCH 2', N'LIÊN CHIỂU', '0907654321', '0287654321', 'xyz@company.com');

-- Thêm dữ liệu vào bảng KHACHHANG
INSERT INTO KHACHHANG (MAKHACHHANG, TENCONGTY, TENGIAODICH, DIACHI, EMAIL, DIENTHOAI, FAX) 
VALUES ('KH00000001', N'Khách hàng A', N'CÔNG TY A', N'HÒA KHÁNH ', 'a@customer.com', '0912345678', '0281234789'),
       ('KH00000002', N'Khách hàng B', N'CÔNG TY B', N'THANH KHÊ', 'b@customer.com', '0918765432', '0289876543');

-- Thêm dữ liệu vào bảng NHANVIEN
INSERT INTO NHANVIEN (MANHANVIEN, TEN, HO, NGAYSINH, NGAYLAMVIEC, DIACHI, DIENTHOAI, LUONGCOBAN, PHUCAP) 
VALUES ('NV00000001', 'Nam', N'Nguyễn', '1990-01-01', '2020-05-15', N'123 Đường E', '0901239876', '6000000', '500000'),
       ('NV00000002', 'Lan', N'Lê', '1985-03-22', '2019-10-10', N'456 Đường F', '0906543210', default, '600000');



-- Thêm dữ liệu vào bảng MATHANG
INSERT INTO MATHANG (MAHANG, TENHANG, MALOAIHANG, MACONGTY, SOLUONG, DVTINH, GIAHANG) 
VALUES ('MH00000001', N'Tivi Samsung', 'LH00000001', 'NC00000001', 100, N'Cái', 15000000),
       ('MH00000002', N'Máy giặt LG', 'LH00000002', 'NC00000002', 50, N'Cái', 10000000);

-- Thêm dữ liệu vào bảng DONDATHANG
INSERT INTO DONDATHANG (SOHOADON, MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, NOIGIAOHANG) 
VALUES ('HD00000001', 'KH00000001', 'NV00000001', '2023-10-10', '2023-10-12', '2023-10-15', N'123 Đường G'),
       ('HD00000002', 'KH00000002', 'NV00000002', '2023-09-20', '2023-09-25', '2023-09-28', N'456 Đường H');

-- Thêm dữ liệu vào bảng CHITIETDATHANG
INSERT INTO CHITIETDATHANG (SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES ('HD00000001', 'MH00000001', 15000000, 2, 50000),
       ('HD00000002', 'MH00000002', 10000000, 1, DEFAULT);
