<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>评分审批管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function() {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function(form){
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function(error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li><a href="${ctx}/approve/estimate/oaEstimateApprove/">评分审批列表</a></li>
    <li class="active"><a href="${ctx}/approve/estimate/oaEstimateApprove/form?id=${oaEstimateApprove.id}">评分审批<shiro:hasPermission name="approve:estimate:oaEstimateApprove:edit">${not empty oaEstimateApprove.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="approve:estimate:oaEstimateApprove:edit">查看</shiro:lacksPermission></a></li>
</ul><br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="oaEstimateApprove" action="${ctx}/approve/estimate/oaEstimateApprove/save" method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group hide">
            <label class="control-label">流程实例编号：</label>
            <div class="controls">
                <form:input path="procInsId" htmlEscape="false" maxlength="64" class="input-xlarge " readonly="false"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">项目外建：</label>
            <div class="controls">
                <form:input path="projectId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">用户主键：</label>
            <div class="controls">
                <sys:treeselect id="user" name="user.id" value="${oaEstimateApprove.user.id}" labelName="user.name" labelValue="${oaEstimateApprove.user.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">原评分：</label>
            <div class="controls">
                <form:input path="fraction" htmlEscape="false" maxlength="11" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                <form:textarea path="evolve" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请评分：</label>
            <div class="controls">
                <form:input path="fractionApprove" htmlEscape="false" maxlength="11" class="input-xlarge required"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请原因：</label>
            <div class="controls">
                <form:textarea path="reason" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge required"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人：</label>
            <div class="controls">
                <sys:treeselect id="bossUserId" name="bossUserId"  value="${oaEstimateApprove.user.id}" labelName="user.name" labelValue="${oaEstimateApprove.user.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人审批意见：</label>
            <div class="controls">
                <form:textarea path="bossSuggest" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人审批时间：</label>
            <div class="controls">
                <input name="bossTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                       value="<fmt:formatDate value="${oaEstimateApprove.bossTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员：</label>
            <div class="controls">
                <sys:treeselect id="adminUserId" name="adminUserId"  value="${oaEstimateApprove.user.id}" labelName="user.name" labelValue="${oaEstimateApprove.user.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员流转备注：</label>
            <div class="controls">
                <form:textarea path="adminSuggest" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员操作时间：</label>
            <div class="controls">
                <input name="adminTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                       value="<fmt:formatDate value="${oaEstimateApprove.adminTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">审批结果：</label>
            <div class="controls">
                <form:select path="bossResult" class="input-xlarge ">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('approve_result')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注信息：</label>
            <div class="controls">
                <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">状态：</label>
            <div class="controls">
                <form:select path="status" class="input-xlarge ">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('approve_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="approve:estimate:oaEstimateApprove:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>