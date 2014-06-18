/* 添加应用数据 */
DELETE FROM [dbo].[tn_Applications] WHERE [ApplicationId] = 9001
INSERT INTO [dbo].[tn_Applications] ([ApplicationId],[ApplicationKey],[ClassType],[IsEnabled],[IsLocked],[DisplayOrder])
     VALUES(9001,'Iditu','Tunynet.Examples.Iditu.IdituApplication,Tunynet.Examples.Iditu',1,0,101)

/* 应用在呈现区域的设置 */
DELETE FROM [dbo].[tn_ApplicationInPresentAreaSettings] WHERE [ApplicationId] = 9001
INSERT INTO [dbo].[tn_ApplicationInPresentAreaSettings] (ApplicationId,PresentAreaKey,IsBuiltIn,IsAutoInstall,IsGenerateData) VALUES(9001,'Channel',1,1,0)
INSERT INTO [dbo].[tn_ApplicationInPresentAreaSettings] (ApplicationId,PresentAreaKey,IsBuiltIn,IsAutoInstall,IsGenerateData) VALUES(9001,'UserSpace',1,1,1)

/* 应用在呈现区域的导航初始化数据 */
DELETE FROM [dbo].[tn_InitialNavigations] WHERE [ApplicationId] = 9001

INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(109001001,0,0,'Channel',9001,0,'Iditu','','','Iditu_Channel_Home',null,null,9,0,1,1)
INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(109001011,109001001,1,'Channel',9001,0,'Iditu首页','','','Iditu_Channel_Home',null,null,1,0,1,1)
INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(109001012,109001001,1,'Channel',9001,0,'Iditu搜索','','~/Iditu/Search/','',null,null,2,0,0,1)
INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(109001019,109001001,1,'Channel',9001,0,'我的Iditu','','','Iditu_UserSpace_Home',null,null,9,0,1,1)

INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(119001001,0,0,'UserSpace',9001,0,'Iditu','','','Iditu_UserSpace_Home',null,null,9,0,1,1)
INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(119001011,0,0,'UserSpace',9001,1,'我的Iditu','','','Iditu_UserSpace_Home',null,null,9,0,1,1)
INSERT INTO [dbo].[tn_InitialNavigations] (NavigationId,ParentNavigationId,Depth,PresentAreaKey,ApplicationId,NavigationType,NavigationText,
  ResourceName,NavigationUrl,UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,OnlyOwnerVisible,IsLocked,IsEnabled) 
  VALUES(119001018,0,0,'UserSpace',9001,1,'Iditu广场','','','Iditu_Channel_Home',null,null,9,0,1,1)

/* 应用在呈现区域的管理操作 */
DELETE FROM [dbo].[tn_ApplicationManagementOperations] WHERE [ApplicationId] = 9001

INSERT INTO [dbo].[tn_ApplicationManagementOperations] (OperationId,ApplicationId,PresentAreaKey,OperationType,OperationText,ResourceName,NavigationUrl,
  UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,IsLocked,IsEnabled) VALUES(109001001,9001,'Channel',1,'发布Iditu','','','Iditu_Create',null,null,1,1,1)
  
INSERT INTO [dbo].[tn_ApplicationManagementOperations] (OperationId,ApplicationId,PresentAreaKey,OperationType,OperationText,ResourceName,NavigationUrl,
  UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,IsLocked,IsEnabled) VALUES(119001001,9001,'UserSpace',1,'发布Iditu','','','Iditu_Create',null,null,1,1,1)

INSERT INTO [dbo].[tn_ApplicationManagementOperations] (OperationId,ApplicationId,PresentAreaKey,OperationType,OperationText,ResourceName,NavigationUrl,
  UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,IsLocked,IsEnabled) VALUES(119001011,9001,'UserSpace',2,'管理Iditu','','','Iditu_UserSpace_Manage',null,null,1,1,1)
INSERT INTO [dbo].[tn_ApplicationManagementOperations] (OperationId,ApplicationId,PresentAreaKey,OperationType,OperationText,ResourceName,NavigationUrl,
  UrlRouteName,ImageUrl,NavigationTarget,DisplayOrder,IsLocked,IsEnabled) VALUES(119001012,9001,'UserSpace',2,'Iditu设置','','~/Iditu/Settings.aspx','',null,null,9,1,1)






