function Node_3D_Scene(_x, _y, _group = noone) : Node_3D(_x, _y, _group) constructor {
	name = "3D Scene";
	
	newOutput(0, nodeValue_Output("Scene", VALUE_TYPE.d3Scene, noone));
	
	object_lists = [];
	
	function createNewInput(index = array_length(inputs)) {
		var inAmo = array_length(inputs);
		
		newInput(index, nodeValue_D3Mesh("Object", noone))
			.setVisible(true, true);
		
		return inputs[index];
	} setDynamicInput(1, true, VALUE_TYPE.d3Mesh);
	
	static processData = function(_output, _data, _array_index = 0, _frame = CURRENT_FRAME) {
		var _scene = new __3dGroup();
		
		for( var i = input_fix_len, n = array_length(inputs); i < n; i += data_length ) {
			var _obj = _data[i];
			if(is(_obj, __3dInstance)) 
				_scene.addObject(_obj);
		}
		
		return _scene;
	}
}