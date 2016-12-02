/* 
 * PROJECT: NyARMqoView
 * --------------------------------------------------------------------------------
 * これはMetaseqファイル（.MQO）ファイルをｊａｖａに読み込み＆描画するクラスです。
 * Copyright (C)2008 kei
 * 
 * 
 * オリジナルファイルの著作権はkeiさんにあります。
 * オリジナルのファイルは以下のURLから入手できます。
 * http://www.sainet.or.jp/~kkoni/OpenGL/reader.html
 * 
 * このファイルは、http://www.sainet.or.jp/~kkoni/OpenGL/20080408.zipにあるファイルを
 * ベースに、NyARMqoView用にカスタマイズしたものです。
 *
 * For further information please contact.
 *	A虎＠nyatla.jp
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 * processing対応部分、 by reco
 */
package jp.nyatla.kGLModel;
import java.io.* ;
import java.nio.*;


import javax.media.opengl.GL;

import processing.core.PApplet;

import jp.nyatla.kGLModel.contentprovider.ContentProvider;

//import com.sun.opengl.util.texture.*;
/**
 * JOGLを使用してファイルからモデルデータの読み込みと描画を行う<br>
 * 使用後はClear()を呼んでください<br>
 * ＯｐｅｎＧＬへ登録したリソースの解放をします。<br>
 * 
 * @author kei
 */
public class KGLModelData {

	// For Prosessing Lib  
	static PApplet myParent;
	static boolean axisLR;		
		//左手系・右手系の管理。通常のprocessingでは左手系、ARToolkitでは右手系のため用途に応じて指定するように。
		//左手系の時true;
	public final String VERSION = "0.3.0";
	/**
     * OpenGLコマンド群をカプセル化したクラス
     * (JOGL)
     */
    protected GL gl;
    /**
     * テクスチャ管理クラス
     */
    protected KGLTextures texPool  = null ;
    /**
     * テクスチャ管理クラスをこのクラスで作成したかどうか
     */
    protected boolean isMakeTexPool = false ;
    /**
     * VBO（頂点配列バッファ）を使用するかどうか
     */
    protected boolean isUseVBO = false ; 

    /**
     * マテリアルの描画情報
     * @author kkoni
     *
     */
    protected class GLMaterial {
	/**
	 * マテリアル名
	 */
	String name ;
	/**
	 * 描画有無<br>
	 */
	boolean isVisible = true;
	/**
	 * 色情報
	 */
	float[]	color = null ;
	/**
	 * 拡散光
	 */
	float[]	dif = null ;
	/**
	 * 環境光
	 */
	float[]	amb = null ;
	/**
	 * 放射輝度
	 */
	float[]	emi = null ;
	/**
	 * 鏡面反射
	 */
	float[]	spc = null ;
	/**
	 * 鏡面反射強度
	 */
	float[] power = null;

	/**
	 * シェーディングモード<br>
	 * GL_SMOOTH or GL_FLAT
	 */
	boolean shadeMode_IsSmooth = true ; //OpenGLのデフォルトはGL_SMOOTH

	/**
	 * 頂点数
	 */
	int vertex_num ;
	/**
	 * テクスチャＩＤ（未使用の場合０）<br>
	 */
	int	texID ;
	/**
	 * データ格納形式<br>
	 * GL_N3F_V3F or GL_T2F_C4F_N3F_V3F or GL_T2F_N3F_V3F or GL_C4F_N3F_V3F
	 */
	int interleaveFormat ;
	/**
	 * データ格納形式に合わせて格納したデータ
	 */
	ByteBuffer interleaved = null ;
    }
    /**
     * モデルの各オブジェクト情報保持クラス
     * @author kei
     *
     */
    protected class GLObject {
	/**
	 * オブジェクト名<br>
	 */
	String name = null ;
	/**
	 * 描画有無<br>
	 */
	boolean isVisible = true;
	/**
	 * マテリアル毎の描画情報<br>
	 */
	GLMaterial[] mat = null ;
	/**
	 * ＯｐｅｎＧＬへ登録した頂点配列バッファＩＤ<br>
	 * （頂点配列バッファを使用する場合にしか値は入らない）<br>
	 */
	int[] VBO_ids = null ;
    }
    /**
     * 描画用内部データ
     */
    protected GLObject[] glObj ;
    /**
     * ファイル名の拡張子を見て読み込みクラスを作成する。<br>
     * →MQOファイルしか作ってないけどね！<br>
     * 
     * @param in_gl		OpenGLコマンド群をカプセル化したクラス
     * @param in_texPool	テクスチャ管理クラス（nullならこのクラス内部に作成）
     * @param i_file_provider	ファイル提供オブジェクト
     * @param i_moq_name	MOQファイルを識別する文字列
     * @param scale		モデルの倍率
     * @param in_isUseVBO	頂点配列バッファを使用するかどうか
     * @return	モデルデータクラス
     */
    static public KGLModelData createGLModel(GL in_gl,KGLTextures in_texPool,ContentProvider i_file_provider,float scale,boolean in_isUseVBO) throws KGLException
    {
	//ファイル解析してMOQか判別したいけど、とりあえずMOQだと信じる。
        return new KGLMetaseq(in_gl,in_texPool,i_file_provider,scale,in_isUseVBO, true) ;
 //           throw new KGLException();
    }

    // Add by reco for processing lib.
    static public KGLModelData createGLModelPs(PApplet theParent, GL in_gl,KGLTextures in_texPool,ContentProvider i_file_provider,float scale,boolean in_isUseVBO, boolean axis) //throws KGLException
    {
    	myParent = theParent;
    	axisLR = axis;		//左手系 processing標準: true, 右手系: false 
	//ファイル解析してMOQか判別したいけど、とりあえずMOQだと信じる。
        return new KGLMetaseq(in_gl,in_texPool,i_file_provider,scale,in_isUseVBO, axisLR) ;
 //           throw new KGLException();
    }

    /**
     * ＯｐｅｎＧＬへ登録したリソースを解放する<br>
     *
     */
    public void Clear() {
	if( glObj == null ) return ;
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    if(glObj[o].VBO_ids != null ) 
		gl.glDeleteBuffersARB(glObj[o].VBO_ids.length,glObj[o].VBO_ids,0) ;
	}
	glObj = null ;
	if( isMakeTexPool ) {
	    texPool.Clear() ;
	    texPool = null ;
	}
    }
    /**
     * コンストラクタ
     * createGLModelを使用してインスタンス化するので、使用しない。
     * @param in_gl		OpenGLコマンド群をカプセル化したクラス
     * @param in_texPool	テクスチャ管理クラス（nullならこのクラス内部に作成）
     * @param scale		モデルの倍率
     * @param in_isUseVBO		頂点配列バッファを使用するかどうか
     */
    protected KGLModelData(GL in_gl, KGLTextures in_texPool,ContentProvider i_provider,float scale, boolean in_isUseVBO)

//    protected KGLModelData(GL in_gl,KGLTextures in_texPool,float scale,boolean in_isUseVBO)
    {
	gl = in_gl ;
	texPool = in_texPool ;
	isUseVBO = in_isUseVBO ;
	if( in_isUseVBO ) {
	    isUseVBO = KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object") ;
	}
	glObj = null ;
	if( texPool == null ) {
	    texPool = new KGLTextures(gl,i_provider) ;
	    isMakeTexPool = true ;
	}
    }
    /**
     * 描画有無を変更する<br>
     * @param objectName	オブジェクト名
     * @param isVisible	描画有無
     */
    public void objectVisible(String objectName,boolean isVisible) {
	if( glObj == null ) return ;
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    if( objectName.equals(glObj[o].name) ) {
		glObj[o].isVisible = isVisible ;
		break ;
	    }
	}

    }
    /**
     * 描画有無を変更する<br>
     * @param materialtName	マテリアル名
     * @param isVisible	描画有無
     */
    public void materialVisible(String materialtName,boolean isVisible)
    {
	if( glObj == null ) return ;
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    for( int m = 0 ; m < glObj[o].mat.length ; m++ ) {
		if( materialtName.equals(glObj[o].mat[m].name) ) {
		    glObj[o].mat[m].isVisible = isVisible ;
		    break ;
		}
	    }
	}

    }
    /**
     * 描画有無を変更する<br>
     * @param objectName	オブジェクト名
     * @param materialtName	マテリアル名
     * @param isVisible	描画有無
     */
    public void materialVisible(String objectName,String materialtName,boolean isVisible) {
	if( glObj == null ) return ;
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    if( ! objectName.equals(glObj[o].name) ) continue ;
	    for( int m = 0 ; m < glObj[o].mat.length ; m++ ) {
		if( materialtName.equals(glObj[o].mat[m].name) ) {
		    glObj[o].mat[m].isVisible = isVisible ;
		    break ;
		}
	    }
	}
    }
    /**
     * 描画に必要なglEnable処理を一括して行う。<br>
     * glEnableするものは<br>
     * GL_DEPTH_TEST<br>
     * GL_ALPHA_TEST<br>
     * GL_NORMALIZE（scaleが1.0以外の場合のみ）<br>
     * GL_TEXTURE_2D<br>
     * GL_BLEND<br>
     * これらが必要ないことがわかっているときは手動で設定するほうがよいと思います<br>
     *@param scale 描画するサイズ（１倍以外はＯｐｅｎＧＬに余計な処理が入る）
     */
    public void enables(float scale) {
	gl.glEnable(GL.GL_DEPTH_TEST) ;
	gl.glEnable(GL.GL_ALPHA_TEST) ;
	if( scale != 1.0 ) {
	    gl.glScalef(scale,scale,scale) ;
	    gl.glEnable(GL.GL_NORMALIZE) ;//スケールを変えるときはOpenGLに法線の計算をしてもらわないといけない
	}
	gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP);
	gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP);
	gl.glEnable(GL.GL_TEXTURE_2D) ;
	gl.glEnable(GL.GL_BLEND) ;
	gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE_MINUS_SRC_ALPHA) ;
    }
    /**
     * 描画で使ったフラグ（enables()で設定したもの）をおとす<br>
     * glDsableするものは<br>
     * GL_DEPTH_TEST<br>
     * GL_ALPHA_TEST<br>
     * GL_NORMALIZE<br>
     * GL_TEXTURE_2D<br>
     * GL_BLEND<br>
     */
    public void disables() {
	gl.glDisable(GL.GL_BLEND) ;
	gl.glDisable(GL.GL_TEXTURE_2D) ;
	gl.glDisable(GL.GL_NORMALIZE) ;
	gl.glDisable(GL.GL_ALPHA_TEST) ;
	gl.glDisable(GL.GL_DEPTH_TEST) ;
    }
    /**
     * 描画<br>
     * 内部に持っているデータを描画する
     */
    public void draw() {
	draw(1.0f) ;
    }
    /**
     * 描画<br>
     * 内部に持っているデータを描画する
     *
     *@param alpha	描画する透明度（０～１）
     */
    public void draw(float alpha) {
	float[] fw = new float[4] ;
	if( glObj == null ) return ;
	gl.glPushMatrix() ;
	/* glEnable／glDisableは呼び出し側の都合によって必要ない（かもしれない）
	 * ので、外だし(enables(float),disables())にした。
		gl.glEnable(GL.GL_DEPTH_TEST) ;
		gl.glEnable(GL.GL_ALPHA_TEST) ;
		if( scale != 1.0 ) {
			gl.glScalef(scale,scale,scale) ;
			gl.glEnable(GL.GL_NORMALIZE) ;
		}
	 */
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    GLObject glo = glObj[o] ;
	    if( glo == null ) continue ;
	    if( ! glo.isVisible) continue ;
	    for( int m = 0 ; m < glo.mat.length ; m++ ) {
		GLMaterial mat = glo.mat[m] ;
		if( mat == null ) continue ;
		if( ! mat.isVisible ) continue ;
		//OpenGLの描画フラグ設定
		if( mat.texID != 0 ) {
		    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP);
		    gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP);
//		    gl.glEnable(GL.GL_TEXTURE_2D) ;
		}

		if( mat.shadeMode_IsSmooth ) {
		    gl.glShadeModel(GL.GL_SMOOTH) ;
		}
		else {
		    gl.glShadeModel(GL.GL_FLAT) ;
		}

//		gl.glEnable(GL.GL_BLEND) ;
//		gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE_MINUS_SRC_ALPHA) ;

		//色関係の設定
		gl.glColor4f(mat.color[0],mat.color[1],mat.color[2],mat.color[3]) ;
		if( mat.dif != null ) {//拡散反射成分：物体の色
//		    gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_DIFFUSE,mat.dif,0) ;
		    System.arraycopy(mat.dif,0,fw,0,mat.dif.length) ;
		    fw[3]*=alpha ;
		    gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_DIFFUSE,fw,0) ;
		}
		if( mat.amb != null ) gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_AMBIENT,mat.amb,0) ;//環境光
		if( mat.spc != null ) {//鏡面反射成分 : きらめきの色
//		    gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_SPECULAR,mat.spc,0) ;
		    System.arraycopy(mat.spc,0,fw,0,mat.spc.length) ;
		    fw[3]*=alpha ;
		    gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_SPECULAR,fw,0) ;
		}
		if( mat.emi != null ) gl.glMaterialfv(GL.GL_FRONT_AND_BACK,GL.GL_EMISSION,mat.emi,0) ;//放射輝度
		if( mat.power != null ) gl.glMaterialf(GL.GL_FRONT_AND_BACK,GL.GL_SHININESS,mat.power[0]) ;//鏡面係数

		//テクスチャの設定
		if( mat.texID != 0 ) {
		    gl.glBindTexture(GL.GL_TEXTURE_2D,mat.texID) ;
		}
		//描画データ設定
		if( isUseVBO ) {
		    gl.glBindBufferARB(GL.GL_ARRAY_BUFFER_ARB,glo.VBO_ids[m]) ;
		    gl.glInterleavedArrays(mat.interleaveFormat,0,0) ;
		}
		else {
		    mat.interleaved.position(0) ;
		    gl.glInterleavedArrays(mat.interleaveFormat,0,mat.interleaved) ;

		}

		//描画実行
		gl.glDrawArrays(GL.GL_TRIANGLES,0,mat.vertex_num) ;

		//設定をクリアする
		if( mat.texID != 0 ) {
		    gl.glBindTexture(GL.GL_TEXTURE_2D,0) ;
		}
//		gl.glDisable(GL.GL_BLEND) ;
		if( isUseVBO ) {
		    gl.glBindBufferARB(GL.GL_ARRAY_BUFFER_ARB,0) ;
		}
//		if( mat.texID != 0 ) {
//		gl.glDisable(GL.GL_TEXTURE_2D) ;
//		}
	    }
	}
	/*
		if( scale != 1.0 ) {
			gl.glDisable(GL.GL_NORMALIZE) ;
		}
		gl.glDisable(GL.GL_ALPHA_TEST) ;
		gl.glDisable(GL.GL_DEPTH_TEST) ;
	 */
	gl.glPopMatrix() ;
    }

    /**
     * 文字列＆バイナリデータ混合読み込みクラス
     * 
     */
    protected class multiInput {
	/**
	 * 読み込みストリーム
	 */
	private BufferedInputStream bis = null ;
	/**
	 * コンストラクタ<br>
	 * @param is	入力ストリーム
	 */
	public multiInput(InputStream is) {
	    bis = new BufferedInputStream(is) ;
	}
	/**
	 * データ読み込み<br>
	 * ストリームからb.lengthサイズのデータを読み込もうとする<br>
	 * 実際に読み込んだサイズはreturn値を参照<br>
	 * @param b	読み込みバッファ
	 * @return	読み込みサイズ
	 * @throws IOException
	 */
	public int read(byte[] b) throws IOException {
	    return bis.read(b) ;
	}
	/**
	 * ストリームをクローズする
	 * @throws IOException
	 */
	public void close()throws IOException {
	    bis.close() ;
	}
	/**
	 * １行（文字列）読み込み<br>
	 * 1 行の終端は、改行 (「\n」) か、復帰 (「\r」)、または復帰とそれに続く改行<br>
	 * この関数のあと、読み込み位置は改行文字の次に進む<br>
	 * @return	１行のデータ
	 */
	public String readLine() {
	    String ret = null ;
	    try {
		bis.mark(256) ;//読み込み前に現在位置をマーク
		int idata ;
		int len ;
		int retnum ;
		len = 0 ;
		retnum = 0 ;
		while((idata=bis.read()) != -1) {//読み込み文字数を数える
		    if( idata == '\n' ) {
			len ++ ;
			break ;
		    }
		    if( idata == '\r' ) {
			len++ ;
			continue ;
		    }
		    if( retnum != 0 ) break ;
		    len ++ ;
		} ;
		//読み込み前につけたマークから文字数分読み込み。
		byte[] b = new byte[len] ;
		bis.reset() ;
		bis.read(b) ;
		BufferedReader br = new BufferedReader(new InputStreamReader(
			new ByteArrayInputStream(b))) ;
		ret = br.readLine() ;
	    }
	    catch(Exception e) {
		e.printStackTrace() ;
	    }

	    return ret ;
	}
    }
    /**
     * 読み込んだオブジェクト／マテリアル名称を文字列にする
     */
    public String toString() {
	String ret = null ;
	String retCode = (String)System.getProperties().get("line.separator") ;
	StringBuffer sb = new StringBuffer() ;
	if( glObj == null ) return "データなし" ;
	sb.append("オブジェクト名(マテリアル名,...）").append(retCode) ;
	for( int o = 0 ; o < glObj.length ; o++ ) {
	    sb.append(glObj[o].name).append("(") ;
	    for( int m = 0 ; m < glObj[o].mat.length ; m++ ) {
		sb.append(glObj[o].mat[m].name).append(",");
	    }
	    sb.append(")").append(retCode) ;
	}
	ret = sb.toString();
	return ret ;
    }
}
