package cn.qpwa.mgt;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Created by lsy on 16/7/12.
 */
public class SystemProvider {

    private static final Log LOG = LogFactory.getLog(SystemProvider.class);

    public static void main(String[] args) throws Exception {
        LOG.info("=========mgt-system begin to start=========");
        com.alibaba.dubbo.container.Main.main(args);
    }
}
