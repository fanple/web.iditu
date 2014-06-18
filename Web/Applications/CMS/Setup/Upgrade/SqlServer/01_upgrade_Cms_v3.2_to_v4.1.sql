-----资讯附件
delete from tn_Attachments where TenantTypeId = N'101501'
insert tn_Attachments ([AssociateId],[OwnerId],[TenantTypeId],[UserId]
					   ,[UserDisplayName],[FileName],[FriendlyFileName],[MediaType]
					   ,[ContentType],[FileLength],[Height],[Width],[Price],[Password]
					   ,[IP],[DateCreated]) 
select ThreadID,UserID,N'101501',UserID
	   ,isnull((select top 1 Contributor from old_spb_NewsThreads where UserID = old_spb_NewsAttachments.UserID and Contributor <> N''),N'')
	   ,FileName,FriendlyFileName
	   ,1
	   ,ContentType,ContentSize,Height,Width,0,N'',N'',DateCreated
from old_spb_NewsAttachments
where charindex('image',ContentType) > 0

GO

delete from spb_cms_ContentAttachments
insert spb_cms_ContentAttachments([UserId],[UserDisplayName],
                                 [FileName],[FriendlyFileName],[MediaType],[ContentType],[FileLength],[Height],[Width],[Price]
                                  ,[Password],IP,DateCreated)
select UserID,isnull((select top 1 Contributor from old_spb_NewsThreads where UserID = old_spb_NewsAttachments.UserID and Contributor <> N''),N''),
        FileName,FriendlyFileName,99,ContentType,ContentSize,Height,Width,0,CAST(ThreadID as varchar(100)),N'',DateCreated
from  old_spb_NewsAttachments
where charindex('image',ContentType) <= 0

-----资讯评论

Create Table #TempComments (Id bigint identity(1,1),oldId bigint)
SET IDENTITY_INSERT #TempComments ON
insert #TempComments(Id) select top 1 Id from tn_Comments order by Id desc
SET IDENTITY_INSERT #TempComments OFF

insert #TempComments(oldId) select CommentID from old_spb_NewsComments
delete from #TempComments where oldId is NULL

SET IDENTITY_INSERT tn_Comments ON
delete from tn_Comments where TenantTypeId = N'101501'
go
insert tn_Comments ([Id],[ParentId],[CommentedObjectId],[TenantTypeId],[OwnerId],[UserId]
					,[Author],[ToUserId],[ToUserDisplayName],[Subject],[Body],[IsPrivate]
					,[AuditStatus],[ChildCount],[IsAnonymous],[IP],[DateCreated]) 
select (select Id from #TempComments where oldId = CommentID)
	   ,isnull((select Id from #TempComments where oldId = ParentID and ParentID > 0),0)
	   ,ThreadID,N'101501',UserID,UserID,Author,CASE WHEN ParentID = 0 THEN 0 ELSE UserID END
	   ,isnull((select top 1 Author from old_spb_BlogThreads where UserID = OwnerUserID and Author <> N'' and ParentID > 0),N'')
	   ,Title,Body,0,40,0,charindex(Author,'匿名用户'),N'',getdate()
from old_spb_NewsComments
SET IDENTITY_INSERT tn_Comments OFF

drop table #TempComments
--drop table #TempComments
--GO

-----资讯标签
delete from tn_Tags where TenantTypeId = N'101501'
insert tn_Tags ([TenantTypeId],[TagName],Description,FeaturedImage
				,[IsFeatured],[ItemCount],[OwnerCount],[AuditStatus],[DateCreated]) 
select N'101501',TagName,'',''
		,0,ItemCount
	   ,(select count(UserID) from old_spb_NewsTags ft where ft.TagName = TagName)
	   ,40,getdate()
from old_spb_NewsTags

delete from tn_TagsInOwners where TenantTypeId = N'101501' 
insert tn_TagsInOwners (TenantTypeId,TagName,OwnerId,ItemCount)
select N'101501',TagName,OwnerID,ItemCount from old_spb_NewsTags

delete from tn_ItemsInTags where TenantTypeId = N'101501' 
insert tn_ItemsInTags (TagName,TagInOwnerId,ItemId,TenantTypeId)
select iift.TagName,Id,ItemID,TenantTypeId
from old_spb_ItemsInNewsTags iift
right join tn_TagsInOwners tio
on iift.TagName = tio.TagName
where TenantTypeId = N'101501' and iift.TagName <> N''

-----资讯栏目
delete from spb_cms_ContentFolders 
go
set identity_insert spb_cms_ContentFolders on

insert spb_cms_ContentFolders(ContentFolderId,FolderName,[Description]
,ParentId,ParentIdList,ChildCount,Depth,IsEnabled,ContentItemCount
,DateCreated,ContentTypeKeys,DisplayOrder,EnableContribute,IsAsNavigation
,NeedAuditing,IsLink,LinkUrl,IsLinkToNewWindow,Page_List,Page_Detail
,ExtensionField,PropertyNames,PropertyValues)
 select old_spb_NewsSections.SectionID,old_spb_NewsSections.SectionName,old_spb_NewsSections.[Description]
 ,old_spb_NewsSections.ParentID,old_spb_NewsSections.ParentIDList,old_spb_NewsSections.ChildCount
 ,old_spb_NewsSections.Depth,old_spb_NewsSections.IsActive,'0'
 ,old_spb_NewsSections.DateCreated,'News',old_spb_NewsSections.DisplayOrder
 ,'0',case when old_spb_NewsSections.NewsSectionType='0' then '0'  else '1' end ,'1'
 ,'0','','0'
 ,old_spb_NewsSections.PageList,old_spb_NewsSections.PageDetail,'0'
 ,old_spb_NewsSections.PropertyNames,old_spb_NewsSections.PropertyValues
 from old_spb_NewsSections
 
set identity_insert spb_cms_ContentFolders OFF



----内容项--
delete from spb_cms_ContentItems
go
set identity_insert spb_cms_ContentItems on
insert spb_cms_ContentItems(ContentItemId,ContentFolderId,ContentTypeId,Title
,FeaturedImageAttachmentId,FeaturedImage,UserId,Author,Summary,IsContributed,IsEssential
,IsGlobalSticky,GlobalStickyDate,IsFolderSticky,FolderStickyDate,IsLocked,AuditStatus,IP
,ReleaseDate,DateCreated,LastModified,DisplayOrder,PropertyNames,PropertyValues)
select old_spb_NewsThreads.ThreadID,old_spb_NewsThreads.SectionID,(select top 1 [ContentTypeId] from [spb_cms_ContentTypeDefinitions])
,(select left(old_spb_NewsThreads.Title,64)),'',''
,old_spb_NewsThreads.UserID,old_spb_NewsThreads.Contributor,old_spb_NewsThreads.Subtitle
,old_spb_NewsThreads.IsContributed,old_spb_NewsThreads.IsEssential,old_spb_NewsThreads.SpecialOrder
,old_spb_NewsThreads.StickyDate,'0',getdate(),old_spb_NewsThreads.IsLocked,old_spb_NewsThreads.AuditingStatus
,old_spb_NewsThreads.UserHostAddress,old_spb_NewsThreads.PostDate,old_spb_NewsThreads.PostDate
,old_spb_NewsThreads.LastRepliedDate,old_spb_NewsThreads.ThreadID,old_spb_NewsThreads.PropertyNames
,old_spb_NewsThreads.PropertyValues
from old_spb_NewsThreads 
set identity_insert spb_cms_ContentItems off


---文章
delete from spb_cms_Addon_News
go
insert spb_cms_Addon_News(ContentItemId,TrimBodyAsSummary,Body,CopyFrom
,CopyFromUrl,EnableComment,OriginalAuthor,Editor,Color,IsBold
,FirstAsTitleImage,AutoPage,PageLength)
select old_spb_NewsThreads.ThreadID,'1',old_spb_NewsThreads.Body
,'','','1','','','','0','1','0','0'
from old_spb_NewsThreads


-----资讯正文中的附件地址
Declare @AttachmentID int
Declare @ThreadID int
Declare @FileName nvarchar(512) 
Declare @ContentType nvarchar(64)
Declare @DateCreated datetime
Declare Cur Cursor For 
select AttachmentID,ThreadID,[FileName],ContentType,DateCreated from old_spb_NewsAttachments
Open Cur 
Fetch next From Cur Into @AttachmentID,@ThreadID,@FileName,@ContentType,@DateCreated
While @@fetch_status=0 
Begin 
Declare @oldFilePath nvarchar(100),
		@newFilePath nvarchar(100)
if(charindex('image', @ContentType) > 0 )
	begin
		set @oldFilePath = 'Services/NewsAttachment.ashx?AttachmentID='+CAST(@AttachmentID as nvarchar(100))
		UPDATE spb_cms_Addon_News 
		SET Body = REPLACE(Body,@oldFilePath+'" target="_blank"><img src="',@oldFilePath+'" rel="fancybox"><img src="') 
		where [ContentItemId] =@ThreadID
		
		set @newFilePath = 'Uploads/CMS/'+CAST(YEAR(@DateCreated) as char(4)) +'/'+right ('0'+CAST(MONTH(@DateCreated) as varchar(100)),2)+'/'
								  +right ('0'+CAST(DAY(@DateCreated) as varchar(100)),2) +'/'+@FileName
		UPDATE spb_cms_Addon_News SET Body = REPLACE(Body,@oldFilePath,@newFilePath) where [ContentItemId] =@ThreadID
	end
else
	  begin
		 Declare @AttachId bigint
		 set @AttachId = 0
		 select @AttachId=attachmentId from spb_cms_ContentAttachments where FileName=@FileName 
		 set @oldFilePath ='[attach]'+CAST(@AttachmentID as nvarchar(100))+'[/attach]'
		 set @newFilePath = '[attach:'+CAST(@AttachId as nvarchar(100))+']'
		 UPDATE spb_cms_Addon_News SET Body = REPLACE(Body,@oldFilePath,@newFilePath)
	 end
Fetch Next From Cur Into @AttachmentID,@ThreadID,@FileName,@ContentType,@DateCreated
End 
Close Cur 
Deallocate Cur

----资讯浏览数
if not exists (select * from sysobjects where [name] = 'tn_Counts_101501' and xtype='U')
begin
    CREATE TABLE dbo.[tn_Counts_101501](
        [CountId] [bigint] IDENTITY(1,1) NOT NULL,
        [OwnerId] [bigint] NOT NULL,
        [ObjectId] [bigint] NOT NULL,
        [CountType] [nvarchar](64) NOT NULL,
        [StatisticsCount] [int] NOT NULL,
     CONSTRAINT [PK_tn_Counts_101501] PRIMARY KEY CLUSTERED 
    (
        [CountId] ASC
    ) ON [PRIMARY]
    ) ON [PRIMARY]
    CREATE NONCLUSTERED INDEX [IX_tn_Counts_101501_CountType] ON [tn_Counts_101501] 
    (
        [CountType] ASC
    ) ON [PRIMARY]
    CREATE NONCLUSTERED INDEX [IX_tn_Counts_101501_ObjectId] ON [tn_Counts_101501] 
    (
        [ObjectId] ASC
    ) ON [PRIMARY]
    CREATE NONCLUSTERED INDEX [IX_tn_Counts_101501_OwnerId] ON [tn_Counts_101501] 
    (
        [OwnerId] ASC
    ) ON [PRIMARY]
    CREATE NONCLUSTERED INDEX [IX_tn_Counts_101501_StatisticsCount] ON [tn_Counts_101501] 
    (
        [StatisticsCount] ASC
    ) ON [PRIMARY]

    ALTER TABLE [tn_Counts_101501]  ADD  CONSTRAINT [DF_tn_Counts_101501_OwnerId]  DEFAULT ((0)) FOR [OwnerId]
    ALTER TABLE [tn_Counts_101501]  ADD  CONSTRAINT [DF_tn_Counts_101501_StatisticsCount]  DEFAULT ((0)) FOR [StatisticsCount]
end

delete tn_Counts_101501 where CountType='HitTimes'
insert tn_Counts_101501(OwnerId,ObjectId,CountType,StatisticsCount) 
select UserID,ThreadID,'HitTimes',HitTimes
from old_spb_NewsThreads

--ContentItem的评论数


delete from tn_Counts_101501 where CountType = 'CommentCount'
insert tn_Counts_101501(OwnerId,ObjectId,CountType,StatisticsCount) 
select UserId,[CommentedObjectId],'CommentCount'
,(select count(*) from tn_Comments where TenantTypeId='101501') 
from [tn_Comments] where TenantTypeId='101501'
--近7天评论数


delete from tn_Counts_101501 where CountType = 'CommentCount-7'
insert tn_Counts_101501(OwnerId,ObjectId,CountType,StatisticsCount) 
select UserId,[CommentedObjectId],'CommentCount-7'
,(select count(*) from tn_Comments where TenantTypeId='101501' and datediff(day,DateCreated,GETDATE())<=6 ) 
from [tn_Comments] where TenantTypeId='101501'

--栏目下的资讯数
update spb_cms_ContentFolders set [ContentItemCount]=(select count(*) from [spb_cms_ContentItems] where [spb_cms_ContentItems].[ContentFolderId]=spb_cms_ContentFolders.[ContentFolderId])

--用户的投稿数
delete from tn_OwnerData where DataKey='CMS-ContributeCount' and TenantTypeId='000011'
INSERT INTO tn_OwnerData([OwnerId],[TenantTypeId],[DataKey],[LongValue],[DecimalValue] ,[StringValue])
select UserId,'000011','CMS-ContributeCount',COUNT(spb_cms_ContentItems.ContentItemId),0,''
from spb_cms_ContentItems
group by UserId
delete from tn_ApplicationData where ApplicationId=1015
insert tn_ApplicationData([ApplicationId] ,[TenantTypeId],[Datakey],[LongValue],[DecimalValue] ,[StringValue]) values(1015,'','PubliclyAuditStatus',40,0.0000,'')
     

--修复资讯时间
update spb_cms_ContentItems set [ReleaseDate]=DATEADD(Hour,-8,[ReleaseDate])
update spb_cms_ContentItems set DateCreated=DATEADD(Hour,-8,DateCreated)
update spb_cms_ContentItems set LastModified=DATEADD(Hour,-8,LastModified)
