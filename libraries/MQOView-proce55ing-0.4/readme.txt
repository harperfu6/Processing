------------
Copyright (C)2009 reco

Metaseq�t�@�C���i.MQO�j�t�@�C�������������ɓǂݍ��݁��`�悷��N���X��Processing�ň�����悤�ɂ������C�u�����ł��B

Ver 0.4  2009/4/13 reco
Ver 0.3  2009/3/08 reco
Ver 0.2  2009/2/11 reco
Ver 0.1b  2009/2/1 reco
Ver 0.1  2009/1/27 reco
------------

���̃��C�u�����́A�`�Վ��쐬��NyARToolkit(ARToolKit Class Library for Java)�̓���T���v���v���O�����ł���NyARMqoViewer���x�[�X��Processing��œ���ł���悤�ɂ������̂ł��B
���̃��C�u�����ƁA�������`�Վ��쐬��NyAR4psg(NyARToolkit for proce55ing)��g�ݍ��킹�邱�ƂŁAProcessing����ł����^�Z�R�C�A�`���̃f�[�^��\���ł���悤�ɂȂ�܂��B 

���W�n�̐���ɂ��A�\�����郂�f���́A�y���ɑ΂��Č������ɂȂ��Ă��܂��܂��B
����Ȃ��񂾂Ǝv���Ă����p���������B���ۂɕ\�������āA��]�������肷��΁A���قǋC�ɂȂ�Ȃ��Ǝv���܂����AOpenGL�����牽�炩�ڐA����ꍇ�͒��ӂ��K�v�ł��B<br/>

NyARToolkit�̃y�[�W:�@http://nyatla.jp/nyartoolkit/wiki/index.php?FrontPage
NyARMqoViewer�F�@http://nyatla.jp/nyartoolkit/wiki/index.php?Sample%2FNyARMqoViewer

[�C���X�g�[��]
Lib�t�H���_�z����jar�t�@�C�����Asktch�t�H���_�z����code�t�H���_�̒����AProcessing�̃��C�u�����t�H���_�ɃR�s�[���Ďg�p���Ă��������B
Processing�̃��C�u�����f�B���N�g���ɂ����ꍇ�́Ajp/nytla/kGLMode�t�H���_���쐬���āA���̒���NyARMQO.jar�������Ă��������B�iNyARToolkit����h���������ߓ����悤�ȃN���X�\���ɂ��Ă���܂�) 
�ڂ����́A�T���v���t�@�C�����Q�l���������B

�ȒP�Ȏg�p�@
---
�N���X�̃C���|�[�g
---

import javax.media.opengl.*; 
import processing.opengl.*;

import jp.nyatla.kGLModel.*;
import jp.nyatla.kGLModel.contentprovider.*;

//���L�̃N���X���g�p���܂��B

KGLModelData model_data = new KGLModelData;
ContentProvider content_provider = new ContentProvider;

���Ƃ́A

content_provider = new LocalContentProvider(this, "d:\\MQOData\\hoge.mqo");
content_provider = new HttpContentProvider(this, "http://127.0.0.1/hoge.mqo");
[Ver0.4]ZIP�t�@�C���ɑΉ����܂����B�ڍׂ͌�q�iZIP�t�@�C���̓ǂݎ��ɂ��āj�Q��


�̗l�ɁA�ꏊ����肵�ăR���e���c�v���o�C�_���쐬���Ē����A

  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  
  GL gl = pgl.beginGL();  
   model_data = KGLModelData.createGLModelPs(this, gl,null,this.content_provider,0.015f,
	        	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;
  pgl.endGL();

�̗l�ɁA���f���f�[�^�N���X�Ƀ��[�h�����Ă��������B
���̍ہAOpenGL�̃n���h����n���Ă�����K�v������܂��B
���Ƃ́A

  model_data.enables(1.0f) ;  //�����͔{��
  model_data.draw() ;
  model_data.disables() ;

�ŌĂяo�����Ƃ��\�ł��B������OpenGL�𗘗p����̂ŁA
GL gl = pgl.beginGL(); �` pgl.endGL();�ň͂�ł��K�v������܂��B
���̂�����́AProcessing�̌����y�[�W(http://www.procesing.org/)�ɂ���Reference/library/opengl��������Q�l�ɂ��Ă��������B
Processing��ŁApure Open GL���g�����@��������Ă��܂��B

Processing����Ń��C�u�������ׂĂ��J�o�[���悤�Ǝv�����̂ł����AProcessing�ł͍��x�ȃ��f���̈����͎�ɂ��܂�̂ƁA Processing���̂����FJava�Ƃ������Ƃ�����A�l�C�e�B�u�Ή��ɂ�������������؂��ăI�[�o�[���b�v���������鎖�ɂ��܂����B 

�ǋL: 2009/03/09
NyARToolkit for Processing(http://nyatla.jp/nyartoolkit/wiki/index.php?NyAR4psg) �́A���W�n���E��n�ɂȂ�܂��B
���̂���Processing�W���̍��W�n�ŕ`�悷��ƁA���f���̍��E���t�ɂȂ�����A�e�N�X�`�������܂��\������܂���B
�����I�ɕʏ���������K�v������܂����A�{���C�u�����ł́AcreateGLModelPs�Ń��f�������[�h����ۂɈ�����n�����ƂőΉ��\�Ƃ��܂����B

model_data = KGLModelData.createGLModelPs(this, gl,null,this.content_provider,0.015f,
		       	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;

�Ō�̈����Atrue�ō���n�Afalse�ŉE��n�ɂȂ�܂��B�p�r�ɉ����Ďg�������Ă��������B
�ߓ����ɁANyARToolkit for Processing�Ɩ{���C�u������g�ݍ��킹���T���v�������J�\��ł����A
���ʂ̎���ɂ��x��Ă���܂��B�B

2009/4/13
ZIP�t�@�C���̓ǂݎ��ɂ���

ZIP�t�@�C���ɔ[�߂��Ă��郂�f���f�[�^��ǂݍ��ނ��Ƃ��ł���悤�ɂȂ�܂����B
���L�̗l�ɁA�t�@�C���̏ꏊ�ɉ����Ċ֐����g���킯�Ă��������B
content_provider = new LocalZipContentProvider(this, "d:\\MQOData\\hoge.zip","hoge.mqo");
content_provider = new HttpZipContentProvider(this, "http://127.0.0.1/hoge.zip","hoge.mqo");
�����́A���A�v���b�g�|�C���^�A���Ƀt�@�C���̏ꏊ�A�ǂݎ��t�@�C���ł��B
���ɂ������ŁA�^�[�Q�b�g�t�@�C���݂̂�ύX�������ꍇ�́A�����o�֐��� changeEntry(string str)�����g�����������B
new�ŃR���X�g���N�^���Ăяo���Ă��܂��ƁA�ʐM���������Ă��܂��܂��B

Http...�̕��́A�R���X�g���N�^�쐬����ZIP�t�@�C�����������ɓǂݍ��񂾂��Ƃ́A
��������̃f�[�^�ɃA�N�Z�X���ă^�[�Q�b�g�̃t�@�C�����������܂��B
�^�[�Q�b�g�̃t�@�C���ɃA�N�Z�X����x��http�ʐM���s��Ȃ��Ă��ނ��߁Aweb�ł̌��J���̃��[�h���Ԃ��Z�k�ł��܂��B

���f�ރt�@�C��������ZIP���ɂɊ܂߂Ă��������B

=========================
�֐��ꗗ

[�ǂݍ��݃f�[�^�̎w��:content_provider�e��]
MQO�`���̃t�@�C���𒼐ڎw�肷��ꍇ
content_provider = new LocalContentProvider(PApplet, String); // ���[�J����
content_provider = new HttpContentProvider(PApplet, String); // ���[�J����
ex)
content_provider = new LocalContentProvider(this, "d:\\MQOData\\hoge.mqo"); // ���[�J����
content_provider = new HttpContentProvider(this, "http://127.0.0.1/hoge.mqo"); //http�A�N�Z�X����t�@�C��


ZIP���k����Ă���ꍇ
content_provider = new LocalZipContentProvider(PApplet, String zipfile, String target_file); // ���[�J����
content_provider = new HttpZipContentProvider(PApplet, String zipfile, String target_file); // ���[�J����

ex)
content_provider = new LocalZipContentProvider(this, "d:\\MQOData\\hoge.zip","hoge.mqo");
content_provider = new HttpZipContentProvider(this, "http://127.0.0.1/hoge.zip","hoge.mqo");

�����o�֐��F
���ɂȂ�
��ZIP�t�@�C����舵�����̂�
changeEntry(String filename)

ex)
content_provider.changeEntry("hoge2.mqo");

[���f������舵���N���X�@KGLModelData�N���X]

�����o�֐��F
 createGLModelPs(PApplet pa, GL in_gl,KGLTextures in_texPool,ContentProvider i_file_provider,float scale,boolean in_isUseVBO, boolean axis)
	����
		PApplet pa: Processing�A�v���b�g�ւ̃|�C���^
		GL in_gl: OpenGL�n���h��
		KGLTextures in_texPool �e�N�X�`���Ǘ��N���X�inull�Ȃ炱�̃N���X�����ɍ쐬�j
		ContentProvider i_file_provider �t�@�C���񋟃I�u�W�F�N�g
		float scale	�{��
		boolean in_isUseVBO	in_isUseVBO���g�p���邩���Ȃ����i���ˑ��j
		boolean axis ����n/�E��n�̎w��@true����n�Afalse�E��n (���ʂ�Processing�Ŏg���ꍇ�͍���n)
	�p�r�F
		���f���f�[�^�̃��[�h

	ex) 
	 KGLModelData modeldata = createGLModelPs(this, gl,null,this.content_provider,0.015f,
		       	    KGLExtensionCheck.IsExtensionSupported(gl,"GL_ARB_vertex_buffer_object"),true) ;
 	
 enables(float scale)
 	����
 		scale �\������Ƃ��̔{��
 	�p�r�F
 		OpenGL�̏������ȂǁiDraw�̑O�ɕK��1�x�͌Ăяo���j

 disables()
 	�p�r�F
 		OpenGL�̏I�������ȂǁiDraw�̌�ɕK��1�x�͌Ăяo���j
 	
 draw()
 	�p�r�F
 		���f���f�[�^�̕`��
 	
 	
//  model_data.draw() ;
  model_data[play_anim_no].draw() ;
  model_data[play_anim_no].disables() ;



========================
[�ύX����]
0.4
ZIP���k���ꂽ�t�@�C������̓ǂݏo���ɑΉ�

0.3
����n�`��(Processing�W���j�A�E��n�`��(NyARToolkit for Processing���j�̗����ɑΉ������܂����B
createGLModelPs�̈����̍Ō�ŁA�ǂ���̍��W�n�ŕ`�悷����w�肵�܂��B
true�ō���n�Afalse�ŉE��n�ɂȂ�܂��B�p�r�ɉ����Ďg�������Ă��������B

��createGLModelPs�̈������P�����Ă��܂��i�E��n�E����n�Ή��j
��NyAR�Ƃ͊֌W���Ȃ��̂ŁA����������邽�߂�jar�t�@�C������ύX���܂����B�iNyARMQO.jar��MQOLoader.jar�j

0.1b/0.1c > 0.2 2009/2/11<br/>
  Processing�̉E����W�ւ̕ϊ����[�`���̐��퉻�B���W�n���قȂ邽�߁A���S�ɂ̓��^�Z�R�C�A�Ƃ̓����ɂ͂Ȃ�܂���BZ���ɑ΂��Č������ɂȂ�܂��B<br/>

0.1 > 0.1b 2009/2/1
  ���C�u�����̃R���p�C����Jre6���g���Ă���A�ꕔ�̊���Processing�ł͓��삵�Ȃ����Ƃ����������̂ŁA
�@1.5�ŃR���p�C������蒼���܂����B



========================
[NyARMqoViewer����̕ύX���e]
NyARMqoViewer���x�[�X��Processing�Ή��������Ă݂܂����B
�قƂ�ǂ��̂܂ܓ��삵�܂������A���L�̕����኱�ύX�����܂����B

ZIP�t�@�C������̓ǂݎ��

[HttpContentProvider.java, LocalContentProvider.java]

�E�N���X�����o��processing�p�̃n���h����ǉ� (pAppret)
�@����ɔ��� "import processing.core.*" �̒ǉ�

�EHttpContentProvider, LocalContentProvider�̃R���X�g���N�^�ɁA
�@pAppret�n���h�����󂯂�֐���ǉ��B����͊����̂��̂Ɠ����B


�EProcessing���ł��܂��AKGLException���󂯂��Ȃ��̂ŃR�����g�A�E�g�B
�@(unknowen exception type���o��)

[KGLModelData.java]

KGLModelData�N���X�ɁAcreateGLModelPs�֐���ǉ��B
�Econtentprovider�n�Ɠ������Aprocesing����̃n���h�����󂯎�邽�߂ɁA
�@�֐��̈����̊g���ƃn���h���̃����o�֐��X�g�A�����݂̂��L�q�B(Processing�p�Ȃ̂ŁAPs�ƕt���Ă��܂�)�B
�Econtentprovider�n�Ɠ������AProcessing���ł��܂��AKGLException���󂯂��Ȃ��̂ŃR�����g�A�E�g�B


[KGLMetaseq.java]]
GLObject�N���X�AmakeObjs�֐�����glGenBuffers���AglGenBuffersARB��

���̉Ƃ̊��̂����A����P���PC�̂݁AglGenBuffers�ɑ΂���avilable��Ԃ��̂ɂ�������炸�A
���ۂɃR�[������ƁAnot available�ƂȂ��Ă��܂����߁AARB�̕����g���悤�ɕύX���܂����B
boolean ret2 = gl.isFunctionAvailable("glGenBuffers"); �ł�true���߂��Ă��Ă��܂��āA
�ǂ����悤���Ȃ��Ȃ�܂����B�B�B�B

[������W�n�ւ̑Ή�](ver0.2)
�ǂݍ��ݎ���
���y���̕ϊ��i-1)
�����_�z��i�[���̕ύX�i�����v���Ɂj�@�t�u���W�����l
���s���B
���L�̊֐��ɑ΂��āA����p�̊֐���V���ɍ쐬�B(�����\���k���֐��ɕt�������j
�i����Ή��ȊO�́A�I���W�i���𗘗p�j
KGLMetaseq.java�����́A KGLMetaseq�N���X���A object�N���X��
readVertex, readBVertex, readFace�Aset


========================
�E���쌠�ƃ��C�Z���X
���̃\�[�X�́AA�Ձ�nyatla.jp����̒��앨�ANyARMqoViewer��Metaseq�t�@�C���������������g�p���Ă��܂��B
�R�A�̕����́A�p�b�P�[�Wjp.nyatla.kGLModel�z���̃\�[�X�R�[�h�́Akei����̒��앨��A�Ձ�nyatla.jp���񂪉��ς����������̂ł��B
���̕����̃��C�Z���X��kei����̂���ɏ]���܂��B

���̃��C�u�������̂�MIT���C�Z���X�Ŕz�z���܂��B���C�Z���X�Ɋւ��ẮAlicence.txt���Q�Ƃ��Ă��������B
�\�[�X�R�[�h���̒��쌠�́A�\�[�X�R�[�h�̐擪���������Ă��������B

�E�ӎ�
A�Ձ�nyatla.jp����
ARToolkit��Java���AProcessing�ł̗��p�ɒ��͂�����Ă����܂��B
�����ɏo����Ď��̎�̎��R�x���i�i�ɍL����܂����B
���肪�Ƃ��������܂��B

kei����
���{�ƂȂ郁�^�Z�R�C�A�f�[�^�̓ǂݏo������kGLModel�̌��J�����Ă��������܂����B
���肪�Ƃ��������܂��B

���A����
fprintf@yahoo.co.jp
�u���O�Fhttp://reco-memo.blogspot.com/
���₻�̂ق��́A�u���O�̕��ɃR�����g�����������������Ή����������Ǝv���܂��B

���d�v��
�ENyARToolkit�́c
ARToolkit Java class library NyARToolkit.
Copyright (C)2008 R.Iizuka
http://nyatla.jp/nyartoolkit/wiki/index.php
���w���܂�




