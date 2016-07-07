Yhxutil.ns("Yhxutil.ztree");

Yhxutil.ztree.doInit = function(params){
    	Yhxutil.ztree.inputId = params.inputId;
    	Yhxutil.ztree.inputName = params.inputName;
    	Yhxutil.ztree.MenuId = params.MenuId;
    	Yhxutil.ztree.treeId = params.treeId;
    	Yhxutil.ztree.MultiCheck = params.MultiCheck;
    	Yhxutil.ztree.nocheck = params.nocheck;
	$.ajax({
		   type: "POST",
		   url:  params.url,
		   data: params.data,
		   async:false,
		   scope:this,
		   success: Yhxutil.ztree.doSuccess
		});
};

Yhxutil.ztree.doSuccess = function(response){
	// 将controller返回值转化为JSON对象
//    var obj = jQuery.parseJSON(response);
    var re = response.data;
    var zNodes = [];
    if(Yhxutil.ztree.nocheck)
    {
        for(var i =0;i<re.length;i++) {
        	var param = {
        		id:re[i].ID,
        		pId:re[i].PID,
        		name:re[i].NAME,
        		nocheck:re[i].NOCHECK
        	};
        	zNodes.push(param);
        }
    }else{
        for(var i =0;i<re.length;i++)    {
        	if(re[i].ID!=undefined){
        		
        	var param = {
        		id:re[i].ID,
        		pId:re[i].PID,
        		name:re[i].NAME
        	};
        	zNodes.push(param);
        	}else{
        		var param = {
        				id:re[i]['id'],
        				pId:re[i]['pId'],
        				name:re[i]['name']
        		};
        		zNodes.push(param);
        		
        	}
        }
    }
    
    if(Yhxutil.ztree.MultiCheck)
    {
    	var setting = {
    			check: {
    				enable: true,
    				chkboxType: {"Y":"", "N":""}
    			},
    			view: {
    				dblClickExpand: false,
    				selectedMulti: false
    			},
    			data: {
    				simpleData: {
    					enable: true
    				}
    			},
    			callback: {
    				beforeClick: beforeClick,
    				onCheck: onCheck
    			}
    		};
    }else
    {
    	var setting = {
    			check: {
    				enable: true,
    				chkStyle: "radio",
    				radioType: "all"
    			},
    			view: {
    				dblClickExpand: false,
    				selectedMulti: false
    			},
    			data: {
    				simpleData: {
    					enable: true
    				}
    			},
    			callback: {
    				beforeClick: beforeClick,
    				onCheck: onCheck
    			}
    		};
    }
    

		function beforeClick(treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj(Yhxutil.ztree.treeId);
			zTree.checkNode(treeNode, !treeNode.checked, null, true);
			return false;
		}
		
		function onCheck(e, treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj(Yhxutil.ztree.treeId),
			nodes = zTree.getCheckedNodes(true),
			v = "";
			code ="";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				code += nodes[i].id + ",";
			}
						if (v.length > 0 ) v = v.substring(0, v.length-1);
						if (code.length > 0 ) code = code.substring(0, code.length-1);
			var cityObj = $("#"+Yhxutil.ztree.inputName);
			var citySelCode = $("#"+Yhxutil.ztree.inputId);
			cityObj.attr("value", v);
			citySelCode.attr("value",code);
		}   
		$.fn.zTree.init($("#"+Yhxutil.ztree.treeId), setting, zNodes);
};


Yhxutil.ztree.showMenu = function(param) {
	var cityObj = $("#"+param.id);
	var cityOffset = $("#"+param.id).offset();
	$("#"+Yhxutil.ztree.MenuId).css({left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight() + "px"}).slideDown("fast");
	$("body").bind("mousedown", Yhxutil.ztree.onBodyDown);
};

Yhxutil.ztree.hideMenu = function() {
	$("#"+Yhxutil.ztree.MenuId).fadeOut("fast");
	$("body").unbind("mousedown", Yhxutil.ztree.onBodyDown);
};

Yhxutil.ztree.onBodyDown = function(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == Yhxutil.ztree.inputName || event.target.id == Yhxutil.ztree.MenuId || $(event.target).parents("#"+Yhxutil.ztree.MenuId).length>0)) {
		Yhxutil.ztree.hideMenu();
	}
};