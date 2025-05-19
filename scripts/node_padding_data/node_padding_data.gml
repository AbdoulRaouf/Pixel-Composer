function Node_Padding_Data(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name  = "Padding Data";
	color = COLORS.node_blend_number;
	setDimension(96, 48);
	
	////- Fractional
	
	newInput(4, nodeValue_Bool(    "Use Fractional",    self, false ));
	newInput(5, nodeValue_Surface( "Reference Surface", self));
	
	////- Padding
	
	newInput(0, nodeValue_Float( "Left",   self, 0 ));
	newInput(1, nodeValue_Float( "Right",  self, 0 ));
	newInput(2, nodeValue_Float( "Top",    self, 0 ));
	newInput(3, nodeValue_Float( "Bottom", self, 0 ));
	
	// inputs 6
	
	newOutput(0, nodeValue_Output("Padding", self, VALUE_TYPE.float, [ 0, 0, 0, 0 ])).setDisplay(VALUE_DISPLAY.padding);
	
	input_display_list = [ 
		["Fractional", false, 4], 5, 
		["Padding",    false], 0, 1, 2, 3, 
	]
	
	static processData = function(_output, _data, _array_index = 0) {
		var _l = _data[0];
		var _r = _data[1];
		var _t = _data[2];
		var _b = _data[3];
		
		var _ref = _data[4];
		var _sur = _data[5];
		
		if(_ref) {
			var _sw = surface_get_width_safe(_sur);
			var _sh = surface_get_height_safe(_sur);
			
			_l *= _sw;
			_r *= _sw;
			
			_t *= _sh;
			_b *= _sh;
		}
		
		return [ _r, _t, _l, _b ];
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) {
		var bbox = drawGetBbox(xx, yy, _s);
		draw_sprite_bbox_uniform(s_node_padding_data, 0, bbox);
	}
}