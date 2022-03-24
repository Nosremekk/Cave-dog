/// @description Antes do passinho

//Checando se eu acabei de cair no chão

var temp = place_meeting(x,y+1,obj_plat);

//Caso isso acontecer quer dizer que eu acabei de "pousar"

if (temp and !chao)
{
	xscale =  1.6;
	yscale = .5;
	
	//poeira
	
	for (var i = 0; i < irandom_range(4,10);i++;)
	{
		var xx = random_range(x-sprite_width,x+sprite_width);
		
		instance_create_depth(xx,y,depth-1000,obj_vel);
	}

}
