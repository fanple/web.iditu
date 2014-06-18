//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using Tunynet;
using System.Linq;
using System.Collections.Generic;
using System;

namespace Tunynet.Common
{
    /// <summary>
    /// 推荐获取连接的工厂
    /// </summary>
    public static class RecommendUrlGetterFactory
    {
        /// <summary>
        /// 获取连接的方法
        /// </summary>
        /// <param name="tenantTypeId">租户类型id</param>
        /// <returns>获取连接的实例</returns>
        public static IRecommendUrlGetter Get(string tenantTypeId)
        {
            return DIContainer.Resolve<IEnumerable<IRecommendUrlGetter>>().Where(n => n.TenantTypeId.Equals(tenantTypeId, StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();
        }
    }
}