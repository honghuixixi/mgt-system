$.jBox.setDefaults({
			tipDefaults : {
				top : 0
			}
		});
$(document).ready(function(){
	$.ajaxSetup({
		error : function(jqXHR, textStatus, errorThrown) {
			mgt_util.showMessage(jqXHR, false);
			mgt_util.hideMask();
			mgt_util.buttonEnable();
		},
		complete : function(jqXHR, textStatus) {
			var s = jqXHR.getResponseHeader("sessionstatus");
			if (s == "timeout") {
				//mgt_util.loginWin();
				window.document.location.href = "../../login/toLogin.jhtml";
				return false;
			}
		}
	});
	
	var t = '[data-toggle="jBox-edit-kitPromLm-item"],[data-toggle="jBox-query-kitProm-item"],[data-toggle="jBox-edit-kitProm-item"],[data-toggle="jBox-win"],[data-toggle="jBox-edit-status"],[data-toggle="jBox-location"],[data-toggle="jBox-edit-dept"],[data-toggle="org-jBox-win"],[data-toggle="jBox-query-prom-mas"],[data-toggle="jBox-query-prom-sale"],[data-toggle="jBox-query-promCombo-mas"],[data-toggle="jBox-remove-prom"],[data-toggle="jBox-show"],[data-toggle="jBox-edit-prom-item"],[data-toggle="jBox-edit-promCombo"],[data-toggle="jBox-edit-promTime"],[data-toggle="jBox-edit-goods"],[data-toggle="jBox-remove-cardType"],[data-toggle="jBox-remove-category"],[data-toggle="jBox-remove-resource"],[data-toggle="jBox-remove-function"],[data-toggle="jBox-remove-role"],[data-toggle="function-jBox-win"],[data-toggle="jBox-audit-userfunction"],[data-toggle="jBox-view"],[data-toggle="jBox-submit"],[data-toggle="jBox-bill"],[data-toggle="jBox-edit"],[data-toggle="jBox-remove"],[data-toggle="jBox-update"],[data-toggle="jBox-remove-salarychanges"],[data-toggle="jBox-remove-useroperation"],[data-toggle="jBox-close"],[data-toggle="jBox-refresh"],[data-toggle="jBox-call"],[data-toggle="jBox-query"],[data-toggle="jBox-download"],[data-toggle="page-submit"],[data-toggle="jBox-clear-form"],[data-toggle="jBox-change-order"],[data-toggle="jBox-modify-scope"],[data-toggle="jBox-edit-b2cprom-item"],[data-toggle="jBox-query-prom-user"]';

	$(document).on('click', t, function(e) {
		var $t = $(this);
		var toggle = $t.attr('data-toggle');
		var fn = $t.attr('data-fn');
		var form = $t.attr('data-form') || '#query-form';
		var grid = $t.attr('data-grid') || '#grid-table';
		var url = $t.attr('href');
		var pkno = $t.attr('id');
		var w = $t.attr('jBox-width');
		var h = $t.attr('jBox-height');
		var t = $t.attr('title') || $t.text();
		var type = $t.attr('data-type');
		var callback = $t.attr('call-back');

		if (toggle == 'jBox-close') {
			top.$.jBox.close();
		} else if (toggle == 'jBox-refresh') {
			document.location.reload();
		} 
		else if (toggle == 'jBox-query') {
			mgt_util.queryForm(form, grid);
		}else if (toggle == 'jBox-query-prom-mas') {
			 if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看促销商品");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("添加商品");
				 }
			mgt_util.queryForm(form, grid);
		}else if (toggle == 'jBox-query-prom-sale') {
			 if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看参与该活动商品");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("添加商品");
				 }
			mgt_util.queryForm(form, grid);
		}else if (toggle == 'jBox-query-promCombo-mas') {
			if($("#selectTypeVal").val()=='1'){
				$("#selectTypeVal").val("2");
				$("#sreachFlagSpan").text("查看套装商品");
			}else{
				$("#selectTypeVal").val("1");
				$("#sreachFlagSpan").text("添加商品");
			}
			$("input[name='nameOrStkc']").val('请输入商品条码或编码或名称');
			mgt_util.queryForm(form, grid);
		}else if (toggle == 'jBox-query-prom-user') {
			 if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看促销商户");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("添加商户");
				 }
			mgt_util.queryForm(form, grid);
		} 
		else if (toggle == 'jBox-query-kitProm-item') {
			 if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看促销商品");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("添加商品");
				 }
			mgt_util.queryForm(form, grid);
		} 
		
		else if (toggle == 'jBox-query-kitPromLm-item') {
			 if($("#selectTypeVal").val()=='1'){
				 $("#selectTypeVal").val("2");
				 $("#sreachFlagSpan").text("查看促销方案覆盖的地标");
				 }else{
				 $("#selectTypeVal").val("1");
				 $("#sreachFlagSpan").text("添加促销方案覆盖的地标");
				 }
			mgt_util.queryForm(form, grid);
		} 
		
		else if (toggle == 'jBox-submit') {
			var fn = fn ? eval(fn) : mgt_util.submitForm;
			fn.call(this, form,callback);
		} else if (toggle == 'page-submit') {
			var fn = fn ? eval(fn) : mgt_util.submitPageForm;
			fn.call(this, form);
		}  else if (toggle == 'jBox-download') {
			window.open(url);
		} else if (toggle == 'jBox-bill') {
			var fn = fn ? eval(fn) : queryForm.submitBill;
			fn.call(this, form, grid);
		} else if (toggle == 'jBox-edit' || toggle == 'jBox-view') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
							width : w,
							height : h,
							title : t,
							url : url,
							grid : grid
						});
			}

		} 
		else if (toggle == 'jBox-show') {
			//var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			url = url + '?id=' + pkno;
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
					width : w,
					height : 520,
					title : t,
					url : url,
					grid : grid
				});
			}
		}
		else if (toggle == 'jBox-edit-dept') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} 
			url = url + '?id=' + ids;
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
							width : w,
							height : h,
							title : t,
							url : url,
							grid : grid
						});
			}
			}
		else if (toggle == 'jBox-edit-goods') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			var rowDatas =$(grid).jqGrid('getRowData', ids[0]); 
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			 var  Cts=rowDatas.status;
			 if(Cts=="已绑定"){
					  $.jBox.tip("该产品已经绑定返利，不能再绑定了!");
					  return
				 }
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
							width : w,
							height : h,
							title : t,
							url : url,
							grid : grid
						});
			}

		} 
		else if (toggle == 'jBox-edit-promCombo') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			var rowDatas =$(grid).jqGrid('getRowData', ids[0]); 
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			var stkC=rowDatas.STK_C;
			url = url + '?id=' + ids[0] +'&stkC=' + stkC;
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
					width : w,
					height : h,
					title : t,
					url : url,
					grid : grid
				});
			}
			
		} 
		else if (toggle == 'jBox-edit-promTime') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			var rowDatas =$(grid).jqGrid('getRowData', ids[0]); 
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			var statusFlg=rowDatas.STATUS_FLG;
			if(statusFlg=="已启用"){
				top.$.jBox.tip("该活动已经开始，启用期间禁止修改!");
				return;
			}			
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				mgt_util.showjBox({
					width : w,
					height : h,
					title : t,
					url : url,
					grid : grid
				});
			}
			
		} 
		else if (toggle == 'jBox-audit-userfunction') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} 
			var applyStatus=$t.attr('id');
			$.jBox.confirm("确认"+t+"吗?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在审核数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'ids=' + ids+'&applyStatus='+applyStatus,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
										if (s) {
										 top.$.jBox.tip('审核成功！', 'success');
											mgt_util.refreshGrid(grid);
										}
									});
						}
					});
			 
				}
			});
			
		} 
		else if (toggle == 'jBox-remove') {
			
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
										if (s) {
											if(data.code=='function_merchant_error_001'){
												top.$.jBox.tip('当前应用正在使用,不能删除！','error');
											}else{
											top.$.jBox.tip('删除成功！','success');
											}
											mgt_util.refreshGrid(grid);
										}
									});
						}
					});
				}
			});} 
		else if (toggle == 'jBox-edit-status') {
			
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要停用员工?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在设置数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								if (s) {
									top.$.jBox.tip('设置成功！','success');
									mgt_util.refreshGrid(grid);
								}
							});
						}
					});
				}
			});} 
		else if (toggle == 'jBox-remove-role') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			
//			$.ajax({
//				url : url,
//				type :'post',
//				dataType : 'json',
//				data : 'id=' + ids,
//				success : function(data, status, jqXHR) {
//				mgt_util.hideMask();
//				mgt_util.showMessage(jqXHR,
//						data, function(s) {
//					$.jBox.confirm(data.msg+"确认要删除该数据?", "提示", function(v){
					$.jBox.confirm("确认要删除该数据?", "提示", function(v){
						if(v == 'ok'){
							mgt_util.showMask('正在删除数据，请稍等...');
							$.ajax({
								url : url,
								type :'post',
								dataType : 'json',
								data : 'id=' + ids,
								success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										if(data.code=='function_merchant_error_001'){
											top.$.jBox.tip('当前应用正在使用,不能删除！','error');
										}else{
											top.$.jBox.tip('删除成功！','success');
										}
										mgt_util.refreshGrid(grid);
									}
								});
								}
							});
						}
					});
					
//				});
//			}
//			});
		} 
		else if (toggle == 'jBox-remove-resource') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			
//			$.ajax({
//				url : url,
//				type :'post',
//				dataType : 'json',
//				data : 'id=' + ids,
//				success : function(data, status, jqXHR) {
//				mgt_util.hideMask();
//				mgt_util.showMessage(jqXHR,
//						data, function(s) {
//					$.jBox.confirm(data.msg+"确认要删除该数据?", "提示", function(v){
					$.jBox.confirm("确认要删除该数据?", "提示", function(v){
						if(v == 'ok'){
							mgt_util.showMask('正在删除数据，请稍等...');
							$.ajax({
								url : url,
								type :'post',
								dataType : 'json',
								data : 'id=' + ids,
								success : function(data, status, jqXHR) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR,
										data, function(s) {
									if (s) {
										if(data.code=='function_merchant_error_001'){
											top.$.jBox.tip('当前应用正在使用,不能删除！','error');
										}else{
											top.$.jBox.tip('删除成功！','success');
										}
										mgt_util.refreshGrid(grid);
									}
								});
							}
							});
						}
					});
//				});
//			}
//			});
		} 
		else if (toggle == 'jBox-remove-prom') {

			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
			
										if (s) {
											if(data.code=='001'){
												top.$.jBox.tip('删除成功！','success');
											}else if(data.code=='002'){
												top.$.jBox.tip('该活动正在进行中，删除失败','error');
											}
											mgt_util.refreshGrid(grid);
										}
									});
						}
					});
				}
			});
		
		} 
		
		else if (toggle == 'jBox-update') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要解锁该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在解锁数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
										if (s) {
											top.$.jBox.tip('解锁成功！','success');
											mgt_util.refreshGrid(grid);
										}
									});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-remove-salarychanges') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			top.bootbox.confirm('是否确定删除？', function(v) {
				if (v) {
					zkungfu.util.showMask('正在删除数据，请稍等...');
					$.ajax({
								url : url,
								method : 'post',
								dataType : 'json',
								data : 'ids=' + ids,
								success : function(data, status, jqXHR) {
									mgt_util.hideMask();
									mgt_util.showMessage(jqXHR, data,
											function(s) {
												if (null != data) {
													top.$.jBox.tip('删除成功！',
															'success');
													mgt_util
															.refreshGrid(grid);
												} else {
													top.$.jBox.tip(
																	'这条记录已经同步不能删除，删除失败！',
																	'error');
													mgt_util.refreshGrid(grid);

												}
											});
								}
							})
				}
			});
		}
		else if (toggle == 'jBox-remove-useroperation') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR, data,
										function(s) {
									if (null != data) {
										if(data.code=='001'){
										top.$.jBox.tip('删除成功！',
										'success');
										}
										else{
											top.$.jBox.tip(
													data.msg,
											'error');
											
										}
										
									} else {
										top.$.jBox.tip(
												'删除失败！',
										'error');
										
									}
									mgt_util.refreshGrid(grid);
								});
							});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-remove-function') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条应用！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择应用不能超过一条！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在删除数据，请稍等...');
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR, data,
										function(s) {
									if (null != data) {
										if(data.code=='001'){
										top.$.jBox.tip('删除成功！',
										'success');
										}
										else{
											top.$.jBox.tip(
													data.msg,
											'error');
											
										}
										
									} else {
										top.$.jBox.tip(
												'此应用已经被应用人正在使用，不能删除！',
										'error');
										
									}
									mgt_util.refreshGrid(grid);
								});
							});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-remove-cardType') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR, data,
										function(s) {
									if (null != data) {
										if(data.code=='001'){
										top.$.jBox.tip('删除成功！',
										'success');
										}
										else{
											top.$.jBox.tip(
													'此卡类型下有卡正在使用，不能删除！',
											'error');
											
										}
										
									} else {
										top.$.jBox.tip(
												'此应用已经被应用人正在使用，不能删除！',
										'error');
										
									}
									mgt_util.refreshGrid(grid);
								});
							});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-remove-category') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			$.jBox.confirm("确认要删除该数据?", "提示", function(v){
				if(v == 'ok'){
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
									data, function(s) {
								mgt_util.hideMask();
								mgt_util.showMessage(jqXHR, data,
										function(s) {
									if (null != data) {
										if(data.code=='001'){
											top.$.jBox.tip('删除成功！',
											'success');
										}
										else{
											top.$.jBox.tip(
													'删除失败，分类下已有子分类或商品！',
											'error');
											
										}
										
									} else {
										top.$.jBox.tip(
												'此应用已经被应用人正在使用，不能删除！',
										'error');
										
									}
									mgt_util.refreshGrid(grid);
								});
							});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-location') {
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请至少选择一条记录！');
				return;
			}
			url = url + '?id=' + ids;
			mgt_util.showjBox({
				width : w,
				height : h,
				title : t,
				url : url,
				grid : grid
			});
		}
		else if (toggle == 'jBox-win') {
			mgt_util.showjBox({
						width : w,
						height : h,
						title : t,
						url : url,
						grid : grid
					});
		}
		else if(toggle == 'org-jBox-win'){
			var treeDemo = $.fn.zTree.getZTreeObj("treeDemo");
			var node = Yhxutil.org.zTree.getSelectedNodes();
			if(node)
			{
				if (node.length <= 0) {
					top.$.jBox.tip('请选中一个部门	！');
					return;
				} else if (node.length > 1) {
					top.$.jBox.tip('请选中部门不能超过多条！');
					return;
				}
				url = url + '?departmentId=' + node[0].id;
				mgt_util.showjBox({
					width : w,
					height : h,
					title : t,
					url : url,
					grid : grid
				});
			}
			else{
				top.$.jBox.tip('请选中一个部门！');	
			}
		}else if(toggle == 'function-jBox-win'){
			var treeDemo = $.fn.zTree.getZTreeObj("treeDemo");
			var node = Yhxutil.fun.zTree.getSelectedNodes();
			if(node){
				if (node.length <= 0) {
					top.$.jBox.tip('请选中一个应用分类！');
					return;
				} else if (node.length > 1) {
					top.$.jBox.tip('选中的应用分类不能超过一条！');
					return;
				}
				 if(node[0].id=="-1"){
			    	 $.jBox.tip("该应用分类不能添加应用!");
				    return
				    }
				url = url + '?pId=' + node[0].id+'&&pName='+encodeURIComponent(node[0].name);
				mgt_util.showjBox({
					width : w,
					height : h,
					title : t,
					url : url,
					grid : grid
				});
			}else{
				top.$.jBox.tip('请选中一个应用分类！');
				return
			}
			
		}else if(toggle == 'jBox-change-order'){
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要处理该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在处理数据，请稍等...');
					//var arrayCount = [2,3,4,5,6,7];
					// 获取所有面包屑对象，重新设置数量
					//$.each($(".sub_status_but"),function(n,value) {
					//	$spanCount = $(value).find('span.pull-right');
					//	$spanCount.html(arrayCount[n]);
					//});
					var root = url.substring(0,url.indexOf("order/"));
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'id=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
							data, function(s) {
								if (s) {
									if(data.code == '1987'){
										top.$.jBox.tip(data.msg,'error');
										mgt_util.refreshGrid(grid);
									}else{
										top.$.jBox.tip('处理成功！','success');
										mgt_util.refreshGrid(grid);
									}
								}
							});
						}
					});
				}
			});
		} else if(toggle == 'jBox-modify-scope'){
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			}
			$.jBox.confirm("确认要处理该数据?", "提示", function(v){
				if(v == 'ok'){
					mgt_util.showMask('正在处理数据，请稍等...');
					var root = url.substring(0,url.indexOf("role/"));
					$.ajax({
						url : url,
						type :'post',
						dataType : 'json',
						data : 'ids=' + ids,
						success : function(data, status, jqXHR) {
							mgt_util.hideMask();
							mgt_util.showMessage(jqXHR,
							data, function(s) {
								if (s) {
									if(data.code=='vendorUpdateEpflg'){
										 top.$.jBox.tip(data.msg);
										 return;
									}else{
										top.$.jBox.tip('处理成功！','success');
									}
									mgt_util.refreshGrid(grid);
								}
							});
						}
					});
				}
			});
		}
		else if (toggle == 'jBox-edit-kitProm-item') {
			var root = url.substring(0,url.indexOf("b2cKitPromMas/"));
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				var node = $(grid).jqGrid("getRowData",ids);//
				if(node.STATUS_FLG=='取消'){
					top.$.jBox.tip('该活动已取消！');
					return;
				}
				$.ajax({
					url : root + "b2cKitPromMas/findKitPromStatFlag.jhtml",
					type :'post',
					dataType : 'json',
					data : 'pkNo=' + ids,
					success : function(data, status, jqXHR) { 
						if(data.code==001){
							mgt_util.showjBox({
								width : w,
								height : h,
								title : t,
								url : url,
								grid : grid
							});
							}else if(data.code==002){
							    top.$.jBox.tip('该促销套餐正在进行中.', 'error');
							}
					}
				});
			}
				
			
		}
		
		else if (toggle == 'jBox-edit-kitPromLm-item') {
			var root = url.substring(0,url.indexOf("b2cKitPromMas/"));
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				var node = $(grid).jqGrid("getRowData",ids);//
				if(node.STATUS_FLG=='取消'){
					top.$.jBox.tip('该活动已取消！');
					return;
				}
				$.ajax({
					url : root + "b2cKitPromMas/findKitPromStatFlag.jhtml",
					type :'post',
					dataType : 'json',
					data : 'pkNo=' + ids,
					success : function(data, status, jqXHR) { 
						if(data.code==001){
							mgt_util.showjBox({
								width : w,
								height : h,
								title : t,
								url : url,
								grid : grid
							});
							}else if(data.code==002){
							    top.$.jBox.tip('该促销套餐正在进行中.', 'error');
							}
					}
				});
			}
				
			
		}
		
		
		
		else if (toggle == 'jBox-edit-prom-item') {
			var root = url.substring(0,url.indexOf("prom/"));
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				var node = $(grid).jqGrid("getRowData",ids);//
				if(node.STATUS_FLG=='取消'){
					top.$.jBox.tip('该活动已取消！');
					return;
					
				}
				$.ajax({
					url : root + "prom/findPromStatFlag.jhtml",
					type :'post',
					dataType : 'json',
					data : 'pkNo=' + ids,
					success : function(data, status, jqXHR) { 
						if(data.code==001){
//							mgt_util.showjBox({
//								width : w,
//								height : h,
//								title : t,
//								url : url,
//								grid : grid
//							});
							$("#promId").val(ids[0]);
							$("#editPromForm").submit();
							}else if(data.code==002){
							top.$.jBox.tip('该活动正在进行中或已经结束...', 'error');
							}
					}
				});
				
		
			}

		} else if (toggle == 'jBox-edit-b2cprom-item') {
			var root = url.substring(0,url.indexOf("b2cPromMas/"));
			var ids = $(grid).jqGrid('getGridParam', 'selarrrow');
			if (ids.length <= 0) {
				top.$.jBox.tip('请选择一条记录！');
				return;
			} else if (ids.length > 1) {
				top.$.jBox.tip('选择记录不能超过一条！');
				return;
			}
			url = url + '?id=' + ids[0];
			if (type == 'tab') {
				var tab = top.$('#home-tabs').ajaxTab($(this), t, url);
				if (tab !== false) {
					$('iframe', tab.data('target')).data('grid', $(grid));
				}
			} else {
				var node = $(grid).jqGrid("getRowData",ids);//
				if(node.STATUS_FLG=='取消'){
					top.$.jBox.tip('该活动已取消！');
					return;
					
				}
				$.ajax({
					url : root + "b2cPromMas/findPromStatFlag.jhtml",
					type :'post',
					dataType : 'json',
					data : 'pkNo=' + ids,
					success : function(data, status, jqXHR) { 
						if(data.code==001){
							mgt_util.showjBox({
								width : w,
								height : h,
								title : t,
								url : url,
								grid : grid
							});
							}else if(data.code==002){
							top.$.jBox.tip('该活动正在进行中或已经结束...', 'error');
							}
					}
				});
				
		
			}

		}else if (toggle == 'jBox-call' && fn) {
			eval(fn).call(this);
		}else if(toggle == 'jBox-clear-form'){
			mgt_util.clearForm(form, grid);
		}
		return false;
	})
	
	
});