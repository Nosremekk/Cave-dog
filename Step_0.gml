#region Variaveis e controles
// ---------------- Controles

chao = (place_meeting(x,y+1,obj_plat));

parede_dir = place_meeting(x+1,y,obj_plat);
parede_esq = place_meeting(x-1,y,obj_plat);



var left,right,up,down,jump,jump_s,avanco_h,dash;


left = keyboard_check(ord("A")) +  gamepad_button_check(4,gp_padl) 
right = keyboard_check(ord("D")) + gamepad_button_check(4,gp_padr)
up = keyboard_check(ord("W"))  + gamepad_button_check(4,gp_padu)
down = keyboard_check(ord("S")) + gamepad_button_check(4,gp_padd)
jump = keyboard_check_pressed(ord("K")) +  gamepad_button_check_pressed(4,gp_face1)
jump_s = keyboard_check_released(ord("K"))  +  gamepad_button_check_released(4,gp_face1)
dash = keyboard_check_pressed(ord("L")) + gamepad_button_check_pressed(4,gp_face3)

avanco_h = (right-left) * max_velh;
//Valor da aceleração
if (chao) acel = acel_chao;
else acel = acel_ar;

//Timer pulo

if (chao)
{
	carga = 1;
	timer_pulo = limite_pulo;	
}
else
{
	if (timer_pulo > 0) timer_pulo--;	
}

//Timer parede

if (parede_dir or parede_esq)
{
	if (parede_dir) ultima_parede = 0;
	else ultima_parede = 1;
	
	timer_parede = limite_parede;	
}
else 
{
	if (timer_parede > 0) timer_parede--;	
}

//-- Aplicando a gravidade




#endregion

#region State machine

switch(estado) 

{

case state.parado:

	velh = 0;
	velv = 0;

	if (!chao)
{
	//Não estou no chão
	velv += grav;
}

	//--Mudando de estado
	
	//Pulando
	if (jump) and (chao) 
	{
		velv = -max_velv;
		xscale = .5;
		yscale = 1.5;
		
		for (var i = 0; i < irandom_range(4,10);i++;)
		{
		var xx = random_range(x-sprite_width,x+sprite_width);
		
		instance_create_layer(xx,y,"particulas",obj_vel);
		}
	}
	
	//Buffer do pulo
	
	if (jump) timer_queda = limite_buffer;
	
	if (timer_queda > 0) buffer_pulo = true;
	else buffer_pulo = false;
	
	if (buffer_pulo)
	{
		if (chao) or (timer_pulo)
		{
			velv = -max_velv;	
			
			xscale = .5;
			yscale = 1.5;
			
			timer_pulo = 0;
			timer_queda = 0;
		}
		timer_queda--;
	}
	
	
if (dash) and (carga > 0) 
{
	
	dir = point_direction(0,0,right-left,down-up)
	
	
	estado = state.dash;
	
}
	
	//Saindo do estado
	if (abs(velh) > 0 or abs(velv) > 0 or right or left or jump or !chao) estado = state.movendo;
	
break;

case state.movendo:

//abaixando

if (chao) and (down)
{
	xscale = 1.5;
	yscale = .5;	
}

//Movendo

//Aplicando a movimentação
velh = lerp(velh,avanco_h, acel)

	if(abs(velh) > max_velh - .5) and (chao)
	{
		var chance = random(100)
	
		if (chance > 95)
		{
			
		for (var i = 0; i < irandom_range(4,10);i++;)
		{
				var xx = random_range(x-sprite_width/2,x+sprite_width/2);
		
				instance_create_layer(xx,y,"particulas",obj_vel);
		}	
		
		}
	}

	//Gravidade e parede
	if (!chao) and (parede_dir or parede_esq or timer_parede)
	{
		//Não estou no chão mas estou na parede
		if (velv > 0)//Estou caindo e na parede
		{
			velv = lerp(velv,deslize,acel)	
			
			var chance = random(100)
	
		if (chance > 95)
		{
			
		for (var i = 0; i < irandom_range(4,10);i++;)
		{
				var onde = parede_dir-parede_esq;
				
				var xx = x+onde*sprite_width/2;
				var yy = y+random_range(-sprite_height/4,0);
		
				instance_create_layer(xx,yy,"particulas",obj_vel);
		}	
		
		}
		}
		else velv += grav;//estou subindo
		
		//Pulando na parede 
		if (!ultima_parede and jump)
		{
			velv = -max_velv;
			velh = -max_velh;
			xscale = .5;
			yscale = 1.5;
			
				
			var xx = x+sprite_width/2;
			var yy = y+random_range(-sprite_height/4,0);
		
			instance_create_layer(xx,yy,"particulas",obj_vel);
			
		}
		else if (ultima_parede and jump)
		{
			velv = -max_velv;
			velh = max_velh;
			xscale = .5;
			yscale = 1.5;	
				
			var xx = x-sprite_width/2;
			var yy = y+random_range(-sprite_height/4,0);
		
			instance_create_layer(xx,yy,"particulas",obj_vel);
			
		}
		
	}
	
	else if (!chao) velv += grav;
	
	
	//Estou no chão
	
	if (jump) and (chao or timer_pulo) 
	{
		velv = -max_velv;
		xscale = .5;
		yscale = 1.5;
		
		timer_pulo = 0;
		timer_queda = 0;
		
		for (var i = 0; i < irandom_range(4,10);i++;)
		{
		var xx = random_range(x-sprite_width,x+sprite_width);
		
		instance_create_layer(xx,y,"particulas",obj_vel);
		}
		
	}
	timer_queda--;


//Controlando o pulo
if (jump_s and velv < 0) velv *= .7;


if (dash) and (carga > 0) 
{
	if (up or down or right or left) dir = point_direction(0,0,right-left,down-up)
	else dir = point_direction(0,0,ver,0)
	
	
	estado = state.dash;
	
	carga--;
	
	
}

//-- Limitando as velocidades

velv = clamp(velv,-max_velv,max_velv)

break;

case state.dash:



dura--;

velh = lengthdir_x(len,dir)
velv = lengthdir_y(len,dir)

//Deformando o player
if (dir == 90 or dir == 270)
{
	yscale = 1.5;
	xscale = .5;
}
else
{
	yscale = .5;
	xscale = 1.6
}

//Criando o rastro
var rastro = instance_create_layer(x,y,"rastro",obj_player_vestigio)
rastro.xscale = xscale;
rastro.yscale = yscale;


//Saindo do estado
if (dura <= 0)
{
	estado = state.movendo;
	dura = room_speed/4;
	
	//diminuindo a velocidade
	velh = (max_velh * sign(velh) * .5)
	velv = (max_velv * sign(velv) * .5)
}

break;

	case state.morte:
	
	var aleatorio = random_range(30,60)
	
	for (var i = 0; i < aleatorio;i++)
	{
		var explodiu = instance_create_layer(x,y,"explodir",obj_explodiu);
	}
	
	instance_destroy();
	
	break;
	
}


#endregion

//Switch cor

switch(carga)
{
	case 0:
	
	sat = lerp(sat,50,.5);
	
	break;

	case 1:
	
	sat = lerp(sat,255,.5);
	
	break;

}

//Definindo a cor dele
image_blend = make_color_hsv(20,sat,255);

//voltando para o estado original

xscale = lerp(xscale,1,.15);
yscale = lerp(yscale,1,.15);


//Limitando o player

x = clamp(x,0+sprite_width/2,room_width-sprite_width/2);