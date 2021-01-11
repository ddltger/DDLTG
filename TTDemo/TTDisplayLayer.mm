//
//  TTDisplayLayer.m
//  TTDemoApp
//
//  Created by zing on 2020/11/2.
//

#import "TTDisplayLayer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "font/TTFontState.h"
#import "DDLTGFont.h"

@interface TTDisplayLayer()
{
    //宽
    GLint _backingWidth;
    //高
    GLint _backingHeight;
    
    EAGLContext *_context;
    
    GLuint _frameBufferHandle;
    GLuint _colorBufferHandle;
    GLuint _depthBufferHandle;
    
    TTFontState *fontState;
    
    Ddltg::DDLTGFont *DdltgFont;
}

@property GLuint shaderProgram;

@end


@implementation TTDisplayLayer

-(void)setupGL
{
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        return;
    }

    
    
    [self createBuffers];
    [self loadObjLoaderShader];
    [self displayPixelBuffer];
}

-(void)displayPixelBuffer
{
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        return;
    }
    glClearColor(1.0f, 0.0f, 0.0f, 0.5f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    //绑定渲染缓存区->显示到屏幕
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void) createBuffers
{
    //创建帧缓存区 frameBuffer
    glGenFramebuffers(1, &_frameBufferHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);
    
    //创建渲染缓存区 colorBuffer
    glGenRenderbuffers(1, &_colorBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
 
    //创建深度缓冲区(depthBuffer)
    glGenRenderbuffers(1, &_depthBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBufferHandle);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferHandle);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_RENDERBUFFER, _colorBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBufferHandle);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBufferHandle);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        self.contentsScale = scale;
        //一个布尔值，指示层是否包含完全不透明的内容.默认为NO
        self.opaque = TRUE;
        /*
         kEAGLDrawablePropertyRetainedBacking指定可绘制表面在显示后是否保留其内容的键.默认为NO.
         */
        self.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :[NSNumber numberWithBool:YES]};
        //设置layer图层frame
        [self setFrame:frame];
        
        // 设置绘制框架的上下文.
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!_context) {
            return nil;
        }
        
        NSString* path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Font/fanglang.ttf"];
        
        DdltgFont = new Ddltg::DDLTGFont;
        DdltgFont->initFace((char*)[path UTF8String]);
        
        fontState = [[TTFontState alloc]init];
        [fontState initFont:path];
        [self setupGL];
    }
    return self;
}

#pragma mark - shader

//顶点着色器代码
const GLchar *shaderv = (const GLchar*)
"attribute vec4 position;"
"attribute vec2 texCoord;"
"uniform mat4  mvp;"
"varying vec2  varyTextCoord;"
"void main()"
"{"
"    gl_Position = mvp * position;"
"    varyTextCoord = texCoord;"
"}";

//片元着色器代码
const GLchar *shaderf = (const GLchar*)
"varying highp vec2 varyTextCoord;"
"precision mediump float;"
"uniform sampler2D colorMap;"
"void main()"
"{"
"    gl_FragColor = texture2D(colorMap, varyTextCoord);"
"}";

- (BOOL)loadObjLoaderShader
{
    GLuint vertShader = 0, fragShader = 0;
    
    // 创建着色program.
    self.shaderProgram = glCreateProgram();
    
    //编译顶点着色器
    if(![self compileShaderString:&vertShader type:GL_VERTEX_SHADER shaderString:shaderv]) {
        NSLog(@"Failed to compile vertex obj shader");
        return NO;
    }
    
    //编译片元着色器
    if(![self compileShaderString:&fragShader type:GL_FRAGMENT_SHADER shaderString:shaderf]) {
        NSLog(@"Failed to compile fragment obj shader");
        return NO;
    }
    
    glAttachShader(self.shaderProgram, vertShader);
    glAttachShader(self.shaderProgram, fragShader);
    
    // 绑定属性位置。这需要在链接之前完成.(让ATTRIB_VERTEX/ATTRIB_TEXCOORD 与position/texCoord产生连接)
    glBindAttribLocation(self.shaderProgram, 0, "position");
    
    glBindAttribLocation(self.shaderProgram, 1, "texCoord");
    
    // Link the program.
    if (![self linkProgram:self.shaderProgram]) {
        NSLog(@"Failed to link objProgram: %d", self.shaderProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (self.shaderProgram) {
            glDeleteProgram(self.shaderProgram);
            self.shaderProgram = 0;
        }
        
        return NO;
    }
    
    //objTextureID = glGetUniformLocation(self.objProgram, "colorMap");

    //objMVPID     = glGetUniformLocation(self.objProgram, "mvp");
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(self.shaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(self.shaderProgram, fragShader);
        glDeleteShader(fragShader);
    }
    return YES;
}

//编译shader
- (BOOL)compileShaderString:(GLuint *)shader type:(GLenum)type shaderString:(const GLchar*)shaderString
{
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &shaderString, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    GLint status = 0;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


//释放帧缓存区与渲染缓存区
- (void) releaseBuffers
{
    if(_frameBufferHandle) {
        glDeleteFramebuffers(1, &_frameBufferHandle);
        _frameBufferHandle = 0;
    }
    
    if(_colorBufferHandle) {
        glDeleteRenderbuffers(1, &_colorBufferHandle);
        _colorBufferHandle = 0;
    }
    
    if(_depthBufferHandle) {
        glDeleteRenderbuffers(1, &_depthBufferHandle);
        _depthBufferHandle = 0;
    }
}

@end
