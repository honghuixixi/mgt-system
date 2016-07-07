Yhxutil.ns("Yhxutil.employee");

Yhxutil.employee.doInit = function(params){
    	Yhxutil.employee.inputId = params.inputId;
    	Yhxutil.employee.inputName = params.inputName;
    	Yhxutil.employee.MenuId = params.MenuId;
    	Yhxutil.employee.treeId = params.treeId;
    	Yhxutil.employee.MultiCheck = params.MultiCheck;
    	Yhxutil.employee.nocheck = params.nocheck;
	$.ajax({
		   type: "POST",
		   url:  params.url,
		   data: params.data,
		   async:false,
		   scope:this,
		   success: Yhxutil.employee.doSuccess
		});
};

Yhxutil.employee.doSuccess = function(response){
	// 将controller返回值转化为JSON对象
//    var obj = jQuery.parseJSON(response);
    var re = response.data;
    var zNodes = [];
    if(Yhxutil.employee.nocheck)
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
        		name:re[i].USERNAME
        	};
        	zNodes.push(param);
        	}else{
        		var param = {
        				id:re[i]['id'],
        				pId:re[i]['pId'],
        				name:re[i]['userName']
        		};
        		zNodes.push(param);
        		
        	}
        }
    }
    
    if(Yhxutil.employee.MultiCheck)
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
			var zTree = $.fn.zTree.getZTreeObj(Yhxutil.employee.treeId);
			zTree.checkNode(treeNode, !treeNode.checked, null, true);
			return false;
		}
		
		function onCheck(e, treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj(Yhxutil.employee.treeId),
			nodes = zTree.getCheckedNodes(true),
			v = "";
			code ="";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				code += nodes[i].id + ",";
			}
						if (v.length > 0 ) v = v.substring(0, v.length-1);
						if (code.length > 0 ) code = code.substring(0, code.length-1);
			var cityObj = $("#"+Yhxutil.employee.inputName);
			var citySelCode = $("#"+Yhxutil.employee.inputId);
			cityObj.attr("value", v);
			citySelCode.attr("value",code);
		}   
		$.fn.zTree.init($("#"+Yhxutil.employee.treeId), setting, zNodes);
};


Yhxutil.employee.showMenu = function(param) {
	var cityObj = $("#"+param.id);
	var cityOffset = $("#"+param.id).offset();
	$("#"+Yhxutil.employee.MenuId).css({left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight() + "px"}).slideDown("fast");
	$("body").bind("mousedown", Yhxutil.employee.onBodyDown);
};

Yhxutil.employee.hideMenu = function() {
	$("#"+Yhxutil.employee.MenuId).fadeOut("fast");
	$("body").unbind("mousedown", Yhxutil.employee.onBodyDown);
};

Yhxutil.employee.onBodyDown = function(event) {
	if (!(event.target.id == "menuBtn" || event.target.id == Yhxutil.employee.inputName || event.target.id == Yhxutil.employee.MenuId || $(event.target).parents("#"+Yhxutil.employee.MenuId).length>0)) {
		Yhxutil.employee.hideMenu();
	}
};