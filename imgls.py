import numpy as np
from PIL import Image
img= None
try:
	img= Image.open('img.png')
	w= img.width
	h= img.height
	rast= img.raster.flatten()
	assert(len(rast)==w*h*4)
except:
	w= 1080
	h= 1080
	rast= np.zeros(w*h*4)

#shove into rgba16f

import pygame
from pygame.locals import *

import ctypes as ct
from OpenGL.GL import *
from OpenGL.GL import shaders

pygame.init()
resolution= (w,h)
pygame.display.set_mode(resolution, DOUBLEBUF | OPENGL)
pygame.display.set_caption('____________________________')

prog= None
with open("imgls.comp.glsl") as f:
	csh_src= f.read()
try:
	csh_sh= shaders.compileShader(csh_src, GL_COMPUTE_SHADER)
	prog= shaders.compileProgram(csh_sh)
except Exception as e:
	e= str(e)
	e= e.replace('\\\\n','\n')
	e= e.replace(  '\\n','\n')
	e= e.replace(  '\\t','\t')
	e= e.replace(  '\\t','\t')
	e= e.replace(  '\\','')
	e= e.replace('\\\\','')#fuck
	import re
	e= re.sub(r'\(([0-9]+)\)', r'\nFile "imgls.comp.glsl", line \1', e)
	print('\nSHADERROR\n')
	print(e)
	exit()

tex= glGenTextures(1)
glBindTexture(GL_TEXTURE_2D,tex)
glTexStorage2D(GL_TEXTURE_2D, 1, GL_RGBA16F, w,h)#uninitialized
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
glTexSubImage2D(GL_TEXTURE_2D, 0,0,0,w,h, GL_RGBA,GL_FLOAT, rast);
glBindImageTexture(0,tex, 0,False,0, GL_READ_WRITE, GL_RGBA16F)


glUseProgram(prog)
#texsubdata is coherent glMemoryBarrier( GL_TEXTURE_UPDATE_BARRIER_BIT )
glDispatchCompute(w//2,h//2,1)
glMemoryBarrier( GL_SHADER_IMAGE_ACCESS_BARRIER_BIT )
glGetTexImage(GL_TEXTURE_2D, 0,GL_RGBA,GL_FLOAT, rast)

fb= glGenFramebuffers(1)
glBindFramebuffer(GL_READ_FRAMEBUFFER, fb)
glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0)
glFramebufferTexture2D(GL_READ_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,tex, 0)

glBlitFramebuffer(0,0,w,h,0,0,w,h,GL_COLOR_BUFFER_BIT, GL_NEAREST)


pygame.display.flip()


while(1):
	for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit()