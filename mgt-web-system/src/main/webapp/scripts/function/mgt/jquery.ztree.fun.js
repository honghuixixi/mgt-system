Yhxutil.ns("Yhxutil.fun");
Yhxutil.fun.doInit = function(params){
	$.ajax({
		   type: "POST",		   
		   url:  params.url,
		   data: params.data,
		   async:false,
		   scope:this,
		   success: Yhxutil.fun.doSuccess
		});
}

Yhxutil.fun.doSuccess = function(response){
	    var obj = jQuery.parseJSON(response)
	    var re = obj.data;
	    
	    var zNodes = [];
	    for(var i =0;i<re.length;i++){
	    	var param = {
	    		id:re[i].id,
	    		pId:re[i].pId,
	    		name:re[i].name
	    	}
	    	zNodes.push(param);
	    }
    
    	var setting = {
//    			check: {
//    				enable: true,
//    				chkStyle: "radio",
//    				radioType: "all"
//    			},
    			view: {
					showLine: false,
    				dblClickExpand: false,
    				selectedMulti: false
    			},
    			data: {
    				simpleData: {
    					enable: true
    				}
    			},
    			callback: {
    				onRightClick: Yhxutil.fun.OnRightClick,
    				onClick:Yhxutil.fun.onDblClick
    			}
    		};

		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		Yhxutil.fun.zTree = $.fn.zTree.getZTreeObj("treeDemo");
		//展开
		var nodes = Yhxutil.fun.zTree.getNodesByParam("id", "-1", null);
		Yhxutil.fun.zTree.expandNode(nodes[0],true,false,true,false);
		Yhxutil.fun.rMenu = $("#rMenu");
}



Yhxutil.fun.OnRightClick =function(event, treeId, treeNode) {
	if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
		Yhxutil.fun.zTree.cancelSelectedNode();
	} else if (treeNode && !treeNode.noR) {
		Yhxutil.fun.zTree.selectNode(treeNode);
		Yhxutil.fun.showRMenu("node", event.clientX, event.clientY);
	}
}


Yhxutil.fun.showRMenu = function(type, x, y) {
	$("#rMenu ul").show();
	Yhxutil.fun.rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", Yhxutil.fun.onBodyMouseDown);
}


Yhxutil.fun.onBodyMouseDown = function(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		Yhxutil.fun.rMenu.css({"visibility" : "hidden"});
	}
}


Yhxutil.fun.hideRMenu = function() {
	if (Yhxutil.fun.rMenu) Yhxutil.fun.rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", Yhxutil.fun.onBodyMouseDown);
}


/**
 * 添加
 */
Yhxutil.fun.addTreeNode =  function(){alert(2);
    var parentNode = Yhxutil.fun.zTree.getSelectedNodes()[0]; 
    Yhxutil.fun.hideRMenu();
	mgt_util.showjBox({
		width : 860,
		height : 450,
		title : '添加',
		scope:this,
		url :'/controller/mgt/department/addDepartmentUI?id='+parentNode.id+'&name='+parentNode.name,
		closed:function(){
					var datas =
				    {
				    id:'ids',	name:'names'
					}
				    var param =
				    {
				    	    url:'/controller/mgt/department/deptList',
				    	    data:datas
				    }
				   Yhxutil.fun.doInit(param);
		 }
	});
}	


/**
 * 修改
 */
Yhxutil.fun.modifyTreeNode = function(){
    var parentNode = Yhxutil.fun.zTree.getSelectedNodes()[0]; 
    Yhxutil.fun.hideRMenu();
    var url = '/controller/mgt/department/editDepartmentUI?id='+parentNode.id+'&name='+parentNode.name;
	mgt_util.showjBox({
		width : 860,
		height : 450,
		title : '修改',
		scope:this,
		url :url,
		closed:function(){
					var datas =
				    {
				    id:'ids',	name:'names'
					}
				    var param =
				    {
				    	    url:'/controller/mgt/department/deptList',
				    	    data:datas
				    }
				   Yhxutil.fun.doInit(param);
		 }
	});
}

/**
 * 删除
 */
Yhxutil.fun.removeTreeNode = function(){	
	Yhxutil.fun.hideRMenu();
	var nodes = Yhxutil.fun.zTree.getSelectedNodes()[0];
	var data
			= {
				id:nodes.id,
				name:nodes.name
			}
	if (nodes.id) {
		$.ajax({
			   type: "POST",		   
			   url:  '/controller/mgt/department/delete',
			   async:false,
			   data: data,
			   scope:this,
			   success: function(response)
			   {			
						   var obj = jQuery.parseJSON(response)
					       if(obj.code == "orgExistEmploy"){
					    	   $.jBox.tip(obj.msg);
					      		 }
							var datas =
						    {
						    id:'ids',	name:'names'
							}
						    var param =
						    {
						    	    url:'/controller/mgt/department/deptList',
						    	    data:datas
						    }
						   Yhxutil.fun.doInit(param);
				   }
			});
	}
}

/**
 * 双击刷新grid
 */
Yhxutil.fun.onDblClick = function(){
	var grid = '#grid-table';
	var data = $("#queryForm").serializeObjectForm();
	var parentNode = Yhxutil.fun.zTree.getSelectedNodes()[0]; 
	var shuxing = {departId:parentNode.id,departName:parentNode.name};
	for(var r in shuxing){
	   eval("data."+r+"=shuxing."+r);
	}
	$(grid).jqGrid('setGridParam',{  
        datatype:'json',  
        postData:data, //发送数据  
        page:1  
    }).trigger("reloadGrid");
}

