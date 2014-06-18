//<TunynetCopyright>
//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Tunynet.Common;
using Tunynet.UI;

namespace Spacebuilder.Iditu.Controllers
{

    [Themed(PresentAreaKeysOfBuiltIn.Channel, IsApplication = true)]
    [TitleFilter(IsAppendSiteName = true)]
    public class ChannelIdituController : Controller
    {

        /// <summary>
        /// 主页
        /// </summary>
        public ActionResult Home()
        {
            return View();
        }

        /*
         *         /// <summary>
        /// 个人空间Iditu首页
        /// </summary>
        /// <param name="userDomainName">当前空间用户用户名</param>
        [AcceptVerbs(HttpVerbs.Get)]
        [UserDomainAuthorize(RequireOwnerOrAdministrator = false)]
        [UserVisitAndUserDomainHitTime]
        [UserDomainPrivacy(IsAuthentication = true)]
        public ActionResult Home(string userDomainName)
        {
            #region 设置标题
            SetPageTitle(userDomainName, string.Empty);
            #endregion
            
            User currentDomainUser = GetCurrentDomainUser(userDomainName); // is also ok but different? Globals.GetCurrentUser();

            //获取当前用户的所有组列表,并附值给MVC用的SelectList对象
            List<UserCategory> groupListOfCurrentUser = MultiUserCategoryManager.Instance("Friend").GetUserCategories(currentDomainUser.UserID,true);
            MyMapViewModel model = new MyMapViewModel();
            model.AllMyGroupList = new SelectList(groupListOfCurrentUser, "CategoryID", "CategoryName");

            //获当前用户在这个组内(默认第一个组中)的所有朋友列表,并附值给MVC用的SelectList对象
            CommonMapHandler handler = new CommonMapHandler();
            var userListInTheGroup = handler.GetCurrentGroupUserMapLokiInfo(groupListOfCurrentUser[0].CategoryID.ToString());
            model.AllMyUserList = new SelectList(userListInTheGroup, "point", "[UserName]"); ;//ListGroupFriends(userDomainName, list[0].CategoryID, 1, Friendliness.All, true);

            //获当前用户在这个组内(默认第一个组中)的所有朋友位置信息的列表,并附值给MVC用的MapTotalViewInfo的结构体对象
            DataTable dt = new DataTable();
            dt.Load(handler.GetCurrentGroupUserMapLokiInfo(groupListOfCurrentUser[0].CategoryID.ToString()));
            model.MapTotalViewInfo = getUserInfoFromDB(dt);
          
            return View("Pages/Iditu/Home.aspx", "Masters/Iditu.master", model); return View("Pages/Iditu/Home.aspx", "Masters/Iditu.master");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updataGroup(string currentGroupId)
        {
            CommonMapHandler handler = new CommonMapHandler();
            DataTable dt = new DataTable();
            dt.Load(handler.GetCurrentGroupUserMapLokiInfo(currentGroupId));
            MapTotalViewInfo mtvInfor = getUserInfoFromDB(dt);

            var jsonMapTotalViewInfo = new JsonMapTotalViewInfo
            {
                Lat = mtvInfor.Lat,
                Lng = mtvInfor.Lng,
                Name = mtvInfor.Name,
                Record = mtvInfor.Record,
                Time = mtvInfor.Time,
            };

            return Json(jsonMapTotalViewInfo, "text/x-json");
        }

        /// <summary>
        /// 从存储过程返回的表中,查找Lat,lng,Msg等信息,之后再组合到MapTotalViewInfo的结构体当中,此处设计可以改进,存储过程也返回了point组合后的值,这里再组合重复.
        /// </summary>
        /// <param name="dts">DataTable</param>
        /// <returns>MapTotalViewInfo</returns>
        private MapTotalViewInfo getUserInfoFromDB(DataTable dts)
        {
            MapTotalViewInfo mtvInfo = new MapTotalViewInfo();
            try
            {
                DataTable dt = dts;
                if (dt.Rows.Count > 0)
                {
                    string lat = null;
                    string lng = null;
                    string name = null;
                    string record = null;
                    string time = null;

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        DataRow dr = dt.Rows[i];
                        lat += dr["Lat"].ToString();
                        lng += dr["Lng"].ToString();
                        name += dr["UserName"].ToString();
                        record += dr["Message"].ToString();
                        time += dr["Updatetime"].ToString();
                        if ((i + 1) != dt.Rows.Count)
                        {
                            lat += "|:|";
                            lng += "|:|";
                            name += "|:|";
                            record += "|:|";
                            time += "|:|";
                        }
                    }
                    mtvInfo.Lat = lat;
                    mtvInfo.Lng = lng;
                    mtvInfo.Name = name;
                    mtvInfo.Record = record;
                    mtvInfo.Time = time;
                }
            }
            catch
            {
                mtvInfo.Lat = "30";
                mtvInfo.Lng = "120";
                mtvInfo.Name = "null";
                mtvInfo.Record = "null";
                mtvInfo.Time = "null";
            }
            return mtvInfo;
        }

        #region NoUse
        public SelectList ListGroupFriends(string userDomainName, int? groupID, int? pageIndex, Friendliness? sortBy, bool isManager)
        {
            User domainUser = GetCurrentDomainUser(userDomainName);
            int? displayCount=1;
            IList<Friend> friends;
            if (domainUser.UserID == CurrentUser.UserID)
            {
                friends = Friends.GetTopFriends(domainUser.UserID, true, displayCount ?? 6);
                ViewData["isOwner"] = true;
            }
            else
            {
                friends = Friends.GetTopFriends(domainUser.UserID, false, displayCount ?? 6);
            }

            SelectList sl = new SelectList(friends, "FriendID", "FriendUser.DisplayName");
            return sl;
        }
        
        #endregion


    }
    **/
    }
}
