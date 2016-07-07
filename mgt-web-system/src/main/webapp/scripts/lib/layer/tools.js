//遮罩层
var index = layer.load(1, {
  shade: [0.8,'#393D49']
});

function layer_show(){
	layer.open(index);
}

function layer_close(){
	layer.close(index);
}