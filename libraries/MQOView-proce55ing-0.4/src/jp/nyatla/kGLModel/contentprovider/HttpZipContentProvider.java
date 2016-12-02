/* 
 * --------------------------------------------------------------------------------
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
import java.net.*;

import java.util.zip.*;

import processing.core.PApplet;

import jp.nyatla.kGLModel.KGLException;


public class HttpZipContentProvider implements ContentProvider
{
	private PApplet myParent;	    // Add by reco for processing lib.
    ZipFile zf;
    ZipInputStream zis; 
    File f;
    ByteArrayOutputStream fzip_in;
    ByteArrayInputStream fzip_out;
    byte[] fzip;
    ByteArrayOutputStream fzip_content_in;
    ByteArrayInputStream fzip_content_out;
    private String base_path;
    // Add by reco for processing lib.
  public HttpZipContentProvider(PApplet theParent, String i_zip, String i_base_filepath) 
    {
    	myParent = theParent;

		URLConnection connection;
		InputStream in;
		HttpURLConnection httpcl;
		try{
			URL i_url = new URL(i_zip);
		    connection = (URLConnection)i_url.openConnection();
			httpcl=(HttpURLConnection)connection;
			httpcl.setRequestMethod("GET");
	        in = httpcl.getInputStream();
		    fzip_in = new ByteArrayOutputStream();  

		    byte[] buf = new byte[1024];
		    int len;
		    while ((len = in.read(buf)) > 0) {
		 			fzip_in.write(buf,0,len);
		    }
		    in.close();
		}catch(Exception e){
			System.out.println("Zip Load Error");
		}	
		//インスタンス、fzipに格納
		fzip = fzip_in.toByteArray();
		
		//メモリ上のデータをInputStreamとして扱う
		fzip_out = new ByteArrayInputStream(fzip);
		zis = new ZipInputStream(fzip_out);

    	this.base_path= i_base_filepath;
    	try{
			ZipEntry entry = zis.getNextEntry();
		    while(entry != null && !entry.getName().toLowerCase().equals(i_base_filepath.toLowerCase())){
		    	zis.closeEntry();
		 			entry = zis.getNextEntry();
		    }
		    if(entry == null){
			 	  System.out.println("No such file: "+i_base_filepath);
					return;
		    }
    	}catch(Exception e){}

    }
    public ContentWrapper CreateStream(String i_identifier) throws KGLException
    {
		fzip_out = new ByteArrayInputStream(fzip);		//ファイルの先頭にポインタを戻すのと同等な動作
		zis = new ZipInputStream(fzip_out);
	ContentWrapper result;
	result=new HttpZipContentWrapper(zis, i_identifier);
	return result;
    }
    public void ChangeEntry(String i_base_filepath)
    {
    	this.base_path= i_base_filepath;
/*
    	try{
			ZipEntry entry = zis.getNextEntry();
		    while(entry != null && !entry.getName().toLowerCase().equals(i_base_filepath.toLowerCase())){
		    	zis.closeEntry();
		 			entry = zis.getNextEntry();
		    }
		    if(entry == null){
			 	  System.out.println("No such file: "+i_base_filepath);
					return;
		    }
    	}catch(Exception e){}
*/
    }
    public ContentWrapper CreateMainStream() throws KGLException
    {
	return CreateStream(base_path);
    }
    public static void main(String[] args)
    {
	LocalContentProvider cp=new LocalContentProvider("c:\\test\\test2\\2.txt");
	String s;
//	s=cp.getFileName("a.txt");
//	s=cp.getFileName("d:\\b.txt");
//	s=cp.getFileName("..\\..\\a.txt");
    }
}