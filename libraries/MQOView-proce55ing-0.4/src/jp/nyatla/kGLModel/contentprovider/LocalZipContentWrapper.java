/* --------------------------------------------------------------------------------
 * ネット上にあるZIPファイルをメモリ上に展開、指定のファイルを展開してInputStreamとして渡す
 * NyARToolKit の A虎氏のソース、unZipIt for Processing(http://libraries.seltar.org/unzipit/)のソース
 * NyARToolKitのContentProvideのIFに準拠した作りになっています。
 * を参考に、recoが実装しました。
 * --------------------------------------------------------------------------------
 * Copyright 2009 Reco, (c)2008 A虎 nyatla.jp,(http://nytla.jp/)
 * --------------------------------------------------------------------------------
 */

 package jp.nyatla.kGLModel.contentprovider;

import java.io.*;
import java.util.zip.*;

import jp.nyatla.kGLModel.KGLException;

public class LocalZipContentWrapper implements ContentWrapper
{
    private InputStream fileinput;
    private String suffix;
    ZipFile	zf;
    public LocalZipContentWrapper(ZipFile zip, String i_identifier) throws KGLException
    {
    	this.zf = zip;
	try{
		ZipEntry entry = zf.getEntry(i_identifier);
	    this.fileinput = zf.getInputStream(entry);
	}catch(Exception e){
	    throw new KGLException(e);
	}	
    }

    public String getFileSuffix()
    {
	return suffix;
    }

    public InputStream getInputStream()
    {
	return fileinput;
    }
    public boolean CheckFileExtension(String i_extension)
    {
	//�ق�Ƃ͂����Ń`�F�b�N���Ȃ���΂����Ȃ����ǁA�Ƃ肠���������I�I
	return true;
    }
}