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




public interface ContentProvider
{
    public ContentWrapper CreateStream(String i_identifier) throws KGLException;
    public ContentWrapper CreateMainStream() throws KGLException;
    public void ChangeEntry(String i_base_filepath);
}
