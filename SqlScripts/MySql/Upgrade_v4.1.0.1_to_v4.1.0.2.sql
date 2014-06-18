/* 2013-12-03 zhengw 清除tn_ItemsInCategories表中的重复数据*/
DELETE from `tn_ItemsInCategories` where id NOT in
(
    select a.id from
    (
        select max(id) id from `tn_ItemsInCategories` a where EXISTS
        (
            select 1 from `tn_ItemsInCategories` b where a.CategoryId=b.CategoryId and a.ItemId=b.ItemId group by ItemId,CategoryId HAVING count(1)>1
        )
        group by ItemId,CategoryId
    ) a
);

delete from `tn_AccountTypes` where `AccountTypeKey`='QQ';
INSERT `tn_AccountTypes` 
	(`AccountTypeKey`, `ThirdAccountGetterClassType`, `AppKey`, `AppSecret`, `IsSync`, `IsShareMicroBlog`, `IsFollowMicroBlog`, `OfficialMicroBlogAccount`, `IsEnabled`) 
VALUES 
	('QQ', 'Spacebuilder.Common.QQAccountGetter,Spacebuilder.Common', '', '', 1, 1, 0, '', 0);