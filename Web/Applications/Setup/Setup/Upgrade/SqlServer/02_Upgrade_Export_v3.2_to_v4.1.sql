if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spb_GetAvatarPath]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[spb_GetAvatarPath]
-----头像相对路径
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[spb_GetAvatarPath] (@id bigint)
RETURNS varchar(100)
AS
BEGIN
	declare @length int, @start int
	declare @tempId nvarchar(100),
			@result nvarchar(100),
			@strId  nvarchar(100)
			
	set @strId = cast(@id as nvarchar(100))
	set @length = len(@strId)
	set @start = 1
	set @result = ''
	
	if(@length > 0 and @length < 15)
	begin
		set @tempId = replicate('0',(15 - @length)) + @strId;
		
		while @start < 15
		begin
			set @result += substring(@tempId,@start,5) + '/'
			set @start += 5
		end
		
		set @result += @strId
		
		return @result
	end
	
	return @result;
END

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spb_GetLinkLogoPath]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[spb_GetLinkLogoPath]
-----链接相对路径
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[spb_GetLinkLogoPath] (@id bigint,@logoName nvarchar(100))
RETURNS varchar(100)
AS
BEGIN
	declare @length int, @start int
	declare @tempId nvarchar(100),
			@result nvarchar(100),
			@strId  nvarchar(100),
			@fileName nvarchar(100)
			
	set @strId = cast(@id as nvarchar(100))
	set @fileName = @logoName
	set @length = len(@strId)
	set @start = 1
	set @result = ''
	
	if(@length > 0 and @length < 15)
	begin
		set @tempId = replicate('0',(15 - @length)) + @strId;
		set @result = '/Link/'
		while @start < 15
		begin
			set @result += substring(@tempId,@start,5) + '/'
			set @start += 5
		end		 
		
		return @result+@fileName
	end
	
	return @result;
END

GO


delete from tn_Users
insert tn_Users ([UserId],[UserName],[Password],[PasswordFormat],[PasswordQuestion],[PasswordAnswer],[Nickname]
				,[ForceLogin],[LastAction],[IPCreated],[IPLastActivity],[DatabaseQuota],[DatabaseQuotaUsed],[IsModerated]
				,[IsForceModerated],[IsEmailVerified],[UserType],[ThemeAppearance],[DateCreated],[TradePoints],[Rank]
				,[AccountEmail],[AccountMobile],[TrueName],[IsActivated],[IsBanned],[BanDeadline]
				,[Avatar],[FollowedCount],[FollowerCount],[ExperiencePoints],[LastActivityTime],[BanReason])
select u.[UserID],[UserName],[Password],CASE WHEN [PasswordFormat]=6 THEN 1 WHEN [PasswordFormat]=0 THEN 0 ELSE 2 END,[PasswordQuestion],[PasswordAnswer],[Nickname]
       ,[ForceLogin],[LastAction],[IPCreated],[IPLastActivity],[DatabaseQuota],[DatabaseQuotaUsed],[IsModerated]
       ,[IsForceModerated],[IsEmailVerified],[UserType],'',u.[DateCreated],[TradePoints],[Rank]
       ,[PrivateEmail],[Mobile],[CommonName]
       ,CASE WHEN UserAccountStatus = 0 or UserAccountStatus = 3 THEN 0 WHEN UserAccountStatus = 1 THEN 1 ELSE 1 END
       ,CASE UserAccountStatus WHEN 2 THEN 1 ELSE 0 END,dateadd(day,50,getdate())
       ,CASE WHEN PropertyNames like '%avatarUrl%' THEN dbo.spb_GetAvatarPath(u.UserId) 
       when p.Gender=1 then 'avatar_male' when p.Gender=2 then 'avatar_female' else 'avatar_default' end
       ,FriendCount + isnull(FollowCount,0),FriendCount + isnull(FollowerCount,0),BasicPoints,getdate(),''
FROM old_spb_Users u left join old_spb_MicroBlogUserDatas mbu on u.UserId = mbu.UserID
left join old_spb_PersonUserProfile p on u.UserID =p.UserID

/*todo:未处理资料完整度*/
delete from spb_Profiles
insert spb_Profiles ([UserId],[Gender],[Birthday],[LunarBirthday],[NowAreaCode],[HomeAreaCode]
					 ,[Email],[Mobile],[QQ],[Msn],[Skype],[Fetion],[Aliwangwang],[CardType]
					 ,[CardID],[Integrity],[Introduction]) 
select p.UserID,Gender,isNull(Birthday,''),N'',NowAreaCode,HomeAreaCode,u.PublicEmail
	   ,u.Mobile,u.QQIM,u.MsnIM,u.SkypeIM,N'',N'',CardType,CardID,0,N''
from old_spb_PersonUserProfile p left join old_spb_Users u on p.UserID = u.UserID

-----用户角色
Create Table #TempRoles(RoleName varchar(32), OldRoleName nvarchar(64),RoleImage nvarchar(255))
insert  #TempRoles values (N'SuperAdministrator',N'SystemAdministrator',N'Role\superadministrator.png')
insert  #TempRoles values (N'ContentAdministrator',N'ContentAdministrator',N'Role\contentadministrator.png')

delete from tn_UsersInRoles
insert tn_UsersInRoles ([UserId],[RoleName]) 
select UserId,IsNull((select top 1 RoleName from #TempRoles where OldRoleName = r.RoleName),RoleName)
from old_spb_UsersInRoles uir left join old_spb_Roles r on uir.RoleID = r.RoleID

drop Table #TempRoles 

-----用户黑名单
delete from tn_StopedUsers
insert tn_StopedUsers(UserId,ToUserId,ToUserDisplayName)
select UserID,ToUserID,ToUserDisplayName
from old_spb_StopedUsers

-----身份认证
delete from spb_IdentificationTypes
GO
set identity_insert spb_IdentificationTypes ON
insert spb_IdentificationTypes(IdentificationTypeId,Name,[Description],
       IdentificationTypeLogo,[Enabled],CreaterId,DateCreated)
select IdentityID,'',IdentityDescription,'',1,UserID,getdate()
from old_spb_UserIdentities
set identity_insert spb_IdentificationTypes OFF
GO

-----账号绑定
delete from tn_AccountBindings

insert tn_AccountBindings ([UserId],[AccountTypeKey],[Identification],[AccessToken]) 
select UserID,case AccountType when 0 then N'SinaWeibo' when 1 then N'QQ' end,Identification,OauthTokenSecret
from old_spb_AccountBindings

-----站点公告
delete from spb_Announcements
set identity_insert spb_Announcements ON
insert spb_Announcements([Id],[Subject],[SubjectStyle],[Body],[IsHyperLink],[HyperLinkUrl],[EnabledDescription],[ReleaseDate],[ExpiredDate]
						  ,[LastModified],[CreatDate],[UserId],[DisplayOrder],[DisplayArea]) 
select [ThreadID],[Subject],SubjectStyle,Body,IsHyperLink,HyperLinkUrl,1,ReleaseDate
	   ,DateExpired,LastModified,DateCreated,UserID,DisplayOrder ,''
from old_spb_Announcements 
set identity_insert spb_Announcements OFF

declare @Id bigint
declare cur cursor local for
select id from spb_Announcements
open cur
fetch next from cur into @Id
while @@FETCH_STATUS=0
begin
declare @mytable table 
(
	Col1 varchar(10)
)	
insert into @mytable  
select (case PresentAreaID when 10 then N'Home' when 11 then N'UserSpace' end)
from old_spb_AnnouncementsInPresentAreas
where ThreadID=@id and PresentAreaID in(10,11)

declare @Colstring varchar(50)
select @Colstring = isnull(@Colstring + ',' , '' ) + isnull( Col1 , '' ) from @mytable 
update spb_Announcements set DisplayArea=@Colstring where id=@id
delete from @mytable
set @Colstring=null
fetch next from Cur into @Id
End 
Close Cur 
Deallocate Cur

-----用户好友分组
Create Table #TempCategories(CategoryId int,OldCategoryId int, CategoryName nvarchar(128))
delete from tn_Categories where TenantTypeId = N'000011' and OwnerId > 0
insert tn_Categories ([ParentId],[OwnerId],[TenantTypeId],[CategoryName]
					  ,[Description],[DisplayOrder],[Depth],[ChildCount],[ItemCount]
					  ,[PrivacyStatus],[AuditStatus],[FeaturedItemId],[LastModified]
					  ,[DateCreated]) 
select 0,UserID,N'000011',CategoryName,Description
	   ,DisplayOrder,0,0,ItemCount,PrivacyStatus,40
	   ,0,MostRecentUpdateDate,DateCreated
from old_spb_FriendUserCategories

insert #TempCategories (CategoryName,OldCategoryId,CategoryId)
select c.CategoryName,oc.CategoryID,c.CategoryId
from tn_Categories c inner join old_spb_FriendUserCategories oc
on c.CategoryName = oc.CategoryName
where TenantTypeId = N'000011' and OwnerId > 0 and OwnerId = UserID

delete from tn_ItemsInCategories 
where exists (select 1 from #TempCategories tc where tc.CategoryId = CategoryId)
insert tn_ItemsInCategories(CategoryId,ItemId)
select isnull(tc.CategoryId,0),oiic.ItemID
from old_spb_FriendsInUserCategories oiic left join #TempCategories tc
on oiic.CategoryID = tc.OldCategoryId

Drop Table #TempCategories

-----用户标签
delete from tn_Tags where TenantTypeId = N'000011'
insert tn_Tags ([TenantTypeId],[TagName],[FeaturedImage]
                ,[IsFeatured],[ItemCount],[OwnerCount],[AuditStatus],[DateCreated]) 
select N'000011',TagName,0,0,ItemCount,UserCount,40,getdate() 
from old_spb_PersonSiteTags

delete from tn_TagsInOwners where TenantTypeId = N'000011' 
insert tn_TagsInOwners (TenantTypeId,TagName,OwnerId)
select TenantTypeId,pt.TagName,ItemId
from old_spb_PersonsInUserTags pt
left join tn_Tags t
on pt.TagName = t.TagName
where TenantTypeId = N'000011' 

delete from tn_ItemsInTags where TenantTypeId = N'000011' 
insert tn_ItemsInTags (TagName,TagInOwnerId,ItemId,TenantTypeId)
select TagName,Id,OwnerId,TenantTypeId
from tn_TagsInOwners
where TenantTypeId = N'000011'

-----友情链接

TRUNCATE TABLE spb_Links
insert spb_Links ([OwnerType],[OwnerId],[LinkName],[LinkType],[LinkUrl],[ImageUrl]
				  ,[Description],[IsEnabled],[DisplayOrder],[DateCreated],[LastModified]) 
select 0,0,Title,case when LinkType=2 then 1 when LinkType=1 then 0 end,LinkHref,ImageUrl,LinkTitle,IsEnabled,DisplayOrder
	   ,getdate(),getdate()
from old_spb_SiteLinks
update spb_Links set ImageUrl=dbo.spb_GetLinkLogoPath(LinkId,ImageUrl) where ImageUrl IS NOT NULL and ImageUrl !='' and OwnerType = 0

insert spb_Links ([OwnerType],[OwnerId],[LinkName],[LinkType],[LinkUrl],[ImageUrl]
				  ,[Description],[IsEnabled],[DisplayOrder],[DateCreated],[LastModified]) 
select 1,UserID,Title,case when LinkType=2 then 1 when LinkType=1 then 0 end,LinkHref,ImageUrl,LinkTitle,IsEnabled,DisplayOrder
	   ,getdate(),getdate()
from old_spb_UserLinks
update spb_Links set ImageUrl=dbo.spb_GetLinkLogoPath(LinkId,ImageUrl) where ImageUrl IS NOT NULL and ImageUrl !='' and OwnerType = 1

insert spb_Links ([OwnerType],[OwnerId],[LinkName],[LinkType],[LinkUrl],[ImageUrl]
				  ,[Description],[IsEnabled],[DisplayOrder],[DateCreated],[LastModified])
select 2,ClubID,Title,case when LinkType=2 then 1 when LinkType=1 then 0 end,LinkHref,ImageUrl,LinkTitle,IsEnabled,DisplayOrder
	   ,getdate(),getdate()
from old_spb_ClubLinks
update spb_Links set ImageUrl=dbo.spb_GetLinkLogoPath(LinkId,ImageUrl) where ImageUrl IS NOT NULL and ImageUrl !='' and OwnerType = 2

update spb_Links set  LinkName= replace(LinkName,'&nbsp;',' ')
drop function [dbo].[spb_GetLinkLogoPath]

-----友情链接站点类别

Create Table #TempLinkCategories(CategoryId int,OldCategoryId int, CategoryName nvarchar(128))
delete from tn_Categories where TenantTypeId = N'000071' and OwnerId = 0
insert tn_Categories ([ParentId],[OwnerId],[TenantTypeId],[CategoryName]
					  ,[Description],[DisplayOrder],[Depth],[ChildCount],[ItemCount]
					  ,[PrivacyStatus],[AuditStatus],[FeaturedItemId],[LastModified]
					  ,[DateCreated]) 
select 0,0,N'000071',CategoryName,Description,DisplayOrder
	   ,0,0,0,2,40,0,getdate(),getdate()
from old_spb_SiteLinkCategories

insert #TempLinkCategories (CategoryName,OldCategoryId,CategoryId)
select c.CategoryName,oc.CategoryID,c.CategoryId
from tn_Categories c inner join old_spb_SiteLinkCategories oc
on c.CategoryName = oc.CategoryName
where TenantTypeId = N'000071' and OwnerId = 0

Create Table #TempLinks(LinkId bigint,OldLinkId bigint,CategoryID bigint)
Insert #TempLinks(LinkId,OldLinkId,CategoryID)
select spb_Links.LinkId,old_spb_SiteLinks.LinkID,old_spb_SiteLinks.CategoryID
from spb_Links inner join old_spb_SiteLinks on spb_Links.LinkName = old_spb_SiteLinks.Title
where OwnerType=0 and OwnerId=0

--delete from tn_ItemsInCategories 
--where exists (select 3 from #TempLinkCategories tc where tc.CategoryId = CategoryId)
insert tn_ItemsInCategories(CategoryId,ItemId)
select tc.CategoryId,LinkID
from #TempLinks ob left join #TempLinkCategories tc
on ob.CategoryID = tc.OldCategoryId
where ob.CategoryID > 0 

delete from #TempLinkCategories
delete from #TempLinks
drop table #TempLinkCategories
drop table #TempLinks


-----短网址
delete from tn_ShortUrls
insert tn_ShortUrls ([Alias],[Url],[OtherShortUrl],[DateCreated]) 
select Alias,Url,N'',DateCreated 
from old_spb_UrlInfos 
-----多媒体网址
delete from tn_ParsedMedias
insert tn_ParsedMedias([Alias],[Url],[MediaType],[Name],[Description],[ThumbnailUrl],[PlayerUrl],[SourceFileUrl],[DateCreated])
select [Alias],[Url],case when MediaType=1 then 2 when MediaType=9999 then 99 end,'','',[ThumbnailUrl],[PlayUrl],'',[DateCreated]
from old_spb_UrlInfos 

------关注用户
delete from tn_Follows
set IDENTITY_INSERT tn_Follows ON
insert tn_Follows ([Id],[UserId],[FollowedUserId],[NoteName],[IsQuietly],[IsNewFollower]
				   ,[IsMutual],[DateCreated]) 
select FriendID,UserID,FriendUserID,ISNULL(NoteName,N''),0,0,1,DateCreated
from old_spb_Friends 
set IDENTITY_INSERT tn_Follows OFF

insert tn_Follows ([UserId],[FollowedUserId],[NoteName],[IsQuietly]
				   ,[IsNewFollower],[IsMutual],[DateCreated]) 
select UserID,ItemID,DisplayName,0,0,1,DateCreated
from old_spb_MicroBlogFollows mf
where not exists (select 1 from tn_Follows where Userid = mf.UserID and FollowedUserId = mf.ItemID)

-----初始化用户导航应用
delete from tn_PresentAreaNavigations where PresentAreaKey = N'UserSpace'
insert [tn_PresentAreaNavigations] ([NavigationId],[ParentNavigationId],[Depth]
	   ,[PresentAreaKey],[ApplicationId],[OwnerId],[NavigationType],[NavigationText]
	   ,[ResourceName],[NavigationUrl],[UrlRouteName],[RouteDataName],[IconName],[ImageUrl]
       ,[NavigationTarget],[DisplayOrder],[OnlyOwnerVisible],[IsLocked],[IsEnabled])
select [NavigationId],[ParentNavigationId],[Depth],[PresentAreaKey],[ApplicationId],[UserId]
       ,[NavigationType],[NavigationText],[ResourceName],[NavigationUrl],[UrlRouteName],[RouteDataName]
       ,[IconName],[ImageUrl],[NavigationTarget],[DisplayOrder],[OnlyOwnerVisible],[IsLocked]
       ,[IsEnabled]
from tn_InitialNavigations,tn_Users 
where PresentAreaKey = N'UserSpace'

delete from tn_ApplicationInPresentAreaInstallations where PresentAreaKey = N'UserSpace'
insert tn_ApplicationInPresentAreaInstallations ([OwnerId],[ApplicationId],[PresentAreaKey])
select UserId,ApplicationId,PresentAreaKey
from tn_ApplicationInPresentAreaSettings,tn_Users 
where PresentAreaKey = N'UserSpace'

DELETE FROM [tn_SystemData] where Datakey in('Founder','CNZZStatisticsEnable','CNZZStatisticsPassword','CNZZStatisticsSiteId')
Declare @Founder bigint
select top 1 @Founder=UserId from tn_UsersInRoles where RoleName='SuperAdministrator'
set @Founder= ISNULL(@Founder,0)
INSERT [dbo].[tn_SystemData] (Datakey, LongValue, DecimalValue) VALUES ('Founder', @Founder, 0)
INSERT [dbo].[tn_SystemData] (Datakey, LongValue, DecimalValue) VALUES ('CNZZStatisticsEnable', 0, 0)
INSERT [dbo].[tn_SystemData] (Datakey, LongValue, DecimalValue) VALUES ('CNZZStatisticsPassword', 0, 0)
INSERT [dbo].[tn_SystemData] (Datakey, LongValue, DecimalValue) VALUES ('CNZZStatisticsSiteId', 0, 0)

--修复昵称必须唯一、必填
update tn_Users
set NickName = UserName
where NickName = '' or NickName = NULL

update tn_Users
set NickName = UserName
where NickName in (select NickName from tn_Users group by NickName having count(NickName) > 1)


--修复计数
--用户关注数，粉丝数
update tn_Users set FollowedCount = (select count(*) from tn_Follows where tn_Users.UserId = tn_Follows.UserId)
update tn_Users set FollowerCount = (select count(*) from tn_Follows where tn_Users.UserId = tn_Follows.FollowedUserId)

--评论的子评论数
update tn_Comments set ChildCount = (select count(*) from tn_Comments a where a.ParentId = tn_Comments.Id)

--顶踩数
update tn_Attitudes set SupportCount = (select count(*) from tn_AttitudeRecords where tn_AttitudeRecords.ObjectId = tn_Attitudes.ObjectId and IsSupport = 1)
update tn_Attitudes set OpposeCount = (select count(*) from tn_AttitudeRecords where tn_AttitudeRecords.ObjectId = tn_Attitudes.ObjectId and IsSupport = 0)

--分类：ChildCount、ItemCount
update tn_Categories set ChildCount = (select count(*) from  tn_Categories a where a.ParentId = tn_Categories.CategoryId)
update tn_Categories set ItemCount = (select COUNT(*) from tn_ItemsInCategories where tn_ItemsInCategories.CategoryId = tn_Categories.CategoryId)

--标签
update tn_Tags set ItemCount = (select count(*) from tn_ItemsInTags where tn_ItemsInTags.TagName = tn_Tags.TagName and tn_ItemsInTags.TenantTypeId = tn_Tags.TenantTypeId)
update tn_Tags set OwnerCount = (select count(*) from tn_TagsInOwners where tn_TagsInOwners.TagName = tn_Tags.TagName and tn_TagsInOwners.TenantTypeId = tn_Tags.TenantTypeId)

---私信：MessageCount、UnreadItemCount
update tn_MessageSessions set MessageCount = (select COUNT(*) from tn_MessagesInSessions where tn_MessagesInSessions.SessionId = tn_MessageSessions.SessionId) 
update tn_MessageSessions set UnreadMessageCount = (select COUNT(*) from tn_MessagesInSessions left join tn_Messages on tn_MessagesInSessions.MessageId = tn_Messages.MessageId where tn_MessagesInSessions.SessionId = tn_MessageSessions.SessionId and tn_Messages.IsRead = 0)


--修复tn_Attachments中的时间
update tn_Attachments set DateCreated=DATEADD(Hour,-8,DateCreated)
--修复tn_Comments中的时间
update tn_Comments set DateCreated=DATEADD(Hour,-8,DateCreated)
--修复tn_Categories中的时间
update tn_Categories set DateCreated=DATEADD(Hour,-8,DateCreated)
--修复tn_Tags中的时间
update tn_Tags set DateCreated=DATEADD(Hour,-8,DateCreated)


