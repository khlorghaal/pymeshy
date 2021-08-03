import numpy as np
import png
#import exr

img= None
try:
	img= png.Reader('img.png').read()
	w= img.width
	h= img.height
	rast= img.raster.flatten()
	assert(len(rast)==w*h*4)
except:
	w= 1080
	h= 1080
	rast= np.zeros(w*h*4)

import pygame
from pygame.locals import *

import ctypes as ct
from OpenGL.GL import *
from OpenGL.GL import shaders

pygame.init()
resolution= (w,h)
pygame.display.set_mode(resolution, DOUBLEBUF | OPENGL)
pygame.display.set_caption('____________________________')

with open("imgls.comp.glsl") as f:
	csh_src= f.read()
def prog(s):
	try:
		head= '''
		#version 450
		#define %s 1
		#line 1
		'''%s
		csh_sh= shaders.compileShader(head+csh_src, GL_COMPUTE_SHADER)
		return shaders.compileProgram(csh_sh)
	except Exception as e:
		print('\nSHADERROR\n')
		e= str(e)
		e= e.replace('\\\\n','\n')
		e= e.replace(  '\\n','\n')
		e= e.replace(  '\\t','\t')
		e= e.replace(  '\\t','\t')
		e= e.replace(  '\\','')
		e= e.replace('\\\\','')#fuck
		import re
		e= re.sub(r'\(([0-9]+)\)', r'\nFile "imgls.comp.glsl", line \1', e)
		#sublime default error regex
		print(e)
		exit()
progs= list(map(prog,['STAGE0','STAGE1','STAGE1']))
print(progs)

_pingpong= glGenTextures(2)
for i,pp in enumerate(_pingpong):
	glBindTexture(GL_TEXTURE_2D,pp)
	glTexStorage2D(GL_TEXTURE_2D, 1, GL_RGBA16F, w,h)#uninitialized
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
	glTexSubImage2D(GL_TEXTURE_2D, 0,0,0,w,h, GL_RGBA,GL_FLOAT, rast);


wg= (w//8,h//8,1)
for p in progs:
	glUseProgram(p)
	glUniform2f(2,w,h)
	glUniform2i(3,w,h)

	_pingpong= _pingpong[::-1]
	glBindTexture(GL_TEXTURE_2D,_pingpong[0])
	glBindImageTexture(1,_pingpong[1], 0,False,0, GL_WRITE_ONLY, GL_RGBA16F)

	glDispatchCompute(*wg)
	glMemoryBarrier( GL_SHADER_IMAGE_ACCESS_BARRIER_BIT )

fb= glGenFramebuffers(1)
glBindFramebuffer(GL_READ_FRAMEBUFFER, fb)
glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0)
glFramebufferTexture2D(GL_READ_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,_pingpong[1], 0)
glBlitFramebuffer(0,0,w,h,0,0,w,h,GL_COLOR_BUFFER_BIT, GL_NEAREST)

del rast
rast= glReadPixels(0,0,w,h, GL_RGBA,GL_FLOAT)

pygame.display.flip()

print(rast.shape)
rast= rast*(-1+2**16)
rast= rast.astype(np.uint16).flatten()
print(rast.shape)
w= png.Writer(
	size=(w,h),
	bitdepth=16,#!!16
	greyscale=False,
	alpha= True,
	compression=8
	)

#w.write_array( open('./out.png','wb'), rast )

while(1):
	for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit()