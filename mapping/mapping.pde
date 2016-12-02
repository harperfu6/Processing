PImage mapImage; //画像を取り込むための変数を準備

//setup部分で、640x400の窓を準備
//map.pngをmapImageにロードする
void setup(){
size(640,400); 
mapImage = loadImage("map.png");
}
//imageコマンドで、mapImageを貼り付ける。
//ここで貼り付ける座標は(0,0)
void draw(){
background(255);
image(mapImage, 0, 0);
}
