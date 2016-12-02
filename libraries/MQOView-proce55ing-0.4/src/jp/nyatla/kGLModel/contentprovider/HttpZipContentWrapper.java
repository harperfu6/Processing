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

public class HttpZipContentWrapper implements ContentWrapper
{
    private InputStream fileinput;
    private String suffix;
    ZipInputStream	zis;
    ByteArrayOutputStream fzip_content_in;
	byte[] filebuf;

    public HttpZipContentWrapper(ZipInputStream zip, String i_identifier) throws KGLException
    {
    	this.zis = zip;
	try{
		ZipEntry entry = zis.getNextEntry();
	    while(entry != null && !entry.getName().toLowerCase().equals(i_identifier.toLowerCase())){
//    		System.out.println(entry.getName());
	    	zis.closeEntry();
	 			entry = zis.getNextEntry();
	    }
	    if(entry==null)return;
	    
	    fzip_content_in = new ByteArrayOutputStream();
   	    byte[] buf = new byte[1024];
	    int len;
	    while ((len = zis.read(buf)) > 0) {
	 			fzip_content_in.write(buf,0,len);
	    }
//		System.out.println("read it!!");

		this.filebuf = fzip_content_in.toByteArray();
		this.fileinput = new ByteArrayInputStream(this.filebuf);

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