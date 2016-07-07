mgt_util={
		showMask : function(msg, el, m) {
			var el = $(document.body) || el;
			var msg = $('<div class="x-masked-text"><i class="fa-spinner fa-spin orange bigger-125"></i>'
				+ msg + '</div>').appendTo(el);
			var top = (el.outerHeight() - msg.outerHeight()) / 2;
			msg.css({
					left : (el.outerWidth() - msg.outerWidth()) / 2,
					top : top < 150 ? 150 : top
				});
		},
		hideMask : function() {
			$('div.x-masked-text').remove();
		},
		jqGrid : function(q, p) {
			var flag = false;
			if(p.subGridRowExpanded && (p.subGridRowExpanded.length) > 0)
				flag = true;
			$(q).jqGrid($.extend({
						height : 'auto',
						width:'100%',
						autowidth: true,  
		              	shrinkToFit: true,
						datatype : 'json',
						jsonReader : {
							root:"records",
					   		total:"totalpage",
					   		page: "currentpage",
					   		records:"totalrecord",
					   		repeatitems: false
						},
						ajaxGridOptions : {
							method : 'post'
						},
						multiselect : !flag,
						subGrid: flag,
						viewrecords : true,
						rownumWidth : 40,
						mtype:'post',
						type:'post',
						rownumbers : true,
						rowNum : 20,
						pager : '#grid-pager',
						rowList : [20,50,100],
						altRows : false,
						prmNames:{nd:null},
						multiboxonly : false
//						,autowidth : true
					}, p));
		},
		showjBox : function(o) {// 打开弹出窗口
			var c = $.extend({
						id : 'jbox-win',
						border : 0,
						persistent : true,
						buttons : {},
						closed : function() {
							if (top.$.jBox.refresh === true) {
								mgt_util.refreshGrid(o.grid || '#grid-table');
								delete top.$.jBox.refresh;
							}
						}
					}, o);
			var width = parseFloat(c.width || mgt_constant.JBOX_WIDTH);
			var height = parseFloat(c.height || mgt_constant.JBOX_HEIGHT);
			c.width = width;
			c.height = height;
			top.$.jBox.open("iframe:" + o.url, c.title || '', width, height, c);
			top.$('#jbox-iframe').css('height','98%');
		},
		closejBox : function(token) {// 关闭窗口
			top.$.jBox.close(token);
		},
		refreshGrid : function(grid) {// 刷新grid
			$(grid).trigger("reloadGrid");
		},
		showMessage : function(jqXHR, data, fn) {
			var s = false;
			//alert(JSON.stringify(data));
			if (jqXHR.status == 404) {
				top.bootbox.alert('请求地址不存在！');
			} else if (data && data.success === false) {
				
				if(data.code=='vendorUpdateEpflg'){
					 top.$.jBox.tip(data.msg);
					 return;
				}
				var msg = ['错误代码：' + data.code + ',' + data.msg];
				if (data.stackTrace) {
					msg.push('<a data-toggle="collapse" class="error-collapsed" href="#error-panel-body" title="详细信息"><i class="fa-chevron-down"></i></a>');
					msg.push('<div id="error-panel-body" class="panel-collapse collapse"><pre>'
									+ data.msg + '</pre></div>');
				}
				
				top.bootbox.alert(msg.join(''));
				mgt_util.closejBox('jbox-win');
			} else if (data === false) {
				top.bootbox.alert('系统错误！');
			} else if (jqXHR.getResponseHeader("sessionstatus") == 'timeout') {
				top.$.jBox.tip('登录超时，请重新登录！');
			} else {
				s = true;
			}

			if (typeof fn == 'function') {
				fn.call(this, s, data);
			}
		},
		buttonDisabled : function() {// 禁用按钮
			$('.btn.btn-danger').addClass('disabled').attr('disabled', true);
		},
		buttonEnable : function() {// 启用
			$('.btn.btn-danger').removeClass('disabled').attr('disabled', false);
		},
		formObjectJson : function(form) {
			var json = {};
			var a = $(form).serializeArray();
			for (var i = 0; i < a.length; i++) {
				if(null!=json[a[i].name]&&json[a[i].name].length>0){
					json[a[i].name] = (json[a[i].name]+","+a[i].value);
				}else{
					json[a[i].name] = a[i].value;
				}
			}
			return json;
		},
		queryForm : function(form, jqgrid) { // 查询列表
			$(jqgrid).jqGrid('setGridParam', {
				start : 1,
				datatype:'json',
				type:'post',
				mtype:'post',
				page:1 ,
				postData : mgt_util.formObjectJson(form)
			}).trigger("reloadGrid");
		},
		//情况form
		clearForm :function(form,jqgrid){
            //清空form
			$(form).clearForm();
			$(jqgrid).jqGrid('setGridParam', {
				start : 1,
				datatype:'json',
				type:'post',
				mtype:'post',
				postData : mgt_util.formObjectJson(form)
			}).trigger("reloadGrid");
		},
		submitForm : function(form,functionName) {
			if (mgt_util.validate(form)) {
				try{
					if(functionName && typeof(functionName)!="undefined"){
						var result = eval(functionName+"();");
						if(result==false){return false;}
					}
				}catch(e){console.warn(e);}
				mgt_util.buttonDisabled();
				mgt_util.showMask('数据保存中....');
				$.ajax({
							url : $(form).attr('action'),
							type : 'post',
							dataType : 'json',
							data : mgt_util.formObjectJson(form),
							success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.buttonEnable();
								mgt_util.showMessage(jqXHR, data, function(s) {
							        if(data.code == 'orgNumberIsExist') {
							        	 $.jBox.tip('部门编号已经存在！');
							        }else if(data.code=='vcposCodeIsExist'){
							        	 $.jBox.tip('VCPOS编号已经存在！');
							        } else if(data.code == 'userNumberIsExist'){
							        	 $.jBox.tip('登录账号已经存在！');
							        } else if(data.code == 'FunctionNameIsExist'){
							        	 $.jBox.tip('应用名称已经存在！');
							        }else if(data.code == 'notUpdate'){
							        	 $.jBox.tip('已在客户信息中引用，不允许修改记录！');
							        }else if(data.code == 'catExsit'){
							        	 $.jBox.tip('同一种类别不能定义两条折扣！');
							        }else if(data.code == 'call'){
										top.$.jBox.tip(data.msg, 'success');
										top.$.jBox.refresh = true;
										mgt_util.closejBox('jbox-win');
							        }else if(data.code == 'order-deliver'){
							        	top.$.jBox.tip(data.msg, 'error');
							        	top.$.jBox.refresh = true;
							        	mgt_util.closejBox('jbox-win');
							        }else if(data.code == 'add-A-index'){
							        	top.$.jBox.tip(data.msg, 'success');
							        	$('#grid-table').trigger("reloadGrid");
							        }else if(data.code == 'save-B-index'){
							        	top.$.jBox.tip(data.msg, 'success');
							        	window.location.reload();
							        }else if(s){
										top.$.jBox.tip('保存成功！', 'success');
										top.$.jBox.refresh = true;
										mgt_util.closejBox('jbox-win');
							        }
								});
							}
				});
			}
		},
		submitPageForm : function(form,rules) {
			if (mgt_util.validate(form,rules)) {
				mgt_util.showMask('数据保存中....');
				mgt_util.buttonDisabled();
				$(form)[0].submit();
			}
		},
		ajaxSubmitForm : function(form,rules,callback) {
			if (mgt_util.validate(form,rules)) {
				mgt_util.showMask('数据保存中....');
				mgt_util.buttonDisabled();
				$.ajax({
					url : $(form).attr('action'),
					type : 'post',
					dataType : 'json',
					data : mgt_util.formObjectJson(form),
					success : function(data, status, jqXHR) {
						mgt_util.hideMask();
						mgt_util.buttonEnable();
						mgt_util.showMessage(jqXHR, data,callback);
					}
				});
			}
		},
		validate : function(f, o) {
			var p = $.extend({
						meta: "validate",
						errorElement : 'div',
						errorClass : 'help-block',
						highlight : function(e) {
							$(e).closest('.form-group').removeClass('has-info')
									.addClass('has-error');
						},
						success : function(e) {
							$(e).closest('.form-group').removeClass('has-error')
									.addClass('has-info');
							$(e).remove();
						},
						errorPlacement : function(error, element) {
							if (element.parent().is('.input-group')) {
								error.insertAfter(element.parent());
							} else {
								error.insertAfter(element);
							}
						}
					}, o);
			var v = $(f).validate(p);
			return v.form();
		},
		loginWin : function() {
			top.$.jBox.open("iframe:/login/toLoginWin.jhtml", "用户登录", 450, 285, {
				id : 'loginBox',
				border : 0,
				persistent : true,
				iframeScrolling : 'no',
				buttons : {}
			});
		}
		
};