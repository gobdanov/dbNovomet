USE [master]
GO

CREATE DATABASE [NOVOMET2];
GO

ALTER DATABASE [NOVOMET2] SET COMPATIBILITY_LEVEL = 170
GO

USE [NOVOMET2]
GO

-- Справочник: Операции
CREATE TABLE [dbo].[operations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_operations] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_operations_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Работы
CREATE TABLE [dbo].[works](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_works] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_works_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Изделия
CREATE TABLE [dbo].[commodities](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](12) NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_commodities] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_commodities_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Производства
CREATE TABLE [dbo].[productions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_productions] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_productions_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Заказчики
CREATE TABLE [dbo].[customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](12) NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_customers] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_customers_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Обработки
CREATE TABLE [dbo].[processings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_processings] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_processings_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Обособленные подразделения
CREATE TABLE [dbo].[separate_subdivisions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_separate_subdivisions] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_separate_subdivisions_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Посты
CREATE TABLE [dbo].[posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_posts] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_posts_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

-- Справочник: Группы ресурсов
CREATE TABLE [dbo].[resource_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [int] NOT NULL,
	[name] [nvarchar](64) NOT NULL,
 CONSTRAINT [pk_resource_groups] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_resource_groups_code] UNIQUE NONCLUSTERED ([code] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[surname] [nvarchar](50) NOT NULL,
	[lastname] [nvarchar](50) NOT NULL,
	[username] [nvarchar](24) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[role] [nvarchar](15) NOT NULL,
	[registration_date] [datetime] NOT NULL,
 CONSTRAINT [pk_users] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [uq_users_username] UNIQUE NONCLUSTERED ([username] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[users] ADD CONSTRAINT [df_users_role] DEFAULT ('executor') FOR [role]
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [df_users_registration_date] DEFAULT (getdate()) FOR [registration_date]
GO
ALTER TABLE [dbo].[users] WITH CHECK ADD CONSTRAINT [chk_users_role] CHECK (([role]='executor' OR [role]='dispatcher'))
GO

CREATE TABLE [dbo].[works_version](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[work_id] [int] NOT NULL,
	[time_standard] [int] NULL,
	[people_standard] [int] NULL,
	[delivery_time_standard] [int] NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [pk_works_version] PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[works_version] ADD CONSTRAINT [df_wor_ver_created_at] DEFAULT (getdate()) FOR [created_at]
GO

CREATE TABLE [dbo].[requests](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dispatcher_id] [int] NOT NULL,
	[operation_id] [int] NOT NULL,
	[work_id] [int] NOT NULL,
	[commodity_id] [int] NOT NULL,
	[production_id] [int] NOT NULL,
	[customer_id] [int] NOT NULL,
	[object_name] [nvarchar](64) NOT NULL,
	[processing_id] [int] NOT NULL,
	[separate_subdivision_id] [int] NOT NULL,
	[post_id] [int] NOT NULL,
	[resource_group_id] [int] NOT NULL,
	[status] [varchar](20) NOT NULL,
	[priority] [varchar](20) NOT NULL,
	[executor_id] [int] NULL,
	[well] [nvarchar](24) NOT NULL,
	[well_cluster] [nvarchar](48) NOT NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [pk_requests] PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[requests] ADD CONSTRAINT [df_requests_status] DEFAULT ('new') FOR [status]
GO
ALTER TABLE [dbo].[requests] ADD CONSTRAINT [df_requests_priority] DEFAULT ('critical') FOR [priority]
GO
ALTER TABLE [dbo].[requests] ADD CONSTRAINT [df_requests_executor_id] DEFAULT (NULL) FOR [executor_id]
GO
ALTER TABLE [dbo].[requests] ADD CONSTRAINT [df_requests_well] DEFAULT ('куст -1') FOR [well]
GO
ALTER TABLE [dbo].[requests] ADD CONSTRAINT [df_requests_well_cluster] DEFAULT ('скважина -1') FOR [well_cluster]
GO
ALTER TABLE [dbo].[requests] ADD DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [chk_requests_priority] CHECK (([priority]='low' OR [priority]='normal' OR [priority]='critical'))
GO
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [chk_requests_status] CHECK (([status]='new' OR [status]='in_progress' OR [status]='done'))
GO

CREATE TABLE [dbo].[reports](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[executor_id] [int] NOT NULL,
	[request] [int] NOT NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[vvn] [float] NULL,
	[ped] [float] NULL,
	[i_n] [float] NULL,
	[u_n] [float] NULL,
	[load] [float] NULL,
	[r_iz] [float] NULL,
	[u_otp] [float] NULL,
	[p] [float] NULL,
	[t] [float] NULL,
	[zp] [float] NULL,
	[esp] [float] NULL,
	[descent_depth] [float] NULL,
	[nst] [float] NULL,
	[comment] [nvarchar](512) NULL,
	[photo] [nvarchar](512) NULL,
 CONSTRAINT [pk_reports] PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[reports] ADD CONSTRAINT [df_reports_start_time] DEFAULT (NULL) FOR [start_time]
GO
ALTER TABLE [dbo].[reports] ADD CONSTRAINT [df_reports_end_time] DEFAULT (NULL) FOR [end_time]
GO
ALTER TABLE [dbo].[reports] ADD CONSTRAINT [df_reports_comment] DEFAULT (NULL) FOR [comment]
GO
ALTER TABLE [dbo].[reports] ADD CONSTRAINT [df_reports_photo] DEFAULT (NULL) FOR [photo]
GO

ALTER TABLE [dbo].[works_version] WITH CHECK ADD CONSTRAINT [works_version_work_fk]
FOREIGN KEY([work_id]) REFERENCES [dbo].[works] ([id])
GO

-- Диспетчер
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_dispatcher_fk]
FOREIGN KEY([dispatcher_id]) REFERENCES [dbo].[users] ([id])
GO

-- Операция
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_operation_fk]
FOREIGN KEY([operation_id]) REFERENCES [dbo].[operations] ([id])
GO

-- Работа
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_work_fk]
FOREIGN KEY([work_id]) REFERENCES [dbo].[works] ([id])
GO

-- Изделие
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_commodity_fk]
FOREIGN KEY([commodity_id]) REFERENCES [dbo].[commodities] ([id])
GO

-- Производство
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_production_fk]
FOREIGN KEY([production_id]) REFERENCES [dbo].[productions] ([id])
GO

-- Заказчик
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_customer_fk]
FOREIGN KEY([customer_id]) REFERENCES [dbo].[customers] ([id])
GO

-- Обработка
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_processing_fk]
FOREIGN KEY([processing_id]) REFERENCES [dbo].[processings] ([id])
GO

-- Обособленное подразделение
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_sep_sub_fk]
FOREIGN KEY([separate_subdivision_id]) REFERENCES [dbo].[separate_subdivisions] ([id])
GO

-- Пост
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_post_fk]
FOREIGN KEY([post_id]) REFERENCES [dbo].[posts] ([id])
GO

-- Группа ресурсов
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [request_res_gr_fk]
FOREIGN KEY([resource_group_id]) REFERENCES [dbo].[resource_groups] ([id])
GO

-- Исполнитель (может быть NULL)
ALTER TABLE [dbo].[requests] WITH CHECK ADD CONSTRAINT [requests_executor_id]
FOREIGN KEY([executor_id]) REFERENCES [dbo].[users] ([id])
GO

-- Исполнитель
ALTER TABLE [dbo].[reports] WITH CHECK ADD CONSTRAINT [report_executor_fk]
FOREIGN KEY([executor_id]) REFERENCES [dbo].[users] ([id])
GO

-- Заявка (с каскадным удалением)
ALTER TABLE [dbo].[reports] WITH CHECK ADD CONSTRAINT [report_request_fk]
FOREIGN KEY([request]) REFERENCES [dbo].[requests] ([id])
ON DELETE CASCADE
GO