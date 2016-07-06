package cn.qpwa.common.utils;

import cn.qpwa.common.utils.json.JsonDateValueProcessor;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.log4j.Logger;

import java.sql.Timestamp;
import java.util.Date;


public class Msg
{
  protected Logger log = Logger.getLogger(getClass());

  private boolean success = false;
  private String msg;
  private String code;
  private Object data;
  private String t;
  private String userId;
  private String sign;

  public Msg()
  {
  }

  public Msg(String msg)
  {
    this(true, msg);
  }

  public Msg(boolean success, String msg)
  {
    this(success, msg, null);
  }

  public Msg(String msg, Object data)
  {
    this(true, msg, null);
  }

  public Msg(boolean success, String msg, Object data)
  {
    this.msg = msg;
    this.success = success;
    if ((null == data) || ("null".equals(data)))
      this.data = "";
    else
      this.data = data;
  }

  public Object getData()
  {
    return this.data;
  }

  public Msg setData(Object data)
  {
    this.data = data;
    return this;
  }

  public String getMsg()
  {
    return this.msg;
  }

  public Msg setMsg(String msg)
  {
    this.msg = msg;
    return this;
  }

  public boolean isSuccess()
  {
    return this.success;
  }

  public String getCode()
  {
    return this.code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public Msg setSuccess(boolean success)
  {
    this.success = success;
    return this;
  }

  public String getT() {
    return this.t;
  }

  public void setT(String t) {
    this.t = t;
  }

  public String getUserId() {
    return this.userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getSign() {
    return this.sign;
  }

  public void setSign(String sign) {
    this.sign = sign;
  }

  public JsonConfig getJsonConfig(String dateFormat) {
    JsonConfig config = new JsonConfig();
    config.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(dateFormat));
    config.registerJsonValueProcessor(Timestamp.class, new JsonDateValueProcessor(dateFormat));
    return config;
  }

  public JSONObject toJSONObject()
  {
    String format = "yyyy-MM-dd HH:mm:ss";
    JSONObject jsonObject = new JSONObject();
    String newMsg = this.msg == null ? "" : this.msg;
    setMsg(newMsg);
    jsonObject = JSONObject.fromObject(this, getJsonConfig(format));
    return jsonObject;
  }

  public JSONObject toJSONObject(String dataFormat)
  {
    JSONObject jsonObject = new JSONObject();
    String newMsg = this.msg == null ? "" : this.msg;
    setMsg(newMsg);
    jsonObject = JSONObject.fromObject(this, getJsonConfig(dataFormat));
    return jsonObject;
  }

}