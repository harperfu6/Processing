/* 
 * PROJECT: NyARMqoView
 * --------------------------------------------------------------------------------
 * Copyright (c)2008 A虎＠nyatla.jp
 * airmail@ebony.plala.or.jp
 * http://nyatla.jp/
 * 
 */
package jp.nyatla.kGLModel.contentprovider;
import java.io.*;
import java.net.*;

import jp.nyatla.kGLModel.KGLException;



public class HttpContentWrapper implements ContentWrapper
{
    private InputStream input;
    private String suffix;
    public HttpContentWrapper(InputStream i_is) throws KGLException
    {
	input=i_is;
    }
    public String getFileSuffix()
    {
	return suffix;
    }
    public InputStream getInputStream()
    {
	return input;
    }
    public boolean CheckFileExtension(String i_extension)
    {
	//ほんとはここでチェックしなければいけないけど、とりあえず無視！！
	return true;
    }
}
