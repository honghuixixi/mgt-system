[#macro urlPrefix url]
    [#if url == "B2BWEB"]
    	<input type="text" id="macroUrl" value="http://www.11wlw.cn/" /> 
    	<input type="text" id="macroUrl0" value="http://117.121.48.155:8080/" /> 
    	<input type="text" id="macroUrl1" value="http://117.121.48.156:8080/" /> 
    	<input type="text" id="ImgSize" value="1000*450像素" /> 
    [#elseif url == "B2BWAP"]
    	<input type="text" id="macroUrl" value="http://m.11wlw.cn/" />
    	<input type="text" id="macroUrl0" value="http://m.11wlw.cn/" />
    	<input type="text" id="macroUrl1" value="http://m.11wlw.cn/" />
    	<input type="text" id="ImgSize" value="600*200像素" />  
    [#elseif url == "B2BAPP"]
    	<input type="text" id="macroUrl" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="macroUrl0" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="macroUrl1" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="ImgSize" value="600*200像素" />  
    [#elseif url == "B2CWAP"]
    	<input type="text" id="macroUrl" value="http://www.B2CWAP.cn/" />
    	<input type="text" id="macroUrl0" value="http://www.B2CWAP.cn/" />
    	<input type="text" id="macroUrl1" value="http://www.B2CWAP.cn/" />
    	<input type="text" id="ImgSize" value="600*200像素" />  
    [#elseif url == "B2CAPP"]
    	<input type="text" id="macroUrl" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="macroUrl0" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="macroUrl1" value="http://www.B2BAPP.cn/" />
    	<input type="text" id="ImgSize" value="600*200像素" />  
    [/#if]
[/#macro]
