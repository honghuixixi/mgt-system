package cn.qpwa.common.easemob.api.impl;

import cn.qpwa.common.easemob.api.ChatMessageAPI;
import cn.qpwa.common.easemob.api.EasemobRestAPI;
import cn.qpwa.common.easemob.comm.constant.HTTPMethod;
import cn.qpwa.common.easemob.comm.helper.HeaderHelper;
import cn.qpwa.common.easemob.comm.wrapper.HeaderWrapper;
import cn.qpwa.common.easemob.comm.wrapper.QueryWrapper;

public class EasemobChatMessage extends EasemobRestAPI implements ChatMessageAPI {

    private static final String ROOT_URI = "chatmessages";

    public Object exportChatMessages(Long limit, String cursor, String query) {
        String url = getContext().getSeriveURL() + getResourceRootURI();
        HeaderWrapper header = HeaderHelper.getDefaultHeaderWithToken();
        QueryWrapper queryWrapper = QueryWrapper.newInstance().addLimit(limit).addCursor(cursor).addQueryLang(query);

        return getInvoker().sendRequest(HTTPMethod.METHOD_DELETE, url, header, null, queryWrapper);
    }

    @Override
    public String getResourceRootURI() {
        return ROOT_URI;
    }
}
