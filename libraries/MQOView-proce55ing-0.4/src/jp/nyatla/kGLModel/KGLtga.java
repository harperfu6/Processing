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
 */
package jp.nyatla.kGLModel;

import java.io.*;
import java.nio.*;

import jp.nyatla.kGLModel.contentprovider.ContentProvider;
import jp.nyatla.kGLModel.contentprovider.ContentWrapper;

/**
 * TGAファイル読み込みクラス<br>
 * com.sun.opengl.util.texture.TextureIOでＴＧＡファイルのモノクロが
 * 非サポートなので読み込みクラスを作成した<br>
 * <br>
 * ☆バイト境界は怪しい。手元にあるＴＧＡファイルが２バイト境界っぽかったので
 * そのように作っている。<br>
 * @author kei
 *
 */
public class KGLtga {
    /**
     * TGAファイルヘッダ
     * @author kei
     *
     */
    class TgaHeader {
	byte id ;
	byte color_map_flag ;
	byte type ;
	byte dmy_1 ;//バイト境界を埋めるための物。
	short color_map_entry ;
	byte color_map_entry_size ;
	byte dmy_2 ;//バイト境界を埋めるための物。
	short x ;
	short y ;
	short width ;
	short height ;
	byte depth ;
	byte bit_info ;
    }
    /**
     * データ格納方向<br>
     * true:下から上へ<br>
     * false:上から下へ<br>
     */
    protected boolean hight_UndaerToTop = true ;
    protected TgaHeader header = null ;
    protected byte[] data = null ;
    /**
     * ＴＧＡクラス作成（ファイルからデータ読み込み）
     * @param dataFile	ＴＧＡファイル
     * @throws Exception	データ読み込み失敗
     */
    public KGLtga(ContentProvider i_provider,String i_identifier) throws KGLException
    {
	BufferedInputStream bis = null;
	ContentWrapper tga_input=i_provider.CreateStream(i_identifier);
	if(!tga_input.CheckFileExtension("tga")){
	    
	}
	bis=null;
	try {
	    bis = new BufferedInputStream(tga_input.getInputStream());
	    byte[] rbuf = new byte[18] ;
	    int sz ;
	    sz = bis.read(rbuf) ;
	    if( sz != rbuf.length ){
		throw new IOException("TGAファイル　ヘッダ読み込みエラー") ;
	    }
	    ByteBuffer bb = ByteBuffer.wrap(rbuf) ;
	    bb.order(ByteOrder.LITTLE_ENDIAN) ;//TGAファイルは（多分）リトルエンディアン
	    bb.position(0) ;
	    header = new TgaHeader() ;
	    header.id = bb.get() ;
	    header.color_map_flag = bb.get() ;
	    header.type = bb.get() ;
	    header.dmy_1 = bb.get() ;
	    header.color_map_entry = bb.getShort() ;
	    header.color_map_entry_size = bb.get() ;
	    header.dmy_2 = bb.get() ;
	    header.x = bb.getShort();
	    header.y = bb.getShort() ;
	    header.width = bb.getShort() ;
	    header.height = bb.getShort() ;
	    header.depth = bb.get() ;
	    header.bit_info = bb.get() ;
	    if( (header.bit_info & 0x02) != 0 ) hight_UndaerToTop = false ;
	    data = new byte[header.width*header.height*(header.depth/8)] ;
	    bis.read(data) ;
	    bis.close();
	}catch(Exception e){
	    throw new KGLException(e);
	}
	finally{
	}
    }
}
