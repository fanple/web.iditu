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
