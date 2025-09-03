function Node_pSystem_3D_Turbulence(_x, _y, _group = noone) : Node_3D(_x, _y, _group) constructor {
	name  = "Turbulence";
	icon  = THEME.vfx;
	color = COLORS.node_blend_vfx;
	node_draw_icon = s_node_psystem_turb;
	
	setDimension(96, 0);
	update_on_frame = true;
	
	newInput( 2, nodeValueSeed());
	
	////- =Particles
	newInput( 0, nodeValue_Particle( "Particles" ));
	newInput( 1, nodeValue_Buffer(   "Mask"      ));
	
	////- =Turbulence
	newInput( 3, nodeValue_Range(    "Strength",  [1,1], true )).setCurvable( 4, CURVE_DEF_11, "Over Lifespan"); 
	// 5
	
	newOutput(0, nodeValue_Output("Particles", VALUE_TYPE.particle, noone ));
	
	input_display_list = [ 2, 
		[ "Particles",  false ], 0, 1, 
		[ "Turbulence", false ], 3, 4, 
	];
	
	////- Nodes
	
	curve_strn = undefined;
	
	static getDimension = function() { return is(inline_context, Node_pSystem_Inline)? inline_context.dimension : DEF_SURF; }
	
	static processData = function(_output, _data, _array_index = 0, _frame = CURRENT_FRAME) {
		var _parts = _data[ 0];
		var _masks = _data[ 1], use_mask = _masks != noone;
		
		if(!is(_parts, pSystem_Particles)) return _parts;
		if(use_mask) buffer_to_start(_masks);
		outputs[0].setValue(_parts);
		
		var _seed = _data[ 2];
		var _strn = _data[ 3], _strn_curved = inputs[3].attributes.curved && curve_strn != undefined;
		
		var _partAmo  = _parts.maxCursor;
		var _partBuff = _parts.buffer;
		var _off = 0;
			
		repeat(_partAmo) {
			var _start = _off;
			buffer_seek(_partBuff, buffer_seek_start, _start);
			_off += global.pSystem_data_length;
			
			var _mask   = use_mask? buffer_read(_masks, buffer_f32) : 1; if(_mask <= 0) continue;
			var _act    = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.active, buffer_bool );
			var _spwnId = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.sindex, buffer_u32  );
			if(!_act) continue;
			
			var _px     = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.posx,   buffer_f64  );
			var _py     = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.posy,   buffer_f64  );
			
			var _lif    = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.life,   buffer_f64  );
			var _lifMax = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.mlife,  buffer_f64  );
			
			var _vx     = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.velx,   buffer_f64  );
			var _vy     = buffer_read_at( _partBuff, _start + PSYSTEM_OFF.vely,   buffer_f64  );
			
			var rat = _lif / (_lifMax - 1);
			random_set_seed(_seed + _spwnId);
			
			var _strn_mod = _strn_curved? curve_strn.get(rat) : 1;
			var _strn_cur = random_range(_strn[0], _strn[1]) * _strn_mod * _mask;
			
			var _dirr = 1;
			var _gx = lengthdir_x(1, _dirr);
			var _gy = lengthdir_y(1, _dirr);
			
			_vx += _gx * _strn_cur;
			_vy += _gy * _strn_cur;
			
			buffer_write_at(_partBuff, _start + PSYSTEM_OFF.velx, buffer_f64, _vx );
			buffer_write_at(_partBuff, _start + PSYSTEM_OFF.vely, buffer_f64, _vy );
		}
		
		return _parts;
	}
	
	static reset = function() {
		var _strn_curve = getInputData( 4);
		
		curve_strn = new curveMap(_strn_curve);
	}
}