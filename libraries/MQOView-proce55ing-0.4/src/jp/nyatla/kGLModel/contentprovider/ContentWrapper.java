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

import jp.nyatla.kGLModel.KGLException;



public interface ContentWrapper{
    public String getFileSuffix();
    public InputStream getInputStream();
    public boolean CheckFileExtension(String i_extension);
}
