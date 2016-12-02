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
 * 	A虎＠nyatla.jp
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 * 
 */
package jp.nyatla.kGLModel;

import javax.media.opengl.GL;
import java.util.*;
import java.nio.*;
import java.io.*;           // For File
//import java.awt.image.*;    // For BufferedImage
//import javax.imageio.*;     // For ImageIO
import com.sun.opengl.util.texture.*;

import jp.nyatla.kGLModel.contentprovider.ContentProvider;
import jp.nyatla.kGLModel.contentprovider.ContentWrapper;
import jp.nyatla.nyarmqoviewer.*;
/**
 * テクスチャの生成と管理<br>
 * 一度読み込んだテクスチャは再利用する。<br>
 * 使用後はClear()を呼んでください<br>
 * ＯｐｅｎＧＬへ登録したリソースの解放をします。<br>
 * 
 * @author kei
 *
 */
public class KGLTextures {
    private ContentProvider file_provider;
    /**
     * OpenGLコマンド群をカプセル化したクラス
     * (JOGL)
     */
    private GL gl ;
    /**
     * texture nameの保存コンテナ<br>
     * テクスチャ名＋アルファファイル名＋透明度<br>
     * をキーにOpenGLのtexture name（int）を保存しているコンテナ<br>
     */
    private HashMap<String,Integer> texPool  = null ;
    /**
     * コンストラクタ
     * 
     */
    public KGLTextures(GL in_gl,ContentProvider i_provider)
    {
	gl = in_gl;
	file_provider=i_provider;
	texPool = new HashMap<String,Integer>() ;
    }
    /**
     * ＯｐｅｎＧＬへ登録したリソースを解放する
     *
     */
    public void Clear()
    {
	Collection<Integer> collection = texPool.values() ;
	Integer[] ciarray = collection.toArray(new Integer[0]) ;
	if( ciarray.length == 0 ) return ;
	int[] iarray = new int[ciarray.length] ;
	for( int i = 0 ; i < iarray.length ; i++ ) {
	    iarray[i] = ciarray[i];
	}
	gl.glDeleteTextures(iarray.length,iarray,0) ;
	texPool.clear() ;
    }
    /**
     * テクスチャの登録<br>
     * 
     * @param texname	テクスチャファイル名
     * @param alpname	アルファファイル名
     * @param reload	true:登録してあってもファイルから読み直しする
     * @return			OpenGLのtexture name（int）
     */
    public int getGLTexture(String texname,String alpname,boolean reload)
    {
	if( texname == null && alpname == null ) return 0 ;
	Integer ret = 0 ;
	ret = texPool.get(texname+alpname) ;
	if( !reload ) {//再読込しない＆登録済みなら、登録してあったものを返す
	    if( ret != null ) return ret ;
	}
	else {//再読込＆登録済みなら、登録していたものを削除する
	    if( ret != null ) {
		gl.glBindTexture(GL.GL_TEXTURE_2D,0) ;
		glDeleteTexture(ret) ;
		texPool.remove(texname+alpname) ;
		ret = 0 ;
	    }
	}
	/*コレだと上下反転している画像の対応とか透明度を別ファイルで指定している場合とかがメンドイ
		if( alpname == null ) {
			try {
				Texture gltex = TextureIO.newTexture(new File(texname),false) ;
				boolean bbb = gltex.getMustFlipVertically() ;
				gltex.setTexParameteri(GL.GL_TEXTURE_MAG_FILTER,GL.GL_LINEAR) ;
				gltex.setTexParameteri(GL.GL_TEXTURE_MIN_FILTER,GL.GL_LINEAR) ;
				ret = gltex.getTextureObject() ;
				texPool.put(texname+alpname+alpha,ret) ;
			}
			catch(Exception e) {
				e.printStackTrace() ;
			}
			if( ret != 0 ) return ret ;
		}
	 */
	/* texnameだけなら、基本的にここまでの処理でOKなはず。　
	 * これ以降はアルファファイル対応のときに使う 
	 */
	ByteBuffer images ;
	int size = 0;
	images = loadTexture(texname,alpname) ;
	if(images == null ) return 0 ;
	size = (int)Math.sqrt((double)images.capacity()/(double)4) ;
	ret = glGenTexture() ;
	if( ret == 0 ) return 0 ;
	gl.glPixelStorei(GL.GL_UNPACK_ALIGNMENT,1) ;
	gl.glPixelStorei(GL.GL_PACK_ALIGNMENT,1) ;
	gl.glBindTexture(GL.GL_TEXTURE_2D,ret) ;
	gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
	gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
	images.position(0) ;
	gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA8, size, size,
		0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, images);
	gl.glBindTexture(GL.GL_TEXTURE_2D,0) ;
	texPool.put(texname+alpname,ret) ;
	return ret ;
    }

    /**
     * OpenGLにテクスチャを登録する（１個）
     * 
     * @return	登録したtexture name(int)
     */
    private int glGenTexture() {
	int texs[] = new int[1];
	gl.glGenTextures(1,texs,0) ;
	return texs[0] ;
    }
    /**
     * 登録されたテクスチャを削除する（１個）
     * 
     * @param tex	登録済みtexture name(int)
     */
    private void glDeleteTexture(int tex) {
	int texs[] = new int[1];
	texs[0] = tex ;
	gl.glDeleteTextures(1,texs,0) ;
	return  ;
    }
    /**
     * イメージファイルからデータ列を読み込む
     * 
     * @param texname	テクスチャファイル名
     * @param alpname	アルファファイル名
     * @return	読み込んだデータ列
     */
    protected ByteBuffer loadTexture(String texname,String alpname)
    {
	ByteBuffer ret = null;
	try {
	    KGLtga tga = null;
	    boolean b_alp_MustFlipVertically = false;
	    ContentWrapper file_wrapper;
	    byte balpha ;
	    balpha = (byte)(255) ;
	    int h,w ;
	    int npixel  = 0;
	    int napixel = 0;
	    int texform = 0 ;
	    Buffer bw = null ;
	    ByteBuffer bbtex = null ;
	    ByteBuffer bbalp = null ;
	    byte[] barray = null ;
	    byte[] baarray = null ;
	    TextureData gltexdata = null ;
	    //ファイルを得る
	    file_wrapper=this.file_provider.CreateStream(texname);
	    gltexdata   =TextureIO.newTextureData(file_wrapper.getInputStream(),false,null) ;
	    texform = gltexdata.getPixelFormat() ;
	    bw = gltexdata.getBuffer() ;
	    if( bw instanceof ByteBuffer )
	    {
		bbtex = (ByteBuffer)bw ;
		barray = bbtex.array() ;
	    }
	    h = gltexdata.getHeight();
	    w = gltexdata.getWidth() ;
	    TextureData glalpdata = null ;
	    try {
		if( alpname != null ){
		    file_wrapper=this.file_provider.CreateStream(alpname);
		    glalpdata = TextureIO.newTextureData(file_wrapper.getInputStream(),false,null) ;
		}
		if( glalpdata != null ) {
		    bw = glalpdata.getBuffer() ;
		    if( bw instanceof ByteBuffer ) {
			if( h == glalpdata.getHeight() && w == glalpdata.getWidth() ) {
			    bbalp = (ByteBuffer)bw ;
			    baarray = bbalp.array() ;
			    napixel = baarray.length/(h*w) ;
			}
		    }
		    b_alp_MustFlipVertically = glalpdata.getMustFlipVertically() ;
		}
	    }catch(IOException ioe) {
		System.err.println("TGAファイルのモノクロフォーマットが対応していないっぽいので自力で読んでみる。");
		//TGAファイルのモノクロフォーマットが対応していないっぽいので自力で読んでみる。
		//java.io.IOException: TGADecoder Uncompressed Grayscale images not supported
		try {
		    tga = new KGLtga(file_provider,alpname);
		    if( h == tga.header.height && w == tga.header.width ) {
			baarray = tga.data ;
			napixel = tga.header.depth/8 ;
			b_alp_MustFlipVertically = ! tga.hight_UndaerToTop ;
		    }
		}catch(Exception e) {
		    new KGLException(e);
		}
	    }
	    npixel = barray.length ;
	    npixel /= (h*w);
	    ret = ByteBuffer.allocateDirect(h*w*4) ;
	    ret.order(ByteOrder.nativeOrder()) ;
	    int hini = 0;
	    int hmin = 0 ;
	    int hmax = h;
	    int hadd = 1;
	    if( !gltexdata.getMustFlipVertically() ) {
		hini = h-1 ;
		hadd = -1 ;
	    }
	    for( int hp = hini ; hmin <= hp && hp < hmax ; hp+=hadd ) {
		for( int wp = 0 ; wp < w ; wp++ ) {
		    if( texform == GL.GL_BGR || texform == GL.GL_BGRA ) {
			ret.put(barray[(hp*w+wp)*npixel+2]) ;
			ret.put(barray[(hp*w+wp)*npixel+1]) ;
			ret.put(barray[(hp*w+wp)*npixel+0]) ;
		    }
		    else {
			ret.put(barray[(hp*w+wp)*npixel+0]) ;
			ret.put(barray[(hp*w+wp)*npixel+1]) ;
			ret.put(barray[(hp*w+wp)*npixel+2]) ;
		    }
		    if( baarray != null ) {
			if( (hini != 0 && (b_alp_MustFlipVertically)) || 
				(hini == 0 && (!b_alp_MustFlipVertically) )
			) { //テクスチャファイルとアルファファイルで格納方向が逆の場合
			    ret.put(baarray[((hmax-1-hp)*w+wp)*napixel+napixel-1]) ;
			}
			else {
			    ret.put(baarray[(hp*w+wp)*napixel+napixel-1]) ;
			}
			continue ;
		    }
		    if( texform == GL.GL_BGRA || texform == GL.GL_RGBA) {
			ret.put(barray[(hp*w+wp)*npixel+3]) ;
			continue ;
		    }
		    ret.put(balpha) ;
		}
	    }

	    /* com.sun.opengl.util.textureを使わないで画像読み込みするときのソース
		BufferedImage tex = null ;
		BufferedImage alp = null ;
			File texf ;
			texf = new File(texname) ;
			tex = ImageIO.read(texf) ;
			if( alpname != null ) alp = ImageIO.read(new File(alpname)) ;
			Raster rtr ;
			Raster artr = null  ;
			int ty ;
			Object data ;
			Object adata ;
			h = tex.getHeight();
			w = tex.getWidth() ;
			rtr = tex.getData() ;
			data = rtr.getDataElements(0,0,h,w,null) ;
			byte[] bdata = (byte[])data ;
			byte[] balp = null ;
			int anpixel = 0 ;
			int aoffset = 0 ;
			if( alpname != null ) {
				if( h == alp.getHeight() && w == alp.getWidth() ) {
					artr = alp.getData() ;
					adata = artr.getDataElements(0,0,h,w,null) ;
					if( adata instanceof byte[] ) {
						balp = (byte[]) adata ;
						anpixel = artr.getNumDataElements() ;
						aoffset = (anpixel-1) ;
					}
				}
			}
			ty = rtr.getTransferType() ;
			if( ty != DataBuffer.TYPE_BYTE ) throw new Exception("データ配列がよくわからん") ;
			npixel = rtr.getNumDataElements() ;
			if( h != w ) throw new Exception("テクスチャの縦横がちがう") ;
			if( data instanceof byte[] ) {
				ret = ByteBuffer.allocateDirect(h*w*4) ;
				ret.order(ByteOrder.nativeOrder()) ;
				for( int i = 0 ; i < h*w ; i++ ) {
					ret.put(i*4+0,(byte)(bdata[i*npixel+0])) ;
					ret.put(i*4+1,(byte)(bdata[i*npixel+1])) ;
					ret.put(i*4+2,(byte)(bdata[i*npixel+2])) ;
					if( balp == null ) {
						ret.put(i*4+3,(byte)(balpha)) ;
					}
					else {
						ret.put(i*4+3,(byte)(balp[i*anpixel+aoffset])) ;
					}
				}
			}
			ret.position(0) ;

	     */
	}
	catch(Exception e) {
	    e.printStackTrace() ;
	    ret = null ;
	}
	return ret ;
    }

}
