package cn.qpwa.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

/**
 * 
 * Message 消息的实体类.
 */
@Entity
@Table(name = "MSG_CONTENT")
public class MessageContent implements java.io.Serializable {

	private static final long serialVersionUID = -8679864357372532218L;

	/** 主键 */
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYSMSG_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	private BigDecimal pkNo;
	// 标题
	@Column(name = "TITLE", length = 256)
	private String  title;
	// 内容
	@Column(name = "CONTENT", length = 3000)
	private String content;
	// 来源（WEB、WAP、APP）
	@Column(name = "SOURCE", length = 32)
	private String    source;
	// 来源类型（SYSTEM系统生成；MANUAL人工生成）
	@Column(name = "SOURCE_TYPE", length = 32)
	private String sourceType;
	// 所属系统（B2B/POS/MGT等）
	@Column(name = "SYSTEM", length = 32)
	private String system;
	// 创建时间
	@Column(name = "CREATE_DATE", length = 32)
	private Date createDate;
	// 创建人
	@Column(name = "CREATOR", length = 32)
	private String creator;
	// 阅读时间
	@Column(name = "READ_TIME", length = 32)
	private Date readTime;
	// 发送人
	@Column(name = "SENDER", length = 32)
	private String sender;
	// 接收人
	@Column(name = "RECEIVER", length = 32)
	private String receiver;
	// 发送类型（短信、360、B2B-APP、B2C-APP）
	@Column(name = "SEND_TYPE", length = 32)
	private String sendType;
	// 发送时间
	@Column(name = "SEND_TIME", length = 32)
	private Date sendTime;
	// 接收人
	@Column(name = "OWNER", length = 32)
	private String owner;
	//业务类型
	@Column(name = "BUSI_TYPE", length = 32)
	private String busiType;
	//业务ID
	@Column(name = "BUSI_ID", length = 32)
	private String busiId; 
	//是否已读
	@Column(name = "IS_READ", length = 4)
	private String isRead;
	//是否已删除
	@Column(name = "IS_DELETE", length = 4)
	private String isDelete; 

	public String getOwner() {
		return owner;
	}

	public void setOwner(String owner) {
		this.owner = owner;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getReceiver() {
		return receiver;
	}

	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}

	public String getSendType() {
		return sendType;
	}

	public void setSendType(String sendType) {
		this.sendType = sendType;
	}

	public Date getSendTime() {
		return sendTime;
	}

	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}

	public BigDecimal getPkNo() {
		return pkNo;
	}

	public void setPkNo(BigDecimal pkNo) {
		this.pkNo = pkNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getSourceType() {
		return sourceType;
	}

	public void setSourceType(String sourceType) {
		this.sourceType = sourceType;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public Date getReadTime() {
		return readTime;
	}

	public void setReadTime(Date readTime) {
		this.readTime = readTime;
	}

	public String getSystem() {
		return system;
	}

	public void setSystem(String system) {
		this.system = system;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	public String getBusiType() {
		return busiType;
	}

	public void setBusiType(String busiType) {
		this.busiType = busiType;
	}

	public String getBusiId() {
		return busiId;
	}

	public void setBusiId(String busiId) {
		this.busiId = busiId;
	}

	public String getIsRead() {
		return isRead;
	}

	public void setIsRead(String isRead) {
		this.isRead = isRead;
	}

	public String getIsDelete() {
		return isDelete;
	}

	public void setIsDelete(String isDelete) {
		this.isDelete = isDelete;
	}
	
}