package cn.qpwa.common.easemob.api.impl;

import cn.qpwa.common.easemob.api.EasemobRestAPI;
import cn.qpwa.common.easemob.api.SendMessageAPI;
import cn.qpwa.common.easemob.comm.constant.HTTPMethod;
import cn.qpwa.common.easemob.comm.helper.HeaderHelper;
import cn.qpwa.common.easemob.comm.wrapper.BodyWrapper;
import cn.qpwa.common.easemob.comm.wrapper.HeaderWrapper;

public class EasemobSendMessage extends EasemobRestAPI implements SendMessageAPI {
    private static final String ROOT_URI = "/messages";

    @Override
    public String getResourceRootURI() {
        return ROOT_URI;
    }

    public Object sendMessage(Object payload) {
        String  url = getContext().getSeriveURL() + getResourceRootURI();
        HeaderWrapper header = HeaderHelper.getDefaultHeaderWithToken();
        BodyWrapper body = (BodyWrapper) payload;

        return getInvoker().sendRequest(HTTPMethod.METHOD_POST, url, header, body, null);
    }
}
