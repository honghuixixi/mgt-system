package cn.qpwa.mgt.facade.system.service.impl;


import cn.qpwa.common.utils.CommonUtil;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.RequestKey;
import cn.qpwa.common.utils.TransferJson;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.utils.http.HttpUtil;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.service.SubaccountService;

import net.sf.json.JSONObject;
import org.hibernate.LockOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

@Service("subaccountService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class SubaccountServiceImpl implements SubaccountService {

	@Autowired
	SubaccountDAO subaccountDAO;
	@Autowired
	SubaccountbindcardDAO subaccountbindcardDAO;
	@Autowired
	SubaccountOperDAO subaccountOperDAO;
	@Autowired
	PaybillDAO paybillDAO;
	@Autowired
	SubaccountseqDAO subaccountseqDAO;
	@Autowired
	UserDao userDAO;
	@Autowired
	AttachedLucknumDAO attachedLucknumDAO;
	
	/**
	 * 注册中信银行附属账户信息
	 * @param params 中信银行所需参数
	 * @param eciticSubaccount 附属账户信息
	 * @param subaccountbindcard 附属账户绑定卡信息
	 * @return
	 */
	public Msg registerSubaccountInfo(JSONObject params, Subaccount eciticSubaccount, Subaccountbindcard subaccountbindcard){
		Msg msg = new Msg();
		JSONObject result = null;
		try {
			result = null;//EciticUtils.eciticFactory("dlbregsnXML", params);
		} catch (Exception e) {
			e.printStackTrace();
			msg.setSuccess(false);	
			msg.setMsg("保存失败，请联系管理员！");
		}
		//注册会员
		if(null!=result&&"AAAAAAA".equals(result.getString("status"))){
			subaccountDAO.save(eciticSubaccount);
			subaccountbindcardDAO.save(subaccountbindcard);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
			msg.setCode(result.getString("status"));
		}else{
			msg.setSuccess(false);	
			msg.setMsg(result.getString("statusText"));
		}
		return msg;
	}
	
	
	@Override
	@Deprecated
	public Subaccount findUniqueBy(String propertyName,Object value) {
		return subaccountDAO.findUniqueBy(Subaccount.class, propertyName, value);
	}

	@Override
	public void removeUnused(String paramString) {

		subaccountDAO.removeById(paramString);
	}

	@Override
	public Subaccount get(String paramString) {
		return subaccountDAO.get(paramString);
	}

	@Override
	public void saveOrUpdate(Subaccount paramT) {
		subaccountDAO.save(paramT);
	}

	@Override
	public Page querys(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		return subaccountDAO.querys(paramMap, orderby);
	}
	
	@Override
	public Page queryAAMList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby){
		return subaccountDAO.queryAAMList(paramMap, orderby);
	}
	
	@Override
	public Subaccount findUniqueBy(String[] propertyName, Object[] value) {
		return subaccountDAO.findUniqueBy(Subaccount.class, propertyName, value);
	}
	
	/**
	 * 判断附属账号是否存在
	 * @param accountNum
	 * @param randomNum
	 * @return
	 */
	public boolean isExist(String accountNum, String randomNum){
		boolean flag = false;
		String[] propertyName={"attachedAccount","subaccountType"};
		String[] value={accountNum,"8001"};
		Subaccount subAccount = subaccountDAO.findUniqueBy(Subaccount.class, propertyName, value);
		AttachedLucknum lucknum = attachedLucknumDAO.findAttachedLucknumByNum(randomNum);
		if(null!=subAccount || null!=lucknum)
			flag = true;
		return flag;
	}
	
	
	@Override
	public void save(Long subaccountId, String attachedAccount,Subaccountbindcard subaccountbindcard) {
		Subaccount subaccount = subaccountDAO.findUniqueBy(Subaccount.class, "id", subaccountId);
		Subaccount eciticSubaccount = subaccountDAO.findUniqueBy(Subaccount.class,
				new String[]{"subaccountType","custId"},
				new Object[]{"8001",subaccount.getCustId()});
		if(null==eciticSubaccount){
			eciticSubaccount = new Subaccount();
			eciticSubaccount.setCustId(subaccount.getCustId());
			eciticSubaccount.setCustName(subaccount.getCustName());
			eciticSubaccount.setSubaccountType("8001");
			eciticSubaccount.setProperty("2");
			eciticSubaccount.setState("00");
			eciticSubaccount.setChannelId("100101000");
			eciticSubaccount.setAttachedAccounttype("N");
			eciticSubaccount.setAttachedAccount(attachedAccount);
			eciticSubaccount.setCreateTime(new Date());
			subaccountDAO.save(eciticSubaccount);
			subaccountbindcard.setBankType("101000");
			subaccountbindcard.setCustId(eciticSubaccount.getCustId());
			subaccountbindcard.setCardbindtime(eciticSubaccount.getCreateTime());
			subaccountbindcard.setSubaccountType(eciticSubaccount.getSubaccountType());
			subaccountbindcardDAO.save(subaccountbindcard);	
		}
	}

	@Override
	public void changeStatus(Long id, String state,String operator) {
		
		Subaccount subaccount = subaccountDAO.findUniqueBy(Subaccount.class, "id", id);
		subaccount.setState(state);
		SubaccountOper subaccountOper = new SubaccountOper();
		subaccountOper.setCreateTime(new Date());
		subaccountOper.setCustId(subaccount.getCustId());
		subaccountOper.setCustName(subaccount.getCustName());
		subaccountOper.setSubaccountType(subaccount.getSubaccountType());
		subaccountOper.setOperator(operator);
		switch (state) {
		case "00":
			subaccountOper.setOpertype("3");
			break;
		case "01":
			subaccountOper.setOpertype("1");
			break;
		case "02":
			subaccountOper.setOpertype("2");
			break;
		}
		subaccountOperDAO.save(subaccountOper);
	} 
	

	/**
	 * 通过用户名、更新余额积分
	 * @return
	 * @return CouponMas
	 */
	public boolean upSubaccountAmount(String custId, BigDecimal amount, BigDecimal points){
		return subaccountDAO.upSubaccountAmount(custId, amount, points);
	}

	@Override
	public String bindBankCard(Long subaccountId, Subaccountbindcard subaccountbindcard) {
		Subaccount subaccount = subaccountDAO.findUniqueBy(Subaccount.class, "id", subaccountId);
		
		Subaccountbindcard bindcard =	subaccountbindcardDAO.findUniqueBy(Subaccountbindcard.class, new String[]{"custId","bankcardno","subaccountType"}, new Object[]{subaccount.getCustId(),subaccountbindcard.getBankcardno(),subaccount.getSubaccountType()});
		if(null!=bindcard){
			return "002";
			
		}
			subaccountbindcard.setCustId(subaccount.getCustId());
			subaccountbindcard.setCardbindtime(new Date());
			subaccountbindcard.setSubaccountType(subaccount.getSubaccountType());
			subaccountbindcardDAO.save(subaccountbindcard);	
		
			return "001";
	}

	@Override
	public String takeCash(Long subaccountId, BigDecimal tranamount,String subaccountbindcardId) {
		Subaccount subaccount = subaccountDAO.findUniqueBy(Subaccount.class, "id", subaccountId,LockOptions.UPGRADE.getLockMode());
		if(subaccount.getAmount().subtract(tranamount).floatValue()>=0){
			String code = CommonUtil.getGenerateCode(new Date());
			Subaccountseq subaccountseq = new Subaccountseq();
			subaccountseq.setPreamount(subaccount.getAmount());
			//用户总余额
			subaccountseq.setAmount(subaccount.getAmount().subtract(tranamount));
			subaccountseq.setCashAmount(subaccount.getCashAmount().subtract(tranamount));
			// 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销09内部交易
			subaccountseq.setChangeType("03");
			//账户变动方向  返回0
			subaccountseq.setSeqflag("1");
			subaccountseq.setCreateTime(DateUtil.toTimestamp(new Date()));
			subaccountseq.setSn(CommonUtil.getGenerateCode(new Date()));
			subaccountseq.setWorkdate(new SimpleDateFormat("yyyyMMdd").format(new Date()));
			subaccountseq.setNote("金额提现");
			subaccountseq.setCustName(subaccount.getCustName());
			subaccountseq.setCustId(subaccount.getCustId());
			subaccountseq.setSubaccountId(subaccount.getId().toString());
			subaccountseq.setSubaccountType(subaccount.getSubaccountType());
			subaccountseq.setRefsn(code);
			subaccountseqDAO.save(subaccountseq);
			subaccount.setAmount(subaccountseq.getAmount());
			subaccountDAO.save(subaccount);
			Map<String,Object> a = paybillDAO.findWaitPayData();
			Map<String,Object> b = paybillDAO.findTranTypeData(a);
			Map<String,Object> caleFeeParams = new HashMap<String,Object>();
			caleFeeParams.put("feeTempletNo", b.get("FEE_TEMPLETNO").toString());
			caleFeeParams.put("tranType", b.get("TRAN_TYPE").toString());
			caleFeeParams.put("tranAmount", tranamount);
			String  channelFee = paybillDAO.calcFee(caleFeeParams);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			//User user = userDAO.findByUsername(subaccount.getCustId());
			Subaccountbindcard subaccountbindcard = subaccountbindcardDAO.findUniqueBy(Subaccountbindcard.class, "id", subaccountbindcardId);
			
			Paybill paybill = new Paybill();
			paybill.setTranDate(sdf.format(new Date()));		
			paybill.setSn(subaccountseq.getRefsn());
			paybill.setSrccustId(a.get("CUST_ID").toString());
			paybill.setTranNote("提现");
			paybill.setPayerIfkftcust("Y");
			paybill.setPayercustId(a.get("CUST_ID").toString());
			paybill.setPayercustName(a.get("BANK_NAME").toString());
			paybill.setTranType(b.get("TRAN_TYPE").toString());
			paybill.setFeetype(b.get("FEE_TEMPLETNO").toString());
			paybill.setChannelId(a.get("CHANNEL_ID").toString());
			paybill.setChannelPayflag(b.get("CHANNEL_PAYFLAG").toString());
			paybill.setChannelAccount(a.get("CHANNEL_ACCOUNT").toString());
			paybill.setFeeState("00");
			paybill.setChannelFee(new BigDecimal(channelFee));
			paybill.setChannelCheckType("Y");
			paybill.setChannelCheckState("00");
			paybill.setPayeecustId(subaccount.getCustId());
			paybill.setPayeecustName(subaccount.getCustName());
			paybill.setCreateTime(new Date());
			paybill.setRechargedtlStatus("E");
			paybill.setRechargeState("3");
			paybill.setState("10");
			paybill.setPayState("00");
			paybill.setTranamount(tranamount);
			paybill.setCheckState("00");
			paybill.setPayerbankType(a.get("BANK_TYPE").toString());
			paybill.setPayerbankCode(a.get("BANK_TYPE").toString());
			paybill.setPayerbankname(a.get("BANK_NAME").toString());
			paybill.setPayerbankcardno(a.get("BANKCARDNO").toString());
			paybill.setPayerbankcardname(a.get("BANKCARDNAME").toString());
			paybill.setPayeebankname(subaccountbindcard.getBankName());
			paybill.setPayeebankcardname(subaccountbindcard.getBankcardname());
			paybill.setPayeebankcardno(subaccountbindcard.getBankcardno());
			paybill.setTranSubtype("提现");
			//paybill.setLineType("A");
			if("ECITIC0".equals(subaccountbindcard.getBankType())){
				paybill.setLineType("A");
			}else{
				paybill.setLineType("C");
			}
			paybillDAO.save(paybill);
			System.out.println("orderCode===================="+code);
		}else{
			return "002";
		}
		return "001";
		
	}
	
	/**
	 * 处理B2B提现(附属户8001)的业务数据保存
	 * 
	 * @param obj
	 * @return
	 */
	public String saveOutCashAttacc(JSONObject obj ,Subaccount subaccount) {
		log.info("B2B提现附属户余额变动保存开始：USID=" + obj.getString("Userid") + " AMT=" + obj.getString("tranAmt"));
		//附属账户提现金额直接从商户附属户减去
		
		obj.put("PayerBankCardNo", subaccount.getAttachedAccount());// 付款方账户号
		obj.put("PayerBankCardName", subaccount.getCustName());// 付款方账户名称
		obj.put("PayerCust_Id", subaccount.getCustId());// 付款方客户编号 
		obj.put("PayerCust_Name", subaccount.getCustName());// 付款方客户名称 
		obj.put("PayeeCust_Id", obj.getString("Userid"));// 收款方客户编号

		log.info("B2B提现附属户余额变动处理：商户附属户提现，付款方账号为商户附属户:" + subaccount.getAttachedAccount()
				+ " PayerCust_Id:"+subaccount.getCustId()+" payerCust_Name:"+subaccount.getCustName()+" PayeeCust_Id:" + obj.getString("Userid"));

		BigDecimal tranamount = new BigDecimal(obj.getString("tranAmt"));
		if (subaccount.getAmount().subtract(tranamount).floatValue() >= 0) {
			log.info("B2B提现附属户余额变动处理：付款方账户系统内当前余额为:" + subaccount.getAmount() + ";提现金额为:" + tranamount);
			String code = CommonUtil.getGenerateCode(new Date());
			Subaccountseq subaccountseq = new Subaccountseq();
			subaccountseq.setPreamount(subaccount.getAmount());
			// 用户总余额
			subaccountseq.setAmount(subaccount.getAmount().subtract(tranamount));
			subaccountseq.setCashAmount(subaccount.getCashAmount().subtract(tranamount));
			// 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销09内部交易
			subaccountseq.setChangeType("03");
			// 账户变动方向 返回0
			subaccountseq.setSeqflag("1");
			subaccountseq.setCreateTime(DateUtil.toTimestamp(new Date()));
			subaccountseq.setSn(CommonUtil.getGenerateCode(new Date()));
			subaccountseq.setWorkdate(new SimpleDateFormat("yyyyMMdd").format(new Date()));
			subaccountseq.setNote("B2B金额提现");
			subaccountseq.setCustName(subaccount.getCustName());
			subaccountseq.setCustId(subaccount.getCustId());
			subaccountseq.setSubaccountId(subaccount.getId().toString());
			subaccountseq.setSubaccountType(subaccount.getSubaccountType());
			subaccountseq.setRefsn(code);
			subaccountseqDAO.save(subaccountseq);
			log.info("B2B提现附属户余额变动处理：保存Subaccountseq成功，REFSN=" + code);
			subaccount.setAmount(subaccount.getAmount().subtract(tranamount));
		    subaccount.setCashAmount(subaccount.getCashAmount().subtract(tranamount));
			subaccountDAO.save(subaccount);
			log.info("B2B提现附属户余额变动处理：保存Subaccount成功，ID=" + subaccount.getId() + " CUSTID=" + subaccount.getCustId()
					+ " AMOUNT=" + subaccount.getAmount());
			Map<String, Object> a = new HashMap<String, Object>();
			a.put("CHANNEL_ID", obj.get("ChannelId"));
			Map<String, Object> b = paybillDAO.findTranTypeData(a);
			Map<String, Object> caleFeeParams = new HashMap<String, Object>();
			caleFeeParams.put("feeTempletNo", b.get("FEE_TEMPLETNO").toString());
			caleFeeParams.put("tranType", b.get("TRAN_TYPE").toString());
			caleFeeParams.put("tranAmount", tranamount);
			String channelFee = paybillDAO.calcFee(caleFeeParams);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

			Paybill paybill = new Paybill();
			paybill.setTranDate(sdf.format(new Date()));
			paybill.setSn(subaccountseq.getRefsn());
			paybill.setSrccustId(obj.get("PayerCust_Id").toString());
			paybill.setPayerIfkftcust("Y");
			paybill.setPayercustId(obj.get("PayerCust_Id").toString());// 付款方Id
			paybill.setPayercustName(obj.get("PayerCust_Name").toString());// 付款方户名
			paybill.setTranType(b.get("TRAN_TYPE").toString());
			paybill.setFeetype(b.get("FEE_TEMPLETNO").toString());

			paybill.setChannelPayflag(b.get("CHANNEL_PAYFLAG").toString());
			paybill.setChannelAccount(obj.get("PayerCust_Id").toString());// 费用支付方
			paybill.setFeeState("00");
			paybill.setChannelFee(new BigDecimal(channelFee));
			paybill.setChannelCheckType("Y");
			paybill.setChannelCheckState("00");
			paybill.setPayeecustId(obj.getString("PayeeCust_Id"));// 收款方ID
			paybill.setPayeecustName(obj.getString("PayeeCust_Name"));// 收款方户名
			paybill.setCreateTime(new Date());
			paybill.setRechargedtlStatus("E");
			paybill.setRechargeState("3");//资金归集状态
			paybill.setState("02");//交易状态 02支付成功
			paybill.setPayState("03");//支付状态 03支付完成
			paybill.setTranamount(tranamount);
			paybill.setCheckState("00");//对账状态  00未对账
			paybill.setPayerbankType("101000");
			paybill.setPayerbankCode("1301");
			paybill.setPayerbankname("中信银行杭州延安支行");
			paybill.setPayerbankcardno(obj.getString("PayerBankCardNo"));
			paybill.setPayerbankcardname(obj.getString("PayerBankCardName"));
			paybill.setPayeebankname(obj.getString("PayeeBankName"));
			paybill.setPayeebankcardname(obj.getString("PayeeBankCardName"));
			paybill.setPayeebankcardno(obj.getString("PayeeBankCardNo"));
			paybill.setTranSubtype("B2B提现");
			paybill.setLineType(obj.getString("Line_type"));
			paybillDAO.save(paybill);
			log.info("B2B提现附属户余额变动处理：保存PayBill成功，SN=" + paybill.getSn());

		} else {
			log.info("B2B提现附属户余额变动处理:余额不足不做处理！当前余额为:" + subaccount.getAmount() + ";提现金额为:" + tranamount);
			return "-1";
		}
		log.info("B2B提现附属户余额变动已处理成功===========================");
		return "1";
	}

	
	@Override
	public List<Subaccount> findBy(String[] propertyName, Object[] value) {
		return subaccountDAO.findBy(Subaccount.class, propertyName, value);
	}

	@Override
	public List<Subaccount> findBy(String propertyName, Object value) {
		return subaccountDAO.findBy(Subaccount.class, propertyName, value);
	}
	
	@Override
	public String queryAmout(String username,String type){
		JSONObject data = new JSONObject();
		JSONObject para = new JSONObject();
		para.put("username", username);
		para.put("type", type);
		String amout = null;
		try {
			JSONObject transferJson = TransferJson.setSimpleReqTransferJson("user", "getAmount", "MGT", para);
			String url = CommonUtil.loadProp("/config/config.properties") .getProperty("qpwa.wireless.url");
			transferJson.put(RequestKey.para.name(), para);
			String	result = HttpUtil.getInstall().sendJSON(url, transferJson.toString());
			System.out.println("返回值为："+result);
			data = JSONObject.fromObject(result);
			if("200".equals(data.getString("code"))){
				amout = data.getJSONObject("data").getString(type);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return amout;
	}


	@Override
	public Page queryBalanceSubaccounts(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby){
		return subaccountDAO.queryBalanceSubaccounts(paramMap, orderby);
	}
	
	/**
     * 查询交易明细
     * @param paramMap
     * @param orderby
     * @return
     */
    public Page queryBalanceSubaccountDetails(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby){
    	return subaccountDAO.queryBalanceSubaccountDetails(paramMap, orderby);
    }


	@Override
	public Map<String, Object> reportAccountInOut(Map<String, Object> paramMap) {
		return subaccountDAO.reportAccountInOut(paramMap);
	}


	@Override
	public Map<String, Object> reportAmtSpread(Map<String, Object> paramMap) {
		return subaccountDAO.reportAmtSpread(paramMap);
	}
}
