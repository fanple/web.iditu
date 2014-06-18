//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System;
using PetaPoco;
using Tunynet.Caching;

namespace Tunynet.Common
{
    /// <summary>
    /// 敏感词类型实体类
    /// </summary>
    [TableName("tn_SensitiveWordTypes")]
    [PrimaryKey("TypeId", autoIncrement = true)]
    [CacheSetting(true)]
    [Serializable]
    public class SensitiveWordType : IEntity
    {
        /// <summary>
        /// 新建实体时使用
        /// </summary>
        public static SensitiveWordType New()
        {
            SensitiveWordType sensitiveWordType = new SensitiveWordType()
            {
                Name = string.Empty

            };

            return sensitiveWordType;
        }

        #region 需持久化属性

        /// <summary>
        /// TypeId
        /// </summary>
        public int TypeId { get; set; }

        /// <summary>
        /// 敏感词类型名
        /// </summary>
        public string Name { get; set; }

        #endregion

        #region IEntity 成员

        object IEntity.EntityId
        {
            get
            {
                return this.TypeId;
            }
        }

        bool IEntity.IsDeletedInDatabase { get; set; }

        #endregion
    }
}
