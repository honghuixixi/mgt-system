package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 消息模板
 * @author wlw-62
 * 2016年5月18日
 */
@Entity
@Table(name = "MSG_TEMPLET")
public class MsgTemplet implements Serializable {
	
	private static final long serialVersionUID = 7631038455924270122L;

	/* 消息模板主键 */
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYSMSG_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	private int pkNo;
	
	/* 业务代码 */
	@Column(name = "BUSI_CODE")
	private String busiCode;
	
	/* 业务名称 */
	@Column(name = "BUSI_NAME")
	private String busiName ;
	
	/* 消息模板名称 */
	@Column(name = "TEMP_NAME")
	private String tempName;
	
	/* 消息体模板 */
	@Column(name = "CONTENT")
	private String content;
	
	/* 消息模板状态 */
	@Column(name = "TEMP_FLAG")
	private String tempFlag;

	public int getPkNo() {
		return pkNo;
	}

	public void setPkNo(int pkNo) {
		this.pkNo = pkNo;
	}

	public String getBusiCode() {
		return busiCode;
	}

	public void setBusiCode(String busiCode) {
		this.busiCode = busiCode;
	}

	public String getBusiName() {
		return busiName;
	}

	public void setBusiName(String busiName) {
		this.busiName = busiName;
	}

	public String getTempName() {
		return tempName;
	}

	public void setTempName(String tempName) {
		this.tempName = tempName;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getTempFlag() {
		return tempFlag;
	}

	public void setTempFlag(String tempFlag) {
		this.tempFlag = tempFlag;
	}

	@Override
	public String toString() {
		return "MsgTemplet [pkNo=" + pkNo + ", busiCode=" + busiCode + ", busiName=" + busiName + ", tempName="
				+ tempName + ", content=" + content + ", tempFlag=" + tempFlag + "]";
	}

}
