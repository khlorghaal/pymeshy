from com import *
import numpy as np
import png
#import exr
from time import *

ANIM= 1
time= 0
frame=0

img= None
try:
	img= png.Reader('img.png').read()
	w= img.width
	h= img.height
	rast= img.raster.flatten()
	assert(len(rast)==w*h*4)
except:
	#w= 2560
	#h= 1440
	w,h= (int(2560//2),1440)#dev
	#w,h= (2560,1440)
	#w,h= (3840,2160)#4k
	#w,h= (9075,6201)#poster
	rast= np.zeros(w*h*4)

import pygame
from pygame.locals import *


import ctypes as ct
from OpenGL.GL import *
from OpenGL.GL import shaders
from OpenGL.GL.EXT.texture_filter_anisotropic import *

pygame.init()
resolution= (w,h)
pygame.display.set_mode(resolution, DOUBLEBUF | OPENGL)
pygame.display.set_caption('____________________________')

prog= None
def loadprog():
	with open("com.glsl") as f:
		com= f.read()
	with open("crystalblock.vsh") as f:
		vsh_src= f.read()
	with open("crystalblock.fsh") as f:
		fsh_src= f.read()
	try:
		pp= lambda f,D: ''.join([
			'#version 430\n',
			com,
			*['#define %s 1\n'%d for d in D],
			'#line 1\n',
			f
		])
		vsh_src= pp(vsh_src,[])
		fsh_src= pp(fsh_src,[])
		v_p= shaders.compileShader(vsh_src, GL_VERTEX_SHADER)
		f_p= shaders.compileShader(fsh_src, GL_FRAGMENT_SHADER)
		global prog
		prog= shaders.compileProgram(v_p,f_p)

	except Exception as e:
		print('\nSHADERROR\n')
		e= str(e)[:500]
		e= e.replace('\\\\n','\n')
		e= e.replace(  '\\n','\n')
		e= e.replace(  '\\t','\t')
		e= e.replace(  '\\t','\t')
		e= e.replace(  '\\','')
		e= e.replace('\\\\','')#fuck
		print(e)
		exit()
		return

import obj
mesh= obj.load('caveblocks.obj')



appstart= perf_counter()
profile_start= perf_counter()

glViewport(0,0,w,h)

import viewmat
view= viewmat.state()

def render():
	glUseProgram(prog)

	vm= view.do()
	mmv= vm.v
	mp=  vm.p
	glUniformMatrix4fv(0,1,True,mmv)
	glUniformMatrix4fv(1,1,True,mp)

	glDisable(GL_BLEND)

	glEnable(GL_DEPTH_TEST)
	glDepthFunc(GL_LESS)

	glEnable(GL_CULL_FACE)
	glFrontFace(GL_CW)

	mesh()

	pygame.display.flip()
	glClearColor(0,0,0,0)
	glClearDepth(1)
	glClear(GL_COLOR_BUFFER_BIT+GL_DEPTH_BUFFER_BIT)

loadprog()
mdown= False
if ANIM:
	def loop():
		global time
		global frame
		while 1:
			#view.update()
			render()
			time= perf_counter()-appstart
			frame+=1
			sleep(1./60.)
			if frame%8==0: #recompile all the time lmao
				#todo file modify hook
				loadprog()

			#input
			for e in pygame.event.get():
				if (e.type == QUIT) or (e.type == KEYUP and e.key == K_ESCAPE):
					return
				if e.type==MOUSEMOTION:
					if(pygame.mouse.get_pressed()[0]):
						w,h = pygame.display.get_surface().get_size()
						cx,cy= pygame.mouse.get_pos()
						cx=   cx - w//2
						cy= h-cy - h//2
						cx/= w
						cy/= h
						view.m= (cx,cy)

				if e.type==TEXTINPUT:
					continue

				if e.type==MOUSEBUTTONDOWN:
					if e.button==1:#LMB
						continue
					if e.button==4:#wheel
						view.z-=1
					if e.button==5:#wheel
						view.z+=1
	loop()
else:
	render()

del rast
rast= glReadPixels(0,0,w,h, GL_RGB,GL_FLOAT)

pygame.display.flip()

print('render time %sms'%((perf_counter()-profile_start)*1000))



profile_start= perf_counter()

print(rast.shape)
rast= rast*(-1+2**8)
rast= rast.astype(np.uint8).flatten()
img= png.Writer(
	size=(w,h),
	bitdepth=8,
	greyscale=False,
	alpha= False,
	compression=4
	)
img.write_array( open('./out.png','wb'), rast )

print('save time %sms'%((perf_counter()-profile_start)*1000))
