package cn.qpwa.common.easemob;

public class Main {

	public static void main(String[] args) throws Exception{
		/*EasemobRestAPIFactory factory = ClientContext.getInstance().init(ClientContext.INIT_FROM_PROPERTIES).getAPIFactory();
		
		IMUserAPI user = (IMUserAPI)factory.newInstance(EasemobRestAPIFactory.USER_CLASS);
		ChatMessageAPI chat = (ChatMessageAPI)factory.newInstance(EasemobRestAPIFactory.MESSAGE_CLASS);
		FileAPI file = (FileAPI)factory.newInstance(EasemobRestAPIFactory.FILE_CLASS);
		SendMessageAPI message = (SendMessageAPI)factory.newInstance(EasemobRestAPIFactory.SEND_MESSAGE_CLASS);
		ChatGroupAPI chatgroup = (ChatGroupAPI)factory.newInstance(EasemobRestAPIFactory.CHATGROUP_CLASS);
		ChatRoomAPI chatroom = (ChatRoomAPI)factory.newInstance(EasemobRestAPIFactory.CHATROOM_CLASS);*/
		
		//String[] targets = new String[]{"User002"};
		//TextMessageBody messageBody = new TextMessageBody("users",targets,"User001",null,"hello,User002,My name is User001");
		//ResponseWrapper responseWrapper = (ResponseWrapper)message.sendMessage(messageBody);
		
		// Create a IM user
		//BodyWrapper userBody = new IMUserBody("User101", "123456", "HelloWorld");
		//user.createNewIMUserSingle(userBody);
		
		//Get a IM user
		//ResponseWrapper userResponseWrapper = (ResponseWrapper)user.getIMUsersByUserName("honghui");
		//System.out.println(userResponseWrapper.getResponseBody().toString()+"=====");
		
		int offlineMsgCount = EaseMobAPI.getOfflineMsgCount("honghui");
		System.out.println("honghui 离线消息数="+offlineMsgCount);
		
		// Create some IM users
		/*List<IMUserBody> users = new ArrayList<IMUserBody>();
		users.add(new IMUserBody("User001", "123456", null));
		users.add(new IMUserBody("User002", "123456", null));
		users.add(new IMUserBody("User003", "123456", null));
		BodyWrapper usersBody = new IMUsersBody(users);
		user.createNewIMUserBatch(usersBody);*/
		
		// Get a fake user
		//user.getIMUsersByUserName("FakeUser001");
				
		// Get 12 users
		//user.getIMUsersBatch(null, null);
		
		//禁用用户
		//user.deactivateIMUser("User001");
		//解禁用户
		//user.activateIMUser("User001");
		
		//文件上传下载
		/*FileAPI file = (FileAPI)factory.newInstance(EasemobRestAPIFactory.FILE_CLASS);
		ResponseWrapper fileResponse = (ResponseWrapper) file.uploadFile(new File("d:/logo.jpg"));
        String uuid = ((ObjectNode) fileResponse.getResponseBody()).get("entities").get(0).get("uuid").asText();
        String shareSecret = ((ObjectNode) fileResponse.getResponseBody()).get("entities").get(0).get("share-secret").asText();
        InputStream in = (InputStream) ((ResponseWrapper) file.downloadFile(uuid, shareSecret, false)).getResponseBody();
        FileOutputStream fos = new FileOutputStream("d:/logo1.jpg");
        byte[] buffer = new byte[1024];
        int len1 = 0;
        while ((len1 = in.read(buffer)) != -1) {
            fos.write(buffer, 0, len1);
        }
        fos.close();*/
	}
}
