//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tunynet.Mvc;
using System.Web.Routing;
using Tunynet.Common;
using Spacebuilder.Common;

namespace Spacebuilder.Microblog
{
    /// <summary>
    /// 推荐项类型扩展类
    /// </summary>
    public static class RecommendItemExtensionByMicroblogTopic
    {
        /// <summary>
        /// 获取微博话题
        /// </summary>
        public static Tag GetMicroblogTopic(this RecommendItem item)
        {
            return new TagService(TenantTypeIds.Instance().Microblog()).Get(item.ItemId);
        }
    }
}