--2013-12-03 zhengw 清除tn_ItemsInCategories表中的重复数据
DELETE FROM [dbo].[tn_ItemsInCategories]
WHERE ID NOT IN
(
SELECT MAX(ID)
FROM [dbo].[tn_ItemsInCategories]
GROUP BY CategoryId, ItemId)


delete from tn_AccountTypes where AccountTypeKey='QQ'
INSERT [dbo].[tn_AccountTypes] 
	([AccountTypeKey], [ThirdAccountGetterClassType], [AppKey], [AppSecret], [IsSync], [IsShareMicroBlog], [IsFollowMicroBlog], [OfficialMicroBlogAccount], [IsEnabled]) 
VALUES 
	(N'QQ', N'Spacebuilder.Common.QQAccountGetter,Spacebuilder.Common', N'', N'', 1, 1, 0, N'', 0)