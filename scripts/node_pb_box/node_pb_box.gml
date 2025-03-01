function Node_PB_Box(_x, _y, _group = noone) : Node_Processor(_x, _y, _group) constructor {
	name = "PBBox";
	setDimension(96, 48);
	
	newInput(0, nodeValue_Pbbox("Base PBBOX", self, new __pbBox()));
	
	newInput(1, nodeValue_Pbbox("PBBOX", self, new __pbBox()));
	
	newInput(2, nodeValue_Float("PBBOX Left",   self, 0));
	newInput(3, nodeValue_Float("PBBOX Top",    self, 0));
	newInput(4, nodeValue_Float("PBBOX Right",  self, 0));
	newInput(5, nodeValue_Float("PBBOX Bottom", self, 0));
	newInput(6, nodeValue_Float("PBBOX Width",  self, 0));
	newInput(7, nodeValue_Float("PBBOX Height", self, 0));
	
	newOutput(0, nodeValue_Output("PBBOX", self, VALUE_TYPE.pbBox, noone));
	
	input_display_list = [
		["Layout",         false], 0, 1, 
		["Layout Override", true], 2, 3, 4, 5, 6, 7, 
	]
	
	static drawOverlay = function(hover, active, _x, _y, _s, _mx, _my, _snx, _sny) {
		var _pbbox = getSingleValue(1);
		if(is(_pbbox, __pbBox)) _pbbox.drawOverlay(hover, active, _x, _y, _s, _mx, _my, _snx, _sny, self);
	}
	
	static processData = function(_outSurf, _data, _output_index, _array_index) {
		var _dim   = group.dimension;
		var _pbase = _data[0];
		var _pbbox = _data[1];
		
		if(inputs[0].value_from == noone) _pbase.base_bbox = [ 0, 0, _dim[0], _dim[1] ];
		if(inputs[2].value_from != noone || inputs[2].is_anim) _pbbox.anchor_l = _data[2];
		if(inputs[3].value_from != noone || inputs[3].is_anim) _pbbox.anchor_t = _data[3];
		if(inputs[4].value_from != noone || inputs[4].is_anim) _pbbox.anchor_r = _data[4];
		if(inputs[5].value_from != noone || inputs[5].is_anim) _pbbox.anchor_b = _data[5];
		if(inputs[6].value_from != noone || inputs[6].is_anim) _pbbox.anchor_w = _data[6];
		if(inputs[7].value_from != noone || inputs[7].is_anim) _pbbox.anchor_h = _data[7];
		
		_pbbox.base_bbox = is(_pbase, __pbBox)? _pbase.getBBOX() : [ 0, 0, _dim[0], _dim[1] ];
		return _pbbox;
	}
	
	static onDrawNode = function(xx, yy, _mx, _my, _s, _hover, _focus) {
		var bbox = drawGetBbox(xx, yy, _s);
		draw_sprite_fit(s_node_pb_box, 0, bbox.xc, bbox.yc, bbox.w, bbox.h);
	}
	
}