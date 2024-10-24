CREATE TABLE KHACHHANG (
    MAKHACHHANG CHAR(10) PRIMARY KEY,
    TENCONGTY NVARCHAR(100) NOT NULL,
    TENGIAODICH NVARCHAR(100) NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL UNIQUE,
    DIENTHOAI VARCHAR(10) NOT NULL,
    FAX NVARCHAR(25)
);

CREATE TABLE NHANVIEN (
    MANHANVIEN CHAR(15) PRIMARY KEY,
    TEN NVARCHAR(20) NOT NULL,
    HO NVARCHAR(20) NOT NULL,
    NGAYSINH DATE NOT NULL,
    NGAYLAMVIEC DATE NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    DIENTHOAI VARCHAR(10) NOT NULL,
    LUONGCOBAN VARCHAR(20) NOT NULL,
    PHUCAP VARCHAR(10)
);

CREATE TABLE NHACUNGCAP (
    MACONGTY VARCHAR(10) PRIMARY KEY,
    TENCONGTY NVARCHAR(100) NOT NULL,
    TENGIAODICH NVARCHAR(50) NOT NULL,
    DIACHI NVARCHAR(100) NOT NULL,
    DIENTHOAI VARCHAR(10) NOT NULL,
    FAX NVARCHAR(25),
    EMAIL VARCHAR(30)
);

CREATE TABLE LOAIHANG (
    MALOAIHANG VARCHAR(10) PRIMARY KEY,
    TENLOAIHANG NVARCHAR(40) NOT NULL
);

CREATE TABLE MATHANG (
    MAHANG VARCHAR(20) PRIMARY KEY,
    TENHANG NVARCHAR(100) NOT NULL,
    MALOAIHANG VARCHAR(10),
    MACONGTY VARCHAR(10),
    SOLUONG FLOAT NOT NULL,
    DVTINH NVARCHAR(20) NOT NULL,
    GIAHANG DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (MALOAIHANG) REFERENCES LOAIHANG(MALOAIHANG),
    FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY)
);

CREATE TABLE DONKHACHHANG (
    SOHOADON CHAR(20) PRIMARY KEY,
    MAKHACHHANG CHAR(10) NOT NULL,
    MANHANVIEN CHAR(15) NOT NULL,
    NGAYDATHANG DATE NOT NULL,
    NGAYGIAOHANG DATE,
    NGAYCHUYENHANG DATE,
    NOIGIAOHANG NVARCHAR(100),
    FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG),
    FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN(MANHANVIEN)
);

CREATE TABLE CHITIETDATHANG (
    SOHOADON CHAR(20),
    MAHANG VARCHAR(20),
    GIABAN DECIMAL(10, 2) NOT NULL,
    SOLUONG FLOAT NOT NULL,
    MUCGIAMGIA DECIMAL(5, 2),
    PRIMARY KEY (SOHOADON, MAHANG),
    FOREIGN KEY (SOHOADON) REFERENCES DONKHACHHANG(SOHOADON),
    FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
);
