//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using Tunynet.Common;

namespace Spacebuilder.Iditu
{
    /// <summary>
    /// 定义的租户类型
    /// </summary>
    public static class TenantTypeIdsExtension
    {

        /// <summary>
        /// Iditu
        /// </summary>
        /// <param name="TenantTypeIds">被扩展对象</param>
        public static string Iditu(this TenantTypeIds TenantTypeIds)
        {
            return "900101";
        }


    }
}