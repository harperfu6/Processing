/* 
/* --------------------------------------------------------------------------------
 * ネット上にあるZIPファイルをメモリ上に展開、指定のファイルを展開してInputStreamとして渡す
 * NyARToolKit の A虎氏のソース、unZipIt for Processing(http://libraries.seltar.org/unzipit/)のソース
 * NyARToolKitのContentProvideのIFに準拠した作りになっています。
 * を参考に、recoが実装しました。
 * --------------------------------------------------------------------------------
 * Copyright 2009 Reco, (c)2008 A虎 nyatla.jp,(http://nytla.jp/)
 * 
 */
package jp.nyatla.kGLModel.contentprovider;

import java.io.*;

import java.util.zip.*;

import processing.core.PApplet;

import jp.nyatla.kGLModel.KGLException;


public class LocalZipContentProvider implements ContentProvider
{
	private PApplet myParent;	    // Add by reco for processing lib.
    ZipFile zf;
    File f;
    private String base_path;
    // Add by reco for processing lib.
  public LocalZipContentProvider(PApplet theParent, String i_zip, String i_base_filepath) 
    {
    	myParent = theParent;
    	try
    	{
        	f = new File(i_zip);
    		zf = new ZipFile(f);
    	}catch(Exception e)
    	{
		 	  System.out.println("No such zip file: "+i_zip);
    	}
    	this.base_path= i_base_filepath;

		ZipEntry entry = zf.getEntry(i_base_filepath);
	     
	    if(entry == null){
		 	  System.out.println("No such file: "+i_base_filepath);
				return;
	    }

    }
    public ContentWrapper CreateStream(String i_identifier) throws KGLException
    {
	ContentWrapper result;
	result=new LocalZipContentWrapper(zf, i_identifier);
	return result;
    }
    public void ChangeEntry(String i_base_filepath)
    {
    	this.base_path= i_base_filepath;

		ZipEntry entry = zf.getEntry(i_base_filepath);
	     
	    if(entry == null){
		 	  System.out.println("No such file: "+i_base_filepath);
				return;
	    }

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