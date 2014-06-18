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
using Tunynet.Common;
using System.Xml.Linq;
using Autofac;
using Tunynet.Globalization;
using Spacebuilder.Common;

namespace Spacebuilder.Iditu
{
    /// <summary>
    /// ApplicationConfig
    /// </summary>
    public class IdituConfig : ApplicationConfig
    {
        private static int applicationId = 9001;

        /// <summary>
        /// 获取IdituConfig实例
        /// </summary>
        public static IdituConfig Instance()
        {
            ApplicationService applicationService = new ApplicationService();

            ApplicationBase app = applicationService.Get(applicationId);
            if (app != null)
                return app.Config as IdituConfig;
            else
                return null;
        }


        public IdituConfig(XElement xElement)
            : base(xElement)
        {
        }

        /// <summary>
        /// ApplicationId
        /// </summary>
        public override int ApplicationId
        {
            get { return applicationId; }
        }

        /// <summary>
        /// ApplicationKey
        /// </summary>
        public override string ApplicationKey
        {
            get { return "Iditu"; }
        }

        /// <summary>
        /// 获取IdituApplication实例
        /// </summary>
        public override Type ApplicationType
        {
            get { return typeof(IdituApplication); }
        }

        /// <summary>
        /// 注册ResourceAccessor的应用资源
        /// </summary>
        /// <param name="containerBuilder">容器构建器</param>
        public override void Initialize(ContainerBuilder containerBuilder)
        {
            //注册ResourceAccessor的应用资源
            ResourceAccessor.RegisterApplicationResourceManager(ApplicationId, "Spacebuilder.Iditu.Resources.Resource", typeof(Spacebuilder.Iditu.Resources.Resource).Assembly);
            containerBuilder.Register(c => new IdituApplicationStatisticDataGetter()).Named<IApplicationStatisticDataGetter>(this.ApplicationKey).SingleInstance();
        }

    }
}