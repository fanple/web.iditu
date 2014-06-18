/*
 *************************************************************
 * Copyright 2013 Lexing Inc. All rights reserved.
 * jiangshl@2013-06-20：创建
 *************************************************************
 */

using System;
using System.Web.Mvc;
using Tunynet.Mvc;

namespace Spacebuilder.Common
{
    /// <summary>
    /// 安全校验过滤器
    /// </summary>
    public class ModeStateErrorAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            if (string.Equals("post", filterContext.HttpContext.Request.HttpMethod, StringComparison.OrdinalIgnoreCase))
            {
                if (!filterContext.Controller.ViewData.ModelState.IsValid && filterContext.Controller.ViewData.ModelState.Keys.Contains("UnTrustedHtml"))
                {
                    if (filterContext.HttpContext.Request.IsAjaxRequest())
                        filterContext.Result = new JsonResult() { Data = new StatusMessageData(StatusMessageType.Error, "表单验证失败，请检查输入数据是否有误，例如文本不能包含特殊字符<、>！") };
                    else
                        filterContext.Result = new RedirectResult(SiteUrls.Instance().SystemMessage(filterContext.Controller.TempData, new SystemMessageViewModel
                        {
                            StatusMessageType = StatusMessageType.Error,
                            Title = "表单验证失败",
                            Body = "请检查输入数据是否有误，例如文本不能包含特殊字符<、>！"
                        }));
                    return;
                }
            }
        }

    }
}