using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc.Html;
using System.Web.Mvc;
using System.Web.Routing;
using System.Linq.Expressions;
using System.Collections;
using System.Web.Helpers;
using Tunynet.Common;
using Spacebuilder.Common;

namespace Tunynet.Mvc
{
    /// <summary>
    /// 扩展对Link的HtmlHelper使用方法
    /// </summary>
    public static class HtmlHelperAtUserExtensions
    {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="htmlHelper"></param>
        /// <param name="textareaId">编辑框的id</param>
        /// <param name="seletorId">出发按钮的id</param>
        /// <returns></returns>
        public static MvcHtmlString AtUser(this HtmlHelper htmlHelper, string textareaId, string seletorId = null)
        {
            if (UserContext.CurrentUser == null)
                return MvcHtmlString.Empty;
            if (htmlHelper.ViewContext.HttpContext.Items["IsAtRemindUsers"] == null)
            {
                htmlHelper.ViewContext.HttpContext.Items["IsAtRemindUsers"] = "True";
                int topNumber = 5000;

                IUser currentUser = UserContext.CurrentUser;
                if (currentUser == null)
                {
                    return null;
                }
                var followService = new FollowService();
                var userService = new UserService();
                var pds = followService.GetFollows(currentUser.UserId, null, Follow_SortBy.FollowerCount_Desc, 1);
                var list = new List<FollowEntity>(pds);
                if (pds.PageCount > 1)
                {
                    for (int i = 2; i <= pds.PageCount; i++)
                    {
                        list.AddRange(followService.GetFollows(currentUser.UserId, null, Follow_SortBy.FollowerCount_Desc, i));
                    }
                }
                htmlHelper.ViewData["data"] = Json.Encode(userService.GetFullUsers(list.Select(n => n.FollowedUserId).Take(topNumber))
                       .Select(n =>
                       {
                           var noteName = string.Empty;
                           FollowEntity followEntity = list.FirstOrDefault(f => f.FollowedUserId == n.UserId);
                           if (followEntity != null)
                               noteName = followEntity.NoteName;
                           return new
                           {
                               nickName = n.NickName,
                               noteName = noteName
                           };
                       }
                       ));
            }

            htmlHelper.ViewData["textareaId"] = textareaId;
            htmlHelper.ViewData["seletorId"] = seletorId;
            return htmlHelper.DisplayForModel("AtUser");

        }
    }
}
