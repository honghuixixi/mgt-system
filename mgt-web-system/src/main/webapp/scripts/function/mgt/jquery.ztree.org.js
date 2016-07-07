Yhxutil.ns("Yhxutil.org");

Yhxutil.org.doInit = function(params){
	$.ajax({
		   type: "POST",		   
		   url:  params.url,
		   data: params.data,
		   async:false,
		   scope:this,
		   success: Yhxutil.org.doSuccess
		});
};

Yhxutil.org.doSuccess = function(response){
		// 转化JSON
//	    var obj = jQuery.parseJSON(response);
//		var re = obj.data;
		if(response.data == null || response.data =='null')
			return;
		var re = response.data;
	    var zNodes = [];
	    var param = [];
	    for(var i =0;i<re.length;i++){
//		    $.each(re[i],function(k,v){
//		    	alert(k+'=='+v);
//		   });
	    	if(count(re[i])>3){
	    		param = {
    				id:re[i].id,
    				pId:re[i].pId,
    				name:re[i].name
	    		};
	    	}else{
	    		param = {
    				id:re[i].ID,
    				pId:re[i].PID,
    				name:re[i].NAME
	    		};
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
    				dblClickExpand: false,
    				selectedMulti: false
    			},
    			data: {
    				simpleData: {
    					enable: true
    				}
    			},
    			callback: {
    				onRightClick: Yhxutil.org.OnRightClick,
    				onClick:Yhxutil.org.onDblClick
    			}
    		};

		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		Yhxutil.org.zTree = $.fn.zTree.getZTreeObj("treeDemo");
		//展开
		Yhxutil.org.zTree.expandAll(true);
		Yhxutil.org.rMenu = $("#rMenu");
};


Yhxutil.org.OnRightClick =function(event, treeId, treeNode) {
	if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
		Yhxutil.org.zTree.cancelSelectedNode();
	} else if (treeNode && !treeNode.noR) {
		Yhxutil.org.zTree.selectNode(treeNode);
		Yhxutil.org.showRMenu("node", event.clientX, event.clientY);
	}
};


Yhxutil.org.showRMenu = function(type, x, y) {
	$("#rMenu ul").show();
	Yhxutil.org.rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", Yhxutil.org.onBodyMouseDown);
};


Yhxutil.org.onBodyMouseDown = function(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		Yhxutil.org.rMenu.css({"visibility" : "hidden"});
	}
}


Yhxutil.org.hideRMenu = function() {
	if (Yhxutil.org.rMenu) Yhxutil.org.rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", Yhxutil.org.onBodyMouseDown);
}


/**
 * 添加
 */
Yhxutil.org.addTreeNode =  function(v){
	var url = $(v).attr("src");
    var parentNode = Yhxutil.org.zTree.getSelectedNodes()[0]; 
    Yhxutil.org.hideRMenu();
	mgt_util.showjBox({
		width : 860,
		height : 450,
		title : '添加',
		scope:this,
		url :url+'?id='+parentNode.id+'&name='+encodeURIComponent(parentNode.name),
		closed:function(){
//			var datas =
//		    {
//		    id:'ids',	name:'names'
//			};
//		    var param =
//		    {
//		    	    url:'/department/deptList.jhtml',
//		    	    data:datas
//		    };
		   Yhxutil.org.doInit(param);
		 }
	});
};


/**
 * 修改
 */
Yhxutil.org.modifyTreeNode = function(v){
	var url = $(v).attr("src");
	var parentNode = Yhxutil.org.zTree.getSelectedNodes()[0]; 
    Yhxutil.org.hideRMenu();
	mgt_util.showjBox({
		width : 860,
		height : 450,
		title : '修改',
		scope:this,
		url :url+'?id='+parentNode.id+'&name='+encodeURIComponent(parentNode.name),
		closed:function(){
//			var datas = {
//				id:'ids',
//				name:'names'
//			};
//		    var param = {
//		    	url:'/controller/mgt/department/deptList',
//		    	data:datas
//		    };
		    Yhxutil.org.doInit(param);
		 }
	});
};

/**
 * 删除
 */
Yhxutil.org.removeTreeNode = function(v){
	var url = $(v).attr("src");
	Yhxutil.org.hideRMenu();
	var nodes = Yhxutil.org.zTree.getSelectedNodes()[0];
	var data = {
		id:nodes.id,
		name:nodes.name
	};
	if (nodes.id) {
		$.ajax({
			type: "POST",		   
			url:url,
			async:false,
			data:data,
			scope:this,
			success: function(response) {			
				//var obj = jQuery.parseJSON(response);
				if(response.code != "success" ){
					$.jBox.tip(response.msg);
					reutrn;
				}
//							var datas =
//						    {
//						    id:'ids',	name:'names'
//							}
//						    var param =
//						    {
//						    	    url:'/controller/mgt/department/deptList',
//						    	    data:datas
//						    }
				Yhxutil.org.doInit(param);
			}
		});
	}
};

/**
 * 双击刷新grid
 */
Yhxutil.org.onDblClick = function(){
	var grid = '#grid-table';
	var data = $("#queryForm").serializeObjectForm();
	var parentNode = Yhxutil.org.zTree.getSelectedNodes()[0]; 
	var shuxing = {departId:parentNode.id,departName:parentNode.name};
	for(var r in shuxing){
	   eval("data."+r+"=shuxing."+r);
	}
	$(grid).jqGrid('setGridParam',{  
        datatype:'json',  
        postData:data, //发送数据  
        page:1  
    }).trigger("reloadGrid");
};


function count(o){
	var t = typeof o;
	if(t == 'string'){
		return o.length;
	}else if(t == 'object'){
		var n = 0;
		for(var i in o){
			n++;
		}
		return n;
	}
	return false;
}