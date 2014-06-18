//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System.Web.Routing;
using Spacebuilder.Iditu;
using Tunynet.Common;
using Tunynet.Mvc;
using Tunynet.Utilities;
using System.Collections.Generic;
using Spacebuilder.Common;

namespace Spacebuilder.Iditu
{
    /// <summary>
    /// Iditu链接管理
    /// </summary>
    public static class SiteUrlsExtension
    {
        private static readonly string IdituAreaName = IdituConfig.Instance().ApplicationKey;
         
        #region Iditu频道

        /// <summary>
        /// 主页
        /// </summary>
        public static string IdituHome(this SiteUrls siteUrls)
        {
            return CachedUrlHelper.Action("Home", "ChannelIditu", IdituAreaName);
        }

        #endregion
 
    }
}