------------
Copyright (C)2009 reco

Metaseqファイル（.MQO）ファイルをｊａｖａに読み込み＆描画するクラスをProcessingで扱えるようにしたライブラリです。

Ver 0.4  2009/4/13 reco
Ver 0.3  2009/3/08 reco
Ver 0.2  2009/2/11 reco
Ver 0.1b  2009/2/1 reco
Ver 0.1  2009/1/27 reco
------------

このライブラリは、Ａ虎氏作成のNyARToolkit(ARToolKit Class Library for Java)の動作サンプルプログラムであるNyARMqoViewerをベースにProcessing上で動作できるようにしたものです。
このライブラリと、同じくＡ虎氏作成のNyAR4psg(NyARToolkit for proce55ing)を組み合わせることで、Processing環境上でもメタセコイア形式のデータを表示できるようになります。 

座標系の制約により、表示するモデルは、Ｚ軸に対して後ろ向きになってしまいます。
そんなもんだと思ってご利用ください。実際に表示させて、回転させたりすれば、さほど気にならないと思いますが、OpenGL等から何らか移植する場合は注意が必要です。<br/>

NyARToolkitのページ:　http://nyatla.jp/nyartoolkit/wiki/index.php?FrontPage
NyARMqoViewer：　http://nyatla.jp/nyartoolkit/wiki/index.php?Sample%2FNyARMqoViewer

[インストール]
Libフォルダ配下のjarファイルを、sktchフォルダ配下のcodeフォルダの中か、Processingのライブラリフォルダにコピーして使用してください。
Processingのライブラリディレクトリにおく場合は、jp/nytla/kGLModeフォルダを作成して、その中にNyARMQO.jarをおいてください。（NyARToolkitから派生したため同じようなクラス構成にしてあります) 
詳しくは、サンプルファイルを参考ください。

簡単な使用法
---
クラスのインポート
---

import javax.media.opengl.*; 
import processing.opengl.*;

import jp.nyatla.kGLModel.*;
import jp.nyatla.kGLModel.contentprovider.*;

//下記のクラスを使用します。

KGLModelData model_data = new KGLModelData;
ContentProvider content_provider = new ContentProvider;

あとは、

content_provider = new LocalContentProvider(this, "d:\\MQOData\\hoge.mqo");
content_provider = new HttpContentProvider(this, "http://127.0.0.1/hoge.mqo");
[Ver0.4]ZIPファイルに対応しました。詳細は後述（ZIPファイルの読み取りについて）参照


の様に、場所を特定してコンテンツプロバイダを作成して頂き、

  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  
  GL gl = pgl.beginGL();  
   model_data = KGLModelData.createGLModelPs(this, gl,null,this.content_provider,0.015f,
	        	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;
  pgl.endGL();

の様に、モデルデータクラスにロードをしてください。
この際、OpenGLのハンドラを渡してあげる必要があります。
あとは、

  model_data.enables(1.0f) ;  //引数は倍率
  model_data.draw() ;
  model_data.disables() ;

で呼び出すことが可能です。同じくOpenGLを利用するので、
GL gl = pgl.beginGL(); ～ pgl.endGL();で囲んでやる必要があります。
このあたりは、Processingの公式ページ(http://www.procesing.org/)にあるReference/library/openglあたりを参考にしてください。
Processing上で、pure Open GLを使う方法が書かれています。

Processing言語でライブラリすべてをカバーしようと思ったのですが、Processingでは高度なモデルの扱いは手にあまるのと、 Processing自体も所詮Javaということもあり、ネイティブ対応にこだわるよりも割り切ってオーバーラップだけをする事にしました。 

追記: 2009/03/09
NyARToolkit for Processing(http://nyatla.jp/nyartoolkit/wiki/index.php?NyAR4psg) は、座標系が右手系になります。
このためProcessing標準の座標系で描画すると、モデルの左右が逆になったり、テクスチャがうまく表示されません。
内部的に別処理をする必要がありますが、本ライブラリでは、createGLModelPsでモデルをロードする際に引数を渡すことで対応可能としました。

model_data = KGLModelData.createGLModelPs(this, gl,null,this.content_provider,0.015f,
		       	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;

最後の引数、trueで左手系、falseで右手系になります。用途に応じて使い分けてください。
近日中に、NyARToolkit for Processingと本ライブラリを組み合わせたサンプルを公開予定ですが、
諸般の事情により遅れております。。

2009/4/13
ZIPファイルの読み取りについて

ZIPファイルに納められているモデルデータを読み込むことができるようになりました。
下記の様に、ファイルの場所に応じて関数を使いわけてください。
content_provider = new LocalZipContentProvider(this, "d:\\MQOData\\hoge.zip","hoge.mqo");
content_provider = new HttpZipContentProvider(this, "http://127.0.0.1/hoge.zip","hoge.mqo");
書式は、自アプレットポインタ、書庫ファイルの場所、読み取るファイルです。
書庫が同じで、ターゲットファイルのみを変更したい場合は、メンバ関数の changeEntry(string str)をお使いください。
newでコンストラクタを呼び出してしまうと、通信が発生してしまいます。

Http...の方は、コンストラクタ作成時にZIPファイルをメモリに読み込んだあとは、
メモリ上のデータにアクセスしてターゲットのファイルを処理します。
ターゲットのファイルにアクセスする度にhttp通信を行わなくてすむため、webでの公開時のロード時間が短縮できます。

※素材ファイルも同じZIP書庫に含めてください。

=========================
関数一覧

[読み込みデータの指定:content_provider各種]
MQO形式のファイルを直接指定する場合
content_provider = new LocalContentProvider(PApplet, String); // ローカル上
content_provider = new HttpContentProvider(PApplet, String); // ローカル上
ex)
content_provider = new LocalContentProvider(this, "d:\\MQOData\\hoge.mqo"); // ローカル上
content_provider = new HttpContentProvider(this, "http://127.0.0.1/hoge.mqo"); //httpアクセスするファイル


ZIP圧縮されている場合
content_provider = new LocalZipContentProvider(PApplet, String zipfile, String target_file); // ローカル上
content_provider = new HttpZipContentProvider(PApplet, String zipfile, String target_file); // ローカル上

ex)
content_provider = new LocalZipContentProvider(this, "d:\\MQOData\\hoge.zip","hoge.mqo");
content_provider = new HttpZipContentProvider(this, "http://127.0.0.1/hoge.zip","hoge.mqo");

メンバ関数：
特になし
※ZIPファイル取り扱い時のみ
changeEntry(String filename)

ex)
content_provider.changeEntry("hoge2.mqo");

[モデルを取り扱うクラス　KGLModelDataクラス]

メンバ関数：
 createGLModelPs(PApplet pa, GL in_gl,KGLTextures in_texPool,ContentProvider i_file_provider,float scale,boolean in_isUseVBO, boolean axis)
	引数
		PApplet pa: Processingアプレットへのポインタ
		GL in_gl: OpenGLハンドル
		KGLTextures in_texPool テクスチャ管理クラス（nullならこのクラス内部に作成）
		ContentProvider i_file_provider ファイル提供オブジェクト
		float scale	倍率
		boolean in_isUseVBO	in_isUseVBOを使用するかしないか（環境依存）
		boolean axis 左手系/右手系の指定　true左手系、false右手系 (普通にProcessingで使う場合は左手系)
	用途：
		モデルデータのロード

	ex) 
	 KGLModelData modeldata = createGLModelPs(this, gl,null,this.content_provider,0.015f,
		       	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;
 	
 enables(float scale)
 	引数
 		scale 表示するときの倍率
 	用途：
 		OpenGLの初期化など（Drawの前に必ず1度は呼び出す）

 disables()
 	用途：
 		OpenGLの終了処理など（Drawの後に必ず1度は呼び出す）
 	
 draw()
 	用途：
 		モデルデータの描画
 	
 	
//  model_data.draw() ;
  model_data[play_anim_no].draw() ;
  model_data[play_anim_no].disables() ;



========================
[変更履歴]
0.4
ZIP圧縮されたファイルからの読み出しに対応

0.3
左手系描画(Processing標準）、右手系描画(NyARToolkit for Processing等）の両方に対応させました。
createGLModelPsの引数の最後で、どちらの座標系で描画するを指定します。
trueで左手系、falseで右手系になります。用途に応じて使い分けてください。

※createGLModelPsの引数が１つ増えています（右手系・左手系対応）
※NyARとは関係がないので、混乱を避けるためにjarファイル名を変更しました。（NyARMQO.jar→MQOLoader.jar）

0.1b/0.1c > 0.2 2009/2/11<br/>
  Processingの右手座標への変換ルーチンの正常化。座標系が異なるため、完全にはメタセコイアとの同じにはなりません。Z軸に対して後ろ向きになります。<br/>

0.1 > 0.1b 2009/2/1
  ライブラリのコンパイラをJre6を使っており、一部の環境のProcessingでは動作しないことが判明したので、
　1.5でコンパイルをやり直しました。



========================
[NyARMqoViewerからの変更内容]
NyARMqoViewerをベースにProcessing対応をさせてみました。
ほとんどそのまま動作しましたが、下記の部分若干変更をしました。

ZIPファイルからの読み取り

[HttpContentProvider.java, LocalContentProvider.java]

・クラスメンバにprocessing用のハンドラを追加 (pAppret)
　これに伴う "import processing.core.*" の追加

・HttpContentProvider, LocalContentProviderのコンストラクタに、
　pAppretハンドルを受ける関数を追加。動作は既存のものと同じ。


・Processing側でうまく、KGLExceptionが受けられないのでコメントアウト。
　(unknowen exception typeが出る)

[KGLModelData.java]

KGLModelDataクラスに、createGLModelPs関数を追加。
・contentprovider系と同じく、procesingからのハンドルを受け取るために、
　関数の引数の拡張とハンドルのメンバ関数ストア部分のみを記述。(Processing用なので、Psと付けています)。
・contentprovider系と同じく、Processing側でうまく、KGLExceptionが受けられないのでコメントアウト。


[KGLMetaseq.java]]
GLObjectクラス、makeObjs関数内のglGenBuffersを、glGenBuffersARBへ

私の家の環境のうち、ある１台のPCのみ、glGenBuffersに対してavilableを返すのにもかかわらず、
実際にコールすると、not availableとなってしまうため、ARBの方を使うように変更しました。
boolean ret2 = gl.isFunctionAvailable("glGenBuffers"); でもtrueが戻ってきてしまって、
どうしようもなくなりました。。。。

[左手座標系への対応](ver0.2)
読み込み時に
○Ｚ軸の変換（-1)
○頂点配列格納順の変更（反時計回りに）　ＵＶ座標も同様
を行う。
下記の関数に対して、左手用の関数を新たに作成。(左手を表すＬが関数に付加される）
（左手対応以外は、オリジナルを利用）
KGLMetaseq.java無いの、 KGLMetaseqクラス内、 objectクラスの
readVertex, readBVertex, readFace、set


========================
・著作権とライセンス
このソースは、A虎＠nyatla.jpさんの著作物、NyARMqoViewerのMetaseqファイルを扱う部分を使用しています。
コアの部分の、パッケージjp.nyatla.kGLModel配下のソースコードは、keiさんの著作物にA虎＠nyatla.jpさんが改変を加えたものです。
この部分のライセンスはkeiさんのそれに従います。

このライブラリ自体はMITライセンスで配布します。ライセンスに関しては、licence.txtを参照してください。
ソースコード毎の著作権は、ソースコードの先頭部分を見てください。

・謝辞
A虎＠nyatla.jpさん
ARToolkitのJava化、Processingでの利用に注力をされておられます。
これらに出会って私の趣味の自由度が格段に広がりました。
ありがとうございます。

keiさん
根本となるメタセコイアデータの読み出し部分kGLModelの公開をしていただきました。
ありがとうございます。

☆連絡先
fprintf@yahoo.co.jp
ブログ：http://reco-memo.blogspot.com/
質問そのほかは、ブログの方にコメントをいただいた方が対応が早いかと思います。

☆重要☆
・NyARToolkitは…
ARToolkit Java class library NyARToolkit.
Copyright (C)2008 R.Iizuka
http://nyatla.jp/nyartoolkit/wiki/index.php
を指します




