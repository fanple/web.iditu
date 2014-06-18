//------------------------------------------------------------------------------
// <copyright company="Tunynet">
//     Copyright (c) Tunynet Inc.  All rights reserved.
// </copyright> 
//------------------------------------------------------------------------------

using System.Collections.Generic;
using System.Linq;
using Tunynet.Common;
using Tunynet.Events;
using Tunynet.Globalization;
using Spacebuilder.Common;
using Tunynet.Utilities;

namespace Spacebuilder.Iditu.EventModules
{
    /// <summary>
    /// 处理动态、积分、通知的EventMoudle
    /// </summary>
    public class IdituEventModule : IEventMoudle
    {
        /// <summary>
        /// 注册事件处理程序
        /// </summary>
        void IEventMoudle.RegisterEventHandler()
        {
            EventBus<Iditu,AuditEventArgs>.Instance().After += new CommonEventHandler<Iditu, AuditEventArgs>(IdituEventModule_After);
        }

        /// <summary>
        /// 增删改等触发的事件
        /// </summary>
        private void IdituEventModule_After(Iditu repair, AuditEventArgs eventArgs)
        {
            //todo:可以在这里处理动态、通知、积分
        }

    }
}