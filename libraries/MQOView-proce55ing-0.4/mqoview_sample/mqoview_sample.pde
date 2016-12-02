/*
 mqoview for processing sample code.
 2009.2.5 reco
*/          
import javax.media.opengl.*; 
import processing.opengl.*;

// 下記の2つのライブラリのインポートが必要
import jp.nyatla.kGLModel.*;
import jp.nyatla.kGLModel.contentprovider.*;

// 
KGLModelData model_data;           //モデルデータ格納用
ContentProvider content_provider;  //読み込みファイル・ＵＲＬ格納

float a;   // 回転数を保持(デモ用)

void setup() {
  size(800, 600, OPENGL);
  //読み込みファイルを指定
  //ローカルファイルの場合は、LocalContentProviderを使用　フルパスで記入する事。
  //Httpアクセスの場合は相対アクセスでＯＫ
  //content_provider = new LocalContentProvider(this, "e:\\tmp\\MQOData\\miku01_BONE7.mqo");
  content_provider = new HttpContentProvider(this, "http://www.hyde-ysd.com/reco-memo/MQOData/miku01_BONE7.mqo.txt");
  // (サーバーの制限の問題で、拡張子がMQOのままUpできないため、拡張子がtxtになってます。
  //miku01_BONE7.mqoは、三次元CG@七葉よりお借りしてます。利用条件はそちらに従ってください。
  
  //OpenGLハンドルの取得
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
  GL gl = pgl.beginGL();  // always use the GL object returned by beginGL

  //引数に上記に記述したファイルハンドルを入れる。
  // Ver 0.3より関数の引数が１つ増えました。最後部の引数でモデルの座標軸を指定します。true=左手系(Processing標準)　(ARToolkit等の右手系対応のため)
   model_data = KGLModelData.createGLModelPs(this, gl,null,this.content_provider,0.015f,
		    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;
  //openGLハンドルの解放
  pgl.endGL();
}

void draw() {
  background(128);
  
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
  GL gl = pgl.beginGL();  // always use the GL object returned by beginGL
  gl.glColor4f(0.7, 0.7, 0.7, 0.8);

  //おまじない
  gl.glTexEnvf(GL.GL_TEXTURE_ENV, GL.GL_TEXTURE_ENV_MODE, GL.GL_MODULATE);
  gl.glEnable(GL.GL_CULL_FACE);
  gl.glCullFace(GL.GL_FRONT);

  //位置調整
  gl.glTranslatef(width/2, height*1/3, 0);
  // 描画毎に aだけ回転（デモ用)
  gl.glRotatef(180, 1, 0, 0);
  gl.glRotatef(180, 0, 1, 0);
  gl.glRotatef(a, 0, 1, 0);
  //座標系の調整。
  //(Processingは左上が0,0、一方メタセコは、中心が0,0で右上方向に軸が進むため
  gl.glPushMatrix();
// - for ARToolkit rotation -
//  gl.glRotatef(180, 0, 1, 0);
//  gl.glRotatef( -90, 1, 0, 0);

// - for ARToolkit rotation -
//  gl.glRotatef(180, 0, 0, 1);
//  gl.glRotatef(180, 0, 1, 0);


  // スケールは各自調整してください。
  // openGLの1.0fとは全然違うので、注意が必要。
  model_data.enables(100.0f) ;
  model_data.draw() ;
  model_data.disables() ;
  gl.glPopMatrix();


  gl.glPushMatrix();
//  gl.glTranslatef(100,100,0);
  gl.glBegin(GL.GL_LINES);
  gl.glColor4f(1, 0, 0, 1);
  gl.glVertex3f(0,0,0);
  gl.glVertex3f(100,0,0);

  gl.glColor4f(0, 1, 0, 1);
  gl.glVertex3f(0,0,0);
  gl.glVertex3f(0,100,0);

  gl.glColor4f(0, 0, 1, 1);
  gl.glVertex3f(0,0,0);
  gl.glVertex3f(0,0,100);
  gl.glEnd();
  gl.glPopMatrix();


  pgl.endGL();
  
/*
pushMatrix();
  translate(width/2, height*1/3, 0);  
  rotate((a*PI/180), 0, 1, 0);
      beginShape(LINES);
    stroke(255,0,0);
    vertex( 0, 0, 0); 
    vertex( 200, 0, 0); 

    stroke(0, 255,0);
    vertex( 0, 0, 0); 
    vertex( 0, 100, 0); 

    stroke( 0,0,255);
    vertex( 0, 0, 200); 
    vertex( 0, 0, 0); 
    endShape();
    popMatrix();
*/
  a += 0.5;
}


