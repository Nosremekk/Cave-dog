/// @description Insert description here
// You can write your code in this editor

//Rodando
image_angle += rot;

switch (estado)
{
	case "avanca":
	
	//Descobrindo a direção e o limite
	var limite_x = lengthdir_x(limite,dir);
	var limite_y = lengthdir_y(limite,dir);
	
	//Movendo
	x += lengthdir_x(vel,dir);
	y += lengthdir_y(vel,dir);
	
	//Trocando de estado(x)
	
	if (limite_x > 0)
	{
		if (x >= xstart + limite_x) estado = "recua";	
	}
	else if (limite_x < 0)
	{
		if (x < xstart + limite_x) estado = "recua";
	}
	
	//Trocando de estado(y)
	
	if (limite_y> 0)
	{
		if (y >= ystart + limite_y) estado = "recua";	
	}
	else if (limite_y < 0)
	{
		if (y < ystart + limite_y) estado = "recua";
	}
	
	
	break;
	
	case "recua":
	
	x -= lengthdir_x(vel,dir);
	y -= lengthdir_y(vel,dir);
	
	if (x == xstart) and (y == ystart) estado = "avanca";
	
	break;
	
	case "parado":
	
	
	break;
	
	default:
	
	show_message("você foi burro e digitou errado");
	
	break;
	
}

if (place_meeting(x,y,obj_morte)) instance_destroy();

