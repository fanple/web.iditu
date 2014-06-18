-----租户类型
DELETE FROM [dbo].[tn_TenantTypes] WHERE [TenantTypeId]='000031'
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'000031', 0, N'评论', N'Tunynet.Common.Comment,Tunynet.BusinessComponents')

-----租户类型关联的服务
DELETE FROM [dbo].[tn_TenantTypesInServices] WHERE [TenantTypeId]='000031'
INSERT [dbo].[tn_TenantTypesInServices] ([TenantTypeId], [ServiceKey]) VALUES (N'000031', N'Recommend')

--2013-7-29 bianchx 在[tn_PointItems]表中添加了一个字段[NeedPointMessage]
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=object_id('tn_PointItems') and name='NeedPointMessage')
	ALTER TABLE tn_PointItems ADD NeedPointMessage tinyint not null DEFAULT (0)
GO
UPDATE tn_PointItems SET NeedPointMessage=1 where ItemKey in ('Ask_CreateAnswer','Ask_CreateQuestion','Ask_DeleteAnswer' ,'Bar_CreateThread' ,
'Bar_DeleteThread' ,'Blog_CreateThread' ,'Blog_DeleteThread' ,'CreateComment' ,'DeleteComment' ,'FirstUploadAvatar' ,'Group_CreateGroup' ,
'Microblog_CreateMicroblog' ,'Microblog_DeleteMicroblog' ,'Photo_DeletePhoto' ,'Photo_UploadPhoto' ,'Register')

--2013-08-07 zhengw 删除Tunynet.Common.InvitationSettings, Tunynet.BusinessComponents，以便更新至最新设置项
DELETE FROM [dbo].[tn_Settings] WHERE [ClassType]='Tunynet.Common.InvitationSettings, Tunynet.BusinessComponents'

--2013-08-07 zhengw  微博使用到了收藏服务
DELETE FROM [dbo].[tn_TenantTypesInServices] WHERE [TenantTypeId]='100101' and [ServiceKey]=N'Favorites'
INSERT [dbo].[tn_TenantTypesInServices] ([TenantTypeId], [ServiceKey]) VALUES (N'100101', N'Favorites')

--2013-08-07 zhengw 修复删除垃圾数据，没有效果
DELETE FROM [dbo].[tn_TenantTypes] WHERE [ApplicationId] = 1001
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'100101', 1001, N'微博', N'Spacebuilder.Microblog.MicroblogEntity,Spacebuilder.Microblog.Service')

DELETE FROM [dbo].[tn_TenantTypes] WHERE [ApplicationId]=1002
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'100200', 1002, N'日志应用', N'')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'100201', 1002, N'日志', N'Spacebuilder.Blog.BlogThread,Spacebuilder.Blog.Service')

DELETE FROM [dbo].[tn_TenantTypes] WHERE [ApplicationId] = 1012
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101200', 1012, N'帖吧', N'')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101201', 1012, N'帖吧', N'Spacebuilder.Bar.BarSection,Spacebuilder.Bar.Service')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101202', 1012, N'帖子', N'Spacebuilder.Bar.BarThread,Spacebuilder.Bar.Service')

--2013-8-8 zhengw 在[tn_AccountBindings]表中添加了序列化字段
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=object_id('tn_AccountBindings') and name='PropertyNames')
	ALTER TABLE tn_AccountBindings ADD PropertyNames nvarchar(MAX) NULL
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=object_id('tn_AccountBindings') and name='PropertyValues')
	ALTER TABLE tn_AccountBindings ADD PropertyValues nvarchar(MAX) NULL
GO

/****** Object:  Table [dbo].[spb_cms_Addon_Links]    Script Date: 07/26/2013 15:08:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_Addon_Links]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_Addon_Links]
GO
/****** Object:  Table [dbo].[spb_cms_Addon_News]    Script Date: 07/26/2013 15:08:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_Addon_News]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_Addon_News]
GO
/****** Object:  Table [dbo].[spb_cms_ContentAttachments]    Script Date: 07/26/2013 15:08:51 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_FileName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_FileName]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_FriendlyFileName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_FriendlyFileName]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_MediaType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_MediaType]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_ContentType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_ContentType]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_FileLength]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_FileLength]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_Height]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_Height]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_Price]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_Price]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentAttachments_Password]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentAttachments] DROP CONSTRAINT [DF_spb_cms_ContentAttachments_Password]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentAttachments]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentAttachments]
GO
/****** Object:  Table [dbo].[spb_cms_ContentFolderModerators]    Script Date: 07/26/2013 15:08:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentFolderModerators]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentFolderModerators]
GO
/****** Object:  Table [dbo].[spb_cms_ContentFolders]    Script Date: 07/26/2013 15:08:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentFolders]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentFolders]
GO
/****** Object:  Table [dbo].[spb_cms_ContentItems]    Script Date: 07/26/2013 15:08:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentItems]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentItems]
GO
/****** Object:  Table [dbo].[spb_cms_ContentTypeColumnDefinitions]    Script Date: 07/26/2013 15:08:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentTypeColumnDefinitions]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentTypeColumnDefinitions]
GO
/****** Object:  Table [dbo].[spb_cms_ContentTypeDefinitions]    Script Date: 07/26/2013 15:08:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_spb_cms_ContentTypeDefinitions_AllowContributeRoleNames]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[spb_cms_ContentTypeDefinitions] DROP CONSTRAINT [DF_spb_cms_ContentTypeDefinitions_AllowContributeRoleNames]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_ContentTypeDefinitions]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_ContentTypeDefinitions]
GO
/****** Object:  Table [dbo].[spb_cms_FormControlDefinitions]    Script Date: 07/26/2013 15:08:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spb_cms_FormControlDefinitions]') AND type in (N'U'))
DROP TABLE [dbo].[spb_cms_FormControlDefinitions]
GO
/****** Object:  Table [dbo].[spb_cms_FormControlDefinitions]    Script Date: 07/26/2013 15:08:52 ******/
/****** Object:  Table [dbo].[spb_cms_FormControlDefinitions]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_FormControlDefinitions](
	[ControlCode] [varchar](64) NOT NULL,
	[ControlName] [nvarchar](64) NOT NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK_spb_cms_FormControlDefinitions] PRIMARY KEY CLUSTERED 
(
	[ControlCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[spb_cms_ContentTypeDefinitions]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentTypeDefinitions](
	[ContentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ContentTypeName] [nvarchar](64) NOT NULL,
	[ContentTypeKey] [varchar](64) NOT NULL,
	[IsBuiltIn] [tinyint] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[TableName] [varchar](64) NOT NULL,
	[ForeignKey] [varchar](64) NOT NULL,
	[Page_New] [varchar](128) NOT NULL,
	[Page_Edit] [varchar](128) NOT NULL,
	[Page_Manage] [varchar](128) NOT NULL,
	[Page_Default_List] [varchar](128) NOT NULL,
	[Page_Default_Detail] [varchar](128) NOT NULL,
	[IsEnabled] [tinyint] NOT NULL,
	[EnableContribute] [tinyint] NOT NULL,
	[EnableComment] [tinyint] NOT NULL,
	[EnableAttachment] [tinyint] NOT NULL,
	[AllowContributeRoleNames] [varchar](512) NOT NULL,
 CONSTRAINT [PK_spb_cms_ContentTypeDefinitions] PRIMARY KEY CLUSTERED 
(
	[ContentTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'允许投稿的角色名集合，多个角色名用英文逗号隔开' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentTypeDefinitions', @level2type=N'COLUMN',@level2name=N'AllowContributeRoleNames'
GO
/****** Object:  Table [dbo].[spb_cms_ContentTypeColumnDefinitions]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentTypeColumnDefinitions](
	[ColumnId] [int] IDENTITY(1,1) NOT NULL,
	[ContentTypeId] [int] NOT NULL,
	[ColumnName] [varchar](64) NOT NULL,
	[ColumnLabel] [nvarchar](128) NOT NULL,
	[IsBuiltIn] [tinyint] NOT NULL,
	[DataType] [varchar](64) NOT NULL,
	[Length] [int] NOT NULL,
	[Precision] [varchar](64) NOT NULL,
	[IsNotNull] [tinyint] NOT NULL,
	[DefaultValue] [nvarchar](64) NOT NULL,
	[IsIndex] [tinyint] NOT NULL,
	[IsUnique] [tinyint] NOT NULL,
	[KeyOrIndexName] [varchar](64) NOT NULL,
	[KeyOrIndexColumns] [varchar](255) NOT NULL,
	[ControlCode] [varchar](64) NOT NULL,
	[InitialValue] [varchar](20) NOT NULL,
	[EnableInput] [tinyint] NOT NULL,
	[EnableEdit] [tinyint] NOT NULL,
	[ValidateRole] [nvarchar](64) NULL,
 CONSTRAINT [PK_spb_cms_ContentTypeColumnDefinitions] PRIMARY KEY CLUSTERED 
(
	[ColumnId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[spb_cms_ContentItems]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentItems](
	[ContentItemId] [bigint] IDENTITY(1,1) NOT NULL,
	[ContentFolderId] [int] NOT NULL,
	[ContentTypeId] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[FeaturedImageAttachmentId] [bigint] NULL,
	[FeaturedImage] [nvarchar](255) NULL,
	[UserId] [bigint] NOT NULL,
	[Author] [nvarchar](64) NOT NULL,
	[Summary] [nvarchar](512) NOT NULL,
	[IsContributed] [tinyint] NOT NULL,
	[IsEssential] [tinyint] NOT NULL,
	[IsGlobalSticky] [tinyint] NOT NULL,
	[GlobalStickyDate] [datetime] NOT NULL,
	[IsFolderSticky] [tinyint] NOT NULL,
	[FolderStickyDate] [datetime] NOT NULL,
	[IsLocked] [tinyint] NOT NULL,
	[AuditStatus] [smallint] NOT NULL,
	[IP] [nvarchar](64) NOT NULL,
	[ReleaseDate] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[DisplayOrder] [bigint] NOT NULL,
	[PropertyNames] [nvarchar](max) NULL,
	[PropertyValues] [nvarchar](max) NULL,
 CONSTRAINT [PK_spb_cms_ContentItems] PRIMARY KEY CLUSTERED 
(
	[ContentItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentItems', @level2type=N'COLUMN',@level2name=N'Summary'
GO
/****** Object:  Table [dbo].[spb_cms_ContentFolders]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentFolders](
	[ContentFolderId] [int] IDENTITY(1,1) NOT NULL,
	[FolderName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[ParentId] [int] NOT NULL,
	[ParentIdList] [nvarchar](255) NOT NULL,
	[ChildCount] [int] NOT NULL,
	[Depth] [int] NOT NULL,
	[IsEnabled] [tinyint] NOT NULL,
	[ContentItemCount] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[ContentTypeKeys] [nvarchar](255) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[EnableContribute] [tinyint] NOT NULL,
	[IsAsNavigation] [tinyint] NOT NULL,
	[NeedAuditing] [tinyint] NOT NULL,
	[IsLink] [tinyint] NOT NULL,
	[LinkUrl] [nvarchar](255) NOT NULL,
	[IsLinkToNewWindow] [tinyint] NOT NULL,
	[Page_List] [varchar](128) NOT NULL,
	[Page_Detail] [varchar](128) NOT NULL,
	[ExtensionField] [nvarchar](max) NULL,
	[PropertyNames] [nvarchar](max) NULL,
	[PropertyValues] [nvarchar](max) NULL,
 CONSTRAINT [PK_spb_cms_ContentFolders] PRIMARY KEY CLUSTERED 
(
	[ContentFolderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'内容模型Key集合(多个用英文逗号隔开)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentFolders', @level2type=N'COLUMN',@level2name=N'ContentTypeKeys'
GO
/****** Object:  Table [dbo].[spb_cms_ContentFolderModerators]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentFolderModerators](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContentFolderId] [int] NOT NULL,
	[UserId] [bigint] NOT NULL,
 CONSTRAINT [PK_spb_cms_ContentFolderModerators] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[spb_cms_ContentAttachments]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_ContentAttachments](
	[AttachmentId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[UserDisplayName] [nvarchar](64) NOT NULL,
	[FileName] [nvarchar](255) NOT NULL,
	[FriendlyFileName] [nvarchar](255) NOT NULL,
	[MediaType] [int] NOT NULL,
	[ContentType] [nvarchar](128) NOT NULL,
	[FileLength] [bigint] NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[Password] [nvarchar](32) NOT NULL,
	[IP] [nvarchar](64) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[PropertyNames] [nvarchar](max) NULL,
	[PropertyValues] [nvarchar](max) NULL,
 CONSTRAINT [PK_spb_cms_ContentAttachments] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附件上传人UserId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附件上传人名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'UserDisplayName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实际存储文件名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'FileName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文件显示名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'FriendlyFileName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'媒体类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'MediaType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附件MIME类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'ContentType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文件大小' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'FileLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'图片类型附件的高度（单位:px）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'Height'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'图片类型附件的宽度（单位:px）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'Width'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'售价（积分）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'Price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'下载密码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'附件上传人IP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'DateCreated'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'可序列化属性名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'PropertyNames'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'可序列化属性内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_ContentAttachments', @level2type=N'COLUMN',@level2name=N'PropertyValues'
GO
/****** Object:  Table [dbo].[spb_cms_Addon_News]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_Addon_News](
	[ContentItemId] [bigint] NOT NULL,
	[TrimBodyAsSummary] [tinyint] NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[CopyFrom] [nvarchar](255) NOT NULL,
	[CopyFromUrl] [nvarchar](512) NOT NULL,
	[EnableComment] [tinyint] NOT NULL,
	[OriginalAuthor] [nvarchar](64) NOT NULL,
	[Editor] [nvarchar](64) NOT NULL,
	[Color] [varchar](16) NOT NULL,
	[IsBold] [tinyint] NOT NULL,
	[FirstAsTitleImage] [tinyint] NOT NULL,
	[AutoPage] [tinyint] NOT NULL,
	[PageLength] [int] NOT NULL,
 CONSTRAINT [PK_spb_cms_Addon_News] PRIMARY KEY CLUSTERED 
(
	[ContentItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'关联主表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'ContentItemId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否截取内容前200字作为摘要' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'TrimBodyAsSummary'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'内容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'Body'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'来源名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'CopyFrom'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'来源地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'CopyFromUrl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否允许评论' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'EnableComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'原创作者用户Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'OriginalAuthor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'责任编辑用户Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'Editor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标题颜色' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'Color'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标题是否加粗' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'IsBold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'设置第一张图片为标题图' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'FirstAsTitleImage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'分页类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'AutoPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每页显示的字符' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_News', @level2type=N'COLUMN',@level2name=N'PageLength'
GO
/****** Object:  Table [dbo].[spb_cms_Addon_Links]    Script Date: 07/30/2013 15:50:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spb_cms_Addon_Links](
	[ContentItemId] [int] NOT NULL,
	[Color] [varchar](16) NOT NULL,
	[IsBold] [tinyint] NOT NULL,
	[LinkUrl] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_spb_cms_Addon_Links] PRIMARY KEY CLUSTERED 
(
	[ContentItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'关联主表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_Links', @level2type=N'COLUMN',@level2name=N'ContentItemId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标题颜色' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_Links', @level2type=N'COLUMN',@level2name=N'Color'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否加粗' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_Links', @level2type=N'COLUMN',@level2name=N'IsBold'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'链接地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'spb_cms_Addon_Links', @level2type=N'COLUMN',@level2name=N'LinkUrl'
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_FileName]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_FileName]  DEFAULT ('') FOR [FileName]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_FriendlyFileName]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_FriendlyFileName]  DEFAULT ('') FOR [FriendlyFileName]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_MediaType]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_MediaType]  DEFAULT ((99)) FOR [MediaType]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_ContentType]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_ContentType]  DEFAULT ('') FOR [ContentType]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_FileLength]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_FileLength]  DEFAULT ((0)) FOR [FileLength]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_Height]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_Height]  DEFAULT ((0)) FOR [Height]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_Price]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_Price]  DEFAULT ((0)) FOR [Price]
GO
/****** Object:  Default [DF_spb_cms_ContentAttachments_Password]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentAttachments] ADD  CONSTRAINT [DF_spb_cms_ContentAttachments_Password]  DEFAULT ('') FOR [Password]
GO
/****** Object:  Default [DF_spb_cms_ContentTypeDefinitions_AllowContributeRoleNames]    Script Date: 07/30/2013 15:50:34 ******/
ALTER TABLE [dbo].[spb_cms_ContentTypeDefinitions] ADD  CONSTRAINT [DF_spb_cms_ContentTypeDefinitions_AllowContributeRoleNames]  DEFAULT ('') FOR [AllowContributeRoleNames]
GO

-----添加应用数据
DELETE FROM [dbo].[tn_Applications] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_Applications] ([ApplicationId], [ApplicationKey], [Description], [IsEnabled], [IsLocked], [DisplayOrder]) VALUES (1015, N'CMS', N'资讯应用', 1, 0, 1015)

-----应用在呈现区域的设置
DELETE FROM [dbo].[tn_ApplicationInPresentAreaSettings] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_ApplicationInPresentAreaSettings] ([ApplicationId], [PresentAreaKey], [IsBuiltIn], [IsAutoInstall], [IsGenerateData]) VALUES (1015, N'Channel', 0, 1, 1)
INSERT [dbo].[tn_ApplicationInPresentAreaSettings] ([ApplicationId], [PresentAreaKey], [IsBuiltIn], [IsAutoInstall], [IsGenerateData]) VALUES (1015, N'UserSpace', 0, 1, 0)

-----默认安装记录
DELETE FROM [dbo].[tn_ApplicationInPresentAreaInstallations] WHERE [ApplicationId] = 1015 and OwnerId = 0
INSERT [dbo].[tn_ApplicationInPresentAreaInstallations] ([OwnerId], [ApplicationId], [PresentAreaKey]) VALUES (0, 1015, 'Channel')

-----快捷操作
DELETE FROM [dbo].[tn_ApplicationManagementOperations] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_ApplicationManagementOperations] ([OperationId], [ApplicationId], [AssociatedNavigationId], [PresentAreaKey], [OperationType], [OperationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (10101501, 1015, 0, N'Channel', 1, N'投稿', N'', N'', N'Channel_CMS_Contribute', NULL, N'', NULL, N'_self', 10101501, 0, 1, 1)

-------动态
DELETE FROM  [dbo].[tn_ActivityItems] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_ActivityItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [Description], [IsOnlyOnce], [IsUserReceived], [IsSiteReceived]) VALUES (N'CreateCmsComment', 1015, N'评论资讯', 1, N'', 0, 1, 0)

-----用户角色
DELETE FROM [dbo].[tn_Roles] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_Roles] ([RoleName], [FriendlyRoleName], [IsBuiltIn], [ConnectToUser], [ApplicationId], [IsPublic], [Description], [IsEnabled], [RoleImage]) VALUES (N'CMSAdministrator', N'资讯管理员', 1, 1, 1015, 1, N'管理资讯应用下的内容', 1, N'')

-- 应用的审核规则
delete from tn_ApplicationData where ApplicationId=1015
insert tn_ApplicationData([ApplicationId] ,[TenantTypeId],[Datakey],[LongValue],[DecimalValue] ,[StringValue]) values(1015,'','PubliclyAuditStatus',40,0.0000,'')

-----自运行任务
DELETE FROM [dbo].[tn_TaskDetails] WHERE [ClassType] = N'Spacebuilder.CMS.ExpireStickyContentItemTask,Spacebuilder.CMS'
INSERT [dbo].[tn_TaskDetails] ([Name], [TaskRule], [ClassType], [Enabled], [RunAtRestart], [IsRunning], [LastStart], [LastEnd], [LastIsSuccess], [NextStart], [StartDate], [EndDate], [RunAtServer]) VALUES (N'更新置顶时间到期的资讯', N'0 0 0/12 * * ?', N'Spacebuilder.CMS.ExpireStickyContentItemTask,Spacebuilder.CMS', 1, 0, 0, N'', N'', 1, N'', N'', NULL, 0)

-----权限项
DELETE FROM [dbo].[tn_PermissionItems] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_PermissionItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [EnableQuota], [EnableScope]) VALUES (N'CMS_ContentItem', 1015, N'资讯投稿', 16, 0, 0)

-----角色针对权限的设置
DELETE FROM [dbo].[tn_PermissionItemsInUserRoles] WHERE [ItemKey] = N'CMS_ContentItem' and [RoleName] = N'RegisteredUsers'
INSERT [dbo].[tn_PermissionItemsInUserRoles] ([RoleName], [ItemKey], [PermissionType], [PermissionQuota], [PermissionScope], [IsLocked]) VALUES ( N'RegisteredUsers', N'CMS_ContentItem', 1, 0, 0, 0)

-----审核项
DELETE FROM [dbo].[tn_AuditItems] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_AuditItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [Description]) VALUES (N'CMS_ContentItem', 1015, N'资讯', 1, N'')

--审核规则
DELETE FROM [dbo].[tn_AuditItemsInUserRoles] WHERE [ItemKey] = N'CMS_ContentItem' and [RoleName] = N'RegisteredUsers'
INSERT [dbo].[tn_AuditItemsInUserRoles]([RoleName],[ItemKey] ,[StrictDegree],[IsLocked])VALUES(N'RegisteredUsers',N'CMS_ContentItem',2 ,0)

-----积分项
DELETE FROM [dbo].[tn_PointItems] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_PointItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [ExperiencePoints], [ReputationPoints], [TradePoints], [TradePoints2], [TradePoints3], [TradePoints4], [Description],[NeedPointMessage]) VALUES (N'CMS_ContributeAccepted', 1015, N'投稿被采纳', 151, 20, 0, 20, 0, 0, 0, N'',0)
INSERT [dbo].[tn_PointItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [ExperiencePoints], [ReputationPoints], [TradePoints], [TradePoints2], [TradePoints3], [TradePoints4], [Description],[NeedPointMessage]) VALUES (N'CMS_ContributeDeleted', 1015, N'投稿被删除', 151, -20, 0, -20, 0, 0, 0, N'',0)
INSERT [dbo].[tn_PointItems] ([ItemKey], [ApplicationId], [ItemName], [DisplayOrder], [ExperiencePoints], [ReputationPoints], [TradePoints], [TradePoints2], [TradePoints3], [TradePoints4], [Description],[NeedPointMessage]) VALUES (N'CMS_StickyNews', 1015, N'投稿被置顶', 151, 100, 0, 100, 0, 0, 0, N'',0)

-----推荐类别
DELETE FROM [dbo].[tn_RecommendItemTypes] WHERE [TypeId] in (N'10150101',N'10150102')
INSERT [dbo].[tn_RecommendItemTypes] ([TypeId], [TenantTypeId], [Name], [Description], [HasFeaturedImage], [DateCreated]) VALUES (N'10150101', N'101501', N'推荐资讯幻灯片', N'', 1, getdate())
INSERT [dbo].[tn_RecommendItemTypes] ([TypeId], [TenantTypeId], [Name], [Description], [HasFeaturedImage], [DateCreated]) VALUES (N'10150102', N'000031', N'精彩点评', N'', 0, getdate())

-----租户类型
DELETE FROM [dbo].[tn_TenantTypes] WHERE TenantTypeId in ('101500','101501','101502')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101500', 1015, N'资讯应用', N'')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101501', 1015, N'资讯', N'Spacebuilder.CMS.ContentItem,Spacebuilder.CMS.Service')
INSERT [dbo].[tn_TenantTypes] ([TenantTypeId], [ApplicationId], [Name], [ClassType]) VALUES (N'101502', 1015, N'资讯附件', N'Spacebuilder.CMS.ContentAttachment,Spacebuilder.CMS.Service')

-----租户使用到的服务
DELETE FROM [dbo].[tn_TenantTypesInServices] WHERE [TenantTypeId] in ('101501','101502')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES('101501','Attachment')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES('101501','Tag')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES('101501','Notice')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101501','Recommend')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101501','Comment')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101501','Attitude')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101501','Visit')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101501','Count')
INSERT INTO [dbo].[tn_TenantTypesInServices]([TenantTypeId],[ServiceKey]) VALUES ('101502','Count')

-----初始化导航
DELETE FROM [dbo].[tn_InitialNavigations] WHERE [ApplicationId] = 1015
INSERT [dbo].[tn_InitialNavigations] ([NavigationId], [ParentNavigationId], [Depth], [PresentAreaKey], [ApplicationId], [NavigationType], [NavigationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (10101501, 0, 0, N'Channel', 1015, 0, N'资讯', N'', N'', N'Channel_CMS_Home', NULL, N'Cms', NULL, N'_self', 10101501, 0, 0, 1)
INSERT [dbo].[tn_InitialNavigations] ([NavigationId], [ParentNavigationId], [Depth], [PresentAreaKey], [ApplicationId], [NavigationType], [NavigationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (10101502, 10101501, 1, N'Channel', 1015, 0, N'资讯首页', N' ', N' ', N'Channel_CMS_Home', NULL, NULL, NULL, N'_self', 10101502, 0, 0, 1)
INSERT [dbo].[tn_InitialNavigations] ([NavigationId], [ParentNavigationId], [Depth], [PresentAreaKey], [ApplicationId], [NavigationType], [NavigationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (10101506, 10101501, 1, N'Channel', 1015, 0, N'我的资讯', N' ', N' ', N'Channel_CMS_My', NULL, NULL, NULL, N'_self', 10101506, 0, 0, 1)
INSERT [dbo].[tn_InitialNavigations] ([NavigationId], [ParentNavigationId], [Depth], [PresentAreaKey], [ApplicationId], [NavigationType], [NavigationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (11101501, 0, 0, N'UserSpace', 1015, 0, N'资讯', N' ', N' ', N'Channel_CMS_User', N'', N'Cms', NULL, N'_blank', 11101501, 0, 0, 1)
INSERT [dbo].[tn_InitialNavigations] ([NavigationId], [ParentNavigationId], [Depth], [PresentAreaKey], [ApplicationId], [NavigationType], [NavigationText], [ResourceName], [NavigationUrl], [UrlRouteName], [RouteDataName], [IconName], [ImageUrl], [NavigationTarget], [DisplayOrder], [OnlyOwnerVisible], [IsLocked], [IsEnabled]) VALUES (20101501, 20000011, 2, N'ControlPanel', 1015, 0, N'资讯', N'', N'', N'ControlPanel_CMS_Home', NULL, NULL, NULL, N'_self', 20101501, 0, 0, 1)

----数据模型
DELETE FROM [spb_cms_ContentTypeDefinitions]
INSERT [spb_cms_ContentTypeDefinitions] ([ContentTypeName], [ContentTypeKey], [IsBuiltIn], [DisplayOrder], [TableName], [ForeignKey], [Page_New], [Page_Edit], [Page_Manage], [Page_Default_List], [Page_Default_Detail], [IsEnabled], [EnableContribute], [EnableComment], [EnableAttachment]) VALUES (N'文章', N'News', 1, 1, N'spb_cms_Addon_News', N'ContentItemId', N'EditNews', N'EditNews', N'ManageNews', N'ListNews', N'ShowNews', 1, 0, 0, 1)
INSERT [spb_cms_ContentTypeDefinitions] ([ContentTypeName], [ContentTypeKey], [IsBuiltIn], [DisplayOrder], [TableName], [ForeignKey], [Page_New], [Page_Edit], [Page_Manage], [Page_Default_List], [Page_Default_Detail], [IsEnabled], [EnableContribute], [EnableComment], [EnableAttachment]) VALUES (N'链接', N'NewsLink', 1, 2, N'spb_cms_Addon_Links', N'ContentItemId', N'EditLink', N'EditLink', N'ManageLinks', N'ListLinks', N'''''', 1, 0, 0, 0)

----副表元信息
DELETE FROM spb_cms_ContentTypeColumnDefinitions
INSERT [spb_cms_ContentTypeColumnDefinitions] 
([ContentTypeId], [ColumnName], [ColumnLabel], [IsBuiltIn], [DataType], [Length], [Precision], [IsNotNull], [DefaultValue], 
[IsIndex], [IsUnique], [KeyOrIndexName], [KeyOrIndexColumns], [ControlCode], [InitialValue], [EnableInput], [EnableEdit], [ValidateRole])
SELECT 
[ContentTypeId]= (select top 1 ContentTypeId from spb_cms_ContentTypeDefinitions where TableName= O.name),
[ColumnName]=C.name,
[ColumnLabel]=cast(ISNULL(PFD.[value],N'') as nvarchar(128)),
[IsBuiltIn]=1,
[DataType]=case when T.name like '%char' then N'string' 
				when T.name = 'tinyint' then N'bool' 
				when T.name = 'smallint' or T.name = 'int' then N'int'
				when T.name = 'bigint' then N'long' 
				else T.name end,
[Length]=C.max_length,
[Precision]=cast(C.precision as varchar(64)),
[IsNotNull]=C.is_nullable,
[DefaultValue]=N'',
[IsIndex]=ISNULL(IDX.IsIndex,0),
[IsUnique]=ISNULL(IDX.IsUnique,0),
[KeyOrIndexName]=ISNULL(IDX.IndexName,N''),
[KeyOrIndexColumns]=case when IDX.IsIndex=1  then C.name else N'' end,
[ControlCode]=N'',
[InitialValue]=N'',
[EnableInput]=1,
[EnableEdit]=case when IDX.IndexName like 'PK%' then 0 else 1 end,
[ValidateRole]=N''
FROM sys.columns C
INNER JOIN sys.objects O
ON C.[object_id]=O.[object_id]
AND O.type='U'
AND O.is_ms_shipped=0
INNER JOIN sys.types T
ON C.user_type_id=T.user_type_id
LEFT JOIN sys.default_constraints D
ON C.[object_id]=D.parent_object_id
AND C.column_id=D.parent_column_id
AND C.default_object_id=D.[object_id]
LEFT JOIN sys.extended_properties PFD
ON PFD.class=1 
AND C.[object_id]=PFD.major_id 
AND C.column_id=PFD.minor_id
LEFT JOIN sys.extended_properties PTB
ON PTB.class=1 
AND PTB.minor_id=0 
AND C.[object_id]=PTB.major_id
LEFT JOIN -- 索引及主键信息
(
SELECT 
IDX.object_id,
IDXC.column_id,
IsIndex=1,
IsUnique=IDX.is_unique,
PrimaryKey=IDX.is_primary_key,
IndexName=IDX.Name
FROM sys.indexes IDX
INNER JOIN sys.index_columns IDXC
ON IDX.[object_id]=IDXC.[object_id]
AND IDX.index_id=IDXC.index_id
LEFT JOIN sys.key_constraints KC
ON IDX.[object_id]=KC.[parent_object_id]
AND IDX.index_id=KC.unique_index_id
INNER JOIN -- 对于一个列包含多个索引的情况,只显示第1个索引信息
(
SELECT [object_id], Column_id, index_id=MIN(index_id)
FROM sys.index_columns
GROUP BY [object_id], Column_id
) IDXCUQ
ON IDXC.[object_id]=IDXCUQ.[object_id]
AND IDXC.Column_id=IDXCUQ.Column_id
AND IDXC.index_id=IDXCUQ.index_id
--WHERE idx.object_id=object_id(N'spb_CMSPages') -- 如果只查询指定表,加上此条件
) IDX
ON C.[object_id]=IDX.[object_id]
AND C.column_id=IDX.column_id

WHERE O.name=N'spb_cms_Addon_News' or O.name=N'spb_cms_Addon_Links' -- 如果只查询指定表,加上此条件
ORDER BY O.name,C.column_id
