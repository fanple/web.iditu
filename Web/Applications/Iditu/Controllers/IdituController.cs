//<TunynetCopyright>
//--------------------------------------------------------------
//<copyright>拓宇网络科技有限公司 2005-2012</copyright>
//<version>V0.5</verion>
//<createdate>2012-08-08</createdate>
//<author>yangmj</author>
//<email>yangmj@tunynet.com</email>
//<log date="2012-08-08" version="0.5">创建</log>
//--------------------------------------------------------------
//</TunynetCopyright>

using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Spacebuilder.Common;
using Tunynet;
using Tunynet.Common;
using Tunynet.Common.Configuration;
using Tunynet.FileStore;
using Tunynet.Mvc;
using Tunynet.UI;
using Tunynet.Utilities;
using System.Text;

namespace Spacebuilder.Iditu.Controllers
{
    /// <summary>
    /// 空间Iditu
    /// </summary>
    [AnonymousBrowseCheck]
    [Themed(PresentAreaKeysOfBuiltIn.UserSpace, IsApplication = true)]
    public partial class IdituController : Controller
    {
        private IUserService userService = DIContainer.Resolve<IUserService>();

        /// <summary>
        /// 我的Iditu
        /// </summary>
        [HttpGet]
        [UserSpaceAuthorize]
        public ActionResult Mine(string spaceKey)
        {
            IUser owner = userService.GetUser(spaceKey);
            ViewData["DisplayName"] = owner.DisplayName;
            ViewBag.DisplayName = owner.DisplayName;
            return View(owner);
        }

    }
}