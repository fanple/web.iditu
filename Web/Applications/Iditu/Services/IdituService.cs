//<TunynetCopyright>
//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System.Collections.Generic;
using PetaPoco;
using Spacebuilder.Common;
using Tunynet;
using Tunynet.Common;
using Tunynet.Events;

namespace Spacebuilder.Iditu
{
    /// <summary>
    /// 业务逻辑类
    /// </summary>
    public class IdituService
    {
        private IIdituRepository repository;

        #region 构造函数

        /// <summary>
        /// 构造函数
        /// </summary>
        public IdituService()
            : this(new IdituRepository())
        {
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="repository">仓储实现</param>
        public IdituService(IIdituRepository repository)
        {
            this.repository = repository;
        }

        #endregion


        /// <summary>
        /// 删除用户时处理其Iditu应用下的数据
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="takeOverUserName"></param>
        /// <param name="isTakeOver"></param>
        public void DeleteUser(string userId, string takeOverUserName, bool isTakeOver)
        {
            //todo:处理删除用户时，同时处理用户的应用数据。
        }
    }
}