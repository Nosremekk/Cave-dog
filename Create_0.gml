/// @description Criação
// ----- Variaveis essenciais

grav = .3
acel_chao = .1;
acel_ar =  .07;
acel = .1;
deslize = 2;



//-- Velocidade maxima

max_velh = 6;
max_velv = 8;
len = 10;
//Bonus de pulo

limite_pulo = 6;
timer_pulo = 0;

limite_buffer = 6;
buffer_pulo = false;
timer_queda = 0;

limite_parede = 6;
timer_parede = 0;

//-- Variaveis de controle

chao = false;

yscale = 1;
xscale = 1;

parede_dir = false;
parede_esq = false;

dura = room_speed/4;

dir = 0;

carga = 1;

ultima_parede = 0;

ver = 1;

criar_pedaco = true;

lista = noone;

//-Controlando a cor

sat = 255;

enum state
{
	parado,movendo,dash,morte,
}

estado = state.movendo;

if (!instance_exists(obj_camera)) instance_create_layer(20,20,"camera",obj_camera)