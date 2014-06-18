

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Tunynet.Utilities;
using System.ComponentModel.DataAnnotations;
using System.Collections.Specialized;
using System.Reflection;
using System.Collections;

namespace Spacebuilder.Common
{
    public class CustomModelBinder : DefaultModelBinder
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="controllerContext"></param>
        /// <param name="bindingContext"></param>
        /// <returns></returns>
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            if (bindingContext.ModelType.FullName.Contains("System.String"))
            {
                bool cleanHtml = false;

                //如果模型绑定的字段加了AllowHtmlAttribute，则bindingContext.ModelMetadata.RequestValidationEnabled=false，仍需要过滤掉不安全的Html标签
                if (!bindingContext.ModelMetadata.RequestValidationEnabled)
                {
                    cleanHtml = true;
                }

                //先禁止.net对请求内容的自动安全校验
                bindingContext.ModelMetadata.RequestValidationEnabled = false;
                var value = base.BindModel(controllerContext, bindingContext);

                if (value == null)
                {
                    return value;
                }

                if (value is Array)
                {
                    string[] tempArray = (string[])value;

                    if (tempArray != null && tempArray.Length > 0)
                    {
                        for (int i = 0; i < tempArray.Length; i++)
                        {
                            if (FilterSensitiveWord(bindingContext, tempArray[i], out tempArray[i]))
                                break;

                            tempArray[i] = this.formatInputValue(bindingContext, tempArray[i], cleanHtml);
                        }
                    }

                    return tempArray;
                }
                else if (value is string)
                {
                    string tempValue = value as string;
                    if (!string.IsNullOrEmpty(tempValue))
                        tempValue = tempValue.Trim();

                    Type type = bindingContext.ModelMetadata.ContainerType;
                    PropertyInfo propertyInfo = null;
                    if (type != null)
                    {
                        propertyInfo = type.GetProperty(bindingContext.ModelName);
                    }

                    var noFilterWordAttribute = propertyInfo != null ? Attribute.GetCustomAttribute(propertyInfo, typeof(NoFilterWordAttribute)) as NoFilterWordAttribute : null;
                    if (noFilterWordAttribute == null)
                    {
                        if (FilterSensitiveWord(bindingContext, tempValue, out tempValue))
                            return tempValue;
                    }

                    var noCleanHtmlAttribute = propertyInfo != null ? Attribute.GetCustomAttribute(propertyInfo, typeof(NoCleanHtmlAttribute)) as NoCleanHtmlAttribute : null;
                    if (noCleanHtmlAttribute != null)
                    {
                        return tempValue;
                    }

                    return this.formatInputValue(bindingContext, tempValue, cleanHtml);
                }
            }

            return base.BindModel(controllerContext, bindingContext);
        }


        /// <summary>
        /// 对输入的字符串内容进行格式化处理
        /// </summary>
        /// <param name="inputValue">输入的字符串内容</param>
        /// <param name="cleanHtml">是否需要清理不安全的Html标签</param>
        /// <returns>格式化后的字符串内容</returns>
        private string formatInputValue(ModelBindingContext bindingContext, string inputValue, bool cleanHtml)
        {
            if (string.IsNullOrEmpty(inputValue))
            {
                return inputValue;
            }

            if (cleanHtml)
            {
                inputValue = HtmlUtility.CleanHtml(inputValue, TrustedHtmlLevel.HtmlEditor);
            }
            else
            {
                inputValue = HtmlUtility.StripHtml(inputValue, true, false);

                //处理多行纯文本
                inputValue = Formatter.FormatMultiLinePlainTextForStorage(inputValue, false);
            }

            if (string.IsNullOrEmpty(inputValue))
            {
                bindingContext.ModelState.AddModelError("UnTrustedHtml", "内容未通过验证或包含非法字符如<、>！");
            }

            return inputValue;
        }

        /// <summary>
        /// 处理敏感词
        /// </summary>
        /// <param name="bindingContext"></param>
        /// <param name="inputText">输入文本</param>
        /// <param name="outputText">输出文本</param>
        /// <returns>是否包含禁止提交的敏感词</returns>
        private bool FilterSensitiveWord(ModelBindingContext bindingContext, string inputText, out string outputText)
        {
            //处理敏感词
            WordFilterStatus status = WordFilterStatus.Banned;
            outputText = WordFilter.SensitiveWordFilter.Filter(inputText, out status);
            if (status == WordFilterStatus.Banned)
            {
                bindingContext.ModelState.AddModelError("SensitiveWord", "内容未通过验证或包含非法词语！");
                return true;
            }
            return false;
        }
    }
}
