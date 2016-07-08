package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * 系统模块表
 * Created by Administrator on 2016/7/8 0008.
 */
@Entity
@Table(name = "MGT_MODULE")
public class MgtModule implements Serializable {

    private static final long serialVersionUID = 2L;

    //主键
    private Integer pkNo;

    //模块名称
    private String name;

    //模块域名
    private String domain;

    //编码
    private String code;

    //创建日期
    private Date createDate;

    @Id
    @SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_PB_PK_NO")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
    @Column(name = "PK_NO", unique = true, nullable = false)
    public Integer getPkNo() {
        return pkNo;
    }

    public void setPkNo(Integer pkNo) {
        this.pkNo = pkNo;
    }

    @Column(name = "NAME", length = 50)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "DOMAIN", length = 200)
    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    @Column(name = "DOMAIN", length = 20, insertable = false, updatable = false)
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Column(name = "CREATE_DATE" , length = 7)
    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}
