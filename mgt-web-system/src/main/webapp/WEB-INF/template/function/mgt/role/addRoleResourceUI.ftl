<!DOCTYPE html>
<html>
	<head>
		<title>分配资源</title>
		[#include "/common/commonHead.ftl" /]
		[#include "/common/commonZtreeHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
	</head>

	<script type="text/javascript">
		var roleUserList={};
	</script>

	<body class="toolbar-fixed-top">
		<div class="form-horizontal">
			<input type="hidden" value="${roleId}" name="roleId">
			<div class="navbar-fixed-top" id="toolbar">
				<button class="btn btn-danger" id="submit">保存
					<i class="fa-save  align-top bigger-125 fa-on-right"></i>
				</button>
				<input class="btn btn-success"  type="button" value="全选" id="allSelect"/>
				<button class="btn btn-warning" data-toggle="jBox-close">关闭
					<i class="fa-undo align-top bigger-125 fa-on-right"></i>
				</button>
			</div>

			<div class="page-content">
                <div>
                    <ul id="menuTree" class="ztree"></ul>
                </div>
			</div>
		</div>
	</body>
<script>
$(document).ready(function(){

    function setFontCss(treeId, treeNode) {
        return treeNode.level == 0 ? {'font-weight': 'bolder'} : treeNode.level == 1 ? {'font-weight': 'bold'}:{};
    }

    var setting = {
        check : {
            autoCheckTrigger : false,
            chkboxType : {"Y": "ps", "N": "ps"},
            chkStyle : "checkbox",
            enable : true,
            nocheckInherit : false,
            chkDisabledInherit : false,
            radioType : "level"
        },
        view: {
            fontCss: setFontCss
        }
    };
	var zNodes = [
		[#if menuList?exists]
			[#list menuList as menuLists]
            {name:'${menuLists.NAME}',menuID:'${menuLists.ID}',children:[
				[#list menuLists.menuItems as menuItem]
				{name:"${menuItem.NAME}",menuItemID:'${menuItem.ID}',children:[
					[#list menuItem.resourceItems as resourceItem]
						{name:'${resourceItem.NAME}',resourceId:'${resourceItem.ID}'},
					[/#list]
                ]},
				[/#list]
            ]},
			[/#list]
		[/#if]
	];
    var zTreeObj = $.fn.zTree.init($("#menuTree"), setting, zNodes);
    var node;
    [#if resourceList?exists]
        [#list resourceList as resource]
            node = zTreeObj.getNodeByParam("resourceId", '${resource.ID}', null);
            zTreeObj.checkNode(node, true, true);
        [/#list]
    [/#if]

    $('#submit').click(function () {
        var resourceIds = '';
        zTreeObj.getNodesByFilter(function (node) {
            if(node.level == 2&&node.checked) {
                resourceIds += node.resourceId+',';
            }
            return false;
        });
        resourceIds = resourceIds.substring(0,resourceIds.length-1);
        var roleId = $('input[name=roleId').val();
        $.ajax({
            url: '${base}/role/addRoleResource.jhtml',
            type: 'post',
            dataType: 'json',
            data: {roleId:roleId,resourceIds:resourceIds},
            success: function (data) {
                if(data.success) {
                    top.$.jBox.tip(data.msg, 'success');
                    top.$.jBox.close();
                } else {
                    top.$.jBox.tip(data.msg, 'error');
                }
            }
        });
    });

	$("#allSelect").click(function(){
		if(this.value=='全选'){
            zTreeObj.checkAllNodes(true);
			this.value='取消全选';
		}else{
            zTreeObj.checkAllNodes(false);
			this.value='全选';
		}
	});
});
</script>
</html>