CREATE Function [dbo].[ReplaceImge]( @text nvarchar(max))
Returns nvarchar(max)
As
Begin
declare @startPos int,@endPos int, @img nvarchar(max);
Set @startPos = PATINDEX('%<img%%',@text);

If @StartPos = 0
Return @text;

Set @endPos = CharIndex('>', @text,@startPos);
set @text = Stuff(@text, @startPos,@endPos -@startPos+1, '');
return @text;
End
GO

-----微博
delete from spb_Microblogs
set identity_insert spb_Microblogs ON
insert spb_Microblogs ([MicroblogId],[UserId],[Author],[TenantTypeId],[OwnerId]
,[OriginalMicroblogId],[ForwardedMicroblogId],[Body],[ReplyCount],[ForwardedCount]
,[HasPhoto],[HasVideo],[HasMusic],[PostWay],[Source],[SourceUrl],[IP],[AuditStatus]
,[DateCreated]) 
 select ThreadID,OwnerUserID,Author,'000011',OwnerUserID
 ,OriginalThreadID,ForwardedThreadID,Body,ReplyCount ,ForwardedCount
 ,HasPhoto,HasVideo,HasMusic,PostMode,PostSource,'',N'127.0.0.1',AuditingStatus
 ,Datecreated from old_spb_MicroBlogThreads
 set identity_insert spb_Microblogs OFF
-----微博标签（话题）
delete from tn_Tags where TenantTypeId = N'100101'
insert tn_Tags ([TenantTypeId],[TagName],[IsFeatured],Description,FeaturedImage,
				[ItemCount],OwnerCount,[AuditStatus],[DateCreated]) 
select N'100101',Body,IsFeatured,'','',ItemCount,0,40,DateCreated
from old_spb_MicroBlogTopics

delete from tn_TagsInOwners where TenantTypeId = N'100101' 
insert tn_TagsInOwners (TenantTypeId,TagName,OwnerId,ItemCount)
select TenantTypeId,TagName,UserId,tn_Tags.ItemCount
from tn_Tags left join old_spb_MicroBlogTopics on tn_Tags.TagName=old_spb_MicroBlogTopics.Title where TenantTypeId = N'100101' 
----话题内容
delete from tn_ItemsInTags where TenantTypeId = N'100101' 
insert tn_ItemsInTags(TagName,TagInOwnerId,ItemId,TenantTypeId)
select TagName,Id,MicroblogId,tn_TagsInOwners.TenantTypeId
from tn_TagsInOwners,spb_Microblogs 
where tn_TagsInOwners.TenantTypeId = N'100101' 
and spb_Microblogs.Body like '%#'+tn_TagsInOwners.TagName+'#%'

---微博评论
delete from tn_Comments where TenantTypeId = N'100101'
insert tn_Comments ([ParentId],[CommentedObjectId],[TenantTypeId],[OwnerId],[UserId]
					,[Author],[ToUserId],[ToUserDisplayName],[Subject],[Body],[IsPrivate]
					,[AuditStatus],[ChildCount],[IsAnonymous],[IP],[DateCreated]) 
select 0,ThreadID,N'100101',OwnerUserID,UserID,Author,0,N'',N'',Body,0,40,0,0,N'',DateCreated
from old_spb_MicroBlogComments

update tn_Comments
set Body=dbo.ReplaceImge(Body) from tn_Comments 

---关注话题
delete from tn_Favorites where TenantTypeId = N'100101'
insert tn_Favorites([TenantTypeId],[UserId],[ObjectId])
select '000041',UserID,TagId
from old_spb_MicroBlogTopicesFavorites left join tn_Tags on (old_spb_MicroBlogTopicesFavorites.Keyword=tn_Tags.TagName)
where tn_Tags.TagId>0

---我的收藏
delete from tn_Favorites where TenantTypeId = N'100101'
insert tn_Favorites([TenantTypeId],[UserId],[ObjectId])
select '100101',UserID,old_spb_MicroBlogsFavorites.ThreadID
from old_spb_MicroBlogsFavorites left join old_spb_MicroBlogThreads on (old_spb_MicroBlogsFavorites.ThreadID=old_spb_MicroBlogThreads.ThreadID)
where old_spb_MicroBlogsFavorites.ThreadID>0

-----微博附件
delete from tn_Attachments where TenantTypeId = N'100101'
insert tn_Attachments ([AssociateId],[OwnerId],[TenantTypeId],[UserId]
					   ,[UserDisplayName],[FileName],[FriendlyFileName],[MediaType]
					   ,[ContentType],[FileLength],[Height],[Width],[Price],[Password]
					   ,[IP],[DateCreated]) 
select ThreadID,UserID,N'100101',UserID
	   ,isnull((select top 1 Author from old_spb_MicroBlogThreads where OwnerUserID = UserID and Author <> N''),N'')
	   ,FileName,FriendlyFileName,1,ContentType,ContentSize,Height,Width,0,N'',N'',DateCreated
from old_spb_MicroBlogAttachments


 --微博回复计数
update spb_Microblogs set ReplyCount = (select count(*) from tn_Comments where tn_Comments.CommentedObjectId =spb_Microblogs.MicroblogId )
--修复微博时间
update spb_Microblogs set DateCreated=DATEADD(Hour,-8,DateCreated)

 DROP FUNCTION  [ReplaceImge]

IF EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[DF_spb_Microblogs_ReplyCount]'))
ALTER TABLE [dbo].[spb_Microblogs] DROP CONSTRAINT [DF_spb_Microblogs_ReplyCount]
alter table [dbo].[spb_Microblogs] add  CONSTRAINT [DF_spb_Microblogs_ReplyCount]  default(0) for ReplyCount

