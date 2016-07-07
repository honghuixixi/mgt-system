<!DOCTYPE html>
<html>
<head>
    <title>确认对账</title>
[#include "/common/commonHead.ftl" /]
    <link rel="shortcut icon" href="${base}/styles/images/16.ico" />
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
    <link rel="stylesheet" media="screen" href="${base}/styles/css/base/css/ztree.css" />
</head>

<body class="toolbar-fixed-top">
<form class="form-horizontal" id="form" action="${base}/paybill/checkPaybill.jhtml" method="POST">
    <input type="hidden"  name="id" id="id" value="${id}">
    <input type="hidden"  name="sn"  id="sn" value="${sn}">
    <input type="hidden"  name="tranAmount" id="tranAmount" value="${tranAmount}">
    <div class="navbar-fixed-top" id="toolbar">
        <div class="btn-group pull-right">
            <div class="btn-group">
                <button class="btn btn-danger" data-toggle="jBox-submit" data-form="#form" data-fn="checkForm">对账成功
                    <i class="fa-save  align-top bigger-125 fa-on-right"></i>
                </button>
            </div>
            <button class="btn btn-warning" data-toggle="jBox-close">关闭
                <i class="fa-undo align-top bigger-125 fa-on-right"></i>
            </button>
        </div>
    </div>

    <!--  <div class="page-content"> -->
    <div class="row">

        <div class="col-xs-5">
            <div class="form-group">
                <label for="beginDate" class="col-sm-3 control-label">
                   金额:
                </label>
                <div class="col-sm-6">
                    <input type="text" id="amount" name="amount" class="form-control required number" value=""  maxlength = "12"/>
                </div>
            </div>
        </div>

    </div>
    <!-- </div> -->
    <div class="row">

        <div class="col-xs-5">
            <div class="form-group">
                <label for="name" class="col-sm-3 control-label">
                    银行流水号：
                </label>
                <div class="col-sm-6">
                    <input type="text" class="form-control input-sm required"  id="bankSn" name="bankSn" value='' maxlength="32" />
                </div>
            </div>
        </div>

    </div>
</form>
<script type="text/javascript">

    function checkForm(){
        if (mgt_util.validate(form)){
            var amount = $("#amount").val();
            var tranAmount = $("#tranAmount").val();
            if(amount != tranAmount){
                $("#amount").after("<span id='amountError' style='color:#f00;'>金额与账单交易金额不一致</span>");
            }else{
                mgt_util.submitForm('#form');
            }
        }
    }
</script>
</body>
</html>
