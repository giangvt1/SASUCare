USE [master]
GO
/****** Object:  Database [SWP391_GROUP6_1]    Script Date: 1/14/2025 8:46:41 AM ******/
CREATE DATABASE [SWP391_GROUP6_1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SWP391_GROUP6_1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SWP391_GROUP6_1.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SWP391_GROUP6_1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SWP391_GROUP6_1_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [SWP391_GROUP6_1] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SWP391_GROUP6_1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ARITHABORT OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET  MULTI_USER 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SWP391_GROUP6_1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SWP391_GROUP6_1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [SWP391_GROUP6_1] SET QUERY_STORE = ON
GO
ALTER DATABASE [SWP391_GROUP6_1] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [SWP391_GROUP6_1]
GO
/****** Object:  User [sa]    Script Date: 1/14/2025 8:46:41 AM ******/
CREATE USER [sa] FOR LOGIN [sa] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[appointments]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[appointments](
	[appointment_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[doctor_id] [int] NOT NULL,
	[service_id] [int] NOT NULL,
	[appointment_date] [datetime] NOT NULL,
	[status] [varchar](20) NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[appointment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chatlogs]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chatlogs](
	[chat_id] [int] IDENTITY(1,1) NOT NULL,
	[appointment_id] [int] NOT NULL,
	[message] [text] NULL,
	[sender_id] [int] NOT NULL,
	[sent_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customers]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customers](
	[customer_id] [int] NOT NULL,
	[health_record] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[departments]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[departments](
	[department_id] [int] IDENTITY(1,1) NOT NULL,
	[department_name] [nvarchar](100) NOT NULL,
	[description] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[doctors]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[doctors](
	[doctor_id] [int] NOT NULL,
	[department_id] [int] NOT NULL,
	[specialty] [nvarchar](100) NULL,
	[experience_years] [int] NULL,
	[certifications] [text] NULL,
	[biography] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[doctor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[features]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[features](
	[fid] [int] IDENTITY(1,1) NOT NULL,
	[fname] [varchar](50) NOT NULL,
	[url] [varchar](50) NOT NULL,
 CONSTRAINT [PK_features] PRIMARY KEY CLUSTERED 
(
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[feedback]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feedback](
	[feedback_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[service_id] [int] NOT NULL,
	[rating] [int] NULL,
	[comment] [text] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[feedback_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[medicalrecords]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[medicalrecords](
	[record_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[doctor_id] [int] NOT NULL,
	[appointment_id] [int] NOT NULL,
	[diagnosis] [text] NULL,
	[prescription] [text] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[record_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles](
	[rid] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles-features]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles-features](
	[rid] [int] NOT NULL,
	[fid] [int] NOT NULL,
 CONSTRAINT [PK_roles-features] PRIMARY KEY CLUSTERED 
(
	[rid] ASC,
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[schedules]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[schedules](
	[schedule_id] [int] IDENTITY(1,1) NOT NULL,
	[doctor_id] [int] NOT NULL,
	[work_date] [date] NOT NULL,
	[start_time] [time](7) NOT NULL,
	[end_time] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[servicepackages]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[servicepackages](
	[package_id] [int] IDENTITY(1,1) NOT NULL,
	[package_name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[services]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[services](
	[service_id] [int] IDENTITY(1,1) NOT NULL,
	[service_name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[package_id] [int] NOT NULL,
	[department_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[appointment_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[status] [nvarchar](10) NULL,
	[payment_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userpackages]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userpackages](
	[user_package_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[package_id] [int] NOT NULL,
	[purchase_date] [datetime] NULL,
	[expiry_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 1/14/2025 8:46:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[full_name] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[phone_number] [varchar](50) NULL,
	[created_at] [datetime] NULL,
	[role_id] [int] NOT NULL,
	[password] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__users__AB6E6164BE469A89] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__users__F3DBC57266BA77A7] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[appointments] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[appointments] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[chatlogs] ADD  DEFAULT (getdate()) FOR [sent_at]
GO
ALTER TABLE [dbo].[feedback] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[medicalrecords] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[servicepackages] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT (getdate()) FOR [payment_date]
GO
ALTER TABLE [dbo].[userpackages] ADD  DEFAULT (getdate()) FOR [purchase_date]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[appointments]  WITH CHECK ADD  CONSTRAINT [appointments_fk1] FOREIGN KEY([customer_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[appointments] CHECK CONSTRAINT [appointments_fk1]
GO
ALTER TABLE [dbo].[appointments]  WITH CHECK ADD  CONSTRAINT [appointments_fk2] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[appointments] CHECK CONSTRAINT [appointments_fk2]
GO
ALTER TABLE [dbo].[appointments]  WITH CHECK ADD  CONSTRAINT [appointments_fk3] FOREIGN KEY([service_id])
REFERENCES [dbo].[services] ([service_id])
GO
ALTER TABLE [dbo].[appointments] CHECK CONSTRAINT [appointments_fk3]
GO
ALTER TABLE [dbo].[chatlogs]  WITH CHECK ADD  CONSTRAINT [chatlogs_fk1] FOREIGN KEY([appointment_id])
REFERENCES [dbo].[appointments] ([appointment_id])
GO
ALTER TABLE [dbo].[chatlogs] CHECK CONSTRAINT [chatlogs_fk1]
GO
ALTER TABLE [dbo].[chatlogs]  WITH CHECK ADD  CONSTRAINT [chatlogs_fk2] FOREIGN KEY([sender_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[chatlogs] CHECK CONSTRAINT [chatlogs_fk2]
GO
ALTER TABLE [dbo].[customers]  WITH CHECK ADD  CONSTRAINT [customers_fk] FOREIGN KEY([customer_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[customers] CHECK CONSTRAINT [customers_fk]
GO
ALTER TABLE [dbo].[doctors]  WITH CHECK ADD  CONSTRAINT [FK_doctors_department] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[doctors] CHECK CONSTRAINT [FK_doctors_department]
GO
ALTER TABLE [dbo].[doctors]  WITH CHECK ADD  CONSTRAINT [FK_doctors_user] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[doctors] CHECK CONSTRAINT [FK_doctors_user]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD  CONSTRAINT [FK_feedback_customer] FOREIGN KEY([customer_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[feedback] CHECK CONSTRAINT [FK_feedback_customer]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD  CONSTRAINT [FK_feedback_service] FOREIGN KEY([service_id])
REFERENCES [dbo].[services] ([service_id])
GO
ALTER TABLE [dbo].[feedback] CHECK CONSTRAINT [FK_feedback_service]
GO
ALTER TABLE [dbo].[medicalrecords]  WITH CHECK ADD  CONSTRAINT [FK_medicalrecords_appointment] FOREIGN KEY([appointment_id])
REFERENCES [dbo].[appointments] ([appointment_id])
GO
ALTER TABLE [dbo].[medicalrecords] CHECK CONSTRAINT [FK_medicalrecords_appointment]
GO
ALTER TABLE [dbo].[medicalrecords]  WITH CHECK ADD  CONSTRAINT [FK_medicalrecords_customer] FOREIGN KEY([customer_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[medicalrecords] CHECK CONSTRAINT [FK_medicalrecords_customer]
GO
ALTER TABLE [dbo].[medicalrecords]  WITH CHECK ADD  CONSTRAINT [FK_medicalrecords_doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[medicalrecords] CHECK CONSTRAINT [FK_medicalrecords_doctor]
GO
ALTER TABLE [dbo].[roles-features]  WITH CHECK ADD  CONSTRAINT [FK_roles-features_features] FOREIGN KEY([fid])
REFERENCES [dbo].[features] ([fid])
GO
ALTER TABLE [dbo].[roles-features] CHECK CONSTRAINT [FK_roles-features_features]
GO
ALTER TABLE [dbo].[roles-features]  WITH CHECK ADD  CONSTRAINT [FK_roles-features_roles] FOREIGN KEY([rid])
REFERENCES [dbo].[roles] ([rid])
GO
ALTER TABLE [dbo].[roles-features] CHECK CONSTRAINT [FK_roles-features_roles]
GO
ALTER TABLE [dbo].[schedules]  WITH CHECK ADD  CONSTRAINT [FK_schedules_doctor_id] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[schedules] CHECK CONSTRAINT [FK_schedules_doctor_id]
GO
ALTER TABLE [dbo].[services]  WITH CHECK ADD  CONSTRAINT [FK_services_departments] FOREIGN KEY([department_id])
REFERENCES [dbo].[departments] ([department_id])
GO
ALTER TABLE [dbo].[services] CHECK CONSTRAINT [FK_services_departments]
GO
ALTER TABLE [dbo].[services]  WITH CHECK ADD  CONSTRAINT [FK_services_servicepackages] FOREIGN KEY([package_id])
REFERENCES [dbo].[servicepackages] ([package_id])
GO
ALTER TABLE [dbo].[services] CHECK CONSTRAINT [FK_services_servicepackages]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_appointments] FOREIGN KEY([appointment_id])
REFERENCES [dbo].[appointments] ([appointment_id])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_appointments]
GO
ALTER TABLE [dbo].[userpackages]  WITH CHECK ADD  CONSTRAINT [FK_userpackages_servicepackages] FOREIGN KEY([package_id])
REFERENCES [dbo].[servicepackages] ([package_id])
GO
ALTER TABLE [dbo].[userpackages] CHECK CONSTRAINT [FK_userpackages_servicepackages]
GO
ALTER TABLE [dbo].[userpackages]  WITH CHECK ADD  CONSTRAINT [FK_userpackages_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[userpackages] CHECK CONSTRAINT [FK_userpackages_users]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_roles] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([rid])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_roles]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
ALTER TABLE [dbo].[services]  WITH CHECK ADD CHECK  (([type]='Medical Examination' OR [type]='Consultation'))
GO
USE [master]
GO
ALTER DATABASE [SWP391_GROUP6_1] SET  READ_WRITE 
GO
