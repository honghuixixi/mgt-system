<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8" />
        <title>系统管理-部门信息配置</title>
		[#include "/common/commonHead.ftl" /]
		<link rel="shortcut icon" href="${base}/styles/images/16.ico" />
		<script type="text/javascript" language="javascript" src="${base}/scripts/lib/tabData.js"></script>
		<script  type="text/javascript">
			$(document).ready(function(){
				mgt_util.jqGrid('#grid-table',{
                    multiselect:false,
					url:'${base}/mgtDepartment/list.jhtml',
 					colNames:['','部门编号','部门名称','公司名称','备注','操作'],
				   	colModel:[
				   		{name:'ID',index:'ID',width:0,hidden:true,key:true},
				   		{name:'DEPART_CODE',align:"center",width:90},
				   		{name:'NAME',align:"center",width:90},
				   		{name:'COMPANY_NAME',align:"center",width:90},
				   		{name:'MEMO',align:"center",width:90},
						{name:'detail',index:'PK_NO',width:80,align:'center',sortable:false} 
				   		
				   		],
				   	gridComplete:function(){ //循环为每一行添加业务事件 
					var ids=jQuery("#grid-table").jqGrid('getDataIDs'); 
						for(var i=0; i<ids.length; i++){ 
							var id=ids[i];
							detail ="<button type='button' class='btn btn-info edit' id='"+id+"' data-toggle='jBox-show' href='${base}/mgtDepartment/editMgtDepartmentUI.jhtml'>编辑</button>";
							detail +="&nbsp;<button type='button' class='btn btn-info del' id='"+id+"' onclick='deleteDepartment(&quot;"+id+"&quot;)'>删除</button>";
							jQuery("#grid-table").jqGrid('setRowData', ids[i], { detail: detail }); 
	
						};
						//table数据高度计算
						cache=$(".ui-jqgrid-bdivFind").height();
						tabHeight($(".ui-jqgrid-bdiv").height());
					} 
				   	
				});
			});
            function deleteDepartment(id){
                $.jBox.confirm("确认要删除该数据?", "提示", function(v){
                    if(v == 'ok'){
                        mgt_util.showMask('正在删除数据，请稍等...');
                        $.ajax({
                            url : "${base}/mgtDepartment/delete.jhtml",
                            type :'post',
                            dataType : 'json',
                            data : 'id=' + id,
                            success : function(data, status, jqXHR) {
                                mgt_util.hideMask();
                                mgt_util.showMessage(jqXHR,
                                        data, function(s) {
                                            if (s) {
                                                if(data.code=='function_merchant_error_001'){
                                                    top.$.jBox.tip('当前应用正在使用,不能删除！','error');
                                                }else{
                                                    top.$.jBox.tip('删除成功！','success');
                                                    top.$.jBox.refresh = true;
                                                }
                                                mgt_util.refreshGrid('#grid-table');
                                            }
                                        });
                            }
                        });
                    }
                });
            }
		</script>
    </head>
    <body>
       <div class="body-container">
       	  <div class="main_heightBox1">
            <div id="currentDataDiv" action="mgtDepartment">
	            <div class="currentDataDiv_tit">
	              <div class="form-group">
    		    		<button type="button" class="btn_divBtn add" id="depart_add" data-toggle="jBox-win" href="${base}/mgtDepartment/addMgtDepartmentUI.jhtml">添加 </button>
    		    	</div> 
	            </div>
	            <div class="form_divBox" style="display:block;">
		            <form class="form form-inline queryForm"  name="query" id="query-form"> 
		               <div class="form-group">
		                    <label class="control-label">部门名称</label>
		                    <input type="text" class="form-control" name="name" style="width:120px;">
		                </div>
		                
		            </form>
	            </div>
	            <div class="search_cBox">
	                <div class="form-group">
	                    <!--这里的id和资源中配置的值需要一致。-->
	                 	<button type="button" class="search_cBox_btn" id="department_query" data-toggle="jBox-query"><i class="icon-search"></i> 搜 索 </button>
	                </div>
	            </div>
	        </div>
	      </div>
		  <table id="grid-table" ></table>
		  <div id="grid-pager"></div>
   		</div>
    </body>
</html>