<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset= utf-8" />
<title>支付MQ</title>
</head>
<body onload="javascript: document.forms[0].submit();">
	<form action="https://dlink.test.bank.ecitic.com/pec/b2cplaceorder.do" method="post" >
			<input type="hidden" name="SIGNREQMSG" id="SIGNREQMSG" value="${strSignedMsg}" />
	</form>
</body>
</html>