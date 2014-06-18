//<TunynetCopyright>
//--------------------------------------------------------------
//<version>V0.5</verion>
//<createdate></createdate>
//<author></author>
//<email>@tunynet.com</email>
//<log date="" version="0.5">创建</log>
//--------------------------------------------------------------
//</TunynetCopyright>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tunynet.Repositories;
using Tunynet;

namespace Spacebuilder.Microblog
{
    /// <summary>
    /// 
    /// </summary>
    public enum SortBy_Microblog
    {
        /// <summary>
        /// 最新
        /// </summary>
        DateCreated,

        /// <summary>
        /// 热门转发
        /// </summary>
        ForwardedCount,

        /// <summary>
        /// 热门评论
        /// </summary>
        ReplyCount
    }

    /// <summary>
    /// 微博发布方式
    /// </summary>
    public enum PostWay
    {
        /// <summary>
        /// 网页
        /// </summary>
        Web,

        /// <summary>
        /// 桌面客户端
        /// </summary>
        PCClient,

        /// <summary>
        /// 移动客户端
        /// </summary>
        Android,

        /// <summary>
        /// 安卓平板
        /// </summary>
        AndroidPad,

        /// <summary>
        /// IPhone
        /// </summary>
        IPhone,

        /// <summary>
        /// IPad
        /// </summary>
        IPad,

        /// <summary>
        /// WindowsPhone
        /// </summary>
        WindowsPhone,

        /// <summary>
        /// Surface
        /// </summary>
        Surface
    }

    /// <summary>
    /// 获取枚举类型的名称
    /// </summary>
    public static class PostWayExpand {
        public static string GetName(this PostWay postWay)
        {
            string name = "";
            switch (postWay)
            {
                case PostWay.Web:
                    name = "网页";
                    break;
                case PostWay.PCClient:
                    name = "近乎PC客户端";
                    break;
                case PostWay.Android:
                    name = "近乎Android客户端";
                    break;
                case PostWay.AndroidPad:
                    name = "近乎Android平板";
                    break;
                case PostWay.IPhone:
                    name = "近乎IPhone客户端";
                    break;
                case PostWay.IPad:
                    name = "近乎IPad客户端";
                    break;
                case PostWay.WindowsPhone:
                    name = "近乎WindowsPhone客户端";
                    break;
                case PostWay.Surface:
                    name = "近乎Surface客户端";
                    break;
            }
            return name;
        }
    }

    /// <summary>
    /// 微博待审核、需再审核
    /// </summary>
    public enum MicroblogManageableCountType
    {
        /// <summary>
        /// 待审核
        /// </summary>
        Pending = 1,

        /// <summary>
        /// 需再审核
        /// </summary>
        Again = 2,

        /// <summary>
        /// 总微博数
        /// </summary>
        IsAll = 3,

        /// <summary>
        /// 24小时新增数
        /// </summary>
        IsLast24 = 4
    }
}
